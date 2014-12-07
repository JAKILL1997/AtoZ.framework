/* Erica Sadun, http://ericasadun.com iPhone Developer's Cookbook, 3.0 Edition BSD License, Use at your own risk	*/
//#import <objc/objc-runtime.h>
//#import <objc/objc-class.h>
#import "AtoZ.h"
#import "NSObject-Utilities.h"

@implementation NSInvocation(OCMAdditions)
-   (id)        getArgumentAtIndexAsObject:(int)x {

	const char* argType = [[self methodSignature] getArgumentTypeAtIndex:x];
	while(strchr("rnNoORV", argType[0]) != NULL)
		argType += 1;

	if((strlen(argType) > 1) && (strchr("{^", argType[0]) == NULL) && (strcmp("@?", argType) != 0))
		[NSException raise:NSInvalidArgumentException format:@"Cannot handle argument type '%s'.", argType];

	switch (argType[0])
	{
		case '#':
		case '@':
		{
			id value;
			[self getArgument:&value atIndex:x];
			return value;
		}
		case ':':
		{
			SEL s = (SEL)0;
			[self getArgument:&s atIndex:x];
			id value = NSStringFromSelector(s);
			return value;
		}
		case 'i':
		{
			int value;
			[self getArgument:&value atIndex:x];
			return [NSNumber numberWithInt:value];
		}
		case 's':
		{
			short value;
			[self getArgument:&value atIndex:x];
			return [NSNumber numberWithShort:value];
		}
		case 'l':
		{
			long value;
			[self getArgument:&value atIndex:x];
			return [NSNumber numberWithLong:value];
		}
		case 'q':
		{
			long long value;
			[self getArgument:&value atIndex:x];
			return [NSNumber numberWithLongLong:value];
		}
		case 'c':
		{
			char value;
			[self getArgument:&value atIndex:x];
			return [NSNumber numberWithChar:value];
		}
		case 'C':
		{
			unsigned char value;
			[self getArgument:&value atIndex:x];
			return [NSNumber numberWithUnsignedChar:value];
		}
		case 'I':
		{
			unsigned int value;
			[self getArgument:&value atIndex:x];
			return [NSNumber numberWithUnsignedInt:value];
		}
		case 'S':
		{
			unsigned short value;
			[self getArgument:&value atIndex:x];
			return [NSNumber numberWithUnsignedShort:value];
		}
		case 'L':
		{
			unsigned long value;
			[self getArgument:&value atIndex:x];
			return [NSNumber numberWithUnsignedLong:value];
		}
		case 'Q':
		{
			unsigned long long value;
			[self getArgument:&value atIndex:x];
			return [NSNumber numberWithUnsignedLongLong:value];
		}
		case 'f':
		{
			float value;
			[self getArgument:&value atIndex:x];
			return [NSNumber numberWithFloat:value];
		}
		case 'd':
		{
			double value;
			[self getArgument:&value atIndex:x];
			return [NSNumber numberWithDouble:value];
		}
		case 'B':
		{
			bool value;
			[self getArgument:&value atIndex:x];
			return [NSNumber numberWithBool:value];
		}
		case '^':
        {
            void *value = NULL;
            [self getArgument:&value atIndex:x];
            return [NSValue valueWithPointer:value];
        }
		case '{': // structure
		{
			NSUInteger maxArgSize = [[self methodSignature] frameLength];
			NSMutableData *argumentData = [NSMutableData.alloc initWithLength:maxArgSize];
			[self getArgument:[argumentData mutableBytes] atIndex:x];
			return [NSValue valueWithBytes:[argumentData bytes] objCType:argType];
		}

	}
	[NSException raise:NSInvalidArgumentException format:@"Argument type '%s' not supported", argType];
	return nil;
}
- (NSS*)             invocationDescription               {
	NSMethodSignature *methodSignature = [self methodSignature];
	NSUInteger numberOfArgs = [methodSignature numberOfArguments];

	if (numberOfArgs == 2)
		return NSStringFromSelector([self selector]);

	NSArray *selectorParts = [NSStringFromSelector([self selector]) componentsSeparatedByString:@":"];
	NSMutableString *description = NSMutableString.new;
	unsigned int i;
	for(i = 2; i < numberOfArgs; i++)
	{
		[description appendFormat:@"%@%@:", (i > 2 ? @" " : @""), [selectorParts objectAtIndex:(i - 2)]];
		[description appendString:[self argumentDescriptionAtIndex:i]];
	}

	return description;
}
- (NSS*)        argumentDescriptionAtIndex:(int)x {
	const char *argType = [[self methodSignature] getArgumentTypeAtIndex:x];
	if(strchr("rnNoORV", argType[0]) != NULL)
		argType += 1;

	switch(*argType)
	{
		case '@':	return [self objectDescriptionAtIndex:x];
		case 'c':	return [self charDescriptionAtIndex:x];
		case 'C':	return [self unsignedCharDescriptionAtIndex:x];
		case 'i':	return [self intDescriptionAtIndex:x];
		case 'I':	return [self unsignedIntDescriptionAtIndex:x];
		case 's':	return [self shortDescriptionAtIndex:x];
		case 'S':	return [self unsignedShortDescriptionAtIndex:x];
		case 'l':	return [self longDescriptionAtIndex:x];
		case 'L':	return [self unsignedLongDescriptionAtIndex:x];
		case 'q':	return [self longLongDescriptionAtIndex:x];
		case 'Q':	return [self unsignedLongLongDescriptionAtIndex:x];
		case 'd':	return [self doubleDescriptionAtIndex:x];
		case 'f':	return [self floatDescriptionAtIndex:x];
		// Why does this throw EXC_BAD_ACCESS when appending the string?
		//	case NSObjCStructType: return [self structDescriptionAtIndex:index];
		case '^':	return [self pointerDescriptionAtIndex:x];
		case '*':	return [self cStringDescriptionAtIndex:x];
		case ':':	return [self selectorDescriptionAtIndex:x];
		default:	return [@"<??" stringByAppendingString:@">"];  // avoid confusion with trigraphs...
	}

}
- (NSS*)          objectDescriptionAtIndex:(int)x    {
	id object;

	[self getArgument:&object atIndex:x];
	if (object == nil)
		return @"nil";
	else if(![object isProxy] && [object isKindOfClass:NSString.class])
		return [NSString stringWithFormat:@"@\"%@\"", [object description]];
	else
		return [object description];
}
- (NSS*)            charDescriptionAtIndex:(int)x    {
	unsigned char buffer[128];
	memset(buffer, 0x0, 128);

	[self getArgument:&buffer atIndex:x];

	// If there's only one character in the buffer, and it's 0 or 1, then we have a BOOL
	if (buffer[1] == '\0' && (buffer[0] == 0 || buffer[0] == 1))
		return [NSString stringWithFormat:@"%@", (buffer[0] == 1 ? @"YES" : @"NO")];
	else
		return [NSString stringWithFormat:@"'%c'", *buffer];
}
- (NSS*)    unsignedCharDescriptionAtIndex:(int)x    {
	unsigned char buffer[128];
	memset(buffer, 0x0, 128);

	[self getArgument:&buffer atIndex:x];
	return [NSString stringWithFormat:@"'%c'", *buffer];
}
- (NSS*)             intDescriptionAtIndex:(int)x    {
	int intValue;

	[self getArgument:&intValue atIndex:x];
	return [NSString stringWithFormat:@"%d", intValue];
}
- (NSS*)     unsignedIntDescriptionAtIndex:(int)x    {
	unsigned int intValue;

	[self getArgument:&intValue atIndex:x];
	return [NSString stringWithFormat:@"%d", intValue];
}
- (NSS*)           shortDescriptionAtIndex:(int)x    {
	short shortValue;

	[self getArgument:&shortValue atIndex:x];
	return [NSString stringWithFormat:@"%hi", shortValue];
}
- (NSS*)   unsignedShortDescriptionAtIndex:(int)x    {
	unsigned short shortValue;

	[self getArgument:&shortValue atIndex:x];
	return [NSString stringWithFormat:@"%hu", shortValue];
}
- (NSS*)            longDescriptionAtIndex:(int)x    {
	long longValue;

	[self getArgument:&longValue atIndex:x];
	return [NSString stringWithFormat:@"%ld", longValue];
}
- (NSS*)    unsignedLongDescriptionAtIndex:(int)x    {
	unsigned long longValue;

	[self getArgument:&longValue atIndex:x];
	return [NSString stringWithFormat:@"%lu", longValue];
}
- (NSS*)        longLongDescriptionAtIndex:(int)x    {
	long long longLongValue;

	[self getArgument:&longLongValue atIndex:x];
	return [NSString stringWithFormat:@"%qi", longLongValue];
}
- (NSS*)unsignedLongLongDescriptionAtIndex:(int)x   {
	unsigned long long longLongValue;

	[self getArgument:&longLongValue atIndex:x];
	return [NSString stringWithFormat:@"%qu", longLongValue];
}
- (NSS*)          doubleDescriptionAtIndex:(int)x    {
	double doubleValue;

	[self getArgument:&doubleValue atIndex:x];
	return [NSString stringWithFormat:@"%f", doubleValue];
}
- (NSS*)           floatDescriptionAtIndex:(int)x    {
	float floatValue;

	[self getArgument:&floatValue atIndex:x];
	return [NSString stringWithFormat:@"%f", floatValue];
}
- (NSS*)          structDescriptionAtIndex:(int)x    {
	void *buffer;

	[self getArgument:&buffer atIndex:x];
	return [NSString stringWithFormat:@":(struct)%p", buffer];
}
- (NSS*)         pointerDescriptionAtIndex:(int)x    {
	void *buffer;

	[self getArgument:&buffer atIndex:x];
	return [NSString stringWithFormat:@"%p", buffer];
}
- (NSS*)         cStringDescriptionAtIndex:(int)x    {
	char buffer[128];

	memset(buffer, 0x0, 128);

	[self getArgument:&buffer atIndex:x];
	return [NSString stringWithFormat:@"\"%s\"", buffer];
}
- (NSS*)        selectorDescriptionAtIndex:(int)x    {
	SEL selectorValue;

	[self getArgument:&selectorValue atIndex:x];
	return [NSString stringWithFormat:@"@selector(%@)", NSStringFromSelector(selectorValue)];
}

