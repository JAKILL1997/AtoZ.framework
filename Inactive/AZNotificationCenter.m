//
//  MAKVONotificationCenter.m
//  MAKVONotificationCenter
//
//  Created by Michael Ash on 10/15/08.
//

#import "AZNotificationCenter.h"

#import <libkern/OSAtomic.h>
#import <objc/message.h>
@interface _AZNotificationHelper : NSObject

@property	id	observer;
@property	SEL			selector;

@property	id		target;
@property	NSString*	keyPath;

@property (retain)  id userInfo;

- (id)initWithObserver:(id)observer object:(id)target keyPath:(NSString *)keyPath selector:(SEL)selector userInfo: (id)userInfo options: (NSKeyValueObservingOptions)options;
- (void)deregister;

@end

@implementation _AZNotificationHelper

static char AZNotificationHelperMagicContext;

- (id)initWithObserver:(id)observer object:(id)target keyPath:(NSString *)keyPath selector:(SEL)selector userInfo: (id)userInfo options: (NSKeyValueObservingOptions)options
{
	if((self = [self init]))
	{
		_observer = observer;
		_selector = selector;
		_userInfo = userInfo;// retain];

		_target = target;
		_keyPath = keyPath;// retain];

		[target addObserver:self
				 forKeyPath:keyPath
					options:options
					context:&AZNotificationHelperMagicContext];
	}
	return self;
}

//- (void)dealloc
//{
//	[_userInfo release];
//	[_keyPath release];
//	[super dealloc];
//}

#pragma mark -
- (void) observeValueForKeyPath:(NSString *)keyPath 	ofObject:(id)object
						 change:(NSDictionary *)change 	 context:(void *)context
{
	context == &AZNotificationHelperMagicContext
	// we only ever sign up for one notification per object, so if we got here then we *know* that the key path and object are what we want
	? ((void (*)(id, SEL, NSS *, id, NSD *, id))objc_msgSend)(_observer, _selector,keyPath, object, change, _userInfo)
	: [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
}

- (void)deregister	{	[_target removeObserver:self forKeyPath:_keyPath];	}

@end

@implementation AZNotificationCenter

//
//
//+ (id) defaultCenter {
//	static AZNotificationCenter *center = nil;
//
//	//- check sharedInstance existenz
//	while (!center) {
//		//- create a temporary instance of the singleton
//		id temp = [super allocWithZone:NSDefaultMallocZone()];
//		//- The OSAtomicCompareAndSwapPtrBarrier function provided on Mac OS X
//		//- checks whether sharedInstance is NULL and only actually sets it to temp to it if it is.
//		//- This uses hardware support to really, literally only perform the swap once and tell whether it happened.
//		if(OSAtomicCompareAndSwapPtrBarrier(0x0, (__bridge void *)temp, (void*)&center)) {
//			//- compute singleton initialize
//			AZNotificationCenter *center = self.new;
//		}
//		else {
//			//- if the swap didn't take place, delete the temporary instance
//			temp = nil;
//		}
//	}
//	//- return computed sharedInstance
//	return center;
//}

+ (id)defaultCenter
{
	return [self sharedInstance];
}
		// do a bit of clever atomic setting to make this thread safe
		// if two threads try to set simultaneously, one will fail
		// and the other will set things up so that the failing thread
		// gets the shared center
//		AZNotificationCenter *newCenter = self.new;
//		if(!OSAtomicCompareAndSwapPtrBarrier(nil, /*(__bridge id)*/**newCenter, (void *)&center))
//		CFBridgingRetain(newCenter), (void *)&center))

//			newCenter = nil;
//			[newCenter release];
//	}
//	return center;

- (id)init
{
	if((self = [super init]))
	{
		_observerHelpers = NSMutableDictionary.new;
	}
	return self;
}

//- (void)dealloc
//{
//	[_observerHelpers release];
//	[super dealloc];
//}

#pragma mark -

- (id)_dictionaryKeyForObserver:(id)observer object:(id)target keyPath:(NSString *)keyPath selector:(SEL)selector
{
	return [NSString stringWithFormat:@"%p:%p:%@:%p", observer, target, keyPath, selector];
}

- (void)addObserver:(id)observer object:(id)target keyPath:(NSString *)keyPath selector:(SEL)selector userInfo: (id)userInfo options: (NSKeyValueObservingOptions)options
{
	_AZNotificationHelper *helper = [[_AZNotificationHelper alloc] initWithObserver:observer object:target keyPath:keyPath selector:selector userInfo:userInfo options:options];
	id key = [self _dictionaryKeyForObserver:observer object:target keyPath:keyPath selector:selector];
	@synchronized(self)
	{
		_observerHelpers[key] = helper;
	}
	helper = nil;//release];

}

- (void)removeObserver:(id)observer object:(id)target keyPath:(NSString *)keyPath selector:(SEL)selector
{
	id key = [self _dictionaryKeyForObserver:observer object:target keyPath:keyPath selector:selector];
	_AZNotificationHelper *helper = nil;
	@synchronized(self)
	{
		helper = _observerHelpers[key];// retain];
		[_observerHelpers removeObjectForKey:key];
	}
	[helper deregister];
	helper = nil;// release];
}

@end

@implementation NSObject (AZKVONotification)

- (void)addObserver:(id)observer forKeyPath:(NSString *)keyPath selector:(SEL)selector userInfo:(id)userInfo options:(NSKeyValueObservingOptions)options
{
	[[AZNotificationCenter defaultCenter] addObserver:observer object:self keyPath:keyPath selector:selector userInfo:userInfo options:options];
}

- (void)removeObserver:(id)observer keyPath:(NSString *)keyPath selector:(SEL)selector
{
	[[AZNotificationCenter defaultCenter] removeObserver:observer object:self keyPath:keyPath selector:selector];
}

@end
