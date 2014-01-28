
//
//  AZCLICategories.m
//  AtoZ
//
//  Created by Alex Gray on 4/22/13.
//  Copyright (c) 2013 mrgray.com, inc. All rights reserved.
//

#import "AZCLICategories.h"
#import "AtoZ.h"

//+ (instancetype) instanceWithListNamed:(NSS*)listName {
//
//	NSA* lists = [NSC colorLists];
//	return [self instanceWithColorList:[lists filterOne:^BOOL(id object) {
//		return SameString([object vFk:@"name"], listName);
//	}]];
//}
//+ (instancetype) instanceWithNames:(NSA*)names {
//
//	NSA* colors = [names cw_mapArray:^id(id object) {
//		NSC* c = [NSC colorWithName:object] ?: [NSC colorWithHTMLString:object] ?: [NSC colorWithHexString:object];
//		if (c) c.name = object;		return c ?: nil;
//	}];
//	return [self instanceWithColorList:[NSC createColorlistWithColors:colors andNames:[colors valueForKeyPath:@"name"] named:[[(NSC*)colors[0] name] withString:@"List"]]];
//}
//+ (instancetype) instanceWithColors:(NSA*)names;
//+ (instancetype) instanceWithColorList:(NSCL*)list {
//
//	AZPalette *p = [self.alloc init];
//	p.index = 0;
//	p.name = list.name;
//	cls[list.name] = [list colors];
//
//	return p;
//}
//- (NSA*) names  {	return [cls[_name] valueForKeyPath:@"name"];	}
//- (NSA*) colors {	return cls[_name];	}
//- (NSC*) next  { _index++; return self.colors[_index]; }


//// Subclass specific KVO Compliant "items" accessors to trigger NSArrayController updates on inserts / removals.
////Synthesize array accessors
//#define CAP(x) [[x firstLetter]capitalize]
//#define SynthesizeMutableAccessors(__COLLECTION_NAME__, __INTERNAL_KEYPATH__, __INSERTABLE_CLASS__)\
//- (NSUI)countOfCAP {	return [[self valueForKeyPath:__INTERNAL_KEYPATH__] count]; }\
//- (__INSERTABLE_CLASS__*)  objectIn__CAPPED_KEY__At:(NSUI)i	{	return [self __INTERNAL_KEYPATH__][i];  }\
//- (void)removeObjectFrom__CAPPED_KEY__AtIndex:(NSUI)i { 	[[self __INTERNAL_KEYPATH__] removeObjectAtIndex:i];  };\
//- (void)insertObject:(__INSERTABLE_CLASS__*)o in__CAPPED_KEY__AtIndex:(NSUI)i {	[[self __INTERNAL_KEYPATH__] insertObject:o atIndex:i]; }\
//
//SynthesizeMutableAccessors(@"colors",cls[name],NSC);
/*
@implementation  AZCLIMenu

- (void) provideStdin:						(NSFH*)std	{
	// send a simple program to clang using a GCD task
   dispatch_queue_t aQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
   dispatch_async(aQueue, ^{
      [std writeData:[ @"int main(int argc, char **argv)\n"	dataUsingEncoding:NSUTF8StringEncoding]];
      [std writeData:[ @"{\n" 										dataUsingEncoding:NSUTF8StringEncoding]];
      [std writeData:[ @"   write(1, \"hello\\n\", 6);\n" 	dataUsingEncoding:NSUTF8StringEncoding]];
      [std writeData:[ @"}\n" 										dataUsingEncoding:NSUTF8StringEncoding]];
      [std closeFile];	// sent the code, close the file (pipe in this case)
   });
}
- (void) getData:								(NSNOT*)n 	{
	// read the output from clang and dump to console
   NSS *textRead = [NSS stringWithData:[n.userInfo objectForKey:NSFileHandleNotificationDataItem] encoding:NSUTF8StringEncoding];
   NSLog(@"read %3ld: %@", (long)textRead.length, textRead);
}
- (void) applicationDidFinishLaunching:(NSNOT*)n	{

// invoke clang using an NSTask, reading output via notifications and providing input via an async GCD task
   NSTask *task 			= NSTask.new;
   NSPipe *outputPipe 	= NSPipe.new;
   NSPipe *inPipe 		= NSPipe.pipe;
	task.standardOutput 	= outputPipe;
   task.standardError 	= outputPipe;
   NSFH *outputHandle 	= outputPipe.fileHandleForReading;
	task.standardInput	= inPipe;
   task.launchPath		= @"/usr/bin/clang";
   task.arguments			= @[@"-o", @"/tmp/clang.out", @"-xc",@"-"];
   [AZNOTCENTER addObserver:self selector:@selector(getData:) name:NSFileHandleReadCompletionNotification object:outputHandle];
   [outputHandle readInBackgroundAndNotify];
   [task launch];
   [self provideStdin:inPipe.fileHandleForWriting];
}

@end
*/
#import "NSTerminal.h"

//@implementation NSArray (AZCLI)
//- (NSS*) cliMenuFromContentsStarting:(NSUI)idx inPalette:(NSA*)pal {

//@interface AZPalette ()
//
//@property (ASS) 	 NSUI index;
//@end
//static NSMD *cls = nil;

