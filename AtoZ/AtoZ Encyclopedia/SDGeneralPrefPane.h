//
//  SDPreferencesController.h
//  DeskLabels
//
//  Created by Steven Degutis on 7/1/09.
//  Copyright 2009 8th Light. All rights reserved.
//


#define SDNoteAppearanceDidChangeNotification @"SDNoteAppearanceDidChangeNotification"

#import "SDPreferencesController.h"

@interface SDGeneralPrefPane : NSViewController <SDPreferencePane> {

}

- (IBAction) changeAppearance:_;
                              
@end
