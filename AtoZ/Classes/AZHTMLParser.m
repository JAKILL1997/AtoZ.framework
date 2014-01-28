
//  HTMLParser.m
//  StackOverflow
//  Created by Ben Reeves on 09/03/2010.
//  Copyright 2010 Ben Reeves. All rights reserved.

#import "AZHTMLParser.h"
#include <libxml2/libxml/HTMLparser.h>
//HTMLparser.h>

#import "HTMLNode.h"

@interface AZHTMLParser ()
@property (ASS) htmlDocPtr _doc;
@end

@implementation AZHTMLParser		@synthesize _doc;
-(HTMLNode*)doc	{ return _doc == NULL ? NULL : [[HTMLNode.alloc initWithXMLNode:(xmlNode*)_doc] autorelease];	}
-(HTMLNode*)html	{ return _doc == NULL ? NULL : [self.doc findChildTag:@"html"];	}
-(HTMLNode*)head	{ return _doc == NULL ? NULL : [self.doc findChildTag:@"head"];	}
-(HTMLNode*)body	{ return _doc == NULL ? NULL : [self.doc findChildTag:@"body"];	}
-(id)initWithString:			(NSString*)string error:(NSError**)error	{	if (!(self = [super init])) return nil;
	_doc = NULL;

	if 	([string length] > 0)	{
		CFStringEncoding cfenc 	= CFStringConvertNSStringEncodingToEncoding(NSUTF8StringEncoding);
		CFStringRef cfencstr 	= CFStringConvertEncodingToIANACharSetName(cfenc);
		const char *enc 			= CFStringGetCStringPtr(cfencstr, 0);
		// _doc = htmlParseDoc((xmlChar*)[string UTF8String], enc);
		int optionsHtml 			= HTML_PARSE_RECOVER;
		optionsHtml 				= optionsHtml | HTML_PARSE_NOERROR; //Uncomment this to see HTML errors
		optionsHtml 				= optionsHtml | HTML_PARSE_NOWARNING;
		_doc = htmlReadDoc ((xmlChar*)[string UTF8String], NULL, enc, optionsHtml);
	}
	else 	{	if (error) *error = [NSError errorWithDomain:@"HTMLParserdomain" code:1 userInfo:nil];		}
	return self;
}
-(id)initWithData:			(NSData*)data 		error:(NSError**)error 	{ if (!(self = [super init])) return nil;

	_doc = NULL;	if (data)	{
		CFStringEncoding cfenc 	= CFStringConvertNSStringEncodingToEncoding(NSUTF8StringEncoding);
		CFStringRef cfencstr 	= CFStringConvertEncodingToIANACharSetName(cfenc);
		const char *enc 			= CFStringGetCStringPtr(cfencstr, 0);
		//_doc = htmlParseDoc((xmlChar*)[data bytes], enc);
		_doc = htmlReadDoc((xmlChar*)[data bytes],
						 "",
						enc,
						XML_PARSE_NOERROR | XML_PARSE_NOWARNING);
	}
	else	{			if (error)	*error = [NSError errorWithDomain:@"HTMLParserdomain" code:1 userInfo:nil];	}
	return self;
}
-(id)initWithContentsOfURL:(NSURL*)url 		error:(NSError**)error	{
	
	NSData * _data = [NSData.alloc initWithContentsOfURL:url options:0 error:error];
	if (_data == nil || *error) return [_data release], nil;
	self = [self initWithData:_data error:error];	[_data release];
	return self;
}
-(void)dealloc																			{	if (_doc)	xmlFreeDoc(_doc);	[super dealloc];	}			@end
