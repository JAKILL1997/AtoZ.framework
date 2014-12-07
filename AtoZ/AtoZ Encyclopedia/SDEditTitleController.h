//
//  SDEditTitleController.h
//  DeskNotation
//
//  Created by Steven Degutis on 6/30/09.
//  Copyright 2009 8th Light. All rights reserved.
//


@class SDTitleFieldEditor;

@interface SDEditTitleController : NSWindowController {

//	NSString *aNewTitle;

}
@property (nonatomic, assign) IBOutlet NSTextField *titleTextField;

@property (nonatomic, retain) NSString *title;
@property (nonatomic, retain) SDTitleFieldEditor *fieldEditor;

- (IBAction) accept:_;
                              - (IBAction) cancel:_;
                              
//- (void) setTitle:(NSString*)title;
- (void) setTitleFieldWidth:(float)width;

@end
