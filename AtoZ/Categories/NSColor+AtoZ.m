
//  NSColot+AtoZ.m

#import "AtoZ.h"
#import "NSColor+AtoZ.h"
#import "AZNamedColors.h"

JREnumDefine(AZeColor);

#define AIfmod( X, Y )	fmod((X),(Y))

typedef struct {  NSUI value;	const char name[24];} ColorNameRec;   // Longest name is 20 chars, pad out to multiple of 8

static ColorNameRec sColorTable[] = {

	{ 0xf0f8ff, "aliceblue" },			{ 0xfaebd7, "antiquewhite" },			{ 0x00ffff, "aqua" },				{ 0x7fffd4, "aquamarine" },				{ 0xf0ffff, "azure" },
	{ 0xf5f5dc, "beige" },				{ 0xffe4c4, "bisque" },					{ 0x000000, "black" },				{ 0xffebcd, "blanchedalmond" },			{ 0x0000ff, "blue" },
	{ 0x8a2be2, "blueviolet" },		{ 0xa52a2a, "brown" },					{ 0xdeb887, "burlywood" },			{ 0x5f9ea0, "cadetblue" },					{ 0x7fff00, "chartreuse" },
	{ 0xd2691e, "chocolate" },			{ 0xff7f50, "coral" },					{ 0x6495ed, "cornflowerblue" },	{ 0xfff8dc, "cornsilk" },					{ 0xdc143c, "crimson" },
	{ 0x00ffff, "cyan" },				{ 0x00008b, "darkblue" },				{ 0x008b8b, "darkcyan" },			{ 0xb8860b, "darkgoldenrod" },			{ 0xa9a9a9, "darkgray" },
	{ 0xa9a9a9, "darkgrey" },			{ 0x006400, "darkgreen" },				{ 0xbdb76b, "darkkhaki" },			{ 0x8b008b, "darkmagenta" },				{ 0x556b2f, "darkolivegreen" },
	{ 0xff8c00, "darkorange" },		{ 0x9932cc, "darkorchid" },			{ 0x8b0000, "darkred" },			{ 0xe9967a, "darksalmon" },				{ 0x8fbc8f, "darkseagreen" },
	{ 0x483d8b, "darkslateblue" },	{ 0x2f4f4f, "darkslategray" },		{ 0x2f4f4f, "darkslategrey" },	{ 0x00ced1, "darkturquoise" },			{ 0x9400d3, "darkviolet" },
	{ 0xff1493, "deeppink" },			{ 0x00bfff, "deepskyblue" },			{ 0x696969, "dimgray" },			{ 0x696969, "dimgrey" },					{ 0x1e90ff, "dodgerblue" },
	{ 0xb22222, "firebrick" },			{ 0xfffaf0, "floralwhite" },			{ 0x228b22, "forestgreen" },		{ 0xff00ff, "fuchsia" },					{ 0xdcdcdc, "gainsboro" },
	{ 0xf8f8ff, "ghostwhite" }, 		{ 0xffd700, "gold" },					{ 0xdaa520, "goldenrod" },			{ 0x808080, "gray" },						{ 0x808080, "grey" },
	{ 0x008000, "green" },				{ 0xadff2f, "greenyellow" },			{ 0xf0fff0, "honeydew" },			{ 0xff69b4, "hotpink" },					{ 0xcd5c5c, "indianred" },
	{ 0x4b0082, "indigo" },				{ 0xfffff0, "ivory" },					{ 0xf0e68c, "khaki" },				{ 0xe6e6fa, "lavender" },					{ 0xfff0f5, "lavenderblush" },
	{ 0x7cfc00, "lawngreen" },			{ 0xfffacd, "lemonchiffon" },			{ 0xadd8e6, "lightblue" },			{ 0xf08080, "lightcoral" },				{ 0xe0ffff, "lightcyan" },
	{ 0xfafad2, "lightgoldenrodyellow" },	{ 0xd3d3d3, "lightgray" },		{ 0xd3d3d3, "lightgrey" },			{ 0x90ee90, "lightgreen" },				{ 0xffb6c1, "lightpink" },
	{ 0xffa07a, "lightsalmon" },		{ 0x20b2aa, "lightseagreen" },		{ 0x87cefa, "lightskyblue" },		{ 0x8470ff, "lightslateblue" },			{ 0x778899, "lightslategray" },
	{ 0x778899, "lightslategrey" },	{ 0xb0c4de, "lightsteelblue" },		{ 0xffffe0, "lightyellow" },		{ 0x00ff00, "lime" },						{ 0x32cd32, "limegreen" },
	{ 0xfaf0e6, "linen" },				{ 0xff00ff, "magenta" },				{ 0x800000, "maroon" },				{ 0x66cdaa, "mediumaquamarine" },		{ 0x0000cd, "mediumblue" },
	{ 0xba55d3, "mediumorchid" },		{ 0x9370d8, "mediumpurple" },			{ 0x3cb371, "mediumseagreen" },	{ 0x7b68ee, "mediumslateblue" },			{ 0x00fa9a, "mediumspringgreen" },
	{ 0x48d1cc, "mediumturquoise" },	{ 0xc71585, "mediumvioletred" },		{ 0x191970, "midnightblue" },		{ 0xf5fffa, "mintcream" },					{ 0xffe4e1, "mistyrose" },
	{ 0xffe4b5, "moccasin" },			{ 0xffdead, "navajowhite" },			{ 0x000080, "navy" },				{ 0xfdf5e6, "oldlace" },					{ 0x808000, "olive" },
	{ 0x6b8e23, "olivedrab" },			{ 0xffa500, "orange" },					{ 0xff4500, "orangered" },			{ 0xda70d6, "orchid" },						{ 0xeee8aa, "palegoldenrod" },
	{ 0x98fb98, "palegreen" },			{ 0xafeeee, "paleturquoise" },		{ 0xd87093, "palevioletred" },	{ 0xffefd5, "papayawhip" },				{ 0xffdab9, "peachpuff" },
	{ 0xcd853f, "peru" },				{ 0xffc0cb, "pink" },					{ 0xdda0dd, "plum" },				{ 0xb0e0e6, "powderblue" },				{ 0x800080, "purple" },
	{ 0xff0000, "red" },					{ 0xbc8f8f, "rosybrown" },				{ 0x4169e1, "royalblue" },			{ 0x8b4513, "saddlebrown" },				{ 0xfa8072, "salmon" },
	{ 0xf4a460, "sandybrown" },		{ 0x2e8b57, "seagreen" },				{ 0xfff5ee, "seashell" },			{ 0xa0522d, "sienna" },						{ 0xc0c0c0, "silver" },
	{ 0x87ceeb, "skyblue" },			{ 0x6a5acd, "slateblue" },				{ 0x708090, "slategray" },			{ 0x708090, "slategrey" },					{ 0xfffafa, "snow" },
	{ 0x00ff7f, "springgreen" },		{ 0x4682b4, "steelblue" },				{ 0xd2b48c, "tan" },					{ 0x008080, "teal" },						{ 0xd8bfd8, "thistle" },
	{ 0xff6347, "tomato" },				{ 0x40e0d0, "turquoise" },				{ 0xee82ee, "violet" },				{ 0xd02090, "violetred" },					{ 0xf5deb3, "wheat" },
	{ 0xffffff, "white" },				{ 0xf5f5f5, "whitesmoke" },			{ 0xffff00, "yellow" },				{ 0x9acd32, "yellowgreen" },
};

static NSC *ColorWithUnsignedLong(unsigned long value, BOOL hasAlpha) {

 	float a = hasAlpha ? (float)(0x00FF & value)	/ 255.0 : 1.0;   // Extract alpha, if available
  	if (hasAlpha) value >>= 8;
	float r = (float)				(value >> 16) 	/ 255.0,
	g = (float)(0x00FF & (value >> 8)) 	/ 255.0,
	b = (float)(0x00FF & value) 			/ 255.0;  	return [NSC r:r g:g b:b a:a];
}

static NSC *ColorWithHexDigits(NSS *str) {    NSString *hexStr;

	NSScanner 	  *scanner = [NSScanner 		 scannerWithString:						str.lowercaseString];
	NSCharacterSet *hexSet = [NSCharacterSet characterSetWithCharactersInString:@"0123456789abcdef"];

	[scanner scanUpToCharactersFromSet:hexSet intoString:	  nil];
	[scanner scanCharactersFromSet:    hexSet intoString:&hexStr];

	if (hexStr.length < 6) return nil;
	BOOL 		hasAlpha = hexStr.length == 8;
	unsigned long value = strtoul(hexStr.UTF8String, NULL, 16);
	return ColorWithUnsignedLong(value, hasAlpha);
}

static NSC *ColorWithCSSString(NSS *str) {

	NSString  *trimmed = [str stringByTrimmingCharactersInSet:NSCharacterSet.whitespaceCharacterSet];
	NSString *lowerStr = trimmed.lowercaseString;
	NSScanner *scanner = [NSScanner scannerWithString:lowerStr];

	if ([scanner scanString:@"rgb" intoString:NULL]) {
		[scanner scanString:@"(" intoString:NULL];
		NSString *content;
		[scanner scanUpToString:@")" intoString:&content];
		NSCharacterSet *spaceOrCommaSet = [NSCharacterSet characterSetWithCharactersInString:@" ,"];
		NSArray *components = [content componentsSeparatedByCharactersInSet:spaceOrCommaSet];
		int count = components.count;
		float a = count > 3 ? (float)[[components objectAtIndex:3] fV] : 1.0,
				r = (float)strtoul([components stringAtIdx:0].UTF8String, NULL, 10) / 255.0,
				g = (float)strtoul([components stringAtIdx:1].UTF8String, NULL, 10) / 255.0,
				b = (float)strtoul([components stringAtIdx:2].UTF8String, NULL, 10) / 255.0;

		return [NSColor colorWithCalibratedRed:r green:g blue:b alpha:a];
	}

	return nil;
}

int  hexToInt ( char  hex ) {	return 	hex >= '0' && hex <= '9' ? hex - '0'
											  	:	hex >= 'a' && hex <= 'f' ? hex - 'a' + 10
												: 	hex >= 'A' && hex <= 'F'	?	hex - 'A' + 10 : -1;
} // Convert hex to an int

char intToHex ( NSI dig ) { return dig > 9 ? ( dig <= 0xf ? ('a' + dig - 10) : '\0') : dig >= 0 ? '0' + dig : '\0' ; /*NUL*/ } // Convert int to a hex

static CGF LuminanceFromRGBComponents(const CGF *rgb) { return .3086f*rgb[0] + .6094f*rgb[1] + .0820f*rgb[2]; /* 0.3086 + 0.6094 + 0.0820 = 1.0 */ }

#import <string.h>

static NSArray *defaultValidColors = nil;

#define VALID_COLORS_ARRAY @[							@"aqua",						@"aquamarine",				@"blue",					@"blueviolet",					@"brown",					\
	@"burlywood",			@"cadetblue",				@"chartreuse",				@"chocolate",				@"coral",				@"cornflowerblue",			@"crimson",			 		\
	@"cyan",					@"darkblue",				@"darkcyan",				@"darkgoldenrod",			@"darkgreen",			@"darkgrey",					@"darkkhaki",				\
	@"darkmagenta",		@"darkolivegreen",		@"darkorange",				@"darkorchid",				@"darkred",				@"darksalmon",					@"darkseagreen",			\
	@"darkslateblue",		@"darkslategrey",			@"darkturquoise",			@"darkviolet",				@"deeppink",			@"deepskyblue",				@"dimgrey",					\
	@"dodgerblue",			@"firebrick",				@"forestgreen",			@"fuchsia",					@"gold",					@"goldenrod",					@"green",					\
	@"greenyellow",		@"grey",						@"hotpink",					@"indianred",				@"indigo",				@"lawngreen",					@"lightblue",				\
	@"lightcoral",			@"lightgreen",				@"lightgrey",				@"lightpink",				@"lightsalmon",		@"lightseagreen",				@"lightskyblue",			\
	@"lightslategrey",	@"lightsteelblue",		@"lime",						@"limegreen",				@"magenta",				@"maroon",						@"mediumaquamarine",		\
	@"mediumblue",			@"mediumorchid",			@"mediumpurple",			@"mediumseagreen",		@"mediumslateblue",	@"mediumspringgreen",		@"mediumturquoise",		\
	@"mediumvioletred",	@"midnightblue",			@"navy",						@"olive",					@"olivedrab",			@"orange",						@"orangered",				\
	@"orchid",				@"palegreen",				@"paleturquoise",			@"palevioletred",			@"peru",					@"pink",							@"plum",						\
	@"powderblue",			@"purple",					@"red",						@"rosybrown",				@"royalblue",			@"saddlebrown",				@"salmon",					\
	@"sandybrown",			@"seagreen",				@"sienna",					@"silver",					@"skyblue",				@"slateblue",					@"slategrey",				\
	@"springgreen",		@"steelblue",				@"tan",						@"teal",						@"thistle",				@"tomato",						@"turquoise",				\
	@"violet",				@"yellowgreen"]

static const CGF 	ONE_THIRD = 1.0f / 3.0, ONE_SIXTH = 1.0f / 6.0,	TWO_THIRD = 2.0f / 3.0;

static NSMD *bestMatches = nil, 	*palettesD = nil, *colorListD = nil, *colorsFromStruct = nil;
static NSCL 		 *safe = nil,  	 *named = nil;

@implementation NSColor (AtoZ)

+ (NSA*) randomPaletteAnimationBlock:(colorFadeBlock)target {	NSA* r = RANDOMPAL;
	NSA* pal = [self gradientPalletteLooping:r steps:1000];	NSLog(@"number of colors in fade: %ld", pal.count);


  __block NSUI ct = 0;
	return [NSTimer scheduledTimerWithTimeInterval:.2 block:^(NSTimer *timer) { //		NSLog(@"gotColor: %@", u.nameOfColor);
		NSColor*u =[pal normal:ct]; ct++; target(u);
 	} repeats:YES], pal;
}

//@dynamic name;

//SYNTHESIZE_ASC_OBJ_LAZYDEFAULT_EXP(name,setName,[self nameOfColor])
//SYNTHESIZE_ASC_OBJ_LAZY_BLOCK(name,
SYNTHESIZE_ASC_OBJ_BLOCK(name, setName, ^{ if (!value) value = self.nameOfColor; }, ^{});

- (NSComparisonResult)compare:(NSC *)otherColor {
	// comparing the same type of animal, so sort by name
	//	if ([self kindOfAnimal] == [otherAnimal kindOfAnimal]) return [[self name] caseInsensitiveCompare:[otherAnimal name]];
	// we're comparing by kind of animal now. they will be sorted by the order in which you declared the types in your enum // (Dogs first, then Cats, Birds, Fish, etc)
	//	return [[NSNumber numberWithInt:[self kindOfAnimal]] compare:[[[NSNumber]] numberWithInt:[otherAnimal kindOfAnimal]]]; }
	return [@(self.hueComponent)compare : @(otherColor.hueComponent)];
}

- (NSG*) gradient {	return [self associatedValueForKey:@"_gradient" orSetTo:
		[NSG.alloc initWithColorsAndLocations:self.brighter.brighter, 0.0,self.brighter, .13, self, 0.5,self.darker, .8,self.darker.darker.darker, 1.0, nil]];
}

+ (NSD*) colorNamesDictionary		{ static NSD *colorNames = nil;  	return colorNames = colorNames ?:

	@{	@"black"		: [NSC colorWithHTMLString:   @"#000"], 	@"silver"	: [NSC colorWithHTMLString:  @"#c0c0c0"],
		@"gray"		: [NSC colorWithHTMLString:@"#808080"], 	@"grey"		: [NSC colorWithHTMLString:  @"#808080"],
		@"white"		: [NSC colorWithHTMLString:	@"#fff"],	@"maroon"	: [NSC colorWithHTMLString:  @"#800000"],
		@"red"		: [NSC colorWithHTMLString:   @"#f00"],	@"purple"   : [NSC colorWithHTMLString:  @"#800080"],
		@"fuchsia"	: [NSC colorWithHTMLString:	@"#f0f"], 	@"green"		: [NSC colorWithHTMLString:  @"#008000"],
		@"lime"		: [NSC colorWithHTMLString:   @"#0f0"],   @"olive"		: [NSC colorWithHTMLString:  @"#808000"],
		@"yellow"	: [NSC colorWithHTMLString:   @"#ff0"],   @"navy"		: [NSC colorWithHTMLString:  @"#000080"],
		@"blue"		: [NSC colorWithHTMLString:   @"#00f"],	@"teal"		: [NSC colorWithHTMLString:  @"#008080"],
		@"aqua"		: [NSC colorWithHTMLString:   @"#0ff"]};
}

+ (id)colorWithHTMLString:(NSS*)str	{	return [self colorWithHTMLString:str defaultColor:nil];	}