@end

@implementation AZInvocationGrabber

-									(id) initWithTarget:(id)target						{ _target = target;													return self;	}
- (NSMethodSignature*) methodSignatureForSelector:(SEL)sel	{ return   [self.target methodSignatureForSelector:sel];	}
-               (void) forwardInvocation:(NSInvocation*)inv {	[inv setTarget:self.target];    self.invocation = inv;	}
@end
@implementation NSInvocation (jr_block)

+ (NSInvocation *)createInvocationOnTarget:(id)target selector:(SEL)selector {
	return [self createInvocationOnTarget:target selector:selector withArguments:nil];	}
 
+ (NSInvocation *)createInvocationOnTarget:(id)target selector:(SEL)selector withArguments:(id)arg1, ... {

	NSMethodSignature *sig						= [target methodSignatureForSelector:selector];
	__block NSInvocation *invocation 	= [NSInvocation invocationWithMethodSignature:sig];
 	invocation.target									= target;
	invocation.selector								= selector;

 	if(arg1) { __block int ct = 2;

		AZVA_Block b = ^(id obj){ [invocation setArgument:&obj atIndex:ct]; NSLog(@"%i: %@", ct, invocation.invocationDescription);	ct++;	};
		azva_iterate_list(arg1, b);
	}
	return [invocation copy];
}
+ (id)invocationWithTarget:(id)target block:(void(^)(id target))block {

    AZInvocationGrabber *grabber = [AZInvocationGrabber.alloc initWithTarget:target];
    block(grabber);    return grabber.invocation;
}
@end

