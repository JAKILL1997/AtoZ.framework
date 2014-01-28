//
//  JsonElement.m
//  VisualJSON
//
//  Created by youknowone on 11. 12. 12..
//  Copyright (c) 2011 youknowone.org. All rights reserved.
//

#import "JsonElement.h"

@interface JsonElement ()

// internal data form
- (id)initWithDictionary:(NSDictionary *)dictionary;
- (id)initWithArray:(NSArray *)array;
- (id)initWithTerminal:(id)object;

//! @breif  'Text' view string representation
- (NSString *)descriptionWithDepth:(NSInteger)depth;

@end

//! @brief  'Tree' view internal representation
@interface JsonElement (OutlineDescription)

- (NSString *)outlineItemDescription:(id)item;
- (NSString *)outlineArrayItems;
- (NSString *)outlineDictionaryItems;

@end


@interface NSNumber (JsonElement)

- (NSString *)jsonRepresentation;

@end

@implementation NSNumber (JsonElement)

- (NSString *)jsonRepresentation {
	if ([self.className isEqualToString:@"__NSCFBoolean"]) {
		return [self boolValue] ? @"true" : @"false";
	}
	return [self typeFormedDescription];
}

@end

@implementation JsonElement

NSDictionary *JsonElementInitializers = nil;

- (id)initWithObject:(id)object {
	if ([object ISADICT]) {
		return [self initWithDictionary:object];
	}
	if ([object isKindOfClass:[NSArray class]]) {
		return [self initWithArray:object];
	}
	return [self initWithTerminal:object];
}

+ (id)elementWithObject:(id)object {
	return [[[self alloc] initWithObject:object] autorelease];
}

- (id)initWithDictionary:(NSDictionary *)object {
	self = [super init];
	if (self != nil) {
		self.object = object;
		self.keys = [object.allKeys sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)];
	}
	return self;
}

- (id)initWithArray:(NSArray *)object {
	self = [super init];
	if (self != nil) {
		self.object = object;
		NSMutableArray *keys = [NSMutableArray array];
		for (NSInteger i = 0; i < object.count; i++) {
			[keys addObject:[NSNumber numberWithInteger:i]];
		}
		self.keys = [NSArray arrayWithArray:keys];
	}
	return self;
}

- (id)initWithTerminal:(id)object {
	self = [super init];
	if (self != nil) {
		self.object = object;
	}
	return self;
}

- (id)childAtIndex:(NSInteger)index {
	if (self.keys == nil) return nil;
	if (self.children == nil) self.children = [NSMutableDictionary dictionary];
	id key = [self.keys objectAtIndex:index];
	JsonElement *child = [self.children objectForKey:key];
	if (child == nil) {
		id json = [key isKindOfClass:[NSNumber class]] ? [self.object objectAtIndex:[key integerValue]] : [self.object objectForKey:key];
		child = [[self class] elementWithObject:json];
		child.parent = self;
		child.key = key;
		[self.children setObject:child forKey:key];
	}
	return child;
}

- (NSString *)outlineDescription {
	if (self.keys == nil) {
		if ([self.object isKindOfClass:[NSNumber class]]) {
			return [self.object jsonRepresentation];
		} else {
			return [self.object description];
		}
	}
	if ([self.object isKindOfClass:[NSArray class]]) {
		return [NSString stringWithFormat:@"Array(%lu): [%@]", [self.keys count], [self outlineArrayItems]];
	} else if ([self.object ISADICT]) {
		return [NSString stringWithFormat:@"Dict(%lu): {%@}", [self.keys count], [self outlineDictionaryItems]];
	}
	return [self.object description];
}

- (NSString *)description {
	return [self descriptionWithDepth:0];
}

- (NSString *)descriptionWithDepth:(NSInteger)depth {
	if (self.object == nil) return @"";
	
	NSMutableString *indent = [NSMutableString string];
	for (NSInteger i = 0; i < depth; i++) {
		[indent appendString:@"\t"];
	}
	NSString *indent2 = [indent stringByAppendingString:@"\t"];
	NSMutableString *desc = [NSMutableString string];
	if ([self.object isKindOfClass:[NSArray class]]) {
		[desc appendString:@"[\n"];
		for (NSInteger i = 0; i < self.keys.count; i++) {
			[desc appendString:indent2];
			[desc appendString:[[self childAtIndex:i] descriptionWithDepth:depth + 1]];
			[desc appendString:@",\n"];
		}
		NSInteger deleteCount = 1 + (self.keys.count != 0);
		[desc deleteCharactersInRange:NSMakeRange(desc.length - deleteCount, deleteCount)];
		[desc appendString:@"\n"];
		[desc appendString:indent];
		[desc appendString:@"]"];
	} else if ([self.object ISADICT]) {
		[desc appendString:@"{\n"];
		for (NSInteger i = 0; i < self.keys.count; i++) {
			[desc appendString:indent2];
			id desc2 = [NSString stringWithFormat:@"\"%@\": %@", [self.keys objectAtIndex:i], [[self childAtIndex:i] descriptionWithDepth:depth + 1]];
			[desc appendString:desc2];
			[desc appendString:@",\n"];
		}
		[desc deleteCharactersInRange:NSMakeRange(desc.length-2, 2)];
		[desc appendString:@"\n"];
		[desc appendString:indent];
		[desc appendString:@"}"];
	} else if ([self.object isKindOfClass:NSString.class]) {
		[desc appendString:@"\""];
		[desc appendString:[self.object stringByReplacingOccurrencesOfString:@"\"" withString:@"\\\""]];
		[desc appendString:@"\""];
	} else if ([self.object isKindOfClass:[NSNumber class]]) {
		[desc appendString:[self.object jsonRepresentation]];
	} else {
		[desc appendString:[self.object description]];
	}
	return desc;
}

@end

@implementation JsonElement (OutlineDescription)

- (NSString *)outlineItemDescription:(id)item {
	if ([item isKindOfClass:[NSArray class]]) {
		return [NSString stringWithFormat:@"Array(%lu)", [item count]];
	} else if ([item ISADICT]) {
		return [NSString stringWithFormat:@"Dict(%lu)", [[item allKeys] count]];
	} else if ([item isKindOfClass:NSString.class]) {
		return [NSString stringWithFormat:@"\"%@\"", [item stringByReplacingOccurrencesOfString:@"\"" withString:@"\\\""]];
	} else if ([item isKindOfClass:[NSNumber class]]) {
		return [item jsonRepresentation];
	} else {
		return [item description];
	}
}

- (NSString *)outlineArrayItems {
	NSArray *item = self.object;
	NSMutableArray *children = [NSMutableArray array];
	for (NSInteger i = 0; i < item.count; i++) {
		NSString *desc = [self outlineItemDescription:[item objectAtIndex:i]];
		[children addObject:desc];
	}
	return [children componentsJoinedByString:@","]; 
}

- (NSString *)outlineDictionaryItems {
	NSDictionary *item = self.object;
	NSMutableArray *children = [NSMutableArray array];
	for (id key in self.keys) {
		NSString *desc = [self outlineItemDescription:[item objectForKey:key]];
		[children addObject:[NSString stringWithFormat:@"\"%@\":%@", key, desc]];
	}
	return [children componentsJoinedByString:@","]; 
}

@end