+ (id)colorWithHTMLString:(NSS*)str defaultColor:(NSC*)defaultColor	{	if (!str || (!str.length && !defaultColor)) return nil;

	NSString *colorValue = str;
	if (!str.length || [str characterAtIndex:0] != '#') {
		//look it up; it's a colour name
		colorValue = self.colorNamesDictionary[str] ?: [self.colorNamesDictionary objectForKey:str.lowercaseString] ?: defaultColor;
#if COLOR_DEBUG
		if (!colorValue) colorValue = defaultColor
			NSLog(@"+[NSColor(AIColorAdditions) colorWithHTMLString:] called with unrecognised color name (str is %@); returning %@", str, defaultColor);
#endif
	}
	//we need room for at least 9 characters (#00ff00ff) plus the NUL terminator. this array is 12 bytes long because I like multiples of four. ;)
	enum { hexStringArrayLength = 12 };
	size_t hexStringLength = 0;
	char hexStringArray[hexStringArrayLength] = { 0, 0, 0, 0,  0, 0, 0, 0,  0, 0, 0, 0, };
	{
		NSData *stringData = [str dataUsingEncoding:NSUTF8StringEncoding];
		hexStringLength = [stringData length];
		memcpy(hexStringArray, [stringData bytes], MIN(hexStringLength, hexStringArrayLength - 1)); 		//subtract 1 because we don't want to overwrite that last NUL.
	}
	const char *hexString = hexStringArray;
	float 	red, green, blue, alpha = 1.0;
	if (*hexString == '#') ++hexString;  	//skip # if present.
	if (hexStringLength < 3) {
#if COLOR_DEBUG
		NSLog(@"+[%@ colorWithHTMLString:] called with a string that cannot possibly be a hexadecimal color specification (e.g. #ff0000, #00b, #cc08) (string: %@ input: %@); returning %@", NSStringFromClass(self), colorValue, str, defaultColor);
		return defaultColor;
#endif
	}
	//long specification:  #rrggbb[aa]	//short specification: #rgb[a]	//e.g. these all specify pure opaque blue: #0000ff #00f #0000ffff #00ff
	BOOL isLong = hexStringLength > 4;
	//for a long component c = 'xy':	//	c = (x * 0x10 + y) / 0xff	//for a short component c = 'x':		//	c = x / 0xf
	red   = hexToInt(*(hexString++));
	if (isLong) red    = (red   * 16.0 + hexToInt(*(hexString++))) / 255.0;
	else        red   /= 15.0;
	green = hexToInt(*(hexString++));
	if (isLong) green  = (green * 16.0 + hexToInt(*(hexString++))) / 255.0;
	else        green /= 15.0;
	blue  = hexToInt(*(hexString++));
	if (isLong) blue   = (blue  * 16.0 + hexToInt(*(hexString++))) / 255.0;
	else        blue  /= 15.0;
	if (*hexString) {
		//we still have one more component to go: this is alpha. without this component, alpha defaults to 1.0 (see initialiser above).
		alpha = hexToInt(*(hexString++));
		if (isLong) alpha = (alpha * 16.0 + hexToInt(*(hexString++))) / 255.0;
		else alpha /= 15.0;
	}
	return [self r:red g:green b:blue a:alpha];
}


+ (NSArray *)colorNames {  	static NSArray *sAllNames = nil;

	if (!sAllNames) {   	int count = sizeof(sColorTable) / sizeof(sColorTable[0]); NSMutableArray *names = NSMA.new; 	ColorNameRec *rec = sColorTable;
		for (int i = 0; i < count; ++i, ++rec)	[names addObject:$UTF8(rec->name)];
		sAllNames = names.copy;
		[names release];
	}
	return sAllNames;
}

+ (NSColor *)colorWithString:(NSString *)name {		if (![name length]) return nil;
	NSArray *allNames = self.colorNames;
	NSUI count = allNames.count;
	NSUI	 idx = [allNames indexOfObject:name.lowercaseString];
	// If the string contains some hex digits, try to convert #RRGGBB or #RRGGBBAA  rgb(r,g,b) or rgba(r,g,b,a)
	return idx >= count ? ColorWithHexDigits(name) : ColorWithCSSString(name) ?: ColorWithUnsignedLong(sColorTable[idx].value, NO);
}

+ (NSC*)colorFromAZeColor:(AZeColor)c { return [self colorWithString:[AZeColorToString(c)stringByRemovingPrefix:@"AZeColor"].lowercaseString];
	//	return [self colorFromString:$UTF8(sColorTable[c])];
}

+  (NSA*) colorListNames { return [self.colorLists.allValues vFKP:@"name"]; }

+ (NSMD*) colorLists 								{

	if (!colorListD) colorListD = NSMD.new;
	static dispatch_once_t onceToken;
	dispatch_once(&onceToken, ^{
		colorListD = [[[AZBUNDLE pathsForResourcesOfType:@"clr" inDirectory:@""] cw_mapArray:^id(id object) {
			return [NSColorList.alloc initWithName:[object baseName] fromFile:object] ?: nil;
		}]	 mapToDictionaryKeys:^id(NSCL* object) {	return [object name];
		}].mutableCopy;
	});
	return colorListD;
}

+ (NSA*) gradientPalletteLooping:(NSA*)colors steps:(NSUI)steps 				{

	NSC          *blend = [colors.first blend:colors.last];					// find the point betweenfirst and last...
	NSUI     blendSteps = (NSUI)floor(.1 *colors.count);   // use 10 % of the steps to blend
	NSA *blendFromStart = [NSC gradientPalletteBetween:@[blend,colors.first]	steps:blendSteps/2],
		    *blendFromEnd = [NSC gradientPalletteBetween:@[colors.last, blend]	steps:blendSteps/2];
	return [NSA arrayWithArrays:@[blendFromStart,
															[self gradientPalletteBetween:colors steps:steps-blendSteps],
															blendFromEnd]];
}

+ (NSA*) gradientPalletteBetween:(NSA*)colors steps:(NSUI)steps 				{

	int count = colors.count;
	CGFloat locations[colors.count];
	for (int i = 0; i < count; i++) locations[i] = (CGF)((float)i/(float)count);
	NSGradient *gradient = [NSGradient.alloc initWithColors:colors
															  atLocations:locations
																colorSpace:NSColorSpace.genericRGBColorSpace];
	NSSize imageSize = NSMakeSize(100, 4);
	NSBitmapImageRep *bitmapRep =
	[NSBitmapImageRep.alloc initWithBitmapDataPlanes:NULL
													  pixelsWide:(NSUInteger)imageSize.width
													  pixelsHigh:(NSUInteger)imageSize.height
												  bitsPerSample:8	samplesPerPixel:4
														 hasAlpha:YES	isPlanar:NO  // <--- important !
												 colorSpaceName:NSCalibratedRGBColorSpace
													 bytesPerRow:0	bitsPerPixel:0 ];
	__block NSA *cs;
   [NSGraphicsContext state:^{
		NSGraphicsContext *context =	[NSGraphicsContext graphicsContextWithBitmapImageRep:bitmapRep];
   	[NSGraphicsContext setCurrentContext:context];
		[gradient drawFromPoint:(NSP){0,2} toPoint:(NSP){100,2} options:0];
		cs = [[@0 to:@(steps)] nmap:^id(id obj, NSUInteger ii){
			int indc = ceil(( ( ii / (float)steps) * 100));
			return [bitmapRep colorAtX:indc y:3];
			//		NSLog(@"index %i of %ld", indc, steps );
			//		return (NSC*)[bitmapRep colorAtX:3 y :(int)(index/steps)];
		}];
	}];
	return cs;
	/* :AZRectFromSize(imageSize) angle:270];
	 [[NSC colorWithDeviceRed:0.2 green:0.3 blue:0.7 alpha:0.9]	 set];
	 //[[NSC colorWithCalibratedWhite:1.0 alpha:1.0] set];
	 NSRectFillUsingOperation(NSMakeRect(0, 0, imageSize.width,
	 imageSize.height),
	 NSCompositeCopy);
	 [[NSC redColor] set]; // adding a rect to see that (and how)
	 it works
	 [NSBezierPath fillRect:NSMakeRect(50, 50, 200,100)];
	 NSLog(@"%@", [bitmapRep colorAtX:10 y:10]);
	 for a test only:
	 [[bitmapRep TIFFRepresentation] writeToFile:@"/tmp/tst.tiff"
	 atomically:NO];
	 NSR rect = AZRectBy(100, 5);
	 NSIMG *img = [NSIMG imageWithSize:rect.size drawnUsingBlock:^{
	 [gradient drawInRect:rect angle:180];
	 }];
	 [img openInPreview];
	 NSBitmapImageRep* imageRep = [NSBitmapImageRep.alloc initWithData:[img TIFFRepresentation]];
	 NSA* loop = [colors arrayByAddingObject:colors.last];
	 return [NSA arrayWithArrays:[[@0 to: @(steps)]nmap:^id(id obj, NSUInteger index) {

	 int idx = (int)[obj floatValue]/loop.count;
	 idx = idx < loop.count ? idx : idx -1;
	 NSC *one = loop[idx];  NSC* two = loop[idx+1];
	 return [self gradientPalletteBetween:one and:two steps:(int)loop.count/steps];
	 }]];
	 */
}

+ (NSA*) gradientPalletteBetween:(NSC*)one and:(NSC*)two steps:(NSUI)steps	{
	CGF sr = one.redComponent, sg = one.greenComponent, sb = one.blueComponent;
	CGF er = two.redComponent, eg = two.greenComponent, eb = two.blueComponent;

	//	CGF (^percent)(int) = {step  * 100;//CGF index = 100 * percent;
	return [[@0 to:@(steps)]map:^id(id obj) {
		CGF count = 100;
		CGF index = ([obj floatValue]/steps) * 100;//CGF index = 100 * percent;
		int cutoff = 7;
		CGFloat delta =  count > cutoff ? delta = 1.0 / count : 1.0 / cutoff;
		count =  count > cutoff ? count : cutoff;
		CGFloat s = delta * (count - index);
		CGFloat e = delta * index;
		CGFloat red = sr * s + er * e;
		CGFloat green = sg * s + eg * e;
		CGFloat blue = sb * s + eb * e;
		return [NSC colorWithDeviceRed:red green:green blue:blue alpha:1];
	}];
}
- (NSC*) alpha:(CGF)f	{	return [self colorWithAlphaComponent:f];	}
- (NSC*) inverted			{
	NSC* original = [self colorUsingColorSpaceName:
						  NSCalibratedRGBColorSpace];
	CGFloat hue = [original hueComponent];
	if (hue >= 0.5) { hue -= 0.5; } else { hue += 0.5; }
	return [NSC colorWithCalibratedHue:hue
									saturation:[original saturationComponent]
									brightness:(1.0 - [original brightnessComponent])
										  alpha:[original alphaComponent]];
}
+ (NSC*) linen 			{
	return [NSC colorWithPatternImage: [NSImage imageNamed:@"linen.png"]];
}
+ (NSC*) linenTintedWithColor:		 (NSC*)color {
	static NSIMG *theLinen = nil;  theLinen = theLinen ?: [NSImage imageNamed:@"linen.png"];
	return [NSC colorWithPatternImage:[theLinen tintedWithColor:color]];
}
+ (NSC*) leatherTintedWithColor:		 (NSC*)color {
	return [NSC colorWithPatternImage:[[NSImage imageNamed:@"perforated_white_leather"]tintedWithColor:color]];
}
+ (NSC*) checkerboardWithFirstColor: (NSC*)one secondColor: (NSC*)two squareWidth:(CGF)x	{
	NSSize patternSize = NSMakeSize(x * 2.0, x * 2.0);
	NSRect rect = NSZeroRect;
	rect.size = patternSize;
	NSImage* pattern = [[NSImage alloc] initWithSize: patternSize];
	rect.size = AZSizeFromDimension(x);
	[pattern lockFocus];
	[one set];											NSRectFill(rect);
	rect.origin.x = x;	rect.origin.y = x;	NSRectFill(rect);
	[two set];
	rect.origin.x = 0.0;	rect.origin.y = x;	NSRectFill(rect);
	rect.origin.x = x;	rect.origin.y = 0.0;	NSRectFill(rect);
	[pattern unlockFocus];
	return [NSC colorWithPatternImage: pattern];
}
//+ (NSD*) colorsAndNames {  return [NSD dictionaryWithObjects:self. forKeys:self.colorNames]; }
//+ (NSA*) colorsWithNames {  return [self.colorNames map:^id(id obj) {  return [self colorNamed:obj]; }]; }
+ (NSC*) colorNamed:(NSS*) name {
	if (![name length])	return nil;
	//	NSArray *allNames = [self colorNames];
	//	NSUInteger count = [allNames count];
	//	NSUInteger idx = [allNames indexOfObject:[name lowercaseString]];
	//	if (idx >= count) {
	// If the string contains some hex digits, try to convert
	// #RRGGBB or #RRGGBBAA
	// rgb(r,g,b) or rgba(r,g,b,a)
	//		NSC*color = ColorWithHexDigits(name);
	//		if (!color)
	//			color = ColorWithCSSString(name);
	//		return color;
	//	}
	//	return ColorWithUnsignedLong(sColorTable[idx].value, NO);
}
+ (NSA*) boringColors{
	return  $array( @"White",	@"Whitesmoke",	@"Whitesmoke",@"Gainsboro",	@"LightGrey",	@"Silver",	@"DarkGray",	@"Gray",	@"DimGray",	@"Black",	@"Translucent",	@"MistyRose",	@"Snow",	@"SeaShell",	@"Linen",	@"Cornsilk",	@"OldLace",	@"FloralWhite",	@"Ivory",	@"HoneyDew",	@"MintCream",	@"Azure",	@"AliceBlue",	@"GhostWhite",	@"LavenderBlush",	@"mercury",	@"Slver",	@"Magnesium",	@"Tin",	@"Aluminum");
}
- (BOOL) isBoring {
	//	CGFloat r,g,b,a;
	//	[[self calibratedRGBColor] getRed:&r green:&g blue:&b alpha:&a];
	//
	////	if ( a > .6 ) {
	////		NSLog(@"Too much alpha... BORING");
	////		return TRUE;
	////	}
	//	float total = r + g + b;
	//	if ( (total > 2.8) || (total < .2) ) {
	//		NSLog(@"Not enough Color! BORING");
	NSC*deviceColor = [self colorUsingColorSpaceName:NSDeviceRGBColorSpace];
	if (( ([deviceColor saturationComponent] + [deviceColor hueComponent] + [deviceColor brightnessComponent]) > 1.6) && ( [deviceColor saturationComponent] > .3)) return FALSE;
	if (( [deviceColor brightnessComponent] 	< .3)	||  // too dark
		 ( [deviceColor saturationComponent] 	< .4)  // too blah
		 //		( [deviceColor brightnessComponent] 	> .8)   	// too bright
		 ) {
		return TRUE;
	}
	//	[[self closestNamedColor] containsAnyOf:[NSC boringColors]]) return TRUE;
	else return FALSE;
}
- (BOOL) isExciting {
	if ([self isBoring] ) return FALSE;
	//	containsAnyOf:[NSC boringColors]]) return FALSE;
	else return TRUE;
}
- (CGColorRef)cgColor {
	CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
	NSC*deviceColor = [self colorUsingColorSpaceName:NSDeviceRGBColorSpace];
	CGFloat components[4];
	[deviceColor getRed: &components[0] green: &components[1] blue:&components[2] alpha: &components[3]];
	CGColorRef output = CGColorCreate(colorSpace, components);
	CGColorSpaceRelease (colorSpace);
	return CGColorRetain(output);
	//[(id)output autorelease];
	//	return (__bridge CGColorRef)(__bridge_transfer id)output;
}
+ (NSC*) MAUVE 				{	static NSC*  MAUVE = nil;	if( MAUVE == nil )
	MAUVE = [NSC colorWithDeviceRed:0.712 green:0.570 blue:0.570 alpha:1.000];
	return MAUVE;
}
+ (NSC*) randomOpaqueColor {	float c[4];
	c[0] = randomComponent();	c[1] = randomComponent();	c[2] = randomComponent();	c[3] = 1.0;
	return [NSC colorWithCalibratedRed:c[0] green:c[1] blue:c[2] alpha:c[3]];
}
+ (NSC*) randomColor 		{
	int red = rand() % 255;	int green = rand() % 255;	int blue = rand() % 255;
	return [NSC colorWithCalibratedRed:red/255.0 green:green/255.0 blue:blue/255.0 alpha:1.0];
}
+ (NSC*) randomLightColor 	{
	NSC *c = RANDOMCOLOR;
	return [c colorWithBrightnessMultiplier:.9];
}
+ (NSC*) randomBrightColor {
	NSC *c = RANDOMCOLOR;
	while ( !c.isBright ) c = RANDOMCOLOR;
	return c;
}
+ (NSC*) randomDarkColor 	{
	NSC *c = RANDOMCOLOR;
	while ( !c.isDark ) c = RANDOMCOLOR;
	return c;
}
/*	NSColor: Instantiate from Web-like Hex RRGGBB string
 Original Source: <http://cocoa.karelia.com/Foundation_Categories/NSColor__Instantiat.m>
 (See copyright notice at <http://cocoa.karelia.com>)	*/