/**		[invocation setArgument:&arg1 atIndex:2];
		va_list args;		va_start(args, arg1);
		NSLog(@"Finished: %@", invocation.invocationDescription);
 		id obj;		int ct = 3;	while( (obj = va_arg(args, id)) != nil ) {
 		while( obj = va_arg(args, id)  { NSLog(@"%@", obj);	[invocation setArgument:&obj atIndex:ct];  ct++;  }
 		va_end(args);  NSLog(@"made invocation: %@", invocation.invocationDescription);	*/

@implementation NSObject (Utilities)

- (NSA*) superclassesAsStrings {  return [[self.superclasses map:^id(id obj) { return NSStringFromClass(obj); }] arrayWithoutStringContaining:@"NSObject"]; }
- (NSA*) superclasses { // Return an array of an object's superclasses

	Class cl = self.class; NSMutableArray *results = @[cl].mutableCopy;
	do {	cl = cl.superclass; [results addObject:cl]; }	while (![cl isEqual:NSObject.class]);
	return results;
}
// Return an invocation based on a selector and variadic arguments
- (NSInvocation *) invocationWithSelector: (SEL) selector andArguments:(va_list) arguments  {
	if (![self respondsToSelector:selector]) return NULL;
	
	NSMethodSignature *ms = [self methodSignatureForSelector:selector];
	if (!ms) return NULL;
	
	NSInvocation *inv = [NSInvocation invocationWithMethodSignature:ms];
	if (!inv) return NULL;
	
	[inv setTarget:self];
	[inv setSelector:selector];
	
	int argcount = 2;
	int totalArgs = [ms numberOfArguments];
	
	while (argcount < totalArgs)
	{
		char *argtype = (char *)[ms getArgumentTypeAtIndex:argcount];
		// printf("[%s] %d of %d\n", [NSStringFromSelector(selector) UTF8String], argcount, totalArgs); // debug
		if (strcmp(argtype, @encode(id)) == 0)
		{
			id argument = va_arg(arguments, id);
			[inv setArgument:&argument atIndex:argcount++];
		}
		else if (
				 (strcmp(argtype, @encode(char)) == 0) ||
				 (strcmp(argtype, @encode(unsigned char)) == 0) ||
				 (strcmp(argtype, @encode(short)) == 0) ||
				 (strcmp(argtype, @encode(unsigned short)) == 0) |
				 (strcmp(argtype, @encode(int)) == 0) ||
				 (strcmp(argtype, @encode(unsigned int)) == 0)
				 )
		{
			int i = va_arg(arguments, int);
			[inv setArgument:&i atIndex:argcount++];
		}
		else if (
				 (strcmp(argtype, @encode(long)) == 0) ||
				 (strcmp(argtype, @encode(unsigned long)) == 0)
				 )
		{
			long l = va_arg(arguments, long);
			[inv setArgument:&l atIndex:argcount++];
		}
		else if (
				 (strcmp(argtype, @encode(long long)) == 0) ||
				 (strcmp(argtype, @encode(unsigned long long)) == 0)
				 )
		{
			long long l = va_arg(arguments, long long);
			[inv setArgument:&l atIndex:argcount++];
		}
		else if (
				 (strcmp(argtype, @encode(float)) == 0) ||
				 (strcmp(argtype, @encode(double)) == 0)
				 )
		{
			double d = va_arg(arguments, double);
			[inv setArgument:&d atIndex:argcount++];
		}
		else if (strcmp(argtype, @encode(Class)) == 0)
		{
			Class c = va_arg(arguments, Class);
			[inv setArgument:&c atIndex:argcount++];
		}
		else if (strcmp(argtype, @encode(SEL)) == 0)
		{
			SEL s = va_arg(arguments, SEL);
			[inv setArgument:&s atIndex:argcount++];
		}
		else if (strcmp(argtype, @encode(char *)) == 0)
		{
			char *s = va_arg(arguments, char *);
			[inv setArgument:s atIndex:argcount++];
		}		
		else
		{
			NSString *type = @(argtype);
			if ([type isEqualToString:@"{CGRect={CGPoint=ff}{CGSize=ff}}"])
			{
				CGRect arect = va_arg(arguments, CGRect);
				[inv setArgument:&arect atIndex:argcount++];
			}
			else if ([type isEqualToString:@"{CGPoint=ff}"])
			{
				CGPoint apoint = va_arg(arguments, CGPoint);
				[inv setArgument:&apoint atIndex:argcount++];
			}
			else if ([type isEqualToString:@"{CGSize=ff}"])
			{
				CGSize asize = va_arg(arguments, CGSize);
				[inv setArgument:&asize atIndex:argcount++];
			}
			else
			{
				// assume its a pointer and punt
				NSLog(@"%@", type);
				void *ptr = va_arg(arguments, void *);
				[inv setArgument:ptr atIndex:argcount++];
			}
		}
	}
	
	if (argcount != totalArgs) 
	{
		printf("Invocation argument count mismatch: %ld expected, %d sent\n", [ms numberOfArguments], argcount);
		return NULL;
	}
	
	return inv;
}
// Return an invocation with the given arguments
- (NSInvocation *) invocationWithSelectorAndArguments: (SEL) selector, ...  {
	va_list arglist;
	va_start(arglist, selector);
	NSInvocation *inv = [self invocationWithSelector:selector andArguments:arglist];
	va_end(arglist);
	return inv;	
}

