//  THRect.h  Lumumba Framework  Created by Benjamin Schüttler on 28.09.09.  Copyright 2011 Rogue Coding. All rights reserved.

//#import "AZGeometry.h"
//#import "AZGeometricFunctions.h"
//@import AtoZUniversal;
//#import "AZPoint.h"
//+ (INST) r;
//+ (INST) rect;

//#import <Zangetsu/Zangetsu.h>
//#import "BoundingObject.h"



//+ (INST) rect:(NSR)r inside:(NSR)outer;
//+ (INST) rect:(NSR)r inside:(NSR)outer mask:(enum CAAutoresizingMask)m;
//+ (INST) rectOf:			(id)object;
//+ (INST) rectWithOrigin:(NSP)origin andSize:(NSSZ)size;
//+ (INST) rectWithX:		(CGF)x andY:(CGF)y  width:(CGF)width  height:(CGF)height;
//+ (INST) rect:(NSR)frame oriented:(AZPOS)pos;

//+ (BOOL)maybeRect:(id) object;

//- (AZA) alignInside:(NSR)ext;
//+ (AZRect*) rectWithRect:	(NSR)rect;
//- (id) initWithRect: (NSR)rect;
//- (id) initWithSize: (NSSZ)size;
//- (id) initFromPoint:(NSP)ptOne toPoint:(NSP)ptTwo;
//- (id) initWithFrame:(NSR)frame inFrame:(NSR)superframe;

//@property (NA) CGP 		anchor;//, position;
//@property (NA) CGF 		 maxX, maxY, minY, minX;//, w, h;width, height,
//@property (NA) NSP 		origin, center, apex;
//@property (NA) NSSZ 	size;
//@property (NA) NSR 		 r; // rect,
//@property (NA) AZA	orient;

//- (void) setApex:(NSP)p move1Scale2:(NSN*)n;

//- (id) shrinkBy:(id) object;
//- (id) shrinkByPadding:(NSI)padding;
//- (id) shrinkBySizePadding:(NSSZ)padding;

//- (id) growBy:				 	(id) object;
//- (id) growByPadding:		(NSI)padding;
//- (id) growBySizePadding:	(NSSZ)padding;


//- (id) centerOn:(id)bounds;
//- (id) moveTo:  (id)relationPoint ofRect:(id) bounds;
//- (id) sizeTo:  (id)relationPoint ofRect:(id) bounds;

// graphing
//- (void) drawFrame;
//- (void) fill;

/** Returns a rect that uses aSize as its size and centered inside the given rect.

The returned rect is expressed relative the given rect parent coordinate space.<br />
To get a rect expressed relative the the given rect itself, pass a rect with a zero 
origin: 
<code>
NSRect inRect = NSMakeRect(40, 50, 100, 200);
NSRect centeredRectSize = NSMakeSize(50, 100);
NSRect rect = ETCenteredRect(centeredRectSize, ETMakeRect(NSZeroPoint, inRect.size));
</code>
The resulting rect is equal to { 25, 50, 50, 100 }.

The returned rect origin is valid whether or not your coordinate space is flipped. */
static inline NSR AZCenteredRect(NSSize aSize, NSR inRect)
{
	CGF xOffset = aSize.width * 0.5f;
	CGF x = NSMidX(inRect) - xOffset;
	CGF yOffset = aSize.height  * 0.5f;
	CGF y = NSMidY(inRect) - yOffset;

	return NSMakeRect(x, y, aSize.width, aSize.height);
}

@interface AZEdge : NSObject
+ (INST) rect:(AZRect*)r along:(AZRect*)outer inside:(BOOL)isinide;
@property (NA) AZA alignment;
@property (NA) AZOrient orient;
@property (NA) CGF cornerTreshHold, snapThreshold;
//- (void) moveInDirection:(NSSZ)sz;
@end


@interface NSObject (AZRectResponder)

@end

/*	Returns a rect that uses aSize scaled based on the content aspect rule and then centered inside the given rect.
	The returned rect is expressed relative the given rect parent coordinate space.
	To get a rect expressed relative the the given rect itself, see ETCenteredRect().
	The returned rect origin is valid whether or not your coordinate space is flipped. 
	
	extern NSR AZScaledRect(NSSize aSize, NSR inRect);
	Returns a rect with a width and height multiplied by the given factor and by shifting the origin to retain the original rect center location. 
static inline NSR AZScaleRect(NSRect frame, CGF factor) {
	NSSize prevSize = frame.size;
	NSRect newFrame;
	newFrame.size  = (NSSZ) {frame.size.width *2, frame.size.height*2};
	//AZMultiplySize( frame.size,  factor);
	// NOTE: frame.origin.x -= (frame.size.width - prevSize.width) / 2;
	//	   	frame.origin.y -= (frame.size.height - prevSize.height) / 2;
	newFrame.origin.x += (prevSize.width 	- newFrame.size.width ) / 2;
	newFrame.origin.y += (prevSize.height 	- newFrame.size.height) / 2;
	return frame;
}
*/