+ (NSC*) colorFromHexRGB:		  (NSS*) inColorString 	{
	NSS *cleansedstring = [inColorString stringByReplacingOccurrencesOfString:@"#" withString:@""];
	NSC*result = nil;	unsigned int colorCode = 0;		unsigned char redByte, greenByte, blueByte;
	if (nil != cleansedstring)	{
		NSScanner *scanner = [NSScanner scannerWithString:cleansedstring];
		(void) [scanner scanHexInt:&colorCode];	// ignore error
	}
	redByte		= (unsigned char) (colorCode >> 16);
	greenByte	= (unsigned char) (colorCode >> 8);
	blueByte	= (unsigned char) (colorCode);	// masks off high bits
	result = [NSC colorWithCalibratedRed:		(float)redByte	/ 0xff
											 green:	(float)greenByte/ 0xff
											  blue:	(float)blueByte	/ 0xff
											 alpha:1.0];
	return result;
}
+ (NSC*) colorWithDeviceRGB:	  (NSUI)hex					{
	hex &= 0xFFFFFF;
	NSUInteger red   = (hex & 0xFF0000) >> 16;
	NSUInteger green = (hex & 0x00FF00) >>  8;
	NSUInteger blue  =  hex & 0x0000FF;
	return [NSC colorWithDeviceRed:(red / 255.0f) green:(green / 255.0f) blue:(blue / 255.0f) alpha: 1.0];
}
+ (NSC*) colorWithCalibratedRGB:(NSUI)hex					{
	hex &= 0xFFFFFF;
	NSUInteger red   = (hex & 0xFF0000) >> 16;
	NSUInteger green = (hex & 0x00FF00) >>  8;
	NSUInteger blue  =  hex & 0x0000FF;
	return [NSC colorWithCalibratedRed:(red / 255.0f) green:(green / 255.0f) blue:(blue / 255.0f) alpha: 1.0];
}
+ (NSC*) colorWithRGB:			  (NSUI)hex					{	return [NSC colorWithCalibratedRGB:hex]; }
// NSS *hexColor = [color hexColor]
+ (NSC*) colorWithHex:			  (NSS*) hexColor 		{
	// Remove the hash if it exists
	hexColor = [hexColor stringByReplacingOccurrencesOfString:@"#" withString:@""];
	int length = (int)[hexColor length];
	bool triple = (length == 3);
	NSMutableArray *rgb = NSMA.new;
	// Make sure the string is three or six characters long
	if (triple || length == 6) {
		CFIndex i = 0;		UniChar character = 0;		NSS *segment = @"";		CFStringInlineBuffer buffer;
		CFStringInitInlineBuffer((__bridge CFStringRef)hexColor, &buffer, CFRangeMake(0, length));
		while ((character = CFStringGetCharacterFromInlineBuffer(&buffer, i)) != 0 ) {
			if (triple) segment = [segment stringByAppendingFormat:@"%c%c", character, character];
			else segment = [segment stringByAppendingFormat:@"%c", character];
			if ((int)[segment length] == 2) {
				NSScanner *scanner = [[NSScanner alloc] initWithString:segment];
				unsigned number;
				while([scanner scanHexInt:&number]){
					[rgb addObject:@((float)(number / (float)255))];
				}
				segment = @"";
			}
			i++;
		}
		// Pad the array out (for cases where we're given invalid input)
		while ([rgb count] != 3) [rgb addObject:@0.0f];
		return [NSC colorWithCalibratedRed:[rgb[0] floatValue]   green:[rgb[1] floatValue]	blue:[rgb[2] floatValue]   alpha:1];
	}
	else {
		NSException* invalidHexException = [NSException exceptionWithName:@"InvalidHexException"					   reason:@"Hex color not three or six characters excluding hash"					 userInfo:nil];
		@throw invalidHexException;
	}
}
- (NSS*) crayonName 												{
	NSC*thisColor = [self colorUsingColorSpaceName:NSCalibratedRGBColorSpace];
	CGFloat bestDistance = FLT_MAX;
	NSS *bestColorKey = nil;
	NSColorList *colors = [NSColorList colorListNamed:@"Crayons"];
	NSEnumerator *enumerator = [[colors allKeys] objectEnumerator];
	NSS *key = nil;
	while ((key = [enumerator nextObject])) {
		NSC*thatColor = [colors colorWithKey:key];
		thatColor = [thatColor colorUsingColorSpaceName:NSCalibratedRGBColorSpace];
		CGFloat colorDistance = fabs([thisColor redComponent] 	- [thatColor redComponent]);
		colorDistance += fabs([thisColor blueComponent] 			- [thatColor blueComponent]);
		colorDistance += fabs([thisColor greenComponent]			- [thatColor greenComponent]);
		colorDistance = sqrt(colorDistance);
		if (colorDistance < bestDistance) {	bestDistance = colorDistance; bestColorKey = key; }
	}
	bestColorKey = [[NSBundle bundleWithPath:@"/System/Library/Colors/Crayons.clr"]
						 localizedStringForKey:bestColorKey	value:bestColorKey 	table:@"Crayons"];
	return bestColorKey;
}
- (NSS*) pantoneName 											{
	NSC*thisColor = [self colorUsingColorSpaceName:NSCalibratedRGBColorSpace];
	CGFloat bestDistance = FLT_MAX;
	NSS *bestColorKey = nil;
	NSColorList *colors = [NSColorList colorListInFrameworkWithFileName:@"RGB.clr"];
	NSEnumerator *enumerator = [[colors allKeys] objectEnumerator];
	NSS *key = nil;
	while ((key = [enumerator nextObject])) {
		NSC*thatColor = [colors colorWithKey:key];
		thatColor = [thatColor colorUsingColorSpaceName:NSCalibratedRGBColorSpace];
		CGFloat colorDistance = fabs([thisColor redComponent] 	- [thatColor redComponent]);
		colorDistance += fabs([thisColor blueComponent] 			- [thatColor blueComponent]);
		colorDistance += fabs([thisColor greenComponent]			- [thatColor greenComponent]);
		colorDistance = sqrt(colorDistance);
		if (colorDistance < bestDistance) {	bestDistance = colorDistance; bestColorKey = key; }
	}
	//	 [colors localizedS
	bestColorKey = [[NSBundle bundleWithPath:@"/System/Library/Colors/Crayons.clr"]
						 localizedStringForKey:bestColorKey	value:bestColorKey 	table:@"Crayons"];
	return bestColorKey;
}
-  (CGF) rgbDistanceTo:			  (NSC*)another 			{
	NSC *rgbself, *rgbAnother; rgbself = self.deviceRGBColor; rgbAnother = another.deviceRGBColor;
	CGF 	colorDistance  = fabs(rgbself.redComponent 	- rgbAnother.redComponent  );
	colorDistance += fabs(rgbself.blueComponent 	- rgbAnother.blueComponent );
	colorDistance += fabs(rgbself.greenComponent - rgbAnother.greenComponent);
	return sqrt(colorDistance);
}
-  (NSC*) closestColorListColor 								{  //gross but works, restore
	if (!bestMatches) bestMatches = NSMD.new;
	if (!safe) 			safe 			= [NSColorList colorListNamed:@"Web Safe Colors"];
	//  	if (!named)			named 		= [AZNamedColors na];
	__block CGF bestDistance = FLT_MAX;
	NSC* best = [[NSA arrayWithArrays:@[safe.colors]] reduce:AZNULL withBlock:^id(id sum, NSC* aColor) {
		CGF contender = [self rgbDistanceTo:aColor];
		if ( contender < bestDistance ) {	bestDistance = contender;	sum = aColor;	}
		return sum;
	}];
	if (best) bestMatches[self] = best;
	return best;
}
+  (NSA*) colorsInListNamed:(NSS*)name 					{ return [self.colorLists[name]colors]; }

//	self.colorLists[name] = colorListD[name] ?: [self.colorLists filterOne:^BOOL(id object) {

//		return SameString(name,[(NSCL*)object name]);
//	}];
//	return palettesD[name] ? list.colors : nil;

+  (NSA*) colorsInFrameworkListNamed:(NSS*)name			{ return [self colorsInListNamed:name]; }
+  (NSA*) fengshui 												{ return [self colorsInListNamed:@"FengShui"]; }
+  (NSA*) allSystemColorNames 								{ return [self.class systemColorNames]; } // BORING
+  (NSA*) systemColorNames 									{

	return [NSA arrayWithArrays:[NSCL.availableColorLists map:^id(NSCL* obj) {	return obj.allKeys;	}]];
}
+  (NSA*) allColors 												{

	return	[NSA arrayWithArrays:[
											 [[NSC vFKP:@"colorLists"]allValues]
											 map:^(id obj){ return [obj colors]; }]];
}
+  (NSA*) allSystemColors 										{ return [[self class] systemColors]; }
+  (NSA*) systemColors 											{

	return [NSA arrayWithArrays:[NSColorList.availableColorLists cw_mapArray:^id(NSCL* obj) {
		return [obj.allKeys map:^id(NSS *key) { NSC* c = [obj colorWithKey:key]; return !c.isBoring ? c : nil; }];
	}]];
}

+ (NSCL*) createColorlistWithColors:(NSA*)cs andNames:(NSA*)ns named:(NSS*)name	{

	NSColorList *testList = [NSColorList.alloc initWithName:name];
	[cs each:^(id obj) {
		[testList setColor: obj	forKey: ns[[cs indexOfObject:obj]] ?: @"N/A"];
	}];
	return testList;
}

- (void) setNameOfColor:(NSString *)nameOfColor{
	[self setAssociatedValue:nameOfColor forKey:@"associatedName" policy:OBJC_ASSOCIATION_RETAIN_NONATOMIC];
}

+ (void) logPalettes				{
	//	[self.colorLists each:^(id key, id value) {

	[[[self.colorLists.allValues vFKP:@"name"] reduce:@"".mutableCopy withBlock:^id(id sum, id obj) {
		return sum = $(@"%@\n%@\n%@",sum, obj,
							[[NSC colorsInListNamed:obj]stringValueInColumnsCharWide:30]);
	}]log];
	//			  [[obj colors] each:^(NSC* color) {
	//			COLORLOG(color ?: nil, @"%@", color.name);

}

+ (NSC*) r:(CGF)red g:(CGF)green b:(CGF)blue a:(CGF)trans { return [self colorWithDeviceRed:red green:green blue:blue alpha:trans];}
+ (NSC*) white:(CGF)percent 						{ return [self colorWithDeviceWhite:percent alpha:1]; }
+ (NSC*) white:(CGF)percent a:(CGF)alpha 		{ return [self colorWithDeviceWhite:percent alpha:alpha]; }
+ (NSA*) randomPalette 								{	return [self.colorLists.allValues.randomElement colors];
}
+ (NSCL*) randomList 								{	return self.colorLists.allValues.randomElement;	}
+ (NSC*)   crayonColorNamed:(NSS*)key			{	return [[NSColorList colorListNamed:@"Crayons"] colorWithKey:key];	}
+ (NSD*) allNamedColors {

	static NSD*allC = nil;  if (allC) return allC; NSMD *colors = NSMD.new;

	[NSColorList.availableColorLists each:^(id obj) {
		[[obj allKeys] enumerateObjectsWithOptions:NSEnumerationConcurrent usingBlock:^(id key, NSUInteger idx, BOOL *stop) {
		   colors[[key lowercaseString]] = [obj colorWithKey:key];
		}];
	}];
	return (allC = [colors dictionaryByAddingEntriesFromDictionary:[AZNamedColors namedColors].dictionary]);
}
+ (NSC*)      colorWithName:(NSS*)colorName 	{ return self.allNamedColors[colorName.lowercaseString]; }
//	// name lookup
//	NSS *lcc = colorName.lowercaseString; __block NSC*match;
//	return [self.allNamedColors obj ]
//
////	[AZNamedColors.namedColors.dictionary dictionaryByAddingEntriesFromDictionary:
//		if ([key.lowercaseString isEqual:lcc]) {
//			return [list colorWithKey:key];
//		}
//	}
//	for (list in []) {
//		for (NSS *key in [list allKeys ]) {
//			if ([key.lowercaseString isEqual:lcc]) {
//				return [list colorWithKey:key];
//			}
//		}
//	}
//	return nil;
//}
+ (NSC*)    colorFromString:(NSS*)string 		{
	if ([string hasPrefix:@"#"]) {
		return [NSC colorFromHexString:string];
	}
	// shifting operations
	NSRange shiftRange = [string rangeOfAny:@"<! <= << <> >> => !>".wordSet];
	if (shiftRange.location != NSNotFound) {
		CGFloat p = 0.5;
		// determine the first of the operations
		NSS *op = [string substringWithRange:shiftRange];
		if ([op isEqual:@"<>"]) {
			// this will stay 50/50
		} else if ([op isEqual:@"<!"]) {
			p = 0.95;
		} else if ([op isEqual:@"<="]) {
			p = 0.85;
		} else if ([op isEqual:@"<<"]) {
			p = 0.66;
		} else if ([op isEqual:@">>"]) {
			p = 0.33;
		} else if ([op isEqual:@"=>"]) {
			p = 0.15;
		} else if ([op isEqual:@"!>"]) {
			p = 0.05;
		}
		// shift operators
		NSS *head = [string substringToIndex:
						 shiftRange.location];
		NSS *tail = [string substringFromIndex:
						 shiftRange.location + shiftRange.length];
		NSC*first = head.trim.colorValue;
		NSC*second = tail.trim.colorValue;
		if (first != nil && second != nil) {
			return [first blendedColorWithFraction:p ofColor:second];
		}
		if (first != nil) {
			return first;
		}
		return second;
	}
	if ([string contains:@" "]) {
		//		NSS *head = nil, *tail = nil;
		//		list(&head, &tail) = string.decapitate;
		NSArray  *comps = string.decapitate;
		NSS *head = comps[0];
		NSS *tail = comps[1];
		//[[string stringByTrimmingCharactersInSet:
		//								   [NSCharacterSet whitespaceAndNewlineCharacterSet]]lowercaseString];
		NSC*tailColor = [NSC colorFromString:tail];
		if (tailColor) {
			if ([head isEqualToString:@"translucent"]) {
				return tailColor.translucent;
			} else if ([head isEqualToString:@"watermark"]) {
				return tailColor.watermark;
			} else if ([head isEqualToString:@"bright"]) {
				return tailColor.bright;
			} else if ([head isEqualToString:@"brighter"]) {
				return tailColor.brighter;
			} else if ([head isEqualToString:@"dark"]) {
				return tailColor.dark;
			} else if ([head isEqualToString:@"darker"]) {
				return tailColor.darker;
			} else if ([head hasSuffix:@"%"]) {
				return [tailColor colorWithAlphaComponent:head.popped.floatValue / 100.0];
			}
		}
	}
	if ([string contains:@","]) {
		NSS *comp = string;
		NSS *func = @"rgb";
		if ([string contains:@"("] && [string hasSuffix:@")"]) {
			comp = [string substringBetweenPrefix:@"(" andSuffix:@")"];
			func = [[string substringBefore:@"("] lowercaseString];
		}
		NSArray *vals = [comp componentsSeparatedByString:@","];
		CGFloat values[5];
		for (int i = 0; i < 5; i++) {
			values[i] = 1.0;
		}
		for (int i = 0; i < vals.count; i++) {
			NSS *v = [vals[i] trim];
			if ([v hasSuffix:@"%"]) {
				values[i] = [[v substringBefore:@"%"] floatValue] / 100.0;
			} else {
				// should be a float
				values[i] = v.floatValue;
				if (values[i] > 1) {
					values[i] /= 255.0;
				}
			}
			values[i] = MIN(MAX(values[i], 0), 1);
		}
		if (vals.count <= 2) {
			// grayscale + alpha
			return [NSC colorWithDeviceWhite:values[0]
												alpha:values[1]
					  ];
		} else if (vals.count <= 5) {
			// rgba || hsba
			if ([func hasPrefix:@"rgb"]) {
				return [NSC colorWithDeviceRed:values[0]
												 green:values[1]
												  blue:values[2]
												 alpha:values[3]
						  ];
			} else if ([func hasPrefix:@"hsb"]) {
				return [NSC colorWithDeviceHue:values[0]
										  saturation:values[1]
										  brightness:values[2]
												 alpha:values[3]
						  ];
			} else if ([func hasPrefix:@"cmyk"]) {
				return [NSC colorWithDeviceCyan:values[0]
												magenta:values[1]
												 yellow:values[2]
												  black:values[3]
												  alpha:values[4]
						  ];
			} else {
				NSLog(@"Unrecognized Prefix <%@> returning nil", func);
			}
		}
	}
	return [NSC colorWithName:string];
}
+ (NSC*) colorFromHexString:(NSS*)hexString	{
	BOOL useHSB = NO;
	BOOL useCalibrated = NO;
	if (hexString.length == 0) {
		return NSColor.blackColor;
	}
	hexString = hexString.trim.uppercaseString;
	if ([hexString hasPrefix:@"#"]) {
		hexString = hexString.shifted;
	}
	if ([hexString hasPrefix:@"!"]) {
		useCalibrated = YES;
		hexString = hexString.shifted;
	}
	if ([hexString hasPrefix:@"*"]) {
		useHSB = YES;
		hexString = hexString.shifted;
	}
	int mul = 1;
	int max = 3;
	CGFloat v[4];
	// full opacity by default
	v[3] = 1.0;
	if (hexString.length == 8 || hexString.length == 4) {
		max++;
	}
	if (hexString.length == 6 || hexString.length == 8) {
		// #RRGGBB || #RRGGBBAA
		mul = 2;
	} else if (hexString.length == 3 || hexString.length == 4) {
		// #RGB || #RGBA
		mul = 1;
	} else {
		return nil;
	}
	for (int i = 0; i < max; i++) {
		NSS *sub = [hexString substringWithRange:NSMakeRange(i * mul, mul)];
		NSScanner *scanner = [NSScanner scannerWithString:sub];
		uint value = 0;
		[scanner scanHexInt: &value];
		v[i] = (float) value / (float) 0xFF;
	}
	// only at full color
	if (useHSB) {
		if (useCalibrated) {
			return [NSC colorWithCalibratedHue:v[0]
											saturation:v[1]
											brightness:v[2]
												  alpha:v[3]
					  ];
		}
		return [NSC colorWithDeviceHue:v[0]
								  saturation:v[1]
								  brightness:v[2]
										 alpha:v[3]
				  ];
	}
	if (useCalibrated) {
		return [NSC colorWithCalibratedRed:v[0]
											  green:v[1]
												blue:v[2]
											  alpha:v[3]
				  ];
	}
	return [NSC colorWithDeviceRed:v[0]
									 green:v[1]
									  blue:v[2]
									 alpha:v[3]
			  ];
}
- (NSC*) closestWebColor 							{
	NSC*thisColor = [self colorUsingColorSpaceName:NSCalibratedRGBColorSpace];
	CGFloat bestDistance = FLT_MAX;
	NSC*bestColorKey = nil;
	NSColorList *colors = [NSColorList colorListNamed:@"Web Safe Colors"];
	NSEnumerator *enumerator = [[colors allKeys] objectEnumerator];
	NSS *key = nil;
	while ((key = [enumerator nextObject])) {
		NSC*thatColor = [colors colorWithKey:key];
		thatColor = [thatColor colorUsingColorSpaceName:NSCalibratedRGBColorSpace];
		CGFloat colorDistance = fabs([thisColor redComponent] 	- [thatColor redComponent]);
		colorDistance += fabs([thisColor blueComponent] 			- [thatColor blueComponent]);
		colorDistance += fabs([thisColor greenComponent]			- [thatColor greenComponent]);
		colorDistance = sqrt(colorDistance);
		if (colorDistance < bestDistance) {	bestDistance = colorDistance; bestColorKey = thatColor; }
	}
	//	bestColorKey = [[NSBundle bundleWithPath:@"/System/Library/Colors/Web Safe Colors.clr"]
	//					localizedStringForKey:bestColorKey	value:bestColorKey 	table:@"Crayons"];
	return bestColorKey;
}
- (NSC*)  deviceRGBColor 		{
	return [self colorUsingColorSpaceName:NSDeviceRGBColorSpace];
}
- (NSC*) calibratedRGBColor	{
	NSC* cali = [self colorUsingColorSpaceName:NSCalibratedRGBColorSpace];
	return cali;
}
- (NSS*) toHex						{
	CGFloat r,g,b,a;
	[[self calibratedRGBColor] getRed:&r green:&g blue:&b alpha:&a];
	int ri = r * 0xFF;
	int gi = g * 0xFF;
	int bi = b * 0xFF;
	return [[NSString stringWithFormat:@"%02x%02x%02x", ri, gi, bi] uppercaseString];
}
- (NSC*) closestNamedColor 	{
	NSC*color = [self closestColorListColor];
	//	 objectForKey:@"name"];// valueForKey:@"name"];
	return color;
}