// Peform the selector using va_list arguments
- (BOOL) performSelector: (SEL) selector withReturnValue: (void *) result andArguments: (va_list) arglist {
	NSInvocation *inv = [self invocationWithSelector:selector andArguments:arglist];
	if (!inv) return NO;
	[inv invoke];
	if (result) [inv getReturnValue:result];
	return YES;	
}
// Perform a selector with an arbitrary number of arguments
// Thanks to Kevin Ballard for assist!
- (BOOL) performSelector: (SEL) selector withReturnValueAndArguments: (void *) result, ...  {
	va_list arglist;
	va_start(arglist, result);
	NSInvocation *inv = [self invocationWithSelector:selector andArguments:arglist];
	if (!inv) return NO;
	[inv invoke];
	if (result) [inv getReturnValue:result];
	va_end(arglist);
	return YES;		
}
// Returning objects by performing selectors
- (id) objectByPerformingSelectorWithArguments: (SEL) selector, ... {
	id result;
	va_list arglist;
	va_start(arglist, selector);
	[self performSelector:selector withReturnValue:&result andArguments:arglist];
	va_end(arglist);
	
	CFShow((__bridge CFTypeRef)(result));
	return result;
}
- (id) objectByPerformingSelector:(SEL)selector withObject:(id) object1 withObject: (id) object2  {
	if (![self respondsToSelector:selector]) return nil;
	
	// Retrieve method signature and return type
	NSMethodSignature *ms = [self methodSignatureForSelector:selector];
	const char *returnType = [ms methodReturnType];
	
	// Create invocation using method signature and invoke it
	NSInvocation *inv = [NSInvocation invocationWithMethodSignature:ms];
	[inv setTarget:self];
	[inv setSelector:selector];
	if (object1) [inv setArgument:&object1 atIndex:2];
	if (object2) [inv setArgument:&object2 atIndex:3];
	[inv invoke];
	
	// return object
	if (strcmp(returnType, @encode(id)) == 0)
	{
		id riz = nil;
		[inv getReturnValue:&riz];
		return riz;
	}
	
	// return double
	if ((strcmp(returnType, @encode(float)) == 0) ||
		(strcmp(returnType, @encode(double)) == 0))
	{
		double f;
		[inv getReturnValue:&f];
		return @(f);
	}
	
	// return NSNumber version of byte. Use valueBy version for recovering chars
	if ((strcmp(returnType, @encode(char)) == 0) ||
		(strcmp(returnType, @encode(unsigned char)) == 0))
	{
		unsigned char c;
		[inv getReturnValue:&c];
		return [NSNumber numberWithInt:(unsigned int)c];
	}
	
	// return c-string
	if (strcmp(returnType, @encode (char*)) == 0)
	{
		char *s = NULL;
		[inv getReturnValue:s];
		return @(s);
	}
	
	// return integer
	long l;
	[inv getReturnValue:&l];
	return @(l);
}
- (id) objectByPerformingSelector:(SEL)selector withObject:(id) object1 {
	return [self objectByPerformingSelector:selector withObject:object1 withObject:nil];
}
- (id) objectByPerformingSelector:(SEL)selector {
	return [self objectByPerformingSelector:selector withObject:nil withObject:nil];
}
// Delayed selectors
- (void) performSelector: (SEL) selector withCPointer: (void *) cPointer afterDelay: (NSTimeInterval) delay {
	NSMethodSignature *ms = [self methodSignatureForSelector:selector];
	NSInvocation *inv = [NSInvocation invocationWithMethodSignature:ms];
	[inv setTarget:self];
	[inv setSelector:selector];
	[inv setArgument:cPointer atIndex:2];
	[inv performSelector:@selector(invoke) withObject:nil afterDelay:delay];
}
- (void) performSelector: (SEL) selector withBool: (BOOL) boolValue afterDelay: (NSTimeInterval) delay  {
	[self performSelector:selector withCPointer:&boolValue afterDelay:delay];
}
- (void) performSelector: (SEL) selector withInt: (int) intValue afterDelay: (NSTimeInterval) delay {
	[self performSelector:selector withCPointer:&intValue afterDelay:delay];
}
- (void) performSelector: (SEL) selector withFloat: (float) floatValue afterDelay: (NSTimeInterval) delay {
	[self performSelector:selector withCPointer:&floatValue afterDelay:delay];
}
- (void) performSelector: (SEL) selector afterDelay: (NSTimeInterval) delay {
	[self performSelector:selector withObject:nil afterDelay: delay];
}
// private. only sent to an invocation
- (void) getReturnValue: (void *) result  {
	NSInvocation *inv = (NSInvocation *) self;
	[inv invoke];
	if (result) [inv getReturnValue:result];
}
// Delayed selector
- (void) performSelector: (SEL) selector withDelayAndArguments: (NSTimeInterval) delay,...  {
	va_list arglist;
	va_start(arglist, delay);
	NSInvocation *inv = [self invocationWithSelector:selector andArguments:arglist];
	va_end(arglist);
	
	if (!inv) return;
	[inv performSelector:@selector(invoke) afterDelay:delay];
}
#pragma mark values
- (id) valueByPerformingSelector:(SEL)selector withObject:(id) object1 withObject: (id) object2 {
	if (![self respondsToSelector:selector]) return nil;
	
	// Retrieve method signature and return type
	NSMethodSignature *ms = [self methodSignatureForSelector:selector];
	const char *returnType = [ms methodReturnType];
	
	// Create invocation using method signature and invoke it
	NSInvocation *inv = [NSInvocation invocationWithMethodSignature:ms];
	[inv setTarget:self];
	[inv setSelector:selector];
	if (object1) [inv setArgument:&object1 atIndex:2];
	if (object2) [inv setArgument:&object2 atIndex:3];
	[inv invoke];
	
	
	// Place results into value
	void *bytes = malloc(16);
	[inv getReturnValue:bytes];
	NSValue *returnValue = [NSValue valueWithBytes: bytes objCType: returnType];
	free(bytes);
	return returnValue;
}
- (id) valueByPerformingSelector:(SEL)selector withObject:(id) object1  {
	return [self valueByPerformingSelector:selector withObject:object1 withObject:nil];
}
- (id) valueByPerformingSelector:(SEL)selector  {
	return [self valueByPerformingSelector:selector withObject:nil withObject:nil];
}
// Return an array of all an object's selectors
+ (NSA*) getSelectorListForClass  {
	NSMutableArray *selectors = [NSMutableArray array];
	unsigned int num;
	Method *methods = class_copyMethodList(self, &num);
	for (int i = 0; i < num; i++)
		[selectors addObject:NSStringFromSelector(method_getName(methods[i]))];
	free(methods);
	return selectors;
}
// Return a dictionary with class/selectors entries, all the way up to NSObject
- (NSD*) selectors  {
	NSMutableDictionary *dict = [NSMutableDictionary dictionary];
	dict[NSStringFromClass([self class])] = [[self class] getSelectorListForClass];
	for (Class cl in [self superclasses])
		dict[NSStringFromClass(cl)] = [cl getSelectorListForClass];
	return dict;
}
// Return an array of all an object's properties
+ (NSA*) getPropertyListForClass  { AZNew(NSMA,propertyNames); unsigned int num;

	objc_property_t *properties = class_copyPropertyList(self, &num);
	for (int i = 0; i < num; i++) [propertyNames addObject:@(property_getName(properties[i]))];
	free(properties); return propertyNames;
}
// Return a dictionary with class/selectors entries, all the way up to NSObject
- (NSD*) properties {	NSMD *d = @{}.mC; AZSAY(@"Do you like my body?");
                                             d[self.className] = self.class.getPropertyListForClass;
  [self.superclasses do:^(Class cl) { d[NSStringFromClass(cl)] = [cl getPropertyListForClass]; }];
  return d;
}
// Return an array of all an object's properties
+ (NSA*) getIvarListForClass  {	AZNew(NSMA,ivarNames); unsigned int num;

  Ivar *ivars = class_copyIvarList(self, &num);	for (int i = 0; i < num; i++)
		[ivarNames addObject:@(ivar_getName(ivars[i]))]; free(ivars); return ivarNames;
}
// Return a dictionary with class/selectors entries, all the way up to NSObject
- (NSD*) ivars  {
	NSMutableDictionary *dict = [NSMutableDictionary dictionary];
	dict[NSStringFromClass([self class])] = [[self class] getIvarListForClass];
	for (Class cl in [self superclasses])
		dict[NSStringFromClass(cl)] = [cl getIvarListForClass];
	return dict;
}
// Return an array of all an object's properties
+ (NSA*) getProtocolListForClass  {
	NSMutableArray *protocolNames = [NSMutableArray array];
//	unsigned int num;
	unsigned int protocolIndex = 0;
	Protocol * const *protocols = class_copyProtocolList(self.class, &protocolIndex);

//	Protocol **protocols = (__bridge_retained Protocol)class_copyProtocolList(self, &num);
	for (int i = 0; i < protocolIndex; i++)
		[protocolNames addObject:@(protocol_getName(protocols[i]))];
	CFRelease(protocols);// free(protocols);
	return protocolNames;
}
// Return a dictionary with class/selectors entries, all the way up to NSObject
- (NSD*) protocols  {
	NSMutableDictionary *dict = [NSMutableDictionary dictionary];
	dict[NSStringFromClass([self class])] = [[self class] getProtocolListForClass];
	for (Class cl in [self superclasses])
		dict[NSStringFromClass(cl)] = [cl getProtocolListForClass];
	return dict;
}
// https://github.com/nodemaker/Additions/blob/master/NSObject/NSObject%2BUtilities.m
- (NSD*) runtime_properties   {
	NSMD *dict = NSMD.new;
	dict[NSStringFromClass([self class])] = [[self class] getPropertyListForClass];
	for (Class cl in [self superclasses])
		dict[NSStringFromClass(cl)] = [cl getPropertyListForClass];
	return dict;
}
// Runtime checks of properties, etc.
- (BOOL) hasProperty: (NSS*) propertyName {
	NSMutableSet *set = [NSMutableSet set];
	NSDictionary *dict = [self runtime_properties];
	for (NSArray *properties in [dict allValues])
		[set addObjectsFromArray:properties];
	return [set containsObject:propertyName];
}
- (BOOL) hasIvar:     (NSS*) ivarName     {
	NSMutableSet *set = [NSMutableSet set];
	NSDictionary *dict = self.ivars;
	for (NSArray *ivars in [dict allValues])
		[set addObjectsFromArray:ivars];
	return [set containsObject:ivarName];
}
+ (BOOL) classExists:(NSS*)className  { return (NSClassFromString(className) != nil); }
+   (id) instanceOfClassNamed:(NSS*)clsNme  { return !!NSClassFromString(clsNme) ? NSClassFromString(clsNme).new : nil; }
// Return a C-string with a selector's return type may extend this idea to return a class
- (const char*) returnTypeForSelector:(SEL)sel {	return [self methodSignatureForSelector:sel].methodReturnType; }
// Choose the first selector that an object can respond to. Thank Kevin Ballard for assist!
- (SEL) chooseSelector:(SEL)sel, ... {

	if ([self respondsToSelector:sel]) return sel; va_list selectors; va_start(selectors, sel);  
  SEL    selector = va_arg(selectors, SEL);
	while (selector) {  if ([self respondsToSelector:selector]) return selector; 
         selector = va_arg(selectors, SEL);	}
	return NULL;
}
// Perform the selector if possible, returning any return value. Otherwise return nil.
CLANG_IGNORE(-Warc-performSelector-leaks)
- (id) tryPerformSelector:(SEL)sel withObject:(id)x1 withObject:(id)x2 {
	return [self respondsToSelector:sel] ? [self performSelector:sel withObject:x1 withObject:x2] : nil;
}
CLANG_POP
- (id) tryPerformSelector:(SEL)sel withObject:(id)x	{ return [self tryPerformSelector:sel withObject:x withObject:nil]; }
- (id) tryPerformSelector:(SEL)sel 									{ return [self tryPerformSelector:sel withObject:nil withObject:nil];     }


