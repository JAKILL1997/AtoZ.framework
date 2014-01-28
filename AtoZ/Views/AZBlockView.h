

//@class BLKCELL;
//#define DRAWCELLBLK ^(BLKCELL*cell,NSR cellFrame,NSV*controlView)
//typedef void(^AZCellBlockDrawer)	(BLKCELL*cell, NSR cF, NSV*cV);
//@interface BLKCELL : NSButtonCell
//+ (instancetype) inView:(NSV*)v withBlock:(void(^)(BLKCELL*,NSR,NSV*))blk;
//@property (NATOM, CP) AZCellBlockDrawer 			dBlock;
//@end



/** AZBlockView.h - USAGE

[[someView addSubview:
	[AZBlockView viewWithFrame:someView.bounds opaque:NO drawnUsingBlock: ^(AZBlockView *view, NSRect dirtyRect) {
		view.autoresizingMask = NSViewHeightSizable| NSViewWidthSizable;
		[RED set];
		[[NSBezierPath bezierPathWithRoundedRect:view.bounds xRadius:5 yRadius:5] fill];
	}]
]positioned:NSWindowBelow relativeTo:anotherView];

*/


//@class AZBlockView;
//// Declare the AZBlockViewDrawer block type:
//typedef void(^AZBlockViewDrawer)(AZBlockView *view, NSRect dirtyRect);
//@interface AZBlockView : NSView {
//	AZBlockViewDrawer drawBlock;
//	BOOL opaque;
//}
//+ (AZBlockView *)viewWithFrame:(NSRect)frame
//						 opaque:(BOOL)opaque
//				drawnUsingBlock:(AZBlockViewDrawer)drawBlock;
//@property (NATOM, CP) AZBlockViewDrawer drawBlock;
//@property (nonatomic, assign) BOOL opaque;
//@end

/*		Usage:

- (void) awakeFromNib {
 	block __typeof(self) blockSelf = self; 
 	[[self view] addSubview:[BNRBlockView viewWithFrame:contentRect opaque:NO drawnUsingBlock:^(BNRBlockView *view, NSRect dirtyRect) { 
 		[[blockSelf roundedRectFillColor] set]; 
		[[NSBezierPath bezierPathWithRoundedRect:[view bounds] xRadius:5 yRadius:5] fill]; 
 	}]];
}

**** IN NSIMAGE + AZOTZ  ***
typedef void(^NSImageDrawer)(void);

@interface NSImage (AtoZDrawBlock)
+ (NSImage*)imageWithSize:(NSSZ)size drawnUsingBlock:(NSImageDrawer)drawBlock;
@end
*/


@class BLKVIEW;
#define DRAWBLK ^(BLKVIEW*v,NSR r)
//#define BLKVIEWinVIEW(v,blk) [v addSubview:[BLKVIEW
typedef void(^BNRBlockViewDrawer)		(BLKVIEW*v, NSR r);
typedef void(^BNRBlockViewLayerDelegate) (BLKVIEW*v, CAL*l);

@interface BNRBlockView : NSView

//[BLKVIEW inView:win.contentView withFrame:win.contentRect inContext:^(BLKVIEW*v, CAL*l){ NSRectFillWithColor(l.bounds, GREEN); }];
+ (BLKVIEW*) inView:(NSV*)v withFrame:(NSR)f inContext:(void(^)(BLKVIEW*view, CAL*lay))block;

+ (BLKVIEW*) inView:(NSV*)v withBlock:(BNRBlockViewLayerDelegate)ctxBlock;

+ (BLKVIEW*) viewWithFrame:(NSR)frame  opaque:(BOOL)opaque
			  drawnUsingBlock:(BNRBlockViewDrawer) drawBlock;

@property (NATOM, CP) BNRBlockViewDrawer 			dBlock;
@property (NATOM, CP) BNRBlockViewLayerDelegate lBlock;
@property (nonatomic, assign) BOOL opaque;
@end


@class BNRBlockView;
@interface AZBlockWindow : NSWindow
+ (AZBlockWindow *)windowWithFrame:(NSRect)frame drawnUsingBlock:(BNRBlockViewDrawer)drawBlock;
@property (NATOM, CP) BNRBlockViewDrawer drawBlock;
@end