/*
 + (BOOL) resolveClassMethod:(SEL)sel {

 if ([self.colorListNames containsObject:NSStringFromSelector(sel)])
 Class selfMetaClass = objc_getMetaClass([[self className] UTF8String]);
 class_addMethod([selfMetaClass, aSEL, (IMP) dynamicMethodIMP, "v@:");
 return YES;
 }
 return [super resolveClassMethod aSEL];
 class_addMethod(self.class, sel, (IMP) dynamicMethodIMP, "v@:");
 return YES;
 2009-10-19 | © 2009 Apple Inc. All Rights Reserved. 16
 ￼￼￼@dynamic propertyName;
 ￼
 void dynamicMethodIMP(id self, SEL _cmd) {
 // implementation ....
 }
 ￼￼￼￼
 Dynamic Method Resolution
 Dynamic Loading
 }
 return [super resolveInstanceMethod:aSEL];
 }
 */
- (NSS*) nameOfColor				{
	if ([self hasAssociatedValueForKey:@"associatedName"]) return [self associatedValueForKey:@"associatedName"];

	//	NSC*color = [self closestColorListColor];
	NSC*thisColor = [self colorUsingColorSpaceName:NSCalibratedRGBColorSpace];
	CGFloat bestDistance = FLT_MAX;
	//	NSColorList *colors = [NSColorList colorListNamed:@"Web Safe Colors"];
	NSColorList *crayons = [NSColorList colorListNamed:@"Crayons"];
	NSArray *avail = $array(crayons);
	//	NSColorList *bestList = nil;
	NSC*bestColor = nil;
	NSS *bestKey = nil;
	for (NSColorList *list  in avail) {
		NSEnumerator *enumerator = [[list allKeys] objectEnumerator];
		NSS *key = nil;
		while ((key = [enumerator nextObject])) {
			NSC*thatColor = [list colorWithKey:key];
			thatColor = [thatColor colorUsingColorSpaceName:NSCalibratedRGBColorSpace];
			CGFloat colorDistance =
			fabs([thisColor redComponent] 	- [thatColor redComponent]);
			colorDistance += fabs([thisColor blueComponent] 	- [thatColor blueComponent]);
			colorDistance += fabs([thisColor greenComponent]	- [thatColor greenComponent]);
			colorDistance = sqrt(colorDistance);
			if (colorDistance < bestDistance) {
				//				bestList = list;
				bestDistance = colorDistance;
				//				bestColor = thatColor;
				bestKey = key; }
		}
	}
	//	bestColorKey = [[NSBundle bundleWithPath:@"/System/Library/Colors/Web Safe Colors.clr"]
	//					localizedStringForKey:bestColorKey	value:bestColorKey 	table:@"Crayons"];
	return bestKey;//, @"color", bestKey, @"key", bestList, @"list");
}
// Convenienct Methods to mess a little with the color values
-  (CGF) luminance 				{
	CGFloat r, g, b, a;
	[[self calibratedRGBColor] getRed:&r green:&g blue:&b alpha:&a];
	// 0.3086 + 0.6094 + 0.0820 = 1.0
	return (0.3086f*r) + (0.6094f*g) + (0.0820f*b);
}
-  (CGF) relativeBrightness 	{
	CGFloat r, g, b, a;
	[[self calibratedRGBColor] getRed:&r green:&g blue:&b alpha:&a];
	return sqrt((r * r * 0.241) + (g * g * 0.691) + (b * b * 0.068));
}
- (BOOL) isBright 				{
	return self.relativeBrightness > 0.57;
}
- (NSC*) bright 					{
	return [NSC colorWithDeviceHue:self.hueComponent
							  saturation:0.3
							  brightness:1.0
									 alpha:self.alphaComponent];
}
- (NSC*) brighter 				{
	CGFloat h,s,b,a;
	[[self calibratedRGBColor] getHue:&h saturation:&s brightness:&b alpha:&a];
	return [NSC colorWithDeviceHue:h
							  saturation:s
							  brightness:MIN(1.0, MAX(b * 1.10, b + 0.05))
									 alpha:a];
}
- (NSC*) darker 					{
	CGFloat h,s,b,a;
	[[self calibratedRGBColor] getHue:&h saturation:&s brightness:&b alpha:&a];
	return [NSC colorWithDeviceHue:h
							  saturation:s
							  brightness:MAX(0.0, MIN(b * 0.9, b - 0.05))
									 alpha:a];
}
- (NSC*) muchDarker 				{
	CGFloat h,s,b,a;
	[[self calibratedRGBColor] getHue:&h saturation:&s brightness:&b alpha:&a];
	return [NSC colorWithDeviceHue:h
							  saturation:s
							  brightness:MAX(0.0, MIN(b * 0.7, b - 0.1))
									 alpha:a];
}
- (BOOL) isDark 					{
	return self.relativeBrightness < 0.42;
}
- (NSC*) dark 						{
	return [NSC colorWithDeviceHue:self.hueComponent
							  saturation:0.8
							  brightness:0.3
									 alpha:self.alphaComponent];
}
- (NSC*) redshift 				{
	CGFloat h,s,b,a;
	[self.deviceRGBColor getHue:&h saturation:&s brightness:&b alpha:&a];
	h += h > 0.5 ? 0.1 : -0.1;
	if (h < 1) {
		h++;
	} else if (h > 1) {
		h--;
	}
	return [NSC colorWithDeviceHue:h saturation:s brightness:b alpha:a];
}
- (NSC*) blueshift 				{
	CGFloat c = self.hueComponent;
	c += c < 0.5 ? 0.1 : -0.1;
	return [NSC colorWithDeviceHue:c
							  saturation:self.saturationComponent
							  brightness:self.brightnessComponent
									 alpha:self.alphaComponent];
}
- (NSC*) blend:(NSC*)other 	{
	return [self blendedColorWithFraction:0.5 ofColor:other];
}
- (NSC*) whitened 				{
	return [self blend:NSColor.whiteColor];
}
- (NSC*) blackened 				{
	return [self blend:NSColor.blackColor];
}
- (NSC*) contrastingForegroundColor {
	NSC*c = self.calibratedRGBColor;
	if (!c) {
		NSLog(@"Cannot create contrastingForegroundColor for color %@", self);
		return NSColor.blackColor;
	}
	if (!c.isBright) {
		return NSColor.whiteColor;
	}
	return NSColor.blackColor;
}
- (NSC*) complement 				{
	NSC*c = self.colorSpaceName == NSPatternColorSpace ? [self.patternImage quantize][0] : self.calibratedRGBColor;
	if (!c) {
		NSLog(@"Cannot create complement for color %@", self);
		return self;
	}
	CGFloat h,s,b,a;
	[c getHue:&h saturation:&s brightness:&b alpha:&a];
	h += 0.5;
	if (h > 1) {
		h -= 1.0;
	}
	NSC *newish = 	[NSC colorWithDeviceHue:h saturation:s	brightness:b alpha:a];
	return self.colorSpaceName == NSPatternColorSpace ? [NSC colorWithPatternImage:[self.patternImage tintedWithColor:newish]]: newish;
}
- (NSC*) rgbComplement 			{
	NSC*c = self.calibratedRGBColor;
	if (!c) {
		NSLog(@"Cannot create complement for color %@", self);
		return self;
	}
	CGFloat r,g,b,a;
	[c getRed:&r green:&g blue:&b alpha:&a];
	return [NSC colorWithDeviceRed:1.0 - r
									 green:1.0 - g
									  blue:1.0 - b
									 alpha:a];
}
// convenience for alpha shifting
- (NSC*) opaque 					{
	return [self colorWithAlphaComponent:1.0];
}
- (NSC*) lessOpaque 				{
	return [self colorWithAlphaComponent:MAX(0.0, self.alphaComponent * 0.8)];
}
- (NSC*) moreOpaque 				{
	return [self colorWithAlphaComponent:MIN(1.0, self.alphaComponent / 0.8)];
}
- (NSC*) translucent 			{
	return [self colorWithAlphaComponent:0.65];
}
- (NSC*) watermark 				{
	return [self colorWithAlphaComponent:0.25];
}
// comparison methods
- (NSC*) rgbDistanceToColor:(NSC*)color {
	if (!color) {
		return nil;
	}
	CGFloat mr,mg,mb,ma, or,og,ob,oa;
	[self.calibratedRGBColor  getRed:&mr green:&mg blue:&mb alpha:&ma];
	[color.calibratedRGBColor getRed:&or green:&og blue:&ob alpha:&oa];
	return [NSC colorWithCalibratedRed:ABS(mr - or)
										  green:ABS(mg - og)
											blue:ABS(mb - ob)
										  alpha:ABS(ma - oa)
			  ];
}
- (NSC*) colorWithSaturation:(CGF)sat brightness:(CGF)bright {
	return [NSC colorWithDeviceHue:self.hueComponent saturation:sat brightness:bright alpha:self.alphaComponent];
}
- (NSC*) hsbDistanceToColor:(NSC*)color {
	CGFloat mh,ms,mb,ma, oh,os,ob,oa;
	[self.calibratedRGBColor  getHue:&mh saturation:&ms brightness:&mb alpha:&ma];
	[color.calibratedRGBColor getHue:&oh saturation:&os brightness:&ob alpha:&oa];
	// as the hue is circular 0.0 lies next to 1.0
	// and thus 0.5 is the most far away from both
	// distance values exceeding 0.5 will result in a fewer real distance
	CGFloat hd = ABS(mh - oh);
	if (hd > 0.5) {
		hd = 1 - hd;
	}
	return [NSC colorWithCalibratedHue:hd
									saturation:ABS(ms - os)
									brightness:ABS(mb - ob)
										  alpha:ABS(ma - oa)
			  ];
}
-  (CGF) rgbWeight {
	CGFloat r,g,b,a;
	[self.calibratedRGBColor getRed:&r green:&g blue:&b alpha:&a];
	return (r + g + b) / 3.0;
}
-  (CGF) hsbWeight {
	CGFloat h,s,b,a;
	[self.calibratedRGBColor getHue:&h saturation:&s brightness:&b alpha:&a];
	return (h + s + b) / 3.0;
}
- (BOOL) isBlueish {
	CGFloat r,g,b,a;
	[self getRed:&r green:&g blue:&b alpha:&a];
	return b - MAX(r,g) > 0.2;
}
- (BOOL) isRedish {
	CGFloat r,g,b,a;
	[self getRed:&r green:&g blue:&b alpha:&a];
	return r - MAX(b,g) > 0.2;
}
- (BOOL) isGreenish {
	CGFloat r,g,b,a;
	[self getRed:&r green:&g blue:&b alpha:&a];
	return g - MAX(r,b) > 0.2;
}
- (BOOL) isYellowish {
	CGFloat r,g,b,a;
	[self getRed:&r green:&g blue:&b alpha:&a];
	return ABS(r - g) < 0.1 && MIN(r,g) - b > 0.2;
}
@end
@implementation NSCoder (AGCoder)
+(void)encodeColor:(CGColorRef)theColor  withCoder:(NSCoder*)encoder withKey:(NSS*)theKey {
	if(theColor != nil)	{
		const CGFloat* components = CGColorGetComponents(theColor);
		[encoder encodeFloat:components[0] forKey:[NSString stringWithFormat:@"%@.red", theKey]];
		[encoder encodeFloat:components[1] forKey:[NSString stringWithFormat:@"%@.green", theKey]];
		[encoder encodeFloat:components[2] forKey:[NSString stringWithFormat:@"%@.blue", theKey]];
		[encoder encodeFloat:components[3] forKey:[NSString stringWithFormat:@"%@.alpha", theKey]];
	}	else	{		// Encode nil as NSNull
		[encoder encodeObject:[NSNull null] forKey:theKey];
	}
}
@end

@implementation NSColor (AIColorAdditions_Comparison)
- (BOOL)equalToRGBColor:(NSC*)inColor			{
	NSColor	*convertedA = [self colorUsingColorSpaceName:NSCalibratedRGBColorSpace];
	NSColor	*convertedB = [inColor colorUsingColorSpaceName:NSCalibratedRGBColorSpace];
	return (([convertedA redComponent]   == [convertedB redComponent])   &&
			  ([convertedA blueComponent]  == [convertedB blueComponent])  &&
			  ([convertedA greenComponent] == [convertedB greenComponent]) &&
			  ([convertedA alphaComponent] == [convertedB alphaComponent]));
}	//	Returns YES if the colors are equal
@end
@implementation NSColor (AIColorAdditions_DarknessAndContrast)
- (BOOL) colorIsDark									{
	return ([[self colorUsingColorSpaceName:NSCalibratedRGBColorSpace] brightnessComponent] < 0.5f);
} 	//	Returns YES if this color is dark
- (BOOL) colorIsMedium								{
	CGFloat brightness = [[self colorUsingColorSpaceName:NSCalibratedRGBColorSpace] brightnessComponent];
	return (0.35f < brightness && brightness < 0.65f);
}
- (NSC*) darkenBy:						  (CGF)f	{
	NSColor	*convertedColor = [self colorUsingColorSpaceName:NSCalibratedRGBColorSpace];
	return [NSC colorWithCalibratedHue:convertedColor.hueComponent				saturation:convertedColor.saturationComponent
									brightness:convertedColor.brightnessComponent - f		  alpha:convertedColor.alphaComponent];
}	//	Percent should be -1.0 to 1.0 (negatives will make the color brighter)
- (NSC*) darkenAndAdjustSaturationBy: (CGF)f	{
	NSColor	*convertedColor = [self colorUsingColorSpaceName:NSCalibratedRGBColorSpace];
	return [NSC colorWithCalibratedHue:convertedColor.hueComponent
									saturation:((convertedColor.saturationComponent == 0.0f) ? convertedColor.saturationComponent : (convertedColor.saturationComponent + f))
									brightness:(convertedColor.brightnessComponent - f)
										  alpha:convertedColor.alphaComponent];
}
- (NSC*) colorWithInvertedLuminance				{
	CGFloat h,l,s;
	NSC*convertedColor = [self colorUsingColorSpaceName:NSCalibratedRGBColorSpace];
	//Get our HLS
	[convertedColor getHue:&h saturation:&s brightness:&l alpha:NULL];
	//Invert L
	l = 1.0f - l;
	//Return the new color
	return [NSC colorWithCalibratedHue:h saturation:s brightness:l alpha:1.0f];
}	//	Inverts the luminance of this color so it looks good on selected/dark backgrounds
- (NSC*) contrastingColor							{
	if ([self colorIsMedium]) {
		if ([self colorIsDark])
			return [NSC whiteColor];
		else
			return [NSC blackColor];
	} else {
		NSC*rgbColor = [self colorUsingColorSpaceName:NSCalibratedRGBColorSpace];
		return [NSC colorWithCalibratedRed:(1.0f - [rgbColor redComponent])
											  green:(1.0f - [rgbColor greenComponent])
												blue:(1.0f - [rgbColor blueComponent])
											  alpha:1.0f];
	}
}	// Returns a color that contrasts well with this one
@end
@implementation NSColor (AIColorAdditions_HLS)
//Linearly adjust a color
- (NSC*)adjustHue:(CGF)dHue saturation:(CGF)dSat brightness:(CGF)dBrit	{
	CGFloat hue, sat, brit, alpha;
	[self getHue:&hue saturation:&sat brightness:&brit alpha:&alpha];
	//	For some reason, redColor's hue is 1.0f, not 0.0f, as of Mac OS X 10.4.10 and 10.5.2.
	//	Therefore, we must normalize any multiple of 1.0 to 0.0. We do this by taking the remainder of hue ÷ 1.
	hue 		= AIfmod(hue, 1.0f);
	hue 		+=  dHue;	AZNormalFloat ( hue );
	sat		+=  dSat;	AZNormalFloat ( sat );
	brit 		+= dBrit;	AZNormalFloat ( brit );
	return [NSC colorWithCalibratedHue:hue saturation:sat brightness:brit alpha:alpha];
}
@end
@implementation NSColor (AIColorAdditions_RepresentingColors)
- (NSS*) hexString				{
	CGFloat 	red,green,blue;
	char	hexString[7];
	NSInteger		tempNum;
	NSColor	*convertedColor;
	convertedColor = [self colorUsingColorSpaceName:NSCalibratedRGBColorSpace];
	[convertedColor getRed:&red green:&green blue:&blue alpha:NULL];
	tempNum = (NSInteger)(red * 255.0f);
	hexString[0] = intToHex(tempNum / 16);
	hexString[1] = intToHex(tempNum % 16);
	tempNum = (NSInteger) (green * 255.0f);
	hexString[2] = intToHex(tempNum / 16);
	hexString[3] = intToHex(tempNum % 16);
	tempNum = (NSInteger)(blue * 255.0f);
	hexString[4] = intToHex(tempNum / 16);
	hexString[5] = intToHex(tempNum % 16);
	hexString[6] = '\0';
	return @(hexString);
}
- (NSS*) stringRepresentation	{
	NSColor	*tempColor = [self colorUsingColorSpaceName:NSCalibratedRGBColorSpace];
	CGFloat alphaComponent = [tempColor alphaComponent];
	if (alphaComponent == 1.0) {
		return [NSString stringWithFormat:@"%d,%d,%d",
				  (int)([tempColor redComponent] * 255.0),
				  (int)([tempColor greenComponent] * 255.0),
				  (int)([tempColor blueComponent] * 255.0)];
	} else {
		return [NSString stringWithFormat:@"%d,%d,%d,%d",
				  (int)([tempColor redComponent] * 255.0),
				  (int)([tempColor greenComponent] * 255.0),
				  (int)([tempColor blueComponent] * 255.0),
				  (int)(alphaComponent * 255.0)];
	}
}	//String representation: R,G,B[,A].
- (NSS*) CSSRepresentation
{
	CGFloat alpha = [self alphaComponent];
	if ((1.0 - alpha) >= 0.000001) {
		NSC*rgb = [self colorUsingColorSpaceName:NSCalibratedRGBColorSpace];
		//CSS3 defines rgba() to take 0..255 for the color components, but 0..1 for the alpha component. Thus, we must multiply by 255 for the color components, but not for the alpha component.
		return [NSString stringWithFormat:@"rgba(%@,%@,%@,%@)",
				  [NSString stringWithCGFloat:[rgb redComponent]   * 255.0f maxDigits:6],
				  [NSString stringWithCGFloat:[rgb greenComponent] * 255.0f maxDigits:6],
				  [NSString stringWithCGFloat:[rgb blueComponent]  * 255.0f maxDigits:6],
				  [NSString stringWithCGFloat:alpha						 maxDigits:6]];
	} else {
		return [@"#" stringByAppendingString:[self hexString]];
	}
}