- (void)runUntil:(BOOL*)stop {

  while(!stop) [AZRUNLOOP runMode:NSDefaultRunLoopMode beforeDate:NSDate.date];
}
@end

static BOOL OVERRIDE_CLASS_METHOD = YES; // Whether to override the -class method to return the old class name rather than the one from the override subclass.

static Class OverrideClass(id bSelf, SEL aCmd)	{

  NSS *className = [NSString.alloc initWithUTF8String:object_getClassName(bSelf)];
	NSS *prefix 	 = $(@"AZOverride_%p_", bSelf);
  const char *c        = ([className hasPrefix:prefix] ? [className substringFromIndex:prefix.length] : className).UTF8String;
	return objc_getClass(c);
}

@implementation NSObject (AZOverride)

+ (void) az_overrideClassMethods:(BOOL)should { OVERRIDE_CLASS_METHOD = should; }


-  (BOOL) az_overrideBoolMethod:(SEL)selector returning:(BOOL)newB {

  return [self az_overrideSelector:selector withBlock:(__bridge void *)^BOOL(id _s, SEL sel){ return newB; }];
}

-  (BOOL) az_overrideSelector:(SEL)selector withBlock:(void*)block	{

	Method        m = NULL;
	BOOL	  success = NO;
	Class selfClass = self.class,
			   subclass = NULL;
	NSS 	 * prefix = $(@"AZ_OVER_%p_", self),
		  * className = OVERRIDE_CLASS_METHOD ? $UTF8(object_getClassName(self)) : self.className,
		  	    *name = [prefix withString:className];

	if ([className hasPrefix:prefix])
    subclass = OVERRIDE_CLASS_METHOD ? objc_getClass(className.UTF8String) : selfClass; // object already has an override subclass

	else {

    subclass = objc_allocateClassPair(selfClass, name.UTF8String, 0);
		
		if (OVERRIDE_CLASS_METHOD && subclass == NULL)
      return NSLog(@"Couldn't create subclass"), NO;
		if (!class_addMethod(subclass, @selector(class), (IMP)OverrideClass, "#@:"))
      return NSLog(@"Couldn't add 'class' method to class %@",AZOBJCLSSTR(subclass)), NO;
		
		objc_registerClassPair(subclass);	object_setClass(self, subclass);
	}

	if ((m = class_getInstanceMethod(selfClass, selector)) == NULL)
    return NSLog(@"Could not find method %@ in class %@", NSStringFromSelector(selector), NSStringFromClass(selfClass)), NO;

	IMP imp = imp_implementationWithBlock((__bridge id)block);				// See also: http://www.friday.com/bbum/2011/03/17/ios-4-3-imp_implementationwithblock/
	success = class_addMethod(subclass, selector, imp, method_getTypeEncoding(m));
  return success ?:	NSLog(@"Could not add method %@ to class %@", NSStringFromSelector(selector), NSStringFromClass(subclass)), NO;
}	
- (void*) az_superForSelector:(SEL)selector	{

  void *impy = NULL;

	if (OVERRIDE_CLASS_METHOD) {
//    NSLog(@"%@", self);
    Class k = [self class];
    impy = [k instanceMethodForSelector:selector];
    return impy;
  }
	NSString *prefix 	= $(@"AZOverride_%p_", self);
	Class theClass 	= self.class;
	while (theClass != nil)	{	NSString *className = NSStringFromClass(theClass);
										theClass = theClass.superclass;
		if ([className hasPrefix:prefix]) return (void*)[theClass instanceMethodForSelector:selector];
	}
	NSLog(@"Could not find superclass for [%@ %@];", AZCLSSTR, NSStringFromSelector(selector));
	return NULL;
}
+  (void) swizzleInstanceSelector:(SEL)oldS withNewSelector:(SEL)newS	{ 	Method oldM = NULL, newM = NULL;
	newM = class_getInstanceMethod(self, newS);
	oldM = class_getInstanceMethod(self, oldS);
	class_addMethod 	  	(self.class,oldS, method_getImplementation(newM), method_getTypeEncoding(newM))
? 	class_replaceMethod	(self.class,newS, method_getImplementation(oldM), method_getTypeEncoding(oldM))
:													  method_exchangeImplementations(oldM, newM);	}
- (void) setDescription:(NSS*)x { self[@"__description"] = [x copy];


  [self az_overrideSelector:@selector(description) withBlock:(__bridge void *)^NSS*(id _self, SEL sel){

    return self[@"__description"];
  }];
}

