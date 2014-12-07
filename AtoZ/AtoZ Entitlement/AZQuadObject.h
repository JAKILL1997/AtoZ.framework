
#import "AZQuadCell.h"

@interface AZQuadCarousel : NSObject <iCarouselDataSource, iCarouselDelegate, NSWindowDelegate>

@property (NATOM, STRNG) AZTW 	*track_N, 	*track_S, 	*track_E, 	*track_W;
@property (NATOM, STRNG) iC 		 *menu_N, 	 *menu_S, 	 *menu_E, 	 *menu_W;
@property (NATOM) iC *activeMenu;

@property (NATOM) iCarouselType cType;
@property (NATOM) CGF 	fontSize;
@property (NATOM) NSUI 	iconStyle, 	selectedIndex, 	tilt;
@prop_RO NSRNG selectedRange;
@property (NATOM, STRNG) NSS 		*activeMenuID,	*activeTrackID;
@property (NATOM, STRNG) NSD 		*windowLog;
@prop_RO 			 NSA 		*menus, 			*tracks;

@property (NATOM) Option option;
@property (UNSFE) id refToSelf;

@property (NATOM, STRNG) NSMutableArray 	*items;
@property (NATOM, STRNG) NSD 					*quads;
@property (NATOM, STRNG) AZSegmentedRect 	*seg;

- (IBAction) toggleQuadFlip: _;
                              //- (IBAction) toggleQuad:	 _;
                              //- (IBAction) setType:		 _;
                              
-(IBAction)advance:_;
                              -(IBAction)rewind:_;
                              
@end

//- (IBAction) setVeils:		 _;
                              //@property (nonatomic, strong) IBOutlet NSArray *southWest;
//@property (nonatomic, strong) IBOutlet NSArray *northEast;
//@property (nonatomic, assign) iCarouselType type;
//@property (nonatomic, strong) NSMutableArray* content;
//@property (nonatomic, strong) AZTrackingWindow *floater;
//@property (nonatomic, assign) NSUInteger visibleItems;
//@property (unsafe_unretained)) iCarousel *activeMenu;
//@property (nonatomic, assign) BOOL wrap;

//@property (weak) IBOutlet AZEntitlementDelegate *entitler;
//@property (nonatomic, strong) AZSizer *szr;
//- (id) 		 	objectAtIndex: 	 (NSUInteger)	index 			inQuad:(AZWindowPosition)quadrant;
//- (NSUInteger) 	itemsInQuad:		 (AZWindowPosition)		quadrant;
//- (NSA*) 	contentsOfQuad:  (AZWindowPosition)		quadrant;
//- (void) 	 	insertItem:	 	 (id)			item;
//- (void) 	 	insertItems:	 	 (NSA*)	items;
//- (NSRange)		ofQuad:			 (AZWindowPosition)quadrant;

//- (void) removeItem:(id)item;
//- (void) removeItems:(NSA*)items;