@end
@implementation NSString (AIColorAdditions_RepresentingColors)
- (NSC*)representedColor						{
	CGF	r = 255, g = 255, b = 255;
	CGF	a = 255;
	const char *selfUTF8 = [self UTF8String];
	//format: r,g,b[,a]
	//all components are decimal numbers 0..255.
	if (!isdigit(*selfUTF8)) goto scanFailed;
	r = (CGF)strtoul(selfUTF8, (char **)&selfUTF8, /*base*/ 10);
	if(*selfUTF8 == ',') ++selfUTF8;
	else				 goto scanFailed;
	if (!isdigit(*selfUTF8)) goto scanFailed;
	g = (CGF)strtoul(selfUTF8, (char **)&selfUTF8, /*base*/ 10);
	if(*selfUTF8 == ',') ++selfUTF8;
	else				 goto scanFailed;
	if (!isdigit(*selfUTF8)) goto scanFailed;
	b = (CGF)strtoul(selfUTF8, (char **)&selfUTF8, /*base*/ 10);
	if (*selfUTF8 == ',') {
		++selfUTF8;
		a = (CGF)strtoul(selfUTF8, (char **)&selfUTF8, /*base*/ 10);
		if (*selfUTF8) goto scanFailed;
	} else if (*selfUTF8 != '\0') {
		goto scanFailed;
	}
	return [NSC colorWithCalibratedRed:(r/255) green:(g/255) blue:(b/255) alpha:(a/255)] ;
scanFailed:
	return nil;
}
- (NSC*)representedColorWithAlpha:(CGF)aa	{
	//this is the same as above, but the alpha component is overridden.
	NSUInteger	r, g, b;
	const char *selfUTF8 = [self UTF8String];
	//format: r,g,b	all components are decimal numbers 0..255.
	if (!isdigit(*selfUTF8)) goto scanFailed;
	r = strtoul(selfUTF8, (char **)&selfUTF8, /*base*/ 10);
	if (*selfUTF8 != ',') goto scanFailed;
	++selfUTF8;
	if (!isdigit(*selfUTF8)) goto scanFailed;
	g = strtoul(selfUTF8, (char **)&selfUTF8, /*base*/ 10);
	if (*selfUTF8 != ',') goto scanFailed;
	++selfUTF8;
	if (!isdigit(*selfUTF8)) goto scanFailed;
	b = strtoul(selfUTF8, (char **)&selfUTF8, /*base*/ 10);
	return [NSC colorWithCalibratedRed:(r/255) green:(g/255) blue:(b/255) alpha:aa];
scanFailed:
	return nil;
}
@end
@implementation NSColor (AIColorAdditions_RandomColor)
+ (NSC*) randomColor				{
	return [NSC colorWithCalibratedRed:(arc4random() % 65536) / 65536.0f
										  green:(arc4random() % 65536) / 65536.0f
											blue:(arc4random() % 65536) / 65536.0f
										  alpha:1.0f];
}
+ (NSC*) randomColorWithAlpha	{
	return [NSC colorWithCalibratedRed:(arc4random() % 65536) / 65536.0f
										  green:(arc4random() % 65536) / 65536.0f
											blue:(arc4random() % 65536) / 65536.0f
										  alpha:(arc4random() % 65536) / 65536.0f];
}
@end
@implementation NSColor (NSColor_CSSRGB)
+ (NSC*) colorWithCSSRGB:(NSS*)rgbString										{
	/* NSColor+CSSRGB.m	SPColorWell  Created by Philip Dow on 11/16/11.  Copyright 2011 Philip Dow / Sprouted. All rights reserved.
	 Redistribution and use in source and binary forms, with or without modification, are permitted provided that the following conditions are met:
	 Redistributions of source code must retain the above copyright notice, this list of conditions and the following disclaimer.
	 Redistributions in binary form must reproduce the above copyright notice, this list of conditions and the following disclaimer in the documentation and/or other materials provided with the distribution.
	 Neither the name of the author nor the names of its contributors may be used to endorse or promote products derived from this software without specific prio written permission.
	 THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS “AS IS” AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
	 For non-attribution licensing options refer to http://phildow.net/licensing/	*/
	static NSCharacterSet *open  = nil;  open = open  ?: [NSCharacterSet characterSetWithCharactersInString:@"("];//retain];
	static NSCharacterSet *close = nil; close = close ?: [NSCharacterSet characterSetWithCharactersInString:@")"];//retain];
	NSI iBegin 		= [rgbString rangeOfCharacterFromSet:open].location;
	NSI iClose 		= [rgbString rangeOfCharacterFromSet:close].location;
	if ( iBegin == NSNotFound || iClose == NSNotFound )  return nil;
	NSS *rgbSub 	= [rgbString substringWithRange:NSMakeRange(iBegin+1,iClose-(iBegin+1))];
	NSA *components = [rgbSub 	 componentsSeparatedByString:@","];
	if ( [components count] != 3 )  return nil;
	NSA* componentValues = [components cw_mapArray:^id(NSS* aComponent) {
		NSS *cleanedComponent = [aComponent stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
		return [cleanedComponent length] == 0 ? nil : @([cleanedComponent floatValue]);
	}];
	return  [componentValues count] != 3 ? nil : [NSC colorWithCalibratedRed: [componentValues[0]fV] / 255.
																							 green: [componentValues[1]fV] / 255.
																							  blue: [componentValues[2]fV] / 255. alpha:1];
}
@end
@implementation NSColor (NSColor_ColorspaceEquality)
- (BOOL) isEqualToColor:(NSC*)inColor colorSpace:(NSS*)inColorSpace	{
	return  [self colorUsingColorSpaceName:inColorSpace] &&	  [inColor colorUsingColorSpaceName:inColorSpace]
	&& [[self colorUsingColorSpaceName:inColorSpace] isEqual:[inColor colorUsingColorSpaceName:inColorSpace]];
}
@end
/*
 @implementation NSColor (AIColorAdditions_HTMLSVGCSSColors)
 + (id)colorWithHTMLString:(NSS*) str											{
 return [self colorWithHTMLString:str defaultColor:nil];
 }
 / * !
 * @brief Convert one or two hex characters to a float
 * @param firstChar The first hex character
 * @param secondChar The second hex character, or 0x0 if only one character is to be used
 * @result The float value. Returns 0 as a bailout value if firstChar or secondChar are not valid hexadecimal characters ([0-9]|[A-F]|[a-f]). Also returns 0 if firstChar and secondChar equal 0.	* /
 static CGF hexCharsToFloat ( char firstChar, char secondChar )			{
 CGFloat				hexValue;
 NSUInteger		firstDigit;
 firstDigit = hexToInt(firstChar);
 if (firstDigit != -1) {
 hexValue = firstDigit;
 if (secondChar != 0x0) {
 int secondDigit = hexToInt(secondChar);
 if (secondDigit != -1)
 hexValue = (hexValue * 16.0f + secondDigit) / 255.0f;
 else
 hexValue = 0;
 } else {
 hexValue /= 15.0f;
 }
 } else {
 hexValue = 0;
 }
 return hexValue;
 }
 + (id)colorWithHTMLString:(NSS*) str defaultColor:(NSC*)defaultColor	{
 if (!str) return defaultColor;
 NSUInteger strLength = [str length];
 NSS *colorValue = str;
 if ([str hasPrefix:@"rgb"]) {
 NSUInteger leftParIndex = [colorValue rangeOfString:@"("].location;
 NSUInteger rightParIndex = [colorValue rangeOfString:@")"].location;
 if (leftParIndex == NSNotFound || rightParIndex == NSNotFound)
 {
 NSLog(@"+[NSColor(AIColorAdditions) colorWithHTMLString:] called with unrecognised color function (str is %@); returning %@", str, defaultColor);
 return defaultColor;
 }
 leftParIndex++;
 NSRange substrRange = NSMakeRange(leftParIndex, rightParIndex - leftParIndex);
 colorValue = [colorValue substringWithRange:substrRange];
 NSArray *colorComponents = [colorValue componentsSeparatedByString:@","];
 if ([colorComponents count] < 3 || [colorComponents count] > 4) {
 NSLog(@"+[NSColor(AIColorAdditions) colorWithHTMLString:] called with a color function with the wrong number of arguments (str is %@); returning %@", str, defaultColor);
 return defaultColor;
 }
 float red, green, blue, alpha = 1.0f;
 red = [[colorComponents objectAtIndex:0] floatValue];
 green = [[colorComponents objectAtIndex:1] floatValue];
 blue = [[colorComponents objectAtIndex:2] floatValue];
 if ([colorComponents count] == 4)
 alpha = [[colorComponents objectAtIndex:3] floatValue];
 return [NSC colorWithCalibratedRed:red green:green blue:blue alpha:alpha];
 }
 if ((!strLength) || ([str characterAtIndex:0] != '#')) {
 //look it up; it's a colour name
 NSDictionary *colorValues = [self colorNamesDictionary];
 colorValue = [colorValues objectForKey:str];
 if (!colorValue) colorValue = [colorValues objectForKey:[str lowercaseString]];
 if (!colorValue) {
 #if COLOR_DEBUG
 NSLog(@"+[NSColor(AIColorAdditions) colorWithHTMLString:] called with unrecognised color name (str is %@); returning %@", str, defaultColor);
 #endif
 return defaultColor;
 }
 }
 //we need room for at least 9 characters (#00ff00ff) plus the NUL terminator.
 //this array is 12 bytes long because I like multiples of four. ;)
 enum { hexStringArrayLength = 12 };
 size_t hexStringLength = 0;
 char hexStringArray[hexStringArrayLength] = { 0, 0, 0, 0,  0, 0, 0, 0,  0, 0, 0, 0, };
 {
 NSData *stringData = [str dataUsingEncoding:NSUTF8StringEncoding];
 hexStringLength = [stringData length];
 //subtract 1 because we don't want to overwrite that last NUL.
 memcpy(hexStringArray, [stringData bytes], MIN(hexStringLength, hexStringArrayLength - 1));
 }
 const char *hexString = hexStringArray;
 CGFloat		red,green,blue;
 CGFloat		alpha = 1.0f;
 //skip # if present.
 if (*hexString == '#') {
 ++hexString;
 --hexStringLength;
 }
 if (hexStringLength < 3) {
 #if COLOR_DEBUG
 NSLog(@"+[%@ colorWithHTMLString:] called with a string that cannot possibly be a hexadecimal color specification (e.g. #ff0000, #00b, #cc08) (string: %@ input: %@); returning %@", NSStringFromClass(self), colorValue, str, defaultColor);
 #endif
 return defaultColor;
 }
 //long specification:  #rrggbb[aa]
 //short specification: #rgb[a]
 //e.g. these all specify pure opaque blue: #0000ff #00f #0000ffff #00ff
 BOOL isLong = hexStringLength > 4;
 //for a long component c = 'xy':
 //	c = (x * 0x10 + y) / 0xff
 //for a short component c = 'x':
 //	c = x / 0xf
 char firstChar, secondChar;
 firstChar = *(hexString++);
 secondChar = (isLong ? *(hexString++) : 0x0);
 red = hexCharsToFloat(firstChar, secondChar);
 firstChar = *(hexString++);
 secondChar = (isLong ? *(hexString++) : 0x0);
 green = hexCharsToFloat(firstChar, secondChar);
 firstChar = *(hexString++);
 secondChar = (isLong ? *(hexString++) : 0x0);
 blue = hexCharsToFloat(firstChar, secondChar);
 if (*hexString) {
 //we still have one more component to go: this is alpha.
 //without this component, alpha defaults to 1.0 (see initialiser above).
 firstChar = *(hexString++);
 secondChar = (isLong ? *hexString : 0x0);
 alpha = hexCharsToFloat(firstChar, secondChar);
 }
 return [self colorWithCalibratedRed:red green:green blue:blue alpha:alpha];
 }
 @end
 */
@implementation NSColor (AIColorAdditions_ObjectColor)
+ (NSS*) representedColorForObject:(id)anObject withValidColors:(NSA*)validColors	{
	NSArray *validColorsArray = validColors;
	if (!validColorsArray || [validColorsArray count] == 0) {
		if (!defaultValidColors) {
			defaultValidColors = VALID_COLORS_ARRAY;
		}
		validColorsArray = defaultValidColors;
	}
	return validColorsArray[([anObject hash] % ([validColorsArray count]))];
}
@end
@implementation NSColor (Utilities)
+   (NSA*) calveticaPalette 									{
	return @[CV_PALETTE_1, CV_PALETTE_2, CV_PALETTE_3, CV_PALETTE_4, CV_PALETTE_5, CV_PALETTE_6, CV_PALETTE_7, CV_PALETTE_8, CV_PALETTE_9, CV_PALETTE_10, CV_PALETTE_11, CV_PALETTE_12, CV_PALETTE_13, CV_PALETTE_14, CV_PALETTE_15, CV_PALETTE_16, CV_PALETTE_17, CV_PALETTE_18, CV_PALETTE_19, CV_PALETTE_20, CV_PALETTE_21];
}
-   (NSC*) closestColorInCalveticaPalette 				{
	return [self closestColorInPalette:[NSC calveticaPalette]];
}
-   (NSC*) closestColorInPalette:(NSA*)palette	{

	//  UIColor+Utilities.m  ColorAlgorith  Created by Quenton Jones on 6/11/11.

	float bestDifference = MAXFLOAT;
	NSC*bestColor = nil;
	float *lab1 = [self colorToLab];
	float C1 = sqrtf(lab1[1] * lab1[1] + lab1[2] * lab1[2]);
	for (NSC*color in palette) {
		float *lab2 = [color colorToLab];
		float C2 = sqrtf(lab2[1] * lab2[1] + lab2[2] * lab2[2]);
		float deltaL = lab1[0] - lab2[0];
		float deltaC = C1 - C2;
		float deltaA = lab1[1] - lab2[1];
		float deltaB = lab1[2] - lab2[2];
		float deltaH = sqrtf(deltaA * deltaA + deltaB * deltaB - deltaC * deltaC);
		float deltaE = sqrtf(powf(deltaL / K_L, 2) + powf(deltaC / (1 + K_1 * C1), 2) + powf(deltaH / (1 + K_2 * C1), 2));
		if (deltaE < bestDifference) {
			bestColor = color;
			bestDifference = deltaE;
		}
		free(lab2);
	}
	NSLog(@"Color Difference: %f", bestDifference);
	NSLog(@"Color: %@", bestColor);
	free(lab1);
	return bestColor;
}
- (float*) colorToLab 											{
	// Don't allow grayscale colors.
	if (CGColorGetNumberOfComponents(self.CGColor) != 4) {
		return nil;
	}
	float *rgb = (float *)malloc(3 * sizeof(float));
	const CGFloat *components = CGColorGetComponents(self.CGColor);
	rgb[0] = components[0];
	rgb[1] = components[1];
	rgb[2] = components[2];
	//NSLog(@"Color (RGB) %@: r: %i g: %i b: %i", self, (int)(rgb[0] * 255), (int)(rgb[1] * 255), (int)(rgb[2] * 255));
	float *lab = [NSC rgbToLab:rgb];
	free(rgb);
	//NSLog(@"Color (Lab) %@: L: %f a: %f b: %f", self, lab[0], lab[1], lab[2]);
	return lab;
}
+ (float*) rgbToLab:(float*)rgb {
	float *xyz = [NSC rgbToXYZ:rgb];
	float *lab = [NSC xyzToLab:xyz];
	free(xyz);
	return lab;
}
+ (float*) rgbToXYZ:(float*)rgb {
	float *newRGB = (float *)malloc(3 * sizeof(float));
	for (int i = 0; i < 3; i++) {
		float component = rgb[i];
		if (component > 0.04045f) {
			component = powf((component + 0.055f) / 1.055f, 2.4f);
		} else {
			component = component / 12.92f;
		}
		newRGB[i] = component;
	}
	newRGB[0] = newRGB[0] * 100.0f;
	newRGB[1] = newRGB[1] * 100.0f;
	newRGB[2] = newRGB[2] * 100.0f;
	float *xyz = (float *)malloc(3 * sizeof(float));
	xyz[0] = (newRGB[0] * 0.4124f) + (newRGB[1] * 0.3576f) + (newRGB[2] * 0.1805f);
	xyz[1] = (newRGB[0] * 0.2126f) + (newRGB[1] * 0.7152f) + (newRGB[2] * 0.0722f);
	xyz[2] = (newRGB[0] * 0.0193f) + (newRGB[1] * 0.1192f) + (newRGB[2] * 0.9505f);
	free(newRGB);
	return xyz;
}
+ (float*) xyzToLab:(float*)xyz {
	float *newXYZ = (float *)malloc(3 * sizeof(float));
	newXYZ[0] = xyz[0] / X_REF;
	newXYZ[1] = xyz[1] / Y_REF;
	newXYZ[2] = xyz[2] / Z_REF;
	for (int i = 0; i < 3; i++) {
		float component = newXYZ[i];
		if (component > 0.008856) {
			component = powf(component, 0.333f);
		} else {
			component = (7.787 * component) + (16 / 116);
		}
		newXYZ[i] = component;
	}
	float *lab = (float *)malloc(3 * sizeof(float));
	lab[0] = (116 * newXYZ[1]) - 16;
	lab[1] = 500 * (newXYZ[0] - newXYZ[1]);
	lab[2] = 200 * (newXYZ[1] - newXYZ[2]);
	free(newXYZ);
	return lab;
}
@end

__attribute__((constructor)) static void do_the_swizzles()
{
	[$ swizzleMethod:@selector(colorWithKey:) with:@selector(swizzleColorWithKey:) in:NSColorList.class];
}

@implementation NSColorList (AtoZ)
- (NSC*) swizzleColorWithKey:(NSS*)k  {
	NSC* c = [self swizzleColorWithKey:k];
	if (c) c.name = k;
	return c;
}
/**
 #define _COLOR(V, N) \
 [self setColor :[@"#" stringByAppendingString : @#V].colorValue \
 forKey : @#N]
 //	_COLOR(FFFFFF00, Transparent);
 _COLOR(F0F8FF, AliceBlue);
 _COLOR(FAEBD7, AntiqueWhite);
 _COLOR(AFB837, AppleGreen);
 _COLOR(00FFFF, Aqua);
 _COLOR(7FFFD 4, Aquamarine);
 _COLOR(F0FFFF, Azure);
 _COLOR(F5F5DC, Beige);
 _COLOR(FFE4C4, Bisque);
 _COLOR(000000, Black);
 _COLOR(FFEBCD, BlanchedAlmond);
 _COLOR(0000FF, Blue);
 _COLOR(8A2BE2, BlueViolet);
 _COLOR(A52A2A, Brown);
 _COLOR(DEB887, BurlyWood);
 _COLOR(5F 9EA0, CadetBlue);
 _COLOR(7FFF 00, Chartreuse);
 _COLOR(D2691E, Chocolate);
 _COLOR(FF7F50, Coral);
 _COLOR(6495ED, CornflowerBlue);
 _COLOR(FFF8DC, Cornsilk);
 _COLOR(DC143C, Crimson);
 _COLOR(00FFFF, Cyan);
 _COLOR(0000 8B, DarkBlue);
 _COLOR(00 8B8B, DarkCyan);
 _COLOR(B8860B, DarkGoldenRod);
 _COLOR(A9A9A9, DarkGray);
 _COLOR(006400, DarkGreen);
 _COLOR(BDB76B, DarkKhaki);
 _COLOR(8B008B, DarkMagenta);
 _COLOR(556B2F, DarkOliveGreen);
 _COLOR(FF8C00, Darkorange);
 _COLOR(9932CC, DarkOrchid);
 _COLOR(8B0000, DarkRed);
 _COLOR(E9967A, DarkSalmon);
 _COLOR(8FBC8F, DarkSeaGreen);
 _COLOR(483D 8B, DarkSlateBlue);
 _COLOR(2F 4F 4F, DarkSlateGray);
 _COLOR(00CED1, DarkTurquoise);
 _COLOR(9400D 3, DarkViolet);
 _COLOR(FF1493, DeepPink);
 _COLOR(00BFFF, DeepSkyBlue);
 _COLOR(696969, DimGray);
 _COLOR(1E90FF, DodgerBlue);
 _COLOR(B22222, FireBrick);
 _COLOR(FFFAF0, FloralWhite);
 _COLOR(228B22, ForestGreen);
 _COLOR(FF00FF, Fuchsia);
 _COLOR(DCDCDC, Gainsboro);
 _COLOR(F8F8FF, GhostWhite);
 _COLOR(FFD700, Gold);
 _COLOR(DAA520, GoldenRod);
 _COLOR(808080, Gray);
 _COLOR(00 8000, Green);
 _COLOR(ADFF2F, GreenYellow);
 _COLOR(F0FFF0, HoneyDew);
 _COLOR(FF69B4, HotPink);
 _COLOR(CD5C5C, IndianRed);
 _COLOR(4B0082, Indigo);
 _COLOR(FFFFF0, Ivory);
 _COLOR(F0E68C, Khaki);
 _COLOR(E6E6FA, Lavender);
 _COLOR(FFF0F5, LavenderBlush);
 _COLOR(7CFC00, LawnGreen);
 _COLOR(FFFACD, LemonChiffon);
 _COLOR(ADD8E6, LightBlue);
 _COLOR(F08080, LightCoral);
 _COLOR(E0FFFF, LightCyan);
 _COLOR(FAFAD2, LightGoldenRodYellow);
 _COLOR(D3D3D3, LightGrey);
 _COLOR(90EE90, LightGreen);
 _COLOR(FFB6C1, LightPink);
 _COLOR(FFA07A, LightSalmon);
 _COLOR(20B2AA, LightSeaGreen);
 _COLOR(87CEFA, LightSkyBlue);
 _COLOR(778899, LightSlateGray);
 _COLOR(B0C4DE, LightSteelBlue);
 _COLOR(FFFFE0, LightYellow);
 _COLOR(00FF 00, Lime);
 _COLOR(32CD32, LimeGreen);
 _COLOR(FAF0E6, Linen);
 _COLOR(FF00FF, Magenta);
 _COLOR(800000, Maroon);
 _COLOR(66CDAA, MediumAquaMarine);
 _COLOR(0000CD, MediumBlue);
 _COLOR(BA55D3, MediumOrchid);
 _COLOR(9370D 8, MediumPurple);
 _COLOR(3CB371, MediumSeaGreen);
 _COLOR(7B68EE, MediumSlateBlue);
 _COLOR(00FA9A, MediumSpringGreen);
 _COLOR(48D 1CC, MediumTurquoise);
 _COLOR(C71585, MediumVioletRed);
 _COLOR(191970, MidnightBlue);
 _COLOR(F5FFFA, MintCream);
 _COLOR(FFE4E1, MistyRose);
 _COLOR(FFE4B5, Moccasin);
 _COLOR(FFDEAD, NavajoWhite);
 _COLOR(0000 80, Navy);
 _COLOR(FDF5E6, OldLace);
 _COLOR(808000, Olive);
 _COLOR(6B8E23, OliveDrab);
 _COLOR(FFA500, Orange);
 _COLOR(FF4500, OrangeRed);
 _COLOR(DA70D6, Orchid);
 _COLOR(EEE8AA, PaleGoldenRod);
 _COLOR(98FB98, PaleGreen);
 _COLOR(AFEEEE, PaleTurquoise);
 _COLOR(D87093, PaleVioletRed);
 _COLOR(FFEFD5, PapayaWhip);
 _COLOR(FFDAB9, PeachPuff);
 _COLOR(CD853F, Peru);
 _COLOR(FFC0CB, Pink);
 _COLOR(DDA0DD, Plum);
 _COLOR(B0E0E6, PowderBlue);
 _COLOR(800080, Purple);
 _COLOR(FF0000, Red);
 _COLOR(BC8F8F, RosyBrown);
 _COLOR(4169E1, RoyalBlue);
 _COLOR(8B4513, SaddleBrown);
 _COLOR(FA8072, Salmon);
 _COLOR(F4A460, SandyBrown);
 _COLOR(2E8B57, SeaGreen);
 _COLOR(FFF5EE, SeaShell);
 _COLOR(A0522D, Sienna);
 _COLOR(C0C0C0, Silver);
 _COLOR(87CEEB, SkyBlue);
 _COLOR(6A5ACD, SlateBlue);
 _COLOR(708090, SlateGray);
 _COLOR(FFFAFA, Snow);
 _COLOR(00FF 7F, SpringGreen);
 _COLOR(4682B4, SteelBlue);
 _COLOR(D2B48C, Tan);
 _COLOR(00 8080, Teal);
 _COLOR(D8BFD8, Thistle);
 _COLOR(FF6347, Tomato);
 _COLOR(40E0D 0, Turquoise);
 _COLOR(EE82EE, Violet);
 _COLOR(F5DEB3, Wheat);
 _COLOR(FFFFFF, White);
 _COLOR(F5F5F5, WhiteSmoke);
 _COLOR(FFFF00, Yellow);
 _COLOR(9ACD32, YellowGreen);
 #undef _COLOR
 }
 - (id)init {
 if (instance != nil) {
 [NSException
 raise:NSInternalInconsistencyException
 format:@"[%@ %@] cannot be called; use +[%@ %@] instead",
 [self className],
 NSStringFromSelector(_cmd),
 [self className],
 NSStringFromSelector(@selector(instance))
 ];
 } else if ((self = [super init])) {
 instance = self;
 [self _initColors];
 }
 return instance;
 }
 + (NSS*)nameOfColor:(NSColor *)color {
 return [self nameOfColor:color savingDistance:nil];
 }
 + (NSS*)nameOfColor:(NSColor *)color savingDistance:(NSColor **)distance {
 if (!color)
 // failsave return
 return nil;
 NSColorList *list = [self namedColors];
 NSString *re = nil;
 // min distance color
 NSColor *mdc = nil;
 // min distance value
 CGFloat mdv = 1.0;
 for (NSString *key in [list allKeys]) {
 NSColor *c = [list colorWithKey:key];
 NSColor *cd = [c hsbDistanceToColor:color];
 CGFloat dv = cd.hsbWeight;
 if (dv < mdv) {
 mdv = dv;
 mdc = cd;
 re = key;
 if (dv == 0)
 break;
 }
 }
 if (distance)
 *distance = mdc;
 return re;
 }
 */
//- (NSMethodSignature *)methodSignatureForSelector:(SEL)selector
//{
//	//look up method signature
//	NSMethodSignature *signature = [super methodSignatureForSelector:selector];
//	if (!signature)
//		if ([NSA.class instancesRespondToSelector:selector])
//			signature = [class instanceMethodSignatureForSelector:selector];
//	return signature;
//}
//
//- (void)forwardInvocation:(NSInvocation *)invocation
//{
//	[invocation invokeWithTarget:nil];
//}

-  (NSA*) colors  					{

	if (palettesD == nil) palettesD = NSMD.new;
	NSA* colors = [palettesD objectForKey:self.name];
	if (!colors) {
		palettesD[self.name] = [self.allKeys cw_mapArray:^id(id obj) {
			NSC* c =  [self colorWithKey:obj].deviceRGBColor;
			//				  c.name = obj;
			//				NSLog(@"named:%@...%@", c, c.name);
			return c;
		}];
	}
	return palettesD[self.name];
}

- (NSC*) randomColor;																			{
	return [self  colorWithKey:[[self allKeys] randomElement]];
}
+   (id) colorListWithFileName:				(NSS*)f inBundle:			  (NSB*)b 	{

	NSColorList *list = nil;	NSS *listP;

	return (b) ? (listP = [b pathForResource:f ofType:nil]) != nil ? [NSColorList.alloc initWithName:listP.lastPathComponent fromFile:listP]: nil : nil;
}
+   (id) colorListWithFileName:				(NSS*)f inBundleForClass:(Class)c 	{	return [self colorListWithFileName:f inBundle:[NSB bundleForClass:c]];	}
+   (id) colorListInFrameworkWithFileName:(NSS*)f {	return [self colorListWithFileName:f inBundle:AtoZ.bundle];	}
@end
@implementation NSString (THColorConversion)
-    (NSC*) colorValue 							{
	return [NSC colorFromString:self];
}
- (NSData*) colorData 							{
	NSData *theData=[NSArchiver archivedDataWithRootObject:self];
	return theData;
}
+    (NSC*) colorFromData:(NSData*)theD 	{ return [NSUnarchiver unarchiveObjectWithData:theD];	}
@end


@interface NSColor (AMAdditions_AppKitPrivate)
+ (NSColor *)toolTipColor;
+ (NSColor *)toolTipTextColor;
@end


@implementation NSColor (AMAdditions)

+ (NSColor *)lightYellowColor
{
	return [NSColor colorWithCalibratedHue:0.2 saturation:0.2 brightness:1.0 alpha:1.0];
}

+ (NSColor *)am_toolTipColor
{
	NSColor *result;
	if ([NSColor respondsToSelector:@selector(toolTipColor)]) {
		result = [NSColor toolTipColor];
	} else {
		result = [NSColor lightYellowColor];
	}
	return result;
}

+ (NSColor *)am_toolTipTextColor
{
	NSColor *result;
	if ([NSColor respondsToSelector:@selector(toolTipTextColor)]) {
		result = [NSColor toolTipTextColor];
	} else {
		result = [NSColor blackColor];
	}
	return result;
}

- (NSColor *)accentColor
{
	NSColor *result;
	CGFloat hue;
	CGFloat saturation;
	CGFloat brightness;
	CGFloat alpha;
	[[self  colorUsingColorSpaceName:NSDeviceRGBColorSpace] getHue:&hue saturation:&saturation brightness:&brightness alpha:&alpha];
	if (brightness <= 0.3) {
		[[[NSColor colorForControlTint:[NSColor currentControlTint]] colorUsingColorSpaceName:NSDeviceRGBColorSpace] getHue:&hue saturation:&saturation brightness:&brightness alpha:&alpha];
		saturation = 1.0;
		brightness = 1.0;
	} else {
		//if (saturation > 0.3) {
		brightness = brightness/2.0;
		//}
		saturation = 1.0;
	}
	result = [NSColor colorWithCalibratedHue:hue saturation:saturation brightness:brightness alpha:alpha];
	return result;
}

- (NSColor *)lighterColor
{
	NSColor *result;
	CGFloat hue;
	CGFloat saturation;
	CGFloat brightness;
	CGFloat alpha;
	[[self  colorUsingColorSpaceName:NSDeviceRGBColorSpace] getHue:&hue saturation:&saturation brightness:&brightness alpha:&alpha];
	if (brightness > 0.4) {
		if (brightness < 0.90) {
			brightness += 0.1+(brightness*0.3);
		} else {
			brightness = 1.0;
			if (saturation > 0.12) {
				saturation = MAX(0.0, saturation-0.1-(saturation/2.0));
			} else {
				saturation += 0.25;
			}
		}
	} else {
		brightness = 0.6;
	}
	result = [NSColor colorWithCalibratedHue:hue saturation:saturation brightness:brightness alpha:alpha];
	return result;
}

- (NSColor *)disabledColor
{
	int alpha = [self alphaComponent];
	return [self colorWithAlphaComponent:alpha*0.5];
}


@end

/*
 NSC*thisColor = [self colorUsingColorSpaceName:NSCalibratedRGBColorSpace];	NSColorList *colors = [NSColorList colorListInFrameworkWithFileName:@"RGB.clr"];	NSColorList *crayons = [NSColorList colorListNamed:@"Crayons"];
 //- (NSC*)closestColorListColor {
 //	__block NSC*thisColor = [self colorUsingColorSpaceName:NSCalibratedRGBColorSpace];
 //	__block	CGFloat bestDistance = FLT_MAX;
 ////	NSColorList *colors = [NSColorList colorListNamed:@"Web Safe Colors"];
 ////	NSColorList *crayons = [NSColorList colorListNamed:@"Crayons"];
 //	NSArray *avail = $array(colors);//, crayons);
 //	NSColorList *bestList = nil;
 __block NSC*bestColor = nil;
 //	__block NSS *bestKey = nil;
 //	for (NSColorList *list  in avail) {
 //		NSEnumerator *enumerator = [[list allKeys] objectEnumerator];
 //		NSS *key = nil;
 //		while ((key = [enumerator nextObject])) {
 [[[NSColorList  colorListNamed:@"Web Safe Colors"] allKeys] enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
 NSC*thatColor = [[[NSColorList colorListNamed:@"Web Safe Colors"] colorWithKey:obj]colorUsingColorSpaceName:NSCalibratedRGBColorSpace];
 if (![thatColor isBoring]) {
 //			thatColor = [thatColor colorUsingColorSpaceName:NSCalibratedRGBColorSpace];
 CGFloat colorDistance =
 fabs([thisColor redComponent] 	- [thatColor redComponent]);
 colorDistance += fabs([thisColor blueComponent] 	- [thatColor blueComponent]);
 colorDistance += fabs([thisColor greenComponent]	- [thatColor greenComponent]);
 colorDistance = sqrt(colorDistance);
 if (colorDistance < bestDistance) {
 //				bestList = list;
 bestDistance = colorDistance;
 bestColor = thatColor;
 //				bestKey = obj;
 }
 }
 //	}];
 //	bestColorKey = [[NSBundle bundleWithPath:@"/System/Library/Colors/Web Safe Colors.clr"]
 //					localizedStringForKey:bestColorKey	value:bestColorKey 	table:@"Crayons"];
 return bestColor;//, @"color", bestKey, @"key", bestList, @"list");
 }
 NSCL *clist = [[self colorsInListNamed:name] filterOne:^BOOL(NSCL* list) { return areSame(list.name, name); }];
 return [clist.allKeys cw_mapArray:^id(id obj) {
 NSC* c = [[clist colorWithKey:obj] colorUsingColorSpaceName:NSDeviceRGBColorSpace];
 c.name = obj; return c;
 }];
 }();
 - (NSC*)closestColorListColor {
 NSC*thisColor = [self colorUsingColorSpaceName:NSCalibratedRGBColorSpace];
 CGFloat bestDistance = FLT_MAX;
 NSColorList *colors = [NSColorList colorListNamed:@"Web Safe Colors"];
 NSColorList *crayons = [NSColorList colorListNamed:@"Crayons"];
 NSArray *avail = $array(colors, crayons);
 //	NSColorList *bestList = nil;
 NSC*bestColor = nil;
 NSS *bestKey = nil;
 for (NSColorList *list  in avail) {
 NSEnumerator *enumerator = [[list allKeys] objectEnumerator];
 NSS *key = nil;
 while ((key = [enumerator nextObject])) {
 NSC*thatColor = [list colorWithKey:key];
 thatColor = [thatColor colorUsingColorSpaceName:NSCalibratedRGBColorSpace];
 CGFloat colorDistance =
 fabs([thisColor redComponent] 	- [thatColor redComponent]);
 colorDistance += fabs([thisColor blueComponent] 	- [thatColor blueComponent]);
 colorDistance += fabs([thisColor greenComponent]	- [thatColor greenComponent]);
 colorDistance = sqrt(colorDistance);
 if (colorDistance < bestDistance) {
 //				bestList = list;
 bestDistance = colorDistance;
 bestColor = thatColor;
 bestKey = key; }
 }
 }
 //	bestColorKey = [[NSBundle bundleWithPath:@"/System/Library/Colors/Web Safe Colors.clr"]
 //					localizedStringForKey:bestColorKey	value:bestColorKey 	table:@"Crayons"];
 return bestColor;//, @"color", bestKey, @"key", bestList, @"list");
 }
 - (NSC*)closestColorListColor {
 NSC*thisColor = [self colorUsingColorSpaceName:NSCalibratedRGBColorSpace];
 CGFloat bestDistance = FLT_MAX;
 NSColorList *colors = [NSColorList colorListInFrameworkWithFileName:@"RGB.clr"];
 NSColorList *safe =  [NSColorList colorListNamed:@"Web Safe Colors"];
 NSColorList *crayons = [NSColorList colorListNamed:@"Crayons"];
 NSArray *avail = $array( safe);
 //	NSColorList *bestList = nil;
 __block float red = [thisColor redComponent];
 __block float green = [thisColor greenComponent];
 __block float blue = [thisColor blueComponent];
 __block NSC*bestColor = nil;
 __block CGFloat colorDistance;
 ////	NSS *bestKey = nil;
 //	for (NSColorList *list  in avail) {
 //		NSEnumerator *enumerator = [[list allKeys] objectEnumerator];
 //		NSS *key = nil;
 //		while ((key = [enumerator nextObject])) {

 [avail eachConcurrentlyWithBlock:^(NSInteger index, id obj, BOOL *stop) {
 [[obj allKeys]filterOne:^BOOL(id object) {
 NSC*thatColor = [[obj colorWithKey:object]colorUsingColorSpaceName:NSCalibratedRGBColorSpace];
 CGFloat colorDistance = sqrt(		fabs( red	- [thatColor redComponent]) + fabs(blue - [thatColor blueComponent])
 + fabs(green	- [thatColor greenComponent]) );
 if (colorDistance < bestDistance)
 if (colorDistance < .04)
 return YES;   //bestList = list;
 else {
 bestDistance = colorDistance;
 bestColor = thatColor;
 return  NO;
 }
 //				return bestColor				//				bestKey = key;
 }return NO;
 }
 }
 //, @"color", bestKey, @"key", bestList, @"list");
 //	bestColorKey = [[NSBundle bundleWithPath:@"/System/Library/Colors/Web Safe Colors.clr"]
 //					localizedStringForKey:bestColorKey	value:bestColorKey 	table:@"Crayons"];
 }
 @implementation NSArray (THColorConversion)
 - (NSA*)colorValues {
 return [self arrayPerformingSelector:@selector(colorValue)];
 }
 @end


 //+ (NSC*)colorWithCGColor:(CGColorRef)aColor {
 //	const CGFloat *components = CGColorGetComponents(aColor);
 //	CGFloat red = components[0];
 //	CGFloat green = components[1];
 //	CGFloat blue = components[2];
 //	CGFloat alpha = components[3];
 //	return [self colorWithDeviceRed:red green:green blue:blue alpha:alpha];
 //}
 / * *+ (NSColor)
 [tempMutableArray addObject:[[Color alloc] initWithColorName:@"Almond" HexCode:@"#EFDECD" Red:239 Green:222 Blue:205]];
 [tempMutableArray addObject:[[Color alloc] initWithColorName:@"Apricot" HexCode:@"#FDD9B5" Red:253 Green:217 Blue:181]];
 [tempMutableArray addObject:[[Color alloc] initWithColorName:@"Aquamarine" HexCode:@"#78DBE2" Red:120 Green:219 Blue:226]];
 [tempMutableArray addObject:[[Color alloc] initWithColorName:@"Asparagus" HexCode:@"#87A96B" Red:135 Green:169 Blue:107]];
 [tempMutableArray addObject:[[Color alloc] initWithColorName:@"Atomic Tangerine" HexCode:@"#FFA474" Red:255 Green:164 Blue:116]];
 [tempMutableArray addObject:[[Color alloc] initWithColorName:@"Banana Mania" HexCode:@"#FAE7B5" Red:250 Green:231 Blue:181]];
 [tempMutableArray addObject:[[Color alloc] initWithColorName:@"Beaver" HexCode:@"#9F8170" Red:159 Green:129 Blue:112]];
 [tempMutableArray addObject:[[Color alloc] initWithColorName:@"Bittersweet" HexCode:@"#FD7C6E" Red:253 Green:124 Blue:110]];
 [tempMutableArray addObject:[[Color alloc] initWithColorName:@"Black" HexCode:@"#000000" Red:0 Green:0 Blue:0]];
 [tempMutableArray addObject:[[Color alloc] initWithColorName:@"Blizzard Blue" HexCode:@"#ACE5EE" Red:172 Green:229 Blue:238]];
 [tempMutableArray addObject:[[Color alloc] initWithColorName:@"Blue" HexCode:@"#1F75FE" Red:31 Green:117 Blue:254]];
 [tempMutableArray addObject:[[Color alloc] initWithColorName:@"Blue Bell" HexCode:@"#A2A2D0" Red:162 Green:162 Blue:208]];
 [tempMutableArray addObject:[[Color alloc] initWithColorName:@"Blue Gray" HexCode:@"#6699CC" Red:102 Green:153 Blue:204]];
 [tempMutableArray addObject:[[Color alloc] initWithColorName:@"Blue Green" HexCode:@"#0D98BA" Red:13 Green:152 Blue:186]];
 [tempMutableArray addObject:[[Color alloc] initWithColorName:@"Blue Violet" HexCode:@"#7366BD" Red:115 Green:102 Blue:189]];
 [tempMutableArray addObject:[[Color alloc] initWithColorName:@"Blush" HexCode:@"#DE5D83" Red:222 Green:93 Blue:131]];
 [tempMutableArray addObject:[[Color alloc] initWithColorName:@"Brick Red" HexCode:@"#CB4154" Red:203 Green:65 Blue:84]];
 [tempMutableArray addObject:[[Color alloc] initWithColorName:@"Brown" HexCode:@"#B4674D" Red:180 Green:103 Blue:77]];
 [tempMutableArray addObject:[[Color alloc] initWithColorName:@"Burnt Orange" HexCode:@"#FF7F49" Red:255 Green:127 Blue:73]];
 [tempMutableArray addObject:[[Color alloc] initWithColorName:@"Burnt Sienna" HexCode:@"#EA7E5D" Red:234 Green:126 Blue:93]];
 [tempMutableArray addObject:[[Color alloc] initWithColorName:@"Cadet Blue" HexCode:@"#B0B7C6" Red:176 Green:183 Blue:198]];
 [tempMutableArray addObject:[[Color alloc] initWithColorName:@"Canary" HexCode:@"#FFFF99" Red:255 Green:255 Blue:153]];
 [tempMutableArray addObject:[[Color alloc] initWithColorName:@"Caribbean Green" HexCode:@"#1CD3A2" Red:28 Green:211 Blue:162]];
 [tempMutableArray addObject:[[Color alloc] initWithColorName:@"Carnation Pink" HexCode:@"#FFAACC" Red:255 Green:170 Blue:204]];
 [tempMutableArray addObject:[[Color alloc] initWithColorName:@"Cerise" HexCode:@"#DD4492" Red:221 Green:68 Blue:146]];
 [tempMutableArray addObject:[[Color alloc] initWithColorName:@"Cerulean" HexCode:@"#1DACD6" Red:29 Green:172 Blue:214]];
 [tempMutableArray addObject:[[Color alloc] initWithColorName:@"Chestnut" HexCode:@"#BC5D58" Red:188 Green:93 Blue:88]];
 [tempMutableArray addObject:[[Color alloc] initWithColorName:@"Copper" HexCode:@"#DD9475" Red:221 Green:148 Blue:117]];
 [tempMutableArray addObject:[[Color alloc] initWithColorName:@"Cornflower" HexCode:@"#9ACEEB" Red:154 Green:206 Blue:235]];
 [tempMutableArray addObject:[[Color alloc] initWithColorName:@"Cotton Candy" HexCode:@"#FFBCD9" Red:255 Green:188 Blue:217]];
 [tempMutableArray addObject:[[Color alloc] initWithColorName:@"Dandelion" HexCode:@"#FDDB6D" Red:253 Green:219 Blue:109]];
 [tempMutableArray addObject:[[Color alloc] initWithColorName:@"Denim" HexCode:@"#2B6CC4" Red:43 Green:108 Blue:196]];
 [tempMutableArray addObject:[[Color alloc] initWithColorName:@"Desert Sand" HexCode:@"#EFCDB8" Red:239 Green:205 Blue:184]];
 [tempMutableArray addObject:[[Color alloc] initWithColorName:@"Eggplant" HexCode:@"#6E5160" Red:110 Green:81 Blue:96]];
 [tempMutableArray addObject:[[Color alloc] initWithColorName:@"Electric Lime" HexCode:@"#CEFF1D" Red:206 Green:255 Blue:29]];
 [tempMutableArray addObject:[[Color alloc] initWithColorName:@"Fern" HexCode:@"#71BC78" Red:113 Green:188 Blue:120]];
 [tempMutableArray addObject:[[Color alloc] initWithColorName:@"Forest Green" HexCode:@"#6DAE81" Red:109 Green:174 Blue:129]];
 [tempMutableArray addObject:[[Color alloc] initWithColorName:@"Fuchsia" HexCode:@"#C364C5" Red:195 Green:100 Blue:197]];
 [tempMutableArray addObject:[[Color alloc] initWithColorName:@"Fuzzy Wuzzy" HexCode:@"#CC6666" Red:204 Green:102 Blue:102]];
 [tempMutableArray addObject:[[Color alloc] initWithColorName:@"Gold" HexCode:@"#E7C697" Red:231 Green:198 Blue:151]];
 [tempMutableArray addObject:[[Color alloc] initWithColorName:@"Goldenrod" HexCode:@"#FCD975" Red:252 Green:217 Blue:117]];
 [tempMutableArray addObject:[[Color alloc] initWithColorName:@"Granny Smith Apple" HexCode:@"#A8E4A0" Red:168 Green:228 Blue:160]];
 [tempMutableArray addObject:[[Color alloc] initWithColorName:@"Gray" HexCode:@"#95918C" Red:149 Green:145 Blue:140]];
 [tempMutableArray addObject:[[Color alloc] initWithColorName:@"Green" HexCode:@"#1CAC78" Red:28 Green:172 Blue:120]];
 [tempMutableArray addObject:[[Color alloc] initWithColorName:@"Green Blue" HexCode:@"#1164B4" Red:17 Green:100 Blue:180]];
 [tempMutableArray addObject:[[Color alloc] initWithColorName:@"Green Yellow" HexCode:@"#F0E891" Red:240 Green:232 Blue:145]];
 [tempMutableArray addObject:[[Color alloc] initWithColorName:@"Hot Magenta" HexCode:@"#FF1DCE" Red:255 Green:29 Blue:206]];
 [tempMutableArray addObject:[[Color alloc] initWithColorName:@"Inchworm" HexCode:@"#B2EC5D" Red:178 Green:236 Blue:93]];
 [tempMutableArray addObject:[[Color alloc] initWithColorName:@"Indigo" HexCode:@"#5D76CB" Red:93 Green:118 Blue:203]];
 [tempMutableArray addObject:[[Color alloc] initWithColorName:@"Jazzberry Jam" HexCode:@"#CA3767" Red:202 Green:55 Blue:103]];
 [tempMutableArray addObject:[[Color alloc] initWithColorName:@"Jungle Green" HexCode:@"#3BB08F" Red:59 Green:176 Blue:143]];
 [tempMutableArray addObject:[[Color alloc] initWithColorName:@"Laser Lemon" HexCode:@"#FEFE22" Red:254 Green:254 Blue:34]];
 [tempMutableArray addObject:[[Color alloc] initWithColorName:@"Lavender" HexCode:@"#FCB4D5" Red:252 Green:180 Blue:213]];
 [tempMutableArray addObject:[[Color alloc] initWithColorName:@"Lemon Yellow" HexCode:@"#FFF44F" Red:255 Green:244 Blue:79]];
 [tempMutableArray addObject:[[Color alloc] initWithColorName:@"Macaroni and Cheese" HexCode:@"#FFBD88" Red:255 Green:189 Blue:136]];
 [tempMutableArray addObject:[[Color alloc] initWithColorName:@"Magenta" HexCode:@"#F664AF" Red:246 Green:100 Blue:175]];
 [tempMutableArray addObject:[[Color alloc] initWithColorName:@"Magic Mint" HexCode:@"#AAF0D1" Red:170 Green:240 Blue:209]];
 [tempMutableArray addObject:[[Color alloc] initWithColorName:@"Mahogany" HexCode:@"#CD4A4C" Red:205 Green:74 Blue:76]];
 [tempMutableArray addObject:[[Color alloc] initWithColorName:@"Maize" HexCode:@"#EDD19C" Red:237 Green:209 Blue:156]];
 [tempMutableArray addObject:[[Color alloc] initWithColorName:@"Manatee" HexCode:@"#979AAA" Red:151 Green:154 Blue:170]];
 [tempMutableArray addObject:[[Color alloc] initWithColorName:@"Mango Tango" HexCode:@"#FF8243" Red:255 Green:130 Blue:67]];
 [tempMutableArray addObject:[[Color alloc] initWithColorName:@"Maroon" HexCode:@"#C8385A" Red:200 Green:56 Blue:90]];
 [tempMutableArray addObject:[[Color alloc] initWithColorName:@"Mauvelous" HexCode:@"#EF98AA" Red:239 Green:152 Blue:170]];
 [tempMutableArray addObject:[[Color alloc] initWithColorName:@"Melon" HexCode:@"#FDBCB4" Red:253 Green:188 Blue:180]];
 [tempMutableArray addObject:[[Color alloc] initWithColorName:@"Midnight Blue" HexCode:@"#1A4876" Red:26 Green:72 Blue:118]];
 [tempMutableArray addObject:[[Color alloc] initWithColorName:@"Mountain Meadow" HexCode:@"#30BA8F" Red:48 Green:186 Blue:143]];
 [tempMutableArray addObject:[[Color alloc] initWithColorName:@"Mulberry" HexCode:@"#C54B8C" Red:197 Green:75 Blue:140]];
 [tempMutableArray addObject:[[Color alloc] initWithColorName:@"Navy Blue" HexCode:@"#1974D2" Red:25 Green:116 Blue:210]];
 [tempMutableArray addObject:[[Color alloc] initWithColorName:@"Neon Carrot" HexCode:@"#FFA343" Red:255 Green:163 Blue:67]];
 [tempMutableArray addObject:[[Color alloc] initWithColorName:@"Olive Green" HexCode:@"#BAB86C" Red:186 Green:184 Blue:108]];
 [tempMutableArray addObject:[[Color alloc] initWithColorName:@"Orange" HexCode:@"#FF7538" Red:255 Green:117 Blue:56]];
 [tempMutableArray addObject:[[Color alloc] initWithColorName:@"Orange Red" HexCode:@"#FF2B2B" Red:255 Green:43 Blue:43]];
 [tempMutableArray addObject:[[Color alloc] initWithColorName:@"Orange Yellow" HexCode:@"#F8D568" Red:248 Green:213 Blue:104]];
 [tempMutableArray addObject:[[Color alloc] initWithColorName:@"Orchid" HexCode:@"#E6A8D7" Red:230 Green:168 Blue:215]];
 [tempMutableArray addObject:[[Color alloc] initWithColorName:@"Outer Space" HexCode:@"#414A4C" Red:65 Green:74 Blue:76]];
 [tempMutableArray addObject:[[Color alloc] initWithColorName:@"Outrageous Orange" HexCode:@"#FF6E4A" Red:255 Green:110 Blue:74]];
 [tempMutableArray addObject:[[Color alloc] initWithColorName:@"Pacific Blue" HexCode:@"#1CA9C9" Red:28 Green:169 Blue:201]];
 [tempMutableArray addObject:[[Color alloc] initWithColorName:@"Peach" HexCode:@"#FFCFAB" Red:255 Green:207 Blue:171]];
 [tempMutableArray addObject:[[Color alloc] initWithColorName:@"Periwinkle" HexCode:@"#C5D0E6" Red:197 Green:208 Blue:230]];
 [tempMutableArray addObject:[[Color alloc] initWithColorName:@"Piggy Pink" HexCode:@"#FDDDE6" Red:253 Green:221 Blue:230]];
 [tempMutableArray addObject:[[Color alloc] initWithColorName:@"Pine Green" HexCode:@"#158078" Red:21 Green:128 Blue:120]];
 [tempMutableArray addObject:[[Color alloc] initWithColorName:@"Pink Flamingo" HexCode:@"#FC74FD" Red:252 Green:116 Blue:253]];
 [tempMutableArray addObject:[[Color alloc] initWithColorName:@"Pink Sherbert" HexCode:@"#F78FA7" Red:247 Green:143 Blue:167]];
 [tempMutableArray addObject:[[Color alloc] initWithColorName:@"Plum" HexCode:@"#8E4585" Red:142 Green:69 Blue:133]];
 [tempMutableArray addObject:[[Color alloc] initWithColorName:@"Purple Heart" HexCode:@"#7442C8" Red:116 Green:66 Blue:200]];
 [tempMutableArray addObject:[[Color alloc] initWithColorName:@"Purple Mountain's Majesty" HexCode:@"#9D81BA" Red:157 Green:129 Blue:186]];
 [tempMutableArray addObject:[[Color alloc] initWithColorName:@"Purple Pizzazz" HexCode:@"#FE4EDA" Red:254 Green:78 Blue:218]];
 [tempMutableArray addObject:[[Color alloc] initWithColorName:@"Radical Red" HexCode:@"#FF496C" Red:255 Green:73 Blue:108]];
 [tempMutableArray addObject:[[Color alloc] initWithColorName:@"Raw Sienna" HexCode:@"#D68A59" Red:214 Green:138 Blue:89]];
 [tempMutableArray addObject:[[Color alloc] initWithColorName:@"Raw Umber" HexCode:@"#714B23" Red:113 Green:75 Blue:35]];
 [tempMutableArray addObject:[[Color alloc] initWithColorName:@"Razzle Dazzle Rose" HexCode:@"#FF48D0" Red:255 Green:72 Blue:208]];
 [tempMutableArray addObject:[[Color alloc] initWithColorName:@"Razzmatazz" HexCode:@"#E3256B" Red:227 Green:37 Blue:107]];
 [tempMutableArray addObject:[[Color alloc] initWithColorName:@"Red" HexCode:@"#EE204D" Red:238 Green:32 Blue:77]];
 [tempMutableArray addObject:[[Color alloc] initWithColorName:@"Red Orange" HexCode:@"#FF5349" Red:255 Green:83 Blue:73]];
 [tempMutableArray addObject:[[Color alloc] initWithColorName:@"Red Violet" HexCode:@"#C0448F" Red:192 Green:68 Blue:143]];
 [tempMutableArray addObject:[[Color alloc] initWithColorName:@"Robin's Egg Blue" HexCode:@"#1FCECB" Red:31 Green:206 Blue:203]];
 [tempMutableArray addObject:[[Color alloc] initWithColorName:@"Royal Purple" HexCode:@"#7851A9" Red:120 Green:81 Blue:169]];
 [tempMutableArray addObject:[[Color alloc] initWithColorName:@"Salmon" HexCode:@"#FF9BAA" Red:255 Green:155 Blue:170]];
 [tempMutableArray addObject:[[Color alloc] initWithColorName:@"Scarlet" HexCode:@"#FC2847" Red:252 Green:40 Blue:71]];
 [tempMutableArray addObject:[[Color alloc] initWithColorName:@"Screamin' Green" HexCode:@"#76FF7A" Red:118 Green:255 Blue:122]];
 [tempMutableArray addObject:[[Color alloc] initWithColorName:@"Sea Green" HexCode:@"#9FE2BF" Red:159 Green:226 Blue:191]];
 [tempMutableArray addObject:[[Color alloc] initWithColorName:@"Sepia" HexCode:@"#A5694F" Red:165 Green:105 Blue:79]];
 [tempMutableArray addObject:[[Color alloc] initWithColorName:@"Shadow" HexCode:@"#8A795D" Red:138 Green:121 Blue:93]];
 [tempMutableArray addObject:[[Color alloc] initWithColorName:@"Shamrock" HexCode:@"#45CEA2" Red:69 Green:206 Blue:162]];
 [tempMutableArray addObject:[[Color alloc] initWithColorName:@"Shocking Pink" HexCode:@"#FB7EFD" Red:251 Green:126 Blue:253]];
 [tempMutableArray addObject:[[Color alloc] initWithColorName:@"Silver" HexCode:@"#CDC5C2" Red:205 Green:197 Blue:194]];
 [tempMutableArray addObject:[[Color alloc] initWithColorName:@"Sky Blue" HexCode:@"#80DAEB" Red:128 Green:218 Blue:235]];
 [tempMutableArray addObject:[[Color alloc] initWithColorName:@"Spring Green" HexCode:@"#ECEABE" Red:236 Green:234 Blue:190]];
 [tempMutableArray addObject:[[Color alloc] initWithColorName:@"Sunglow" HexCode:@"#FFCF48" Red:255 Green:207 Blue:72]];
 [tempMutableArray addObject:[[Color alloc] initWithColorName:@"Sunset Orange" HexCode:@"#FD5E53" Red:253 Green:94 Blue:83]];
 [tempMutableArray addObject:[[Color alloc] initWithColorName:@"Tan" HexCode:@"#FAA76C" Red:250 Green:167 Blue:108]];
 [tempMutableArray addObject:[[Color alloc] initWithColorName:@"Teal Blue" HexCode:@"#18A7B5" Red:24 Green:167 Blue:181]];
 [tempMutableArray addObject:[[Color alloc] initWithColorName:@"Thistle" HexCode:@"#EBC7DF" Red:235 Green:199 Blue:223]];
 [tempMutableArray addObject:[[Color alloc] initWithColorName:@"Tickle Me Pink" HexCode:@"#FC89AC" Red:252 Green:137 Blue:172]];
 [tempMutableArray addObject:[[Color alloc] initWithColorName:@"Timberwolf" HexCode:@"#DBD7D2" Red:219 Green:215 Blue:210]];
 [tempMutableArray addObject:[[Color alloc] initWithColorName:@"Tropical Rain Forest" HexCode:@"#17806D" Red:23 Green:128 Blue:109]];
 [tempMutableArray addObject:[[Color alloc] initWithColorName:@"Tumbleweed" HexCode:@"#DEAA88" Red:222 Green:170 Blue:136]];
 [tempMutableArray addObject:[[Color alloc] initWithColorName:@"Turquoise Blue" HexCode:@"#77DDE7" Red:119 Green:221 Blue:231]];
 [tempMutableArray addObject:[[Color alloc] initWithColorName:@"Unmellow Yellow" HexCode:@"#FFFF66" Red:255 Green:255 Blue:102]];
 [tempMutableArray addObject:[[Color alloc] initWithColorName:@"Violet Purple)" HexCode:@"#926EAE" Red:146 Green:110 Blue:174]];
 [tempMutableArray addObject:[[Color alloc] initWithColorName:@"Violet Blue" HexCode:@"#324AB2" Red:50 Green:74 Blue:178]];
 [tempMutableArray addObject:[[Color alloc] initWithColorName:@"Violet Red" HexCode:@"#F75394" Red:247 Green:83 Blue:148]];
 [tempMutableArray addObject:[[Color alloc] initWithColorName:@"Vivid Tangerine" HexCode:@"#FFA089" Red:255 Green:160 Blue:137]];
 [tempMutableArray addObject:[[Color alloc] initWithColorName:@"Vivid Violet" HexCode:@"#8F509D" Red:143 Green:80 Blue:157]];
 [tempMutableArray addObject:[[Color alloc] initWithColorName:@"White" HexCode:@"#FFFFFF" Red:255 Green:255 Blue:255]];
 [tempMutableArray addObject:[[Color alloc] initWithColorName:@"Wild Blue Yonder" HexCode:@"#A2ADD0" Red:162 Green:173 Blue:208]];
 [tempMutableArray addObject:[[Color alloc] initWithColorName:@"Wild Strawberry" HexCode:@"#FF43A4" Red:255 Green:67 Blue:164]];
 [tempMutableArray addObject:[[Color alloc] initWithColorName:@"Wild Watermelon" HexCode:@"#FC6C85" Red:252 Green:108 Blue:133]];
 [tempMutableArray addObject:[[Color alloc] initWithColorName:@"Wisteria" HexCode:@"#CDA4DE" Red:205 Green:164 Blue:222]];
 [tempMutableArray addObject:[[Color alloc] initWithColorName:@"Yellow" HexCode:@"#FCE883" Red:252 Green:232 Blue:131]];
 [tempMutableArray addObject:[[Color alloc] initWithColorName:@"Yellow Green" HexCode:@"#C5E384" Red:197 Green:227 Blue:132]];
 [tempMutableArray addObject:[[Color alloc] initWithColorName:@"Yellow Orange" HexCode:@"#FFAE42" Red:255 Green:174 Blue:66]];

 + (NSC*) BLUE {	static NSC*  BLUE = nil;	if( BLUE == nil )
 BLUE = [NSC colorWithDeviceRed:0.253 green:0.478 blue:0.761 alpha:1.000];
 return BLUE;
 }
 + (NSC*) ORANGE {	static NSC*  ORANGE = nil;	if( ORANGE == nil )
 ORANGE = [NSC colorWithDeviceRed:0.864 green:0.498 blue:0.191 alpha:1.000];
 return ORANGE;
 }
 + (NSC*) RANDOM {
 NSC*  RANDOM = nil;
 if( RANDOM == nil )
 }
 
 
 */


//#import <AIUtilities/AIUtilities.h>

//SYNTHESIZE_ASC_OBJ_BLOCKOBJ(name, setName,
//	^id(id bSelf, id o){ return o = o ? o : [bSelf nameOfColor]; },// [(NSC*)bSelf setName:z]; return z;}(); },
//	^id(id x,id z){ return z; });
//- (NSS*) name {	NSS* name = objc_getAssociatedObject(self,_cmd);	  if (name == nil) { [(NSC*)self setName:name = [self nameOfColor]]; }	return name;}
//- (void)setName:(NSString *)name {	NSAssert([name ISKINDA:NSS.class], @"name must be string");	objc_setAssociatedObject(self,@selector(name), name, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
//}

//+ (NSA*) colorNames {	if (!colorsFromStruct) {		colorsFromStruct = NSMD.new;	NSInteger count = 0;
//	while( count++ < 149 )
//			[colorsFromStruct setValue:ColorWithUnsignedLong(sColorTable[count].value, NO) forKey:$UTF8(sColorTable[count].name)];
////			addObject: [NSString stringWithFormat: @"%f", c_array[count]]];
////		stringFromArray = [array componentsJoinedByString:@","];
////		[array release];
//	}
//	return colorsFromStruct.allKeys;
//}
//- (NSC*)coloratPercent:(float)percent betweenColor:(NSC*)one andColor:(NSC*)two


//two parts of a single path:
//	defaultRGBTxtLocation1/VERSION/defaultRGBTxtLocation2
//static NSS *defaultRGBTxtLocation1 = @"/usr/share/emacs";
//static NSS *defaultRGBTxtLocation2 = @"etc/rgb.txt";
//#ifdef DEBUG_BUILD
//#define COLOR_DEBUG TRUE
//#else
//#define COLOR_DEBUG FALSE
//#endif
//@implementation NSDictionary (AIColorAdditions_RGBTxtFiles)
//see /usr/share/emacs/(some version)/etc/rgb.txt for an example of such a file.
//the pathname does not need to end in 'rgb.txt', but it must be a file in UTF-8 encoding.
//the keys are colour names (all converted to lowercase); the values are RGB NSColors.
/**+ (id)dictionaryWithContentsOfRGBTxtFile:(NSS*) path
 {
 NSMutableData *data = [NSMutableData dataWithContentsOfFile:path];
 if (!data) return nil;
 char *ch = [data mutableBytes]; //we use mutable bytes because we want to tokenise the string by replacing separators with '\0'.
 NSUInteger length = [data length];
 struct {
 const char *redStart, *greenStart, *blueStart, *nameStart;
 const char *redEnd,   *greenEnd,   *blueEnd;
 float red, green, blue;
 unsigned reserved: 23;
 unsigned inComment: 1;
 char prevChar;
 } state = {
 .prevChar = '\n',
 .redStart = NULL, .greenStart = NULL, .blueStart = NULL, .nameStart = NULL,
 .inComment = NO,
 };
 NSDictionary *result = nil;
 //the rgb.txt file that comes with Mac OS X 10.3.8 contains 752 entries.
 //we create 3 autoreleased objects for each one.
 //best to not pollute our caller's autorelease pool.
 NSMutableDictionary *mutableDict = [NSMutableDictionary dictionary];
 for (unsigned i = 0; i < length; ++i) {
 if (state.inComment) {
 if (ch[i] == '\n') state.inComment = NO;
 } else if (ch[i] == '\n') {
 if (state.prevChar != '\n') { //ignore blank lines
 if (	! ((state.redStart   != NULL)
 && (state.greenStart != NULL)
 && (state.blueStart  != NULL)
 && (state.nameStart  != NULL)))
 {
 #if COLOR_DEBUG
 NSLog(@"Parse error reading rgb.txt file: a non-comment line was encountered that did not have all four of red (%p), green (%p), blue (%p), and name (%p) - index is %u",
 state.redStart,
 state.greenStart,
 state.blueStart,
 state.nameStart, i);
 #endif
 goto end;
 }
 NSRange range = {
 .location = state.nameStart - ch,
 .length   = (&ch[i]) - state.nameStart,
 };
 NSS *name = [NSString stringWithData:[data subdataWithRange:range] encoding:NSUTF8StringEncoding];
 NSC*color = [NSColor colorWithCalibratedRed:state.red
 green:state.green
 blue:state.blue
 alpha:1.0f];
 [mutableDict setObject:color forKey:name];
 NSS *lowercaseName = [name lowercaseString];
 if (![mutableDict objectForKey:lowercaseName]) {
 //only add the lowercase version if it isn't already defined
 [mutableDict setObject:color forKey:lowercaseName];
 }
 state.redStart = state.greenStart = state.blueStart = state.nameStart =
 state.redEnd   = state.greenEnd   = state.blueEnd   = NULL;
 } //if (prevChar != '\n')
 } else if ((ch[i] != ' ') && (ch[i] != '\t')) {
 if (state.prevChar == '\n' && ch[i] == '#') {
 state.inComment = YES;
 } else {
 if (!state.redStart) {
 state.redStart = &ch[i];
 state.red = (float)(strtod(state.redStart, (char **)&state.redEnd) / 255.0f);
 } else if ((!state.greenStart) && state.redEnd && (&ch[i] >= state.redEnd)) {
 state.greenStart = &ch[i];
 state.green = (float)(strtod(state.greenStart, (char **)&state.greenEnd) / 255.0f);
 } else if ((!state.blueStart) && state.greenEnd && (&ch[i] >= state.greenEnd)) {
 state.blueStart = &ch[i];
 state.blue = (float)(strtod(state.blueStart, (char **)&state.blueEnd) / 255.0f);
 } else if ((!state.nameStart) && state.blueEnd && (&ch[i] >= state.blueEnd)) {
 state.nameStart  = &ch[i];
 }
 }
 }
 state.prevChar = ch[i];
 } //for (unsigned i = 0; i < length; ++i)
 //why not use -copy? because this is subclass-friendly.
 //you can call this method on NSMutableDictionary and get a mutable dictionary back.
 result = [[self alloc] initWithDictionary:mutableDict];
 end:
 return result;
 }//@end
 
		*/