@end

@implementation NSProxy (AZOverride)

-  (BOOL)     az_overrideSelector:(SEL)selector withBlock:(void*)block	{


	Class selfClass	= self.class, subclass = nil;
	NSS 	*prefix 		= $(@"AZOverride_%p_", self),
			*className 	= OVERRIDE_CLASS_METHOD ? $UTF8(object_getClassName(self)) : NSStringFromClass(selfClass);

	if (![className hasPrefix:prefix])	{		NSString *name;

		name 		= [prefix withString:className];
		subclass = objc_allocateClassPair(selfClass, name.UTF8String, 0);

		if (OVERRIDE_CLASS_METHOD && subclass == NULL) return NSLog(@"Could not create subclass"), NO;
		else if (!class_addMethod(subclass, @selector(class), (IMP)OverrideClass, "#@:"))
			return NSLog(@"Could not add 'class' method to class %@", NSStringFromClass(subclass)), NO;
		objc_registerClassPair(subclass);
		object_setClass(self,  subclass);
	}
	else subclass 	= OVERRIDE_CLASS_METHOD ? objc_getClass(className.UTF8String) : selfClass; // object already has an override subclass
	Method m 		= class_getInstanceMethod(selfClass, selector);
	if (m == NULL) return NSLog(@"Could not find method %@ in class %@", NSStringFromSelector(selector), AZCLSSTR), NO;
	// See also: http://www.friday.com/bbum/2011/03/17/ios-4-3-imp_implementationwithblock/
	IMP imp 			= imp_implementationWithBlock((__bridge id)block);
	return class_addMethod(subclass, selector, imp, method_getTypeEncoding(m)) ?:
		NSLog(@"Could not add method %@ to class %@", NSStringFromSelector(selector), NSStringFromClass(subclass)), NO;
}
- (void*)     az_superForSelector:(SEL)selector	{

	if (OVERRIDE_CLASS_METHOD)	return [self.class instanceMethodForSelector:selector];
	NSString *prefix = $(@"AZOverride_%p_", self);
	Class theClass = self.class;
	while (theClass != nil)	{
		NSString *className = NSStringFromClass(theClass);
		theClass = theClass.superclass;
		if ([className hasPrefix:prefix])
			return (void *)[theClass instanceMethodForSelector:selector];
	}
	NSLog(@"Could not find superclass for PROXIED [%@ %@];", AZCLSSTR, NSStringFromSelector(selector));
	return NULL;
}
+  (void) swizzleInstanceSelector:(SEL)oldS withNewSelector:(SEL)newS	{ 	Method oldM = NULL, newM = NULL;
	newM = class_getInstanceMethod(self, newS);
	oldM = class_getInstanceMethod(self, oldS);
	class_addMethod 	  	(self.class,oldS, method_getImplementation(newM), method_getTypeEncoding(newM))
? 	class_replaceMethod	(self.class,newS, method_getImplementation(oldM), method_getTypeEncoding(oldM))
:													  method_exchangeImplementations(oldM, newM);	}
@end

//#import "AOPProxy/AOPProxy.h"
//- (BOOL)az_overrideSelector:(SEL)selector callSuper:(InterceptionPoint)point withBlock:(void*)block	{ return NO; }
//  [AOProxy interceptMethodForSelector:(SEL)sel interceptorPoint:(InterceptionPoint)time block:(InterceptionBlock)block;

/*
- (id) objectByPerformingSelector:(SEL)selector withObject:(id) object1 withObject: (id) object2 { return [self objectByPerformingSelectorWithArguments:selector, object1, object2]; }
- (id) objectByPerformingSelector:(SEL)selector withObject:(id) object1{return [self objectByPerformingSelectorWithArguments:selector, object1];}
- (id) objectByPerformingSelector:(SEL)selector{	return [self objectByPerformingSelectorWithArguments:selector]; } */
