//
//  CTGradient.h
//
//  Created by Chad Weider on 12/3/05.
//  Copyright (c) 2006 Cotingent.
//  Some rights reserved: <http://creativecommons.org/licenses/by/2.5/>
//
//  Version: 1.5


typedef struct _CTGradientElement 
	{
	CGFloat red, green, blue, alpha;
	CGFloat position;
	
	struct _CTGradientElement *nextElement;
	} CTGradientElement;

typedef enum  _CTBlendingMode
	{
	CTLinearBlendingMode,
	CTChromaticBlendingMode,
	CTInverseChromaticBlendingMode
	} CTGradientBlendingMode;
@interface CTGradient : NSObject <NSCopying, NSCoding>
	{
	CTGradientElement* elementList;
	CTGradientBlendingMode blendingMode;
	
	CGFunctionRef gradientFunction;
	}

+ gradientWithBeginningColor:(NSColor *)begin endingColor:(NSColor *)end;

+ aquaSelectedGradient;
+ aquaNormalGradient;
+ aquaPressedGradient;

+ unifiedSelectedGradient;
+ unifiedNormalGradient;
+ unifiedPressedGradient;
+ unifiedDarkGradient;

+ sourceListSelectedGradient;
+ sourceListUnselectedGradient;

- (CTGradient *)gradientWithAlphaComponent:(float)alpha;

- (CTGradient *)addColorStop:(NSColor *)color atPosition:(float)position;	//positions given relative to [0,1]
- (CTGradient *)removeColorStopAtIndex:(unsigned)index;
- (CTGradient *)removeColorStopAtPosition:(float)position;

- (CTGradientBlendingMode)blendingMode;
- (NSColor *)colorStopAtIndex:(unsigned)index;
- (NSColor *)colorAtPosition:(float)position;
- (void)drawSwatchInRect:(NSRect)rect;
- (void)fillRect:(NSRect)rect angle:(float)angle;					//fills rect with axial gradient
																	//	angle in degrees
- (void)radialFillRect:(NSRect)rect;								//fills rect with radial gradient
																	//  gradient from center outwards
@end
