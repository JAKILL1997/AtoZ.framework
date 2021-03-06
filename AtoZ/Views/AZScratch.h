
//#import "AZCLI.h>
//#import "AZCLICategories.h>
//#import "AZLassoLayer.h>
//#import "NSColor+RGBHex.h>
//#import "NSImage+AtoZ.h>
//#import "NSTerminal.h>
//#import "SimpleTesseract.h>
//#import "TUITableView+Updating.h>


//typedef void(^log)(NSS*s);


/** The appledoc application handler.

 This is the principal tool class. It represents the entry point for the application. The main promises of the class are parsing and validating of command line arguments and initiating documentation generation. Generation is divided into several distinct phases:

 1. Parsing data from source files: This is the initial phase where input directories and files are parsed into a memory representation (i.e. objects) suitable for subsequent handling. This is where the source code files are  parsed and validated for possible file or object-level incosistencies. This step is driven by `GBParser` class.
 2. Post-processing of the data parsed in the previous step: At this phase, we already have in-memory representation of all source code objects, so we can post-process and validate things such as links to other objects etc. We can also update in-memory representation with this data and therefore prepare everything for the final phase. This step is driven by `GBProcessor` class.
 3. Generating output: This is the final phase where we use in-memory data to generate output. This step is driven by `GBGenerator` class.
 @warning *Global settings implementation details:* To be able to properly apply all levels of settings - factory defaults, global settings and command line arguments - we can't solely rely on `DDCli` for parsing command line args. As the user can supply templates path from command line (instead of using one of the default paths), we need to pre-parse command line arguments for templates switches. The last one found is then used to read global settings. This solves proper settings inheritance up to global settings level. Another issue is how to implement code that deals with global settings; there are several possible solutions (the simplest from programmers point of view would be to force the user to pass in templates path as the first parameter, then `DDCli` would first process this and when we would receive notification, we could parse the option, load in global settings and resume operation). At the end I chose to pre-parse command line for template arguments before passing it to `DDCli`. This did require some tweaking to `DDCli` code (specifically the method that converts option string to KVC key was moved to public interface), but ended up as very simple to inject global settings - by simply using the same KCV messages as `DDCli` uses. This small tweak allowed us to use exactly the same path of handling global settings as normal command line arguments. The benefits are many: all argument names are alreay unit tested to properly map to settings values, code reuse for setting the values.  */

/*  xcode shortcuts  @property (nonatomic, assign) <\#type\#> <\#name\#>; */

/*
 @class AZTaskResponder;
 typedef void (^asyncTaskCallback)(AZTaskResponder *response);
 @interface AZTaskResponder: BaseModel
 @property (copy) BKReturnBlock     returnBlock;
 @property (copy) asyncTaskCallback   asyncTask;
 @property (NA,STR) id response;
 //Atoz
 + (void) aSyncTask:(asyncTaskCallback)handler;
 - (void) parseAsyncTaskResponse;
 // this is how we make the call:
 // [AtoZ aSyncTask:^(AZTaskResponder *response) {   respond to result;  }];
 @end
 */

/*  http://stackoverflow.com/questions/4224495/using-an-nsstring-in-a-switch-statement
 You can use it as

 FilterBlock fb1 = ^id(id element, NSUInteger idx, BOOL *stop){ if ([element isEqualToString:@"YES"]) { NSLog(@"You did it");  *stop = YES;} return element;};
 FilterBlock fb2 = ^id(id element, NSUInteger idx, BOOL *stop){ if ([element isEqualToString:@"NO"] ) { NSLog(@"Nope");   *stop = YES;} return element;};

 NSArray *filter = @[ fb1, fb2 ];
 NSArray *inputArray = @[@"NO",@"YES"];

 [inputArray enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
 [obj processByPerformingFilterBlocks:filter];
 }];
 but you can also do more complicated stuff, like aplied chianed calculations:

 FilterBlock b1 = ^id(id element,NSUInteger idx, BOOL *stop) {return [NSNumber numberWithInteger:[(NSNumber *)element integerValue] *2 ];};
 FilterBlock b2 = ^id(NSNumber* element,NSUInteger idx, BOOL *stop) {
 *stop = YES;
 return [NSNumber numberWithInteger:[element integerValue]*[element integerValue]];
 };
 FilterBlock b3 = ^id(NSNumber* element, NSUInteger idx,BOOL *stop) {return [NSNumber numberWithInteger:[element integerValue]*[element integerValue]];};

 NSArray *filterBlocks = @[b1,b2, b3, b3, b3];
 NSNumber *numberTwo = [NSNumber numberWithInteger:2];
 NSNumber *numberTwoResult = [numberTwo processByPerformingFilterBlocks:filterBlocks];
 NSLog(@"%@ %@", numberTwo, numberTwoResult);
 */

//#pragma GCC diagnostic ignored "-Wformat-security"
//#import <NanoStore/NSFNanoObjectProtocol.h>
//#import <NanoStore/NSFNanoObject.h>
//#import <NanoStore/NSFNanoGlobals.h>
//#import <NanoStore/NSFNanoStore.h>
//#import <NanoStore/NSFNanoPredicate.h>
//#import <NanoStore/NSFNanoExpression.h>
//#import <NanoStore/NSFNanoSearch.h>
//#import <NanoStore/NSFNanoSortDescriptor.h>
//#import <NanoStore/NSFNanoResult.h>
//#import <NanoStore/NSFNanoBag.h>
//#import <NanoStore/NSFNanoEngine.h>
//#import <NanoStore/NSFNanoGlobals.h>
//#import <Growl/Growl.h>
//#import "Nu.h"

// ARC is compatible with iOS 4.0 upwards, but you need at least Xcode 4.2 with Clang LLVM 3.0 to compile it.
//#if !__has_feature(objc_arc)
//#error This project must be compiled with ARC (Xcode 4.2+ with LLVM 3.0 and above)
//#endif


//#define EXCLUDE_STUB_PROTOTYPES 1
//#import <PLWeakCompatibility/PLWeakCompatibilityStubs.h>



// #undef ah_retain #undef ah_dealloc #undef ah_autorelease autorelease #undef ah_dealloc dealloc

//
//  ARC Helper
//
//  Version 2.2
//
//  Created by Nick Lockwood on 05/01/2012.
//  Copyright 2012 Charcoal Design
//
//  Distributed under the permissive zlib license
//  Get the latest version from here:
//
//  https://gist.github.com/1563325
//
/*
  #import <Availability.h>
  #undef ah_retain
  #undef ah_dealloc
  #undef ah_autorelease autorelease
  #undef ah_dealloc dealloc
  #if __has_feature(objc_arc)
    #define ah_retain self
    #define ah_release self
    #define ah_autorelease self
    #define ah_dealloc self
  #else
    #define ah_retain retain
    #define ah_release release
    #define ah_autorelease autorelease
    #define ah_dealloc dealloc
    #undef __bridge
    #define __bridge
    #undef __bridge_transfer
    #define __bridge_transfer
  #endif

  //  Weak reference support

  #import <Availability.h>
  #if !__has_feature(objc_arc_weak)
    #undef ah_weak
    #define ah_weak unsafe_unretained
    #undef __ah_weak
    #define __ah_weak __unsafe_unretained
  #endif

  //  Weak delegate support

  #import <Availability.h>
  #undef ah_weak_delegate
  #undef __ah_weak_delegate
  #if __has_feature(objc_arc_weak) && \
    (!(defined __MAC_OS_X_VERSION_MIN_REQUIRED) || \
    __MAC_OS_X_VERSION_MIN_REQUIRED >= __MAC_10_8)
    #define ah_weak_delegate weak
    #define __ah_weak_delegate __weak
  #else
    #define ah_weak_delegate unsafe_unretained
    #define __ah_weak_delegate __unsafe_unretained
  #endif

//  ARC Helper ends
*/

//#import "GCDAsyncSocket.h"
//#import "GCDAsyncSocket+AtoZ.h"
//#import "HTTPServer.h"
//#import "HTTPConnection.h"
//#import "HTTPMessage.h"
//#import "HTTPResponse.h"
//#import "HTTPDataResponse.h"
//#import "HTTPAuthenticationRequest.h"
//#import "DDNumber.h"
//#import "DDRange.h"
//#import "DDData.h"
//#import "HTTPFileResponse.h"
//#import "HTTPAsyncFileResponse.h"
//#import "HTTPDynamicFileResponse.h"
//#import "RoutingHTTPServer.h"
//#import "WebSocket.h"
//#import "RouteRequest.h"
//#import "RouteResponse.h"
//#import "WebSocket.h"
//#import "AZWebSocketServer.h"
//#import "HTTPLogging.h"

////@import ObjectiveC;
////@import Security;
////@import Quartz;
////#import <QuartzCore/QuartzCore.h>
////#import <QuartzCore/QuartzCore.h>
////@import ApplicationServices;
////@import AVFoundation;
////@import CoreServices;
////@import AudioToolbox;

//#import <objc/message.h>
//#import <objc/runtime.h>
//#import <AppKit/AppKit.h>
//#import <Quartz/Quartz.h>
//#import <Security/Security.h>
//#import <Foundation/Foundation.h>
//#import <QuartzCore/QuartzCore.h>
//#import <AudioToolbox/AudioToolbox.h>
//#import <CoreServices/CoreServices.h>
//#import <AVFoundation/AVFoundation.h>
//#import <ApplicationServices/ApplicationServices.h>


//#import <stat.h>
//#import <Python/Python.h>
//#import <NanoStore/NanoStore.h>
//#import <Nu/Nu.h>


//  ARC Helper ends


/*
  #if __has_feature(objc_arc)                     // ARC Helper Version 2.2
    #define ah_retain     self
    #define ah_release    self
    #define ah_autorelease  self
//    #define release       self                    // Is this right?  Why's mine different?
  //  #define autorelease     self                    // But shit hits fan without.
    #define ah_dealloc    self
  #else
    #define ah_retain     retain
    #define ah_release    release
    #define ah_autorelease  autorelease
    #define ah_dealloc    dealloc
    #undef  __bridge
    #define  __bridge
    #undef   __bridge_transfer
    #define  __bridge_transfer
  #endif
  #if !__has_feature(objc_arc_weak)                 // Weak reference support
    #undef    ah_weak
    #define     ah_weak   unsafe_unretained
    #undef  __ah_weak
    #define   __ah_weak __unsafe_unretained
  #endif
  #undef ah_weak_delegate                         // Weak delegate support
  #undef __ah_weak_delegate
  #if __has_feature(objc_arc_weak) && (!(defined __MAC_OS_X_VERSION_MIN_REQUIRED) || __MAC_OS_X_VERSION_MIN_REQUIRED >= __MAC_10_8)
    #define   ah_weak_delegate weak
    #define __ah_weak_delegate __weak
  #else
    #define   ah_weak_delegate   unsafe_unretained
    #define __ah_weak_delegate __unsafe_unretained
  #endif                                    // ARC Helper ends


  //  ARC Helper Version 1.3.1 Created by Nick Lockwood on 05/01/2012. Copyright 2012 Charcoal Design Distributed under the permissive zlib license  Get the latest version from here: https://gist.github.com/1563325
  #ifndef AH_RETAIN
    #if __has_feature(objc_arc)
      #define AH_RETAIN(x) (x)
      #define AH_RELEASE(x) (void)(x)
      #define AH_AUTORELEASE(x) (x)
      #define AH_SUPER_DEALLOC (void)(0)
      #define __AH_BRIDGE __bridge
    #else
      #define __AH_WEAK
      #define AH_WEAK assign
      #define AH_RETAIN(x) [(x) retain]
      #define AH_RELEASE(x) [(x) release]
      #define AH_AUTORELEASE(x) [(x) autorelease]
      #define AH_SUPER_DEALLOC [super dealloc]
      #define __AH_BRIDGE
    #endif
  #endif

*/
/*
#import <pwd.h>
#import <stdio.h>
#import <netdb.h>
#import <dirent.h>
#import <unistd.h>
#import <stdarg.h>
#import <unistd.h>
#import <dirent.h>
#import <xpc/xpc.h>
#import <xpc/xpc.h>
#import <sys/stat.h>
#import <sys/time.h>
#import <sys/types.h>
#import <sys/ioctl.h>
#import <sys/xattr.h>
#import <sys/sysctl.h>
#import <sys/sysctl.h>
#import <sys/stat.h>
#import <sys/types.h>
#import <sys/xattr.h>
#import <arpa/inet.h>
#import <objc/objc.h>
#import <netinet/in.h>
#import <objc/message.h>
#import <objc/runtime.h>
#import <libkern/OSAtomic.h>

#import <Foundation/Foundation.h>
#import <Security/Security.h>
#import <Python/Python.h>
#import <AppKit/AppKit.h>
#import <Quartz/Quartz.h>
#import <Carbon/Carbon.h>
#import <libkern/OSAtomic.h>
#import <CoreText/CoreText.h>
#import <QuartzCore/QuartzCore.h>
#import <AudioToolbox/AudioToolbox.h>
#import <ApplicationServices/ApplicationServices.h>
#import <AVFoundation/AVFoundation.h>
#import <CoreServices/CoreServices.h>
#import <AudioToolbox/AudioToolbox.h>
*/

//  #import <extobjc_OSX/e.h>
//  #import "extobjc_OSX/extobjc.h"
//  #import <extobjc/metamacros.h>
//  #import "GCDAsyncSocket.h"
//  #import "GCDAsyncSocket+AtoZ.h"
//  #import "AtoZAutoBox/NSObject+DynamicProperties.h"

//#import <AIUtilities/AIUtilities.h>
//#import "extobjc_OSX/extobjc.h"
//#import "AtoZAutoBox/AtoZAutoBox.h"
//#import "ObjcAssociatedObjectHelper/ObjcAssociatedObjectHelpers.h"
//#import "AtoZSingleton/AtoZSingleton.h"
//#import "ObjcAssociatedObjectHelper/ObjcAssociatedObjectHelpers.h"
//#import "TypedCollections/TypedCollections.h"
//#import "KVOMap/DCKeyValueObjectMapping.h"
//#import "KVOMap/DCArrayMapping.h"
//#import "KVOMap/DCDictionaryRearranger.h"
//#import "KVOMap/DCKeyValueObjectMapping.h"
//#import "KVOMap/DCObjectMapping.h"
//#import "KVOMap/DCParserConfiguration.h"
//#import "KVOMap/DCPropertyAggregator.h"
//#import "KVOMap/DCValueConverter.h"

//#endif



//  #import <Security/Security.h>
//  #import <QuartzCore/QuartzCore.h>
//  #import <WebKit/WebKit.h>
//  #import <objc/runtime.h>
//  #import <objc/message.h>
//  #import <AppKit/AppKit.h>
//  #import <Foundation/NSObjCRuntime.h>

//  #import <AtoZAutoBox/AtoZAutoBox.h>

//  #import <AtoZAppKit/AtoZAppKit.h>
//  #import <AtoZBezierPath/AtoZBezierPath.h>
//  #import <BWTK/BWToolkitFramework.h>
//  #import <BlocksKit/A2DynamicDelegate.h>
//  #import <CFAAction/CFAAction.h>
//  #import <CocoatechCore/CocoatechCore.h>
//  #import <DrawKit/DrawKit.h>
//  #import <KSHTMLWriter/KSHTMLWriter.h>
//  #import <MenuApp/MenuApp.h>
//  #import <NMSSH/NMSSH.h>
//  #import <PhFacebook/PhFacebook.h>
//  #import <Rebel/Rebel.h>


//#import <RoutingHTTPServer/RoutingHTTPServer.h>


// 64-bit float macros
/*
#ifdef __LP64__
	#define _CGFloatFabs( n )	fabs( n )
	#define _CGFloatTrunc( n )	trunc( n )
	#define _CGFloatLround( n )	roundtol( n )
	#define _CGFloatFloor( n )	floor( n )
	#define _CGFloatCeil( n )	ceil( n )
	#define _CGFloatExp( n )	exp( n )
	#define _CGFloatSqrt( n )	sqrt( n )
	#define _CGFloatLog( n )	log( n )
#else
	#define _CGFloatFabs( n )	fabsf( n )
	#define _CGFloatTrunc( n )	truncf( n )
	#define _CGFloatLround( n )	roundtol((double) n )
	#define _CGFloatFloor( n )	floorf( n )
	#define _CGFloatCeil( n )	ceilf( n )
	#define _CGFloatExp( n )	expf( n )
	#define _CGFloatSqrt( n )	sqrtf( n )
	#define _CGFloatLog( n )	logf( n )
#endif
*/

/*!

 #define 				 IDDRAG 	id<NSDraggingInfo>
#define 					NSPB 	NSPasteboard

#define 				AZIDCAA 	(id<CAAction>)
#define 				  IDCAA		(id<CAAction>)
#define 					IDCP 	id<NSCopying>
#define 				  	 IBO 	IBOutlet
#define 					 IBA 	IBAction
#define 				  RO 	readonly
#define 				  RW	readwrite
#define 				  ASSGN 	assign
#define 				  NA 	nonatomic
#define 				  STR 	strong
#define 				    STR 	strong

#define 					 ASS 	assign
#define 					  CP 	copy
#define 					 CPY 	copy


#define 					 GET 	getter
#define	 				  WK 	weak
#define 					UNSF 	unsafe_unretained

#define					prop 	property
#define 					 IBO 	IBOutlet
#pragma mark 														- CoreGraphics / CoreFoundation
#define 				  CFTI	CFTimeInterval
#define 				  CGCR	CGColorRef
#define 					CGF 	CGFloat
#define 				   CGP	CGPoint
#define 				  CGPR 	CGPathRef
#define	 				CGR 	CGRect
#define 					CGS 	CGSize
#define 				  CGSZ 	CGSize
#define 					CIF 	CIFilter
#define 				 CGRGB 	CGColorCreateGenericRGB
#define 				CGCREF 	CGContextRef
#define 				JSCREF 	JSContextRef
#define 				  CGWL 	CGWindowLevel

#define 			CGPATH(A)	CGPathCreateWithRect(R)

#define 			AZRUNLOOP	NSRunLoop.currentRunLoop
#define 	   AZRUNFOREVER 	[AZRUNLOOP runMode:NSDefaultRunLoopMode beforeDate:NSDate.distantFuture]
#define 	AZRUN while(0)	[NSRunLoop.currentRunLoop run]
#define 					NSA 	NSArray
#define 			 NSACLASS 	NSArray.class
#define 	    NSAorDCLASS 	@[NSArray.class, NSDictionary.class]
#define 			  ISADICT 	isKindOfClass:NSDictionary.class
#define 			ISANARRAY	isKindOfClass:NSArray.class
#define 	 ISADICTorARRAY	isKindOfAnyClass:NSAorDCLASS
#define 			 NSSCLASS 	NSString.class
#define				 NSAPP 	NSApplication
#define				  NSAC 	NSArrayController
#define				  NSAS 	NSAttributedString
#define				  NSAT 	NSAffineTransform
#define			    	NSB 	NSBundle
#define				NSBUTT 	NSButton
#define				  NSBP 	NSBezierPath
#define			  NSBRWSR 	NSBrowser
#define				 NSBIR 	NSBitmapImageRep
#define				 NSBLO 	NSBlockOperation
#define				 NSBSB	NSBackingStoreBuffered

#define				 NSBWM 	NSBorderlessWindowMask
#define			  NSCOMPR 	NSComparisonResult
#define				  NSDE 	NSDirectoryEnumerator
#define				  NSGC 	NSGraphicsContext
#define				   NSC 	NSColor
#define			     NSCL 	NSColorList
#define				  NSCS 	NSCountedSet
#define				   NSD 	NSDictionary
#define			 NSDCLASS 	NSDictionary.class
#define			   	NSE 	NSEvent
#define			     NSEM	NSEventMask
#define				 NSERR 	NSError
#define			    	NSF 	NSFont
#define 				  NSFH	NSFileHandle
#define			    	NSG	NSGradient
#define				  NSJS	NSJSONSerialization
#define				   NSI 	NSInteger
#define				  NSIP 	NSIndexPath
#define				 NSIMG 	NSImage
#define				  NSIS 	NSIndexSet
#define				  NSIV 	NSImageView

#define					SIG	NSMethodSignature
#define				  NSMA 	NSMutableArray
#define				 NSMAS 	NSMutableAttributedString
#define				  NSMD 	NSMutableDictionary
#define			  NSMDATA 	NSMutableData
#define				   NSM 	NSMenu
#define				  NSMI 	NSMenuItem
#define			  NSMenuI	NSMenuItem
#define				  NSMS 	NSMutableString
#define				NSMSet 	NSMutableSet
#define				 NSMIS 	NSMutableIndexSet
#define				 NSMPS 	NSMutableParagraphStyle
#define				   NSN 	NSNumber
#define				 NSNOT 	NSNotification
#define				   NSO 	NSObject
//#define ID \(NSObject*\)
#define				  NSOQ 	NSOperationQueue
#define				  NSOP 	NSOperation
#define 			 NSPUBUTT   NSPopUpButton
#define 			 	  NSPO   NSPopover

#define				 NSCSV 	NSCellStateValue
#define			  AZOQMAX 	NSOperationQueueDefaultMaxConcurrentOperationCount
#define			  	  NSOV 	NSOutlineView

#define					NSP 	NSPoint
#define			NSPInRect 	NSPointInRect
#define			     NSPI 	NSProgressIndicator
#define			 NSPUBUTT 	NSPopUpButton
#define					NSR 	NSRect
#define				  NSRE 	NSRectEdge
#define				 NSRNG 	NSRange
#define			  NSRFill 	NSRectFill
#define					NSS 	NSString
#define				  NSSI 	NSStatusItem
#define				NSSHDW 	NSShadow
#define				  NSSZ 	NSSize
#define				  NSST 	NSSet
#define					NST 	NSTimer
#define				 NSTSK 	NSTask
#define 			   NSSEGC	NSSegmentedControl
#define			  NSSCRLV 	NSScrollView
#define			  NSSPLTV	NSSplitView
#define			     NSTA 	NSTrackingArea
#define			 	  NSTI 	NSTimeInterval
#define				  NSTV 	NSTableView
#define				  NSTC 	NSTableColumn
#define				NSTXTF 	NSTextField
#define				NSTXTV 	NSTextView
#define				  NSUI 	NSUInteger
#define				NSURLC 	NSURLConnection
#define		   NSMURLREQ	NSMutableURLRequest
#define			 NSURLREQ 	NSURLRequest
#define			 NSURLRES 	NSURLResponse
#define			   	NSV 	NSView
#define				  NSVC 	NSViewController
#define				  NSWC 	NSWindowController
#define				 NSVAL 	NSValue
#define				  NSVT 	NSValueTransformer
#define				NSTABV 	NSTabView

#define 				 NSPSC 	NSPersistentStoreCoordinator
#define 				  NSED 	NSEntityDescription
#define 				  NSMO	NSManagedObject
#define 				 NSMOM	NSManagedObjectModel
#define 			    NSMOC	NSManagedObjectContext

#define				NSTVDO	NSTableViewDropOperation
#define 				  NSDO	NSDragOperation

#define				NSTBAR 	NSToolbar
#define				   NSW 	NSWindow

#define				TUINSV 	TUINSView
#define				TUINSW 	TUINSWindow
#define				  TUIV 	TUIView
#define				 TUIVC	TUIViewController
#define				  Blk 	VoidBlock
#define					 WV	WebView
#define				IDWPDL	id<WebPolicyDecisionListener>
#define 				  AHLO 	AHLayoutObject
#define 				  AHLT 	AHLayoutTransaction
#define  		  BLKVIEW 	BNRBlockView
#define  		     BLKV 	BLKVIEW

#pragma mark -  CoreAnimation
#import <QuartzCore/QuartzCore.h>

typedef struct {	CAConstraintAttribute constraint;	CGFloat scale;	CGFloat offset;	}	AZCAConstraint;

#pragma mark - AZSHORTCUTS

#define 			AZCACMinX	AZConstRelSuper ( kCAConstraintMinX   )
#define 			AZCACMinY	AZConstRelSuper ( kCAConstraintMinY   )
#define 			AZCACMaxX	AZConstRelSuper ( kCAConstraintMaxX   )
#define 			AZCACMaxY	AZConstRelSuper ( kCAConstraintMaxY   )
#define 			AZCACWide 	AZConstRelSuper ( kCAConstraintWidth  )
#define 			AZCACHigh 	AZConstRelSuper ( kCAConstraintHeight )

#define 		 			CAA 	CAAnimation
#define     		  CAAG	CAAnimationGroup
#define 	   		  CABA	CABasicAnimation
#define 		 CACONSTATTR   CAConstraintAttribute
#define			  CACONST	CAConstraint
#define     		  CAGA	CAGroupAnimation
#define     		  CAGL	CAGradientLayer
#define     		  CAKA	CAKeyframeAnimation
#define      			CAL	CALayer
#define    			 CALNA 	CALayerNonAnimating
#define    			 CALNH 	CALayerNoHit
#define    			 CAMTF	CAMediaTimingFunction
#define   			CASLNH 	CAShapeLayerNoHit
#define    			 CASHL 	CAShapeLayer
#define  		  CASCRLL 	CAScrollLayer
#define 				 CASHL 	CAShapeLayer
#define     		  CASL 	CAShapeLayer
#define   			CATLNH 	CATextLayerNoHit
#define      			CAT 	CATransaction
#define     		  CAT3 	CATransform3D
#define            CAT3D 	CATransform3D
#define   		   CAT3DR 	CATransform3DRotate
#define  		  CAT3DTR 	CATransform3DTranslate
#define     		  CATL 	CATransformLayer
#define   			CATXTL 	CATextLayer

#define 			 CATRANNY	CATransaction
#define 			 CATRANST 	CATransition
#define 				  ID3D 	CATransform3DIdentity
#define 		   CATIMENOW 	CACurrentMediaTime()

#define AZNOCACHE NSURLRequestReloadIgnoringLocalCacheData

#define 				  lMGR 	layoutManager
#define				   bgC	backgroundColor
#define 					fgC 	foregroundColor
#define 				arMASK 	autoresizingMask
#define 					mTB 	masksToBounds
#define 			  cRadius 	cornerRadius
#define 				aPoint 	anchorPoint
#define 				 NDOBC 	needsDisplayOnBoundsChange
#define 				 nDoBC 	needsDisplayOnBoundsChange
#define 		  CASIZEABLE 	kCALayerWidthSizable | kCALayerHeightSizable
#define 					loM 	layoutManager
#define 				 sblrs 	sublayers
#define 				  zPos 	zPosition
#define			  constWa   constraintWithAttribute
#define 		  removedOnC 	removedOnCompletion

#define 				  kIMG 	@"image"
#define 				  kCLR 	@"color"
#define 				  kIDX 	@"index"
#define 				  kLAY 	@"layer"
#define 				  kPOS 	@"position"
#define 			 kPSTRING 	@"pString"
#define 			     kSTR 	@"string"
#define 				  kFRM 	@"frame"
#define 				 kHIDE	@"hide"
#define AZSuperLayerSuper (@"superlayer")

#define 		CATransform3DPerspective	( t, x, y ) (CATransform3DConcat(t, CATransform3DMake(1,0,0,x,0,1,0,y,0,0,1,0,0,0,0,1)))
#define CATransform3DMakePerspective  	(  x, y ) (CATransform3DPerspective( CATransform3DIdentity, x, y ))
/ / exception safe save/restore of the current graphics context
#define 			SAVE_GRAPHICS_CONTEXT	@try { [NSGraphicsContext saveGraphicsState];
#define 		RESTORE_GRAPHICS_CONTEXT	} @finally { [NSGraphicsContext restoreGraphicsState]; }


/ / #define CACcWA CAConstraint constraintWithAttribute
#define AZConst(attrb,rel)		[CAConstraint constraintWithAttribute:attrb relativeTo:rel attribute:attrb]
#define AZConst(attrb,rel)				[CAConstraint constraintWithAttribute:attrb relativeTo:rel attribute:attrb]
#define AZConstScaleOff(attrb,rel,scl,off)	[CAConstraint constraintWithAttribute:attrb relativeTo:rel attribute:attrb scale:scl offset:off]
#define AZConstRelSuper(attrb)		[CAConstraint constraintWithAttribute:attrb relativeTo:AZSuperLayerSuper attribute:attrb]
#define AZConstRelSuperScaleOff (att,scl,off) [CAConstraint constraintWithAttribute:att relativeTo:AZSuperLayerSuper attribute:att scale:scl offset:off]
#define AZConstAttrRelNameAttrScaleOff ( attr1, relName, attr2, scl, off) [CAConstraint constraintWithAttribute:attr1 relativeTo:relName attribute:attr2 scale:scl offset:off]

 */

 //@protocol AtoZNodeProtocol;
//#define AZNODEPRO (NSObject<AtoZNodeProtocol>*)


//#define 	AZLAYOUTMGR 		[CAConstraintLayoutManager layoutManager]
//#define  AZTALK	 (log) 	[AZTalker.new say:log]
//#define  AZBezPath (r) 		[NSBezierPath bezierPathWithRect: r]
//#define  NSBezPath (r) 		AZBezPath(r)
//#define  AZQtzPath (r) 		[(AZBezPath(r)) quartzPath]

//#define AZContentBounds [[[ self window ] contentView] bounds]

//#import "extobjc_OSX/extobjc.h"
//@import Cocoa; 
//#import <QuartzCore/QuartzCore.h>
//@import WebKit;
//#import <WebKit/WebKit.h>
//#define SDDefaults [NSUserDefaults standardUserDefaults]
//
//#if defined(DEBUG)
//	#define SDLog(format, ...) NSLog(format, ##__VA_ARGS__)
//#else
//	#define SDLog(format, ...)
//#endif
//
//#define NSSTRINGF(x, args...) [NSString stringWithFormat:x , ## args]
//#define NSINT(x) [NSNumber numberWithInt:x]
//#define NSFLOAT(x) [NSNumber numberWithFloat:x]
//#define NSDOUBLE(x) [NSNumber numberWithDouble:x]
//#define NSBOOL(x) [NSNumber numberWithBool:x]
//
//#define SDInfoPlistValueForKey(key) [[NSBundle mainBundle] objectForInfoDictionaryKey:key]


// NSVALUE defined, see NSValue+AtoZ.h
//#define AZWindowPositionTypeArray @[@"Left",@"Bottom",@"Right",@"Top",@"TopLeft",@"BottomLeft",@"TopRight",@"BottomRight",@"Automatic"]
//#endif

//_EnumKind(AZQuad, AZQuadTopLeft, AZQuadTopRight, AZQuadBotRight, AZQuadBotLeft);
//#define QUAD AZQuad


//JREnum() is fine for when you have an enum that lives solely in an .m file. But if you're exposing an enum in a header file, you'll have to use the alternate macros. In your .h, use _EnumKind():
//	_EnumKind(StreamState,	   Stream_Disconnected,   	Stream_Connecting,                                                    										Stream_Connected, 		Stream_Disconnecting);
//And then use _EnumKind() in your .m:
//	_EnumKind(StreamState); for Free!!
// NSString* AZQuadrant2Text(int value);

//_EnumKind( AZQuadrant, AZTopLeftQuad = 0, AZTopRightQuad, AZBotRightQuad, AZBotLeftQuad);

//typedef NS_ENUM(NSUInteger, AZQuadrant){
//	AZTopLeftQuad = 0,
//	AZTopRightQuad,
//	AZBotRightQuad,
//	AZBotLeftQuad
//};


/*
 //#ifndef ATOZTOUCH
 typedef NS_OPTIONS(NSUInteger, AZWindowPosition) {
 AZLft 			= NSMinXEdge, // 0  NSDrawer
 AZRgt			= NSMaxXEdge, // 2  preferredEdge
 AZTop		   	= NSMaxYEdge, // 3  compatibility
 AZBtm			= NSMinYEdge, // 1  numbering!
 AZPositionTopLeft	   	= 4,
 AZPositionBottomLeft		= 5,
 AZPositionTopRight	 	= 6,
 AZPositionBottomRight   = 7,
 AZPositionAutomatic	 	= 8
 };// AZWindowPosition;
 */
//_EnumKind(AZPosition,
//	AZLft 			= 0,// NSMinXEdge, // 0  NSDrawer
//	AZRgt			= 2, //NSMaxXEdge, // 2  preferredEdge
//	AZTop		   	= 3, //NSMaxYEdge, // 3  compatibility
//	AZBtm			= 1,  //NSMinYEdge, // 1  numbering!
//	AZPositionTopLeft	   	= 4,
//	AZPositionBottomLeft		= 5,
//	AZPositionTopRight	 	= 6,
//	AZPositionBottomRight   = 7,
//	AZPositionAutomatic	 	= 8 );// AZWindowPosition;



//NSS* stringForPosition(AZWindowPosition enumVal);

//NS_INLINE NSS* stringForPosition(AZPOS e) {	_pos = _pos ?: [NSA arrayWithObjects:AZWindowPositionTypeArray];
//	return _pos.count >= e ? _pos[e] : @"outside of range for Positions";
//}
//NS_INLINE AZPOS positionForString(NSS* s)	{	_pos = _pos ?: [NSA arrayWithObjects:AZWindowPositionTypeArray];
//															return (AZPOS) [_pos indexOfObject:s];
//}

//JROptionsDeclare(AZAlign, 	AZAlignLeft       = flagbit1, //0x00000001,
//									AZAlignRight      = flagbit2, //0x00000010,
//									AZAlignTop        = flagbit3, //0x00000100,
//									AZAlignBottom     = flagbit4, //0x00001000,
//									AZAlignTopLeft    = flagbit5, //0x00000101,
//									AZAlignBottomLeft = flagbit6, //0x00001001,
//									AZAlignTopRight   = flagbit7, //0x00000110,
//									AZAlignBottomRight = flagbit8 // 0x00001010
//);


//_EnumKind (AZAlign,

//JROptionsDeclare(AZ_arc, 	AZ_arc_NA	       	= 0x00000001,
//					  AZ_arc_RO 	     		= 0x00000010,
//					  AZ_arc_STRNG	        	= 0x00000100,
//					  AZ_arc_ASSGN  		   	= 0x00001000,
//					  AZ_arc__COPY 		   	= 0x00010000,
//					  AZ_arc__WEAK				= 0x00100000);


//@import AtoZUniversal;
////#ifdef __OBJC__



//typedef enum {
//	JSON = 0,		 // explicitly indicate starting index
//	XML,
//	Atom,
//	RSS,
//
//	FormatTypeCount,  // keep track of the enum size automatically
//} FormatType;
//extern NSString *const FormatTypeName[FormatTypeCount];
//NSLog(@"%@", FormatTypeName[XML]);
//	// In a source file
//NSString *const FormatTypeName[FormatTypeCount] = {
//	[JSON] = @"JSON",
//	[XML] = @"XML",
//	[Atom] = @"Atom",
//	[RSS] = @"RSS",
//};
//typedef enum {
//	IngredientType_text  = 0,
//	IngredientType_audio = 1,
//	IngredientType_video = 2,
//	IngredientType_image = 3
//} IngredientType;
//write a method like this in class:
//+ (NSString*)typeStringForType:(IngredientType)_type {
//	NSString *key = [NSString stringWithFormat:@"IngredientType_%i", _type];
//	return NSLocalizedString(key, nil);
//}
//have the strings inside Localizable.strings file:
///* IngredientType_text */
//"IngredientType_0" = "Text";
///* IngredientType_audio */
//"IngredientType_1" = "Audio";
///* IngredientType_video */
//"IngredientType_2" = "Video";
///* IngredientType_image */
//"IngredientType_3" = "Image";
//

//typedef struct _GlossParameters{
//	CGFloat color[4];
//	CGFloat caustic[4];
//	CGFloat expCoefficient;
//	CGFloat expScale;
//	CGFloat expOffset;
//	CGFloat initialWhite;
//	CGFloat finalWhite;
//} GlossParameters;

//#endif


BOOL flag = YES;
NSLog(flag ? @"Yes" : @"No");
?: is the ternary conditional operator of the form:
condition ? result_if_true : result_if_false

#pragma - Log Functions

#ifdef DEBUG
#	define CWPrintClassAndMethod() NSLog(@"%s%i:\n",__PRETTY_FUNCTION__,__LINE__)
#	define CWDebugLog(args...) NSLog(@"%s%i: %@",__PRETTY_FUNCTION__,__LINE__,[NSString stringWithFormat:args])
#else
#	define CWPrintClassAndMethod() /**/
#	define CWDebugLog(args...) /**/
#endif

#define CWLog(args...) NSLog(@"%s%i: %@",__PRETTY_FUNCTION__,__LINE__,[NSString stringWithFormat:args])
#define CWDebugLocationString() [NSString stringWithFormat:@"%s[%i]",__PRETTY_FUNCTION__,__LINE__]

#define nilease(A) [A release]; A = nil

#define $affectors(A,...) +(NSSet *)keyPathsForValuesAffecting##A { static NSSet *re = nil; \
if (!re) { re = [[[@#__VA_ARGS__ splitByComma] trimmedStrings] set]; } return re; }


 static NSA* colors;  colors = colors ?: NSC.randomPalette;
 static NSUI idx = 0;
 va_list   argList;
 va_start (argList, format);
 NSS *path  	= [$UTF8(file) lastPathComponent];
 NSS *mess   = [NSString.alloc initWithFormat:format arguments:argList];
 //	NSS *justinfo = $(@"[%s]:%i",path.UTF8String, lineNumber);
 //	NSS *info   = [NSString stringWithFormat:@"word:%-11s rank:%u", [word UTF8String], rank];
 NSS *info 	= $( XCODE_COLORS_ESCAPE @"fg82,82,82;" @"  [%s]" XCODE_COLORS_RESET
 XCODE_COLORS_ESCAPE @"fg140,140,140;" @":%i" XCODE_COLORS_RESET	, path.UTF8String, lineNumber);
 int max 			= 130;
 int cutTo			= 22;
 BOOL longer 	= mess.length > max;
 NSC *c = [colors normal:idx];
 NSS *cs = $(@"%i%i%i",(int)c.redComponent, (int)c.greenComponent, (int)c.blueComponent); idx++;
 NSS* nextLine 	= longer ? $(XCODE_COLORS_ESCAPE @"fg%@;" XCODE_COLORS_RESET @"\n\t%@\n", cs, [mess substringFromIndex:max - cutTo]) : @"\n";
 mess 				= longer ? [mess substringToIndex:max - cutTo] : mess;
 int add = max - mess.length - cutTo;
 if (add > 0) {
 NSS *pad = [NSS.string stringByPaddingToLength:add withString:@" " startingAtIndex:0];
 info = [pad stringByAppendingString:info];
 }
 NSS *toLog 	= $(XCODE_COLORS_ESCAPE @"fg%@;" @"%@" XCODE_COLORS_RESET @"%@%@", cs, mess, info, nextLine);
 fprintf ( stderr, "%s", toLog.UTF8String);//[%s]:%i %s \n", [path UTF8String], lineNumber, [message UTF8String] );
 va_end  (argList);


	NSS *toLog 	= $( XCODE_COLORS_RESET	@"%s" XCODE_COLORS_ESCAPE @"fg82,82,82;" @"%-70s[%s]" XCODE_COLORS_RESET
									XCODE_COLORS_ESCAPE @"fg140,140,140;" @":%i\n" XCODE_COLORS_RESET	,
									mess.UTF8String, "", path.UTF8String, lineNumber);

	NSLog(XCODE_COLORS_ESCAPE @"bg89,96,105;" @"Grey background" XCODE_COLORS_RESET);
	NSLog(XCODE_COLORS_ESCAPE @"fg0,0,255;"
			XCODE_COLORS_ESCAPE @"bg220,0,0;"
			@"Blue text on red background"
//			XCODE_COLORS_RESET);

 if ( [[NSApplication sharedApplication] delegate] ) {
 id appD = [[NSApplication sharedApplication] delegate];
 //		fprintf ( stderr, "%s", [[appD description]UTF8String] );
 if ( [(NSObject*)appD respondsToSelector:NSSelectorFromString(@"stdOutView")]) {
 NSTextView *tv 	= ((NSTextView*)[appD valueForKey:@"stdOutView"]);
 if (tv) [tv autoScrollText:toLog];
 }
 }

 $(@"%s: %@", __PRETTY_FUNCTION__, [NSString stringWithFormat: args])	]
	const char *threadName = [[[NSThread currentThread] name] UTF8String];
}


#define AZTransition(duration, type, subtype) CATransition *transition = [CATransition animation];
[transition setDuration:1.0];
[transition setType:kCATransitionPush];
[transition setSubtype:kCATransitionFromLeft];
extern NSArray* AZConstraintEdgeExcept(AZCOn attr, rel, scale, off) \
[NSArray arrayWithArray:@[
AZConstRelSuper( kCAConstraintMaxX ),
AZConstRelSuper( kCAConstraintMinX ),
AZConstRelSuper( kCAConstraintWidth),
AZConstRelSuper( kCAConstraintMinY ),
AZConstRelSuperScaleOff(kCAConstraintHeight, .2, 0),

#define AZConst(attr, rel) \
[CAConstraint constraintWithAttribute: attr relativeTo: rel attribute: attr]
@property (nonatomic, assign) <\#type\#> <\#name\#>;
 AZConst(<\#CAConstraintAttribute\#>, <#\NSString\#>);
 AZConst(<#CAConstraintAttribute#>, <#NSString*#>);
#import "AtoZiTunes.h"

// Sweetness vs. longwindedness
//  BaseModel.h
//  Version 2.3.1
//  ARC Helper
//  Version 1.3.1

//  Weak delegate support
#ifndef ah_weak
#import <Availability.h>
#if (__has_feature(objc_arc)) && \
((defined __IPHONE_OS_VERSION_MIN_REQUIRED && \
__IPHONE_OS_VERSION_MIN_REQUIRED >= __IPHONE_5_0) || \
(defined __MAC_OS_X_VERSION_MIN_REQUIRED && \
__MAC_OS_X_VERSION_MIN_REQUIRED > __MAC_10_7))
#define ah_weak weak
#define __ah_weak __weak
#else
#define ah_weak unsafe_unretained
#define __ah_weak __unsafe_unretained
#endif
#endif
//  ARC Helper ends


#define AZRelease(value) \
if ( value ) { \
[value release]; \
value = nil; \
}

#define AZAssign(oldValue,newValue) \
[ newValue retain ]; \
AZRelease (oldValue); \
oldValue = newValue;


////#import <AppKit/AppKit.h>
//#import <Carbon/Carbon.h>
//#import <Quartz/Quartz.h>
////#import <Python/Python.h>
//#import <WebKit/WebView.h>
//#import <dispatch/dispatch.h>
//#import <Security/Security.h>
//#import <QuartzCore/QuartzCore.h>
//#import <AVFoundation/AVFoundation.h>
//#import <CoreServices/CoreServices.h>
//#import <AudioToolbox/AudioToolbox.h>
//#import <CoreFoundation/CoreFoundation.h>
//#import <ApplicationServices/ApplicationServices.h>
//#import <SystemConfiguration/SystemConfiguration.h>
//#import <CoreServices/CoreServices.h>

//  #import "AtoZGeometry.h"


//#define release self
//
//#define JROptionsDeclare(ENUM_TYPENAME...) _EnumKind(ENUM_TYPENAME,__VA_ARGS__)
//#define JROptionsDefine(X) _EnumKind(X)



/*! @abstract		Enforcement of compiler warning flags */

#ifndef __clang__
#error "Please consider using Clang as compiler!"
#endif

/*
#ifdef AZWARNINGS 

#pragma clang diagnostic fatal "-Wabi"
#pragma clang diagnostic fatal "-Waddress-of-temporary"
#pragma clang diagnostic fatal "-Waddress"
#pragma clang diagnostic fatal "-Waggregate-return"
#pragma clang diagnostic fatal "-Wall"
#pragma clang diagnostic fatal "-Wambiguous-member-template"
#pragma clang diagnostic fatal "-Warc-abi"
#pragma clang diagnostic fatal "-Warc-non-pod-memaccess"
#pragma clang diagnostic fatal "-Warc-retain-cycles"
#pragma clang diagnostic fatal "-Warc-unsafe-retained-assign"
#pragma clang diagnostic fatal "-Warc"
#pragma clang diagnostic fatal "-Watomic-properties"
#pragma clang diagnostic fatal "-Wattributes"
#pragma clang diagnostic fatal "-Wavailability"
#pragma clang diagnostic fatal "-Wbad-function-cast"
#pragma clang diagnostic fatal "-Wbind-to-temporary-copy"
#pragma clang diagnostic fatal "-Wbitwise-op-parentheses"
#pragma clang diagnostic fatal "-Wbool-conversions"
#pragma clang diagnostic fatal "-Wbuiltin-macro-redefined"
#pragma clang diagnostic fatal "-Wc++-compat"
#pragma clang diagnostic fatal "-Wc++0x-compat"
#pragma clang diagnostic fatal "-Wc++0x-extensions"
#pragma clang diagnostic fatal "-Wcast-align"
#pragma clang diagnostic fatal "-Wcast-qual"
#pragma clang diagnostic fatal "-Wchar-align"
#pragma clang diagnostic fatal "-Wchar-subscripts"
#pragma clang diagnostic fatal "-Wcomment"
#pragma clang diagnostic fatal "-Wcomments"
#pragma clang diagnostic fatal "-Wconditional-uninitialized"
#pragma clang diagnostic fatal "-Wconversion"
#pragma clang diagnostic fatal "-Wctor-dtor-privacy"
#pragma clang diagnostic fatal "-Wcustom-atomic-properties"
#pragma clang diagnostic fatal "-Wdeclaration-after-statement"
#pragma clang diagnostic fatal "-Wdelegating-ctor-cycles"
#pragma clang diagnostic fatal "-Wdelete-non-virtual-dtor"
#pragma clang diagnostic fatal "-Wdeprecated-declarations"
#pragma clang diagnostic fatal "-Wdeprecated-implementations"
#pragma clang diagnostic fatal "-Wdeprecated-writable-strings"
#pragma clang diagnostic fatal "-Wdeprecated"
#pragma clang diagnostic fatal "-Wdisabled-optimization"
#pragma clang diagnostic fatal "-Wdiscard-qual"
#pragma clang diagnostic fatal "-Wdiv-by-zero"
#pragma clang diagnostic fatal "-Wduplicate-method-arg"
#pragma clang diagnostic fatal "-Weffc++"
#pragma clang diagnostic fatal "-Wempty-body"
#pragma clang diagnostic fatal "-Wendif-labels"
#pragma clang diagnostic fatal "-Wexit-time-destructors"
#pragma clang diagnostic fatal "-Wextra-tokens"
#pragma clang diagnostic fatal "-Wextra"
#pragma clang diagnostic fatal "-Wformat-extra-args"
#pragma clang diagnostic fatal "-Wformat-nonliteral"
#pragma clang diagnostic fatal "-Wformat-zero-length"
#pragma clang diagnostic fatal "-Wformat"
#pragma clang diagnostic fatal "-Wformat=2"
#pragma clang diagnostic fatal "-Wfour-char-constants"
#pragma clang diagnostic fatal "-Wglobal-constructors"
#pragma clang diagnostic fatal "-Wgnu-designator"
#pragma clang diagnostic fatal "-Wgnu"
#pragma clang diagnostic fatal "-Wheader-hygiene"
#pragma clang diagnostic fatal "-Widiomatic-parentheses"
#pragma clang diagnostic fatal "-Wignored-qualifiers"
#pragma clang diagnostic fatal "-Wimplicit-atomic-properties"
#pragma clang diagnostic fatal "-Wimplicit-function-declaration"
#pragma clang diagnostic fatal "-Wimplicit-int"
#pragma clang diagnostic fatal "-Wimplicit"
#pragma clang diagnostic fatal "-Wimport"
#pragma clang diagnostic fatal "-Wincompatible-pointer-types"
#pragma clang diagnostic fatal "-Winit-self"
#pragma clang diagnostic fatal "-Winitializer-overrides"
#pragma clang diagnostic fatal "-Winline"
#pragma clang diagnostic fatal "-Wint-to-pointer-cast"
#pragma clang diagnostic fatal "-Winvalid-offsetof"
#pragma clang diagnostic fatal "-Winvalid-pch"
#pragma clang diagnostic fatal "-Wlarge-by-value-copy"
#pragma clang diagnostic fatal "-Wliteral-range"
#pragma clang diagnostic fatal "-Wlocal-type-template-args"
#pragma clang diagnostic fatal "-Wlogical-op-parentheses"
#pragma clang diagnostic fatal "-Wlong-long"
#pragma clang diagnostic fatal "-Wmain"
#pragma clang diagnostic fatal "-Wmicrosoft"
#pragma clang diagnostic fatal "-Wmismatched-tags"
#pragma clang diagnostic fatal "-Wmissing-braces"
#pragma clang diagnostic fatal "-Wmissing-declarations"
#pragma clang diagnostic fatal "-Wmissing-field-initializers"
#pragma clang diagnostic fatal "-Wmissing-format-attribute"
#pragma clang diagnostic fatal "-Wmissing-include-dirs"
#pragma clang diagnostic fatal "-Wmissing-noreturn"
#pragma clang diagnostic fatal "-Wmost"
#pragma clang diagnostic fatal "-Wmultichar"
#pragma clang diagnostic fatal "-Wnested-externs"
#pragma clang diagnostic fatal "-Wnewline-eof"
#pragma clang diagnostic fatal "-Wnon-gcc"
#pragma clang diagnostic fatal "-Wnon-virtual-dtor"
#pragma clang diagnostic fatal "-Wnonnull"
#pragma clang diagnostic fatal "-Wnonportable-cfstrings"
#pragma clang diagnostic fatal "-Wnull-dereference"
#pragma clang diagnostic fatal "-Wobjc-nonunified-exceptions"
#pragma clang diagnostic fatal "-Wold-style-cast"
#pragma clang diagnostic fatal "-Wold-style-definition"
#pragma clang diagnostic fatal "-Wout-of-line-declaration"
#pragma clang diagnostic fatal "-Woverflow"
#pragma clang diagnostic fatal "-Woverlength-strings"
#pragma clang diagnostic fatal "-Woverloaded-virtual"
#pragma clang diagnostic fatal "-Wpacked"
#pragma clang diagnostic fatal "-Wparentheses"
#pragma clang diagnostic fatal "-Wpointer-arith"
#pragma clang diagnostic fatal "-Wpointer-to-int-cast"
#pragma clang diagnostic fatal "-Wprotocol"
#pragma clang diagnostic fatal "-Wreadonly-setter-attrs"
#pragma clang diagnostic fatal "-Wredundant-decls"
#pragma clang diagnostic fatal "-Wreorder"
#pragma clang diagnostic fatal "-Wreturn-type"
#pragma clang diagnostic fatal "-Wself-assign"
#pragma clang diagnostic fatal "-Wsemicolon-before-method-body"
#pragma clang diagnostic fatal "-Wsequence-point"
#pragma clang diagnostic fatal "-Wshadow"
#pragma clang diagnostic fatal "-Wshorten-64-to-32"
#pragma clang diagnostic fatal "-Wsign-compare"
#pragma clang diagnostic fatal "-Wsign-promo"
#pragma clang diagnostic fatal "-Wsizeof-array-argument"
#pragma clang diagnostic fatal "-Wstack-protector"
#pragma clang diagnostic fatal "-Wstrict-aliasing"
#pragma clang diagnostic fatal "-Wstrict-overflow"
#pragma clang diagnostic fatal "-Wstrict-prototypes"
#pragma clang diagnostic fatal "-Wstrict-selector-match"
#pragma clang diagnostic fatal "-Wsuper-class-method-mismatch"
#pragma clang diagnostic fatal "-Wswitch-default"
#pragma clang diagnostic fatal "-Wswitch-enum"
#pragma clang diagnostic fatal "-Wswitch"
#pragma clang diagnostic fatal "-Wsynth"
#pragma clang diagnostic fatal "-Wtautological-compare"
#pragma clang diagnostic fatal "-Wtrigraphs"
#pragma clang diagnostic fatal "-Wtype-limits"
#pragma clang diagnostic fatal "-Wundeclared-selector"
#pragma clang diagnostic fatal "-Wuninitialized"
#pragma clang diagnostic fatal "-Wunknown-pragmas"
#pragma clang diagnostic fatal "-Wunnamed-type-template-args"
#pragma clang diagnostic fatal "-Wunneeded-internal-declaration"
#pragma clang diagnostic fatal "-Wunneeded-member-function"
#pragma clang diagnostic fatal "-Wunused-argument"
#pragma clang diagnostic fatal "-Wunused-exception-parameter"
#pragma clang diagnostic fatal "-Wunused-function"
#pragma clang diagnostic fatal "-Wunused-label"
#pragma clang diagnostic fatal "-Wunused-member-function"
#pragma clang diagnostic fatal "-Wunused-parameter"
#pragma clang diagnostic fatal "-Wunused-value"
#pragma clang diagnostic fatal "-Wunused-variable"
#pragma clang diagnostic fatal "-Wunused"
#pragma clang diagnostic fatal "-Wused-but-marked-unused"
#pragma clang diagnostic fatal "-Wvector-conversions"
#pragma clang diagnostic fatal "-Wvla"
#pragma clang diagnostic fatal "-Wvolatile-register-var"
#pragma clang diagnostic fatal "-Wwrite-strings"
*/

/* Not wanted:*/
/*
#pragma clang diagnostic ignored "-Wgnu"
#pragma clang diagnostic ignored "-Wpadded"
#pragma clang diagnostic ignored "-Wselector"
#pragma clang diagnostic ignored "-Wvariadic-macros"
*/

/*
* Not recognized by Apple implementation:
* 
* #pragma clang diagnostic fatal "-Wdefault-arg-special-member"
* #pragma clang diagnostic fatal "-Wauto-import"
* #pragma clang diagnostic fatal "-Wbuiltin-requires-header"
* #pragma clang diagnostic fatal "-Wc++0x-narrowing"
* #pragma clang diagnostic fatal "-Wc++11-compat"
* #pragma clang diagnostic fatal "-Wc++11-extensions"
* #pragma clang diagnostic fatal "-Wc++11-narrowing"
* #pragma clang diagnostic fatal "-Wc++98-compat-bind-to-temporary-copy"
* #pragma clang diagnostic fatal "-Wc++98-compat-local-type-template-args"
* #pragma clang diagnostic fatal "-Wc++98-compat-pedantic"
* #pragma clang diagnostic fatal "-Wc++98-compat-unnamed-type-template-args"
* #pragma clang diagnostic fatal "-Wc1x-extensions"
* #pragma clang diagnostic fatal "-Wc99-extensions"
* #pragma clang diagnostic fatal "-Wcatch-incomplete-type-extensions"
* #pragma clang diagnostic fatal "-Wduplicate-method-match"
* #pragma clang diagnostic fatal "-Wflexible-array-extensions"
* #pragma clang diagnostic fatal "-Wmalformed-warning-check"
* #pragma clang diagnostic fatal "-Wmissing-method-return-type"
* #pragma clang diagnostic fatal "-Wmodule-build"
* #pragma clang diagnostic fatal "-WNSObject-attribute"
* #pragma clang diagnostic fatal "-Wnull-character"
* #pragma clang diagnostic fatal "-Wobjc-missing-super-calls"
* #pragma clang diagnostic fatal "-Wobjc-noncopy-retain-block-property"
* #pragma clang diagnostic fatal "-Wobjc-property-implementation"
* #pragma clang diagnostic fatal "-Wobjc-protocol-method-implementation"
* #pragma clang diagnostic fatal "-Wobjc-readonly-with-setter-property"
* #pragma clang diagnostic fatal "-Woverriding-method-mismatch"
* #pragma clang diagnostic fatal "-Wsentinel"
* #pragma clang diagnostic fatal "-Wunicode"
* #pragma clang diagnostic fatal "-Wunused-comparison"
* #pragma clang diagnostic fatal "-Wunused-result"
* #pragma clang diagnostic fatal "-Wuser-defined-literals"

#endif

*/

/*
//	#import <objc/message.h>
//	#import <objc/runtime.h>
//	#import <libkern/OSAtomic.h>

	#import <Availability.h>
	#import <TargetConditionals.h>
	#if TARGET_OS_IPHONE && __IPHONE_OS_VERSION_MIN_REQUIRED
	#import <SystemConfiguration/SystemConfiguration.h>
	#import <MobileCoreServices/MobileCoreServices.h>
	#import <sys/xattr.h>
	#else
	#import <objc/NSObjCRuntime.h>

	#import <pwd.h>
	#import <stdio.h>
	#import <netdb.h>
	#import <dirent.h>
	#import <unistd.h>
	#import <stdarg.h>
	#import <xpc/xpc.h>
	#import <sys/time.h>
	#import <sys/ioctl.h>
	#import <sys/sysctl.h>
	#import <sys/stat.h>
	#import <sys/types.h>
	#import <sys/xattr.h>
	#import <arpa/inet.h>
	#import <objc/objc.h>
	#import <netinet/in.h>

	#import <objc/message.h>
	#import <objc/runtime.h>
	#import <libkern/OSAtomic.h>


	#import <Foundation/NSObjCRuntime.h>
	#import "AZObserversAndBinders.h"
	#import <TwUI/TwUI.h>



//	#import <extobjc_OSX/e.h>
//	#import "extobjc_OSX/extobjc.h"
//	#import <extobjc/metamacros.h>

	#import <FunSize/FunSize.h>
	#import <DrawKit/DrawKit.h>
//	#import "AtoZAutoBox/NSObject+DynamicProperties.h"
  #import <AtoZAppKit/AtoZAppKit.h>
	#import <BlocksKit/BlocksKit.h>
	#import <CocoaPuffs/CocoaPuffs.h>
	#import <AtoZBezierPath/AtoZBezierPath.h>
	#import "AtoZAutoBox/AtoZAutoBox.h"
	#import "KVOMap/KVOMap.h"

//	#import "GCDAsyncSocket.h"
//	#import "GCDAsyncSocket+AtoZ.h"
	#import "objswitch.h"

	#import "AtoZGeometry.h"
	#import "AtoZCategories.h"
	  #import "BlocksAdditions.h"
  #import "SynthesizeSingleton.h"

//	#import "GCDAsyncSocket.h"
//	#import "HTTPServer.h"

	#define EXCLUDE_STUB_PROTOTYPES 1
	#import <PLWeakCompatibility/PLWeakCompatibilityStubs.h>
	#import <MenuApp/MenuApp.h>
#import <Rebel/Rebel.h>
	#import <KSHTMLWriterKit/KSHTMLWriterKit.h>
	#import <NanoStore/NanoStore.h>

#import <ApplicationServices/ApplicationServices.h>
#import "BaseModel.h"
//	#import <AIUtilities/AIUtilities.h>
	#import "NSTerminal.h"

	#define release 			self										// Is this right?  Why's mine different?
  #define autorelease 		self										// But shit hits fan without.

	#import "AZLog.h"
	#import "NSUserDefaults+Subscript.h"
	#import "AZProcess.h"

//#endif  //  END AZFRAMEWORK PCH  #ifdef __OBJC__
#ifndef _OmniBase_assertions_h_
#define _OmniBase_assertions_h_
//#import <OmniBase/FrameworkDefines.h>
//#if defined(DEBUG) || defined(OMNI_FORCE_ASSERTIONS)
//#define OMNI_ASSERTIONS_ON
//#endif
//#if defined(OMNI_FORCE_ASSERTIONS_OFF)					// This allows you to turn off assertions when debugging
#undef OMNI_ASSERTIONS_ON
//#warning Forcing assertions off!
//#endif
// Make sure that we don't accidentally use the ASSERT macro instead of OBASSERT
#ifdef ASSERT
#undef ASSERT
#endif
typedef void (*OBAssertionFailureHandler)(const char *type, const char *expression, const char *file, unsigned int lineNumber);
#if defined(OMNI_ASSERTIONS_ON)
OmniBase_EXTERN void OBSetAssertionFailureHandler(OBAssertionFailureHandler handler);
OmniBase_EXTERN void OBAssertFailed(const char *type, const char *expression, const char *file, unsigned int lineNumber);
#define OBPRECONDITION(expression)	do{if(!(expression))OBAssertFailed("PRECONDITION", #expression,__FILE__,__LINE__);}while(NO)
#define OBPOSTCONDITION(expression)	do{if(!(expression))OBAssertFailed("POSTCONDITION",#expression,__FILE__,__LINE__);}while(NO)
#define OBINVARIANT(expression)		do{if(!(expression))OBAssertFailed("INVARIANT",    #expression,__FILE__,__LINE__);}while(NO)
#define OBASSERT(expression)			do{if(!(expression))OBAssertFailed("ASSERT", 		#expression,__FILE__,__LINE__);}while(NO)
#define OBASSERT_NOT_REACHED(reason)do{					  OBAssertFailed("NOTREACHED", 	     reason,__FILE__,__LINE__);}while(NO)
#else	// else insert blank lines into the code
#define OBPRECONDITION(expression)
#define OBPOSTCONDITION(expression)
#define OBINVARIANT(expression)
#define OBASSERT(expression)
#define OBASSERT_NOT_REACHED(reason)
#endif
#endif // _OmniBase_assertions_h_

#endif

#import <MapKit/MapKit.h>
#import <Nu/Nu.h>
#import <Lumberjack/Lumberjack.h>
#import <XPCKit/XPCKit.h>
#import <SNRHUDKit/SNRHUDKit.h>
#import <AtoZUI/AtoZUI.h>
#import <libatoz.h>

#import "AutoCoding.h"
#import "HRCoder.h"
*/
/*
 #import "GTMHTTPFetcher.h"
 
 #import "AddressBookImageLoader.h"
 #import "AFHTTPClient.h"
 #import "AFHTTPRequestOperation.h"
 #import "AFImageRequestOperation.h"
 #import "AFJSONRequestOperation.h"
 #import "AFNetworking.h"
 #import "AFPropertyListRequestOperation.h"
 #import "AFURLConnectionOperation.h"
 #import "AFXMLRequestOperation.h"
 #import "AGNSSplitView.h"
 #import "AGNSSplitViewDelegate.h"
 #import "AZProcess.h"
 #import "AHLayout.h"
 #import "ASICacheDelegate.h"
 #import "ASIDataCompressor.h"
 #import "ASIDataDecompressor.h"
 #import "ASIDownloadCache.h"
 #import "ASIFormDataRequest.h"
 #import "ASIHTTPRequest.h"
 #import "ASIHTTPRequestConfig.h"
 #import "ASIHTTPRequestDelegate.h"
 #import "ASIInputStream.h"
 #import "ASINetworkQueue.h"
 #import "ASIProgressDelegate.h"

#import "AssetCollection.h"
#import <AtoZ/AtoZ.h>
#import "AtoZColorWell.h"
#import "AtoZFunctions.h"
#import "AtoZGeometry.h"
#import "AtoZGridView.h"
#import "AtoZGridViewProtocols.h"
#import "AtoZInfinity.h"
#import "AtoZModels.h"
#import "AtoZStack.h"

#import "AtoZWebSnapper.h"
#import "AtoZWebSnapperGridViewController.h"
#import "AtoZWebSnapperWindowController.h"
#import "AutoCoding.h"
#import "AZApplePrivate.h"
#import "AZASIMGV.h"
#import "AZAttachedWindow.h"
#import "AZAXAuthorization.h"
#import "AZBackground.h"
#import "AZBackgroundProgressBar.h"
#import "AZBlockView.h"
#import "AZBorderlessResizeWindow.h"
#import "AZBox.h"
#import "AZBoxGrid.h"
#import "AZBoxMagic.h"
#import "AZButton.h"
#import "AZCalculatorController.h"
#import "AZCLI.h"
#import "AZCLICategories.h"
#import "AZCLITests.h"
#import "AZCoreScrollView.h"
#import "AZCSSColorExtraction.h"
#import "AZDarkButtonCell.h"
#import "AZDebugLayer.h"
#import "AZDockQuery.h"
#import "AZExpandableView.h"
#import "AZFacebookConnection.h"
#import "AZFavIconManager.h"
#import "AZFile.h"
#import "AZFoamView.h"
#import "AZGrid.h"
#import "AZHomeBrew.h"
#import "AZHostView.h"
#import "AZHoverButton.h"
#import "AZHTMLParser.h"
#import "AZHTTPRouter.h"
#import "AZHTTPURLProtocol.h"
#import "AZImageToDataTransformer.h"
#import "AZIndeterminateIndicator.h"
#import "AZInfiniteCell.h"
#import "AZInstantApp.h"
#import "AZLassoLayer.h"
#import "AZLassoView.h"
#import "AZLaunchServices.h"
#import "AZLayer.h"
#import "AZMatrix.h"
#import "AZMatteButton.h"
#import "AZMatteFocusedGradientBox.h"
#import "AZMattePopUpButton.h"
#import "AZMattePopUpButtonView.h"
#import "AZMatteSegmentedControl.h"
#import "AZMedallionView.h"
#import "AZMouser.h"
#import "AZNamedColors.h"
#import "AZPoint.h"
#import "AZPopupWindow.h"
#import "AZPrismView.h"
#import "AZProgressIndicator.h"
#import "AZPropellerView.h"
#import "AZProportionalSegmentController.h"
#import "AZQueue.h"
#import "AZRect.h"
#import "AZScrollerLayer.h"
#import "AZScrollerProtocols.h"
#import "AZScrollPaneLayer.h"
#import "AZSegmentedRect.h"
#import "AZSemiResponderWindow.h"
#import "AZSimpleView.h"
#import "AZSize.h"
#import "AZSizer.h"
#import "AZSnapShotLayer.h"
#import "AZSound.h"
#import "AZSourceList.h"
#import "AZSpeechRecognition.h"
#import "AZSpinnerLayer.h"
#import "AZStopwatch.h"
  #import "AZTalker.h"
#import "AZTimeLineLayout.h"
#import "AZToggleArrayView.h"
#import "AZTrackingWindow.h"
#import "AZURLSnapshot.h"
#import "AZVeil.h"
#import "AZWeakCollections.h"
#import "AZWikipedia.h"
#import "AZWindowExtend.h"
#import "AZXMLWriter.h"
 #import "BaseModel.h"
 #import "BaseModel+AtoZ.h"
 #import "BBMeshView.h"
 #import "BlocksAdditions.h"
 #import "Bootstrap.h"
 #import "CAAnimation+AtoZ.h"
 #import "CALayer+AtoZ.h"
 #import "CalcModel.h"
 #import "CAScrollView.h"
 #import "CAWindow.h"
 #import "CKAdditions.h"
 #import "CKMacros.h"
 #import "CKSingleton.h"
 #import "ConciseKit.h"
 #import "ConcurrentOperation.h"
 #import "CPAccelerationTimer.h"
 #import "CTBadge.h"
 #import "CTGradient.h"
 #import "DDData.h"
 #import "DDNumber.h"
 #import "DDRange.h"
 #import "EGOCache.h"
 #import "EGOImageLoadConnection.h"
 #import "EGOImageLoader.h"
 #import "EGOImageView.h"
 #import "F.h"
 #import "GCDAsyncSocket.h"
 //#import "GTMHTTPFetcher.h"
 //#import "GTMNSString+HTML.h"
 #import "HRCoder.h"
 #import "HTMLNode.h"
 #import "HTMLParserViewController.h"
 #import "HTTPAsyncFileResponse.h"
 #import "HTTPAuthenticationRequest.h"
 #import "HTTPConnection.h"
 #import "HTTPDataResponse.h"
 #import "HTTPDynamicFileResponse.h"
 #import "HTTPErrorResponse.h"
 #import "HTTPFileResponse.h"
 #import "HTTPLogging.h"
 #import "HTTPMessage.h"
 #import "HTTPRedirectResponse.h"
 #import "HTTPResponse.h"
 #import "HTTPResponseProxy.h"
 #import "HTTPServer.h"
 #import "iCarousel.h"
 #import "IGIsolatedCookieWebView.h"
 #import "INAppStoreWindow.h"
 #import "JsonElement.h"
 #import "JSONKit.h"
 #import "KGNoise.h"
 #import "LetterView.h"
 #import "LoremIpsum.h"
 #import "MAAttachedWindow.h"
 #import "MAKVONotificationCenter.h"
#import "MArray.h"
 #import "MediaServer.h"
 #import "MetalUI.h"
 #import "MultipartFormDataParser.h"
 #import "MultipartMessageHeader.h"
 #import "MultipartMessageHeaderField.h"
 #import "NotificationCenterSpy.h"
 #import "NSApplication+AtoZ.h"
 #import "NSArray+AtoZ.h"
 #import "NSArray+ConciseKit.h"
 #import "NSArray+F.h"
 #import "NSArray+UsefulStuff.h"
 #import "NSBag.h"
 #import "NSBezierPath+AtoZ.h"

 #import "NSCell+AtoZ.h"
 #import "NSColor+AtoZ.h"
 #import "NSDate+AtoZ.h"
 #import "NSDictionary+AtoZ.h"
 #import "NSDictionary+ConciseKit.h"
 #import "NSDictionary+F.h"
 #import "NSError+AtoZ.h"
 #import "NSEvent+AtoZ.h"
 #import "NSFileManager+AtoZ.h"
 #import "NSFont+AtoZ.h"
 #import "NSHTTPCookie+Testing.h"
 #import "NSImage-Tint.h"
 #import "NSImage+AtoZ.h"
 #import "NSIndexSet+AtoZ.h"
 #import "AZLogConsole.h"
 #import "NSNotificationCenter+AtoZ.h"
 #import "NSNumber+AtoZ.h"
 #import "NSNumber+F.h"
 #import "NSObject-Utilities.h"

 #import "NSObject+Properties.h"

 #import "NSOrderedDictionary.h"
 #import "NSOutlineView+AtoZ.h"
 #import "NSScreen+AtoZ.h"
 #import "NSShadow+AtoZ.h"
 #import "NSSplitView+DMAdditions.h"
 #import "NSString+AtoZ.h"
 #import "NSString+AtoZEnums.h"
 #import "NSString+ConciseKit.h"
 #import "NSString+PathAdditions.h"
 #import "NSString+URLAdditions.h"
 #import "NSString+UUID.h"
 #import "NSTableView+AtoZ.h"
 #import "NSTask+OneLineTasksWithOutput.h"
 #import "NSTextView+AtoZ.h"
 #import "NSThread+AtoZ.h"
 #import "NSURL+AtoZ.h"
 #import "NSUserDefaults+Subscript.h"
 #import "NSValue+AtoZ.h"
 #import "NSView+AtoZ.h"
 #import "NSWindow_Flipr.h"
 #import "NSWindow+AtoZ.h"

 #import "OperationsRunner.h"
 #import "OperationsRunnerProtocol.h"
 #import "PreferencesController.h"
 #import "PXListDocumentView.h"
 #import "PXListView.h"
 #import "PXListViewCell.h"
 #import "PythonOperation.h"
 #import "RoundedView.h"
 #import "Route.h"
 #import "RouteRequest.h"
 #import "RouteResponse.h"
 #import "RoutingConnection.h"
 #import "RoutingHTTPServer.h"
 #import "RuntimeReporter.h"
 #import "SDCloseButtonCell.h"
 #import "SDCommonAppDelegate.h"
 #import "SDDefines.h"
 #import "SDFoundation.h"
 #import "SDInsetDividerView.h"
 #import "SDInsetTextField.h"
 #import "SDInstructionsWindow.h"
 #import "SDInstructionsWindowController.h"
 #import "SDIsNotEmptyValueTransformer.h"
 #import "SDNextRunloopProxy.h"
 #import "SDOpenAtLoginController.h"
 #import "SDPreferencesController.h"
 #import "SDRoundedInstructionsImageView.h"
 #import "SDSingleton.h"
 #import "SDToolkit.h"
 #import "SDWindowController.h"
 #import "SIAppCookieJar.h"
 #import "SIAuthController.h"
 #import "SIConstants.h"
 #import "SIInboxDownloader.h"
 #import "SIInboxModel.h"
 #import "SIViewControllers.h"
 #import "SIWindow.h"
 #import "SNRHUDButtonCell.h"
 #import "SNRHUDScrollView.h"
 #import "SNRHUDSegmentedCell.h"
 #import "SNRHUDTextFieldCell.h"
 #import "SNRHUDTextView.h"
 #import "SNRHUDWindow.h"
 #import "StandardPaths.h"
 #import "StarLayer.h"

 #import "StickyNoteView.h"
 #import "Transition.h"
 #import "TransparentWindow.h"
 #import "TUIView+Dimensions.h"
 #import "WebFetcher.h"
 #import "WebSocket.h"
 #import "WebView+AtoZ.h"
 #import "XLDragDropView.h"

#import <AtoZ/AtoZ.h>*/ 
 

/*
#import "AtoZFunctions.h"
#import "BaseModel.h"
#import "BaseModel+AtoZ.h"
//#import <AtoZ/AtoZ.h>
#import "SNRHUDButtonCell.h"
#import "SNRHUDImageCell.h"
#import "SNRHUDScrollView.h"
#import "SNRHUDSegmentedCell.h"
#import "SNRHUDTextFieldCell.h"
#import "SNRHUDTextView.h"
#import "SNRHUDWindow.h"

#import "NSObject+AutoMagicCoding.h"
#import "AZSizer.h"
#import "AZObject.h"
#import "AZFile.h"
#import "AZGeometry.h"
#import "Nu.h"

#define NSLog(__VA_ARGS__) NSLog(@"[%s:%d]: %@", __FILE__, __LINE__, [NSString stringWithFormat:__VA_ARGS__])
	#define NSLog(args...) QuietLog(__FILE__,__LINE__,__PRETTY_FUNCTION__,args)
#define NSLog(...) qlog(format,...) {\
#else
# define NSLog(…) 
#endif

#define NSLog(...) NSLog(__VA_ARGS__) {\
va_list argList;\
va_start(argList, format);\
NSString *file = [[NSString stringWithUTF8String:__FILE__] lastPathComponent]; \
printf("%s:%d - ", [file UTF8String], __LINE__); \
QuietLog((format),##__VA_ARGS__); \
}

if (format == nil) {	printf("nil\n"); return; }\
va_list argList;\
va_start(argList, format);\
NSString *s = [NSString.alloc initWithFormat:format arguments:argList];\
printf("%s\n", [[s stringByReplacingOccurrencesOfString:@"%%" withString:@"%%%%"] UTF8String]);\
[s release];\
va_end(argList);\
}

{ \
NSString *file = [[NSString stringWithUTF8String:__FILE__] lastPathComponent]; \
printf("%s:%d - ", [file UTF8String], __LINE__); \
QuietLog((format),##__VA_ARGS__); \
}
	#define NSLog(format,...) { \
	NSString *file = [[NSString stringWithUTF8String:__FILE__] lastPathComponent]; \
	printf("%s:%d - ", [file UTF8String], __LINE__); \
	QuietLog((format),##__VA_ARGS__);	}
#endif
static inline BOOL IsEmpty(id thing);
	return thing ?: [thing respondsToSelector:@selector(length)] && [ (NSD*)thing length]
				 ?: [thing respondsToSelector:@selector(count) ] && [ (NSA*)thing count ]
					NO;
}

 StringConsts.h
#ifdef SYNTHESIZE_CONSTS
# define STR_CONST(name, value) NSString* const name = @ value
#else
# define STR_CONST(name, value) extern NSString* const name
#endif

The in my .h/.m pair where I want to define the constant I do the following:
 myfile.h
#import <StringConsts.h>
STR_CONST(MyConst, "Lorem Ipsum");
STR_CONST(MyOtherConst, "Hello world");
 myfile.m
#define SYNTHESIZE_CONSTS
#import "myfile.h"
#undef SYNTHESIZE_CONSTS



*/


/*
@interface NSColor (AIColorAdditions_HLS) Linearly adjust a color
- (NSC*)adjustHue:(CGFloat)dHue saturation:(CGFloat)dSat brightness:(CGFloat)dBrit;
@end


@implementation NSColor (AIColorAdditions_RepresentingColors)
- (NSString*)hexString
{
	CGFloat 	red,green,blue;
	char	hexString[7];
	NSInteger		tempNum;
	NSColor	*convertedColor;
	convertedColor = [self colorUsingColorSpaceName:NSCalibratedRGBColorSpace];
	[convertedColor getRed:&red green:&green blue:&blue alpha:NULL];
	tempNum = (red * 255.0f);
	hexString[0] = intToHex(tempNum / 16);
	hexString[1] = intToHex(tempNum % 16);
	tempNum = (green * 255.0f);
	hexString[2] = intToHex(tempNum / 16);
	hexString[3] = intToHex(tempNum % 16);
	tempNum = (blue * 255.0f);
	hexString[4] = intToHex(tempNum / 16);
	hexString[5] = intToHex(tempNum % 16);
	hexString[6] = '\0';
	return [NSString stringWithUTF8String:hexString];
}
//String representation: R,G,B[,A].
- (NSString*)stringRepresentation
{
	NSColor	*tempColor = [self colorUsingColorSpaceName:NSCalibratedRGBColorSpace];
	CGFloat alphaComponent = [tempColor alphaComponent];
	if (alphaComponent == 1.0)	{
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
}
//- (NSString*)CSSRepresentation
//{
//	CGFloat alpha = [self alphaComponent];
//	if ( (1.0 - alpha)	>= 0.000001)	{
//		NSColor *rgb = [self colorUsingColorSpaceName:NSCalibratedRGBColorSpace];
//		//CSS3 defines rgba()	to take 0..255 for the color components, but 0..1 for the alpha component. Thus, we must multiply by 255 for the color components, but not for the alpha component.
//		return [NSString stringWithFormat:@"rgba(%@,%@,%@,%@)",
//			[NSString stringWithCGFloat:[rgb redComponent]   * 255.0f maxDigits:6],
//			[NSString stringWithCGFloat:[rgb greenComponent] * 255.0f maxDigits:6],
//			[NSString stringWithCGFloat:[rgb blueComponent]  * 255.0f maxDigits:6],
//			[NSString stringWithCGFloat:alpha						 maxDigits:6]];
//	} else {
//		return [@"#" stringByAppendingString:[self hexString]];
//	}
//}
@end
@implementation NSString (AIColorAdditions_RepresentingColors)
- (NSC*)representedColor
{
	CGFloat	r = 255, g = 255, b = 255;
	CGFloat	a = 255;
	const char *selfUTF8 = [self UTF8String];
	//format: r,g,b[,a]
	//all components are decimal numbers 0..255.
	if (!isdigit(*selfUTF8))	goto scanFailed;
	r = (CGFloat)strtoul(selfUTF8, (char **)&selfUTF8, / * base * / 10);
	if(*selfUTF8 == ',')	++selfUTF8;
	else				 goto scanFailed;
	if (!isdigit(*selfUTF8))	goto scanFailed;
	g = (CGFloat)strtoul(selfUTF8, (char **)&selfUTF8, / * base * / 10);
	if(*selfUTF8 == ',')	++selfUTF8;
	else				 goto scanFailed;
	if (!isdigit(*selfUTF8))	goto scanFailed;
	b = (CGFloat)strtoul(selfUTF8, (char **)&selfUTF8, / * base * / 10);
	if (*selfUTF8 == ',')	{
		++selfUTF8;
		a = (CGFloat)strtoul(selfUTF8, (char **)&selfUTF8, / * base * / 10);
		if (*selfUTF8)	goto scanFailed;
	} else if (*selfUTF8 != '\0')	{
		goto scanFailed;
	}
	return [NSColor colorWithCalibratedRed:(r/255)	green:(g/255)	blue:(b/255)	alpha:(a/255)] ;
scanFailed:
	return nil;
}
- (NSC*)representedColorWithAlpha:(CGFloat)alpha
{
	//this is the same as above, but the alpha component is overridden.
  NSUInteger	r, g, b;
	const char *selfUTF8 = [self UTF8String];
	//format: r,g,b
	//all components are decimal numbers 0..255.
	if (!isdigit(*selfUTF8))	goto scanFailed;
	r = strtoul(selfUTF8, (char **)&selfUTF8, / * base * / 10);
	if (*selfUTF8 != ',')	goto scanFailed;
	++selfUTF8;
	if (!isdigit(*selfUTF8))	goto scanFailed;
	g = strtoul(selfUTF8, (char **)&selfUTF8, / * base * / 10);
	if (*selfUTF8 != ',')	goto scanFailed;
	++selfUTF8;
	if (!isdigit(*selfUTF8))	goto scanFailed;
	b = strtoul(selfUTF8, (char **)&selfUTF8, / * base * / 10);
	return [NSColor colorWithCalibratedRed:(r/255)	green:(g/255)	blue:(b/255)	alpha:alpha];
scanFailed:
	return nil;
}
@end
@implementation NSColor (AIColorAdditions_RandomColor)
+ (NSC*)randomColor
{
	return [NSColor colorWithCalibratedRed:(arc4random()	% 65536)	/ 65536.0f
									 green:(arc4random()	% 65536)	/ 65536.0f
									  blue:(arc4random()	% 65536)	/ 65536.0f
									 alpha:1.0f];
}
+ (NSC*)randomColorWithAlpha
{
	return [NSColor colorWithCalibratedRed:(arc4random()	% 65536)	/ 65536.0f
									 green:(arc4random()	% 65536)	/ 65536.0f
									  blue:(arc4random()	% 65536)	/ 65536.0f
									 alpha:(arc4random()	% 65536)	/ 65536.0f];
}
@end
@implementation NSColor (AIColorAdditions_HTMLSVGCSSColors)
//+ colorWithHTMLString:(NSString*)str
//{
//	return [self colorWithHTMLString:str defaultColor:nil];
//}
/ * !
 * @brief Convert one or two hex characters to a float
 *
 * @param firstChar The first hex character
 * @param secondChar The second hex character, or 0x0 if only one character is to be used
 * @result The float value. Returns 0 as a bailout value if firstChar or secondChar are not valid hexadecimal characters ([0-9]|[A-F]|[a-f]). Also returns 0 if firstChar and secondChar equal 0.
 * /
static CGFloat hexCharsToFloat(char firstChar, char secondChar)
{
	CGFloat				hexValue;
	NSUInteger		firstDigit;
	firstDigit = hexToInt(firstChar);
	if (firstDigit != -1)	{
		hexValue = firstDigit;
		if (secondChar != 0x0)	{
			int secondDigit = hexToInt(secondChar);
			if (secondDigit != -1)
				hexValue = (hexValue * 16.0f + secondDigit)	/ 255.0f;
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

+ colorWithHTMLString:(NSString*)str defaultColor:(NSC*)defaultColor
{
	if (!str)	return defaultColor;
	NSUInteger strLength = [str length];
	NSString *colorValue = str;
	if ([str hasPrefix:@"rgb"])	{
		NSUInteger leftParIndex = [colorValue rangeOfString:@"("].location;
		NSUInteger rightParIndex = [colorValue rangeOfString:@")"].location;
		if (leftParIndex == NSNotFound || rightParIndex == NSNotFound)
		{
			NSLog(@"+[NSColor(AIColorAdditions)	colorWithHTMLString:] called with unrecognised color function (str is %@); returning %@", str, defaultColor);
			return defaultColor;
		}
		leftParIndex++;
		NSRange substrRange = NSMakeRange(leftParIndex, rightParIndex - leftParIndex);
		colorValue = [colorValue substringWithRange:substrRange];
		NSArray *colorComponents = [colorValue componentsSeparatedByString:@","];
		if ([colorComponents count] < 3 || [colorComponents count] > 4)	{
			NSLog(@"+[NSColor(AIColorAdditions)	colorWithHTMLString:] called with a color function with the wrong number of arguments (str is %@); returning %@", str, defaultColor);
			return defaultColor;
		}
		float red, green, blue, alpha = 1.0f;
		red = [[colorComponents objectAtIndex:0] floatValue];
		green = [[colorComponents objectAtIndex:1] floatValue];
		blue = [[colorComponents objectAtIndex:2] floatValue];
		if ([colorComponents count] == 4)
			alpha = [[colorComponents objectAtIndex:3] floatValue];
		return [NSColor colorWithCalibratedRed:red green:green blue:blue alpha:alpha];
	}
	if ((!strLength)	|| ([str characterAtIndex:0] != '#'))	{
		//look it up; it's a colour name
		NSDictionary *colorValues = [self colorNamesDictionary];
		colorValue = [colorValues objectForKey:str];
		if (!colorValue)	colorValue = [colorValues objectForKey:[str lowercaseString]];
		if (!colorValue)	{
#if COLOR_DEBUG
			NSLog(@"+[NSColor(AIColorAdditions)	colorWithHTMLString:] called with unrecognised color name (str is %@); returning %@", str, defaultColor);
#endif
			return defaultColor;
		}
	}
	//we need room for at least 9 characters (#00ff00ff)	plus the NUL terminator.
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
	if (*hexString == '#')	{
		++hexString;
		--hexStringLength;
	}
	if (hexStringLength < 3)	{
#if COLOR_DEBUG
		NSLog(@"+[%@ colorWithHTMLString:] called with a string that cannot possibly be a hexadecimal color specification (e.g. #ff0000, #00b, #cc08)	(string: %@ input: %@); returning %@", NSStringFromClass(self), colorValue, str, defaultColor);
#endif
		return defaultColor;
	}
	//long specification:  #rrggbb[aa]
	//short specification: #rgb[a]
	//e.g. these all specify pure opaque blue: #0000ff #00f #0000ffff #00ff
	BOOL isLong = hexStringLength > 4;
	//for a long component c = 'xy':
	//	c = (x * 0x10 + y)	/ 0xff
	//for a short component c = 'x':
	//	c = x / 0xf
	char firstChar, secondChar;
	firstChar = *(hexString++);
	secondChar = (isLong ? *(hexString++)	: 0x0);
	red = hexCharsToFloat(firstChar, secondChar);
	firstChar = *(hexString++);
	secondChar = (isLong ? *(hexString++)	: 0x0);
	green = hexCharsToFloat(firstChar, secondChar);
	firstChar = *(hexString++);
	secondChar = (isLong ? *(hexString++)	: 0x0);
	blue = hexCharsToFloat(firstChar, secondChar);
	if (*hexString)	{
		//we still have one more component to go: this is alpha.
		//without this component, alpha defaults to 1.0 (see initialiser above).
		firstChar = *(hexString++);
		secondChar = (isLong ? *hexString : 0x0);
		alpha = hexCharsToFloat(firstChar, secondChar);
	}
	return [self colorWithCalibratedRed:red green:green blue:blue alpha:alpha];
}

@end
@implementation NSColor (AIColorAdditions_ObjectColor)
+ (NSString*)representedColorForObject: (id)anObject withValidColors: (NSA*)validColors;
@end

*/


//DEBUG_INFORMATION_FORMAT = dwarf
// GCC_FAST_OBJC_DISPATCH = YES





// Whether function calls should be position-dependent (should always be disabled for library code)

//CODE_SIGN_IDENTITY = MrGray.com

//FRAMEWORK_SEARCH_PATHS = $(USER_FWKS) //"$HOME/Library/Frameworks" $(FRAMEWORK_SEARCH_PATHS)
//LD_RUNPATH_SEARCH_PATHS = $(USER_FWKS)
//HEADER_SEARCH_PATHS = $(AZBUILD)/include include /usr/local/include $(SDKROOT)/usr/include/libxml2

// IBC_FLATTEN_NIBS = NO
//$(AZBUILD) $(DEVELOPER_FRAMEWORKS_DIR)/../../Platforms/MacOSX.platform/Developer/Library/Frameworks $(LD_RUNPATH_SEARCH_PATHS)
//LIBRARY_SEARCH_PATHS = /usr/local/lib $(LIBRARY_SEARCH_PATHS)
//OTHER_LDFLAGS = $(inherited) -lXtrace -sub_library libXtrace
//$(CODESIGNING_FOLDER_PATH)
//" $(AZBUILD) // /Library/Frameworks"


//GCC_INCREASE_PRECOMPILED_HEADER_SHARING = YES // NO
//PRECOMPS_INCLUDE_HEADERS_FROM_BUILT_PRODUCTS_DIR = YES // NO

//GCC_PRECOMPILE_PREFIX_HEADER = YES


// SYMROOT = /dd/AtoZ

//DSTROOT = /




// -Wno-absolute-value

//-Wno-unused-getter-return-value

// -Wincomplete-umbrella

// STRIP_INSTALLED_PRODUCT = NO





// $(DEVELOPER_FRAMEWORKS_DIR)
//$(BUILT_PRODUCTS_DIR)/include $(inherited)
//(BUILT_PRODUCTS_DIR)
//CLANG_WARN_IMPLICIT_SIGN_CONVERSION = NO [NO]  // Whether to warn on implicit conversions between signed/unsigned types
//CURRENT_PROJECT_VERSION = ${ATOZ_VERSION}
//DSTROOT = /
//FRAMEWORK_SEARCH_PATHS = $(BUILT_PRODUCTS_DIR)
//GCC_CW_ASM_SYNTAX = NO
//GCC_ENABLE_ASM_KEYWORD = NO
//GCC_ENABLE_OBJC_EXCEPTIONS = YES [YES]
//GCC_NO_COMMON_BLOCKS = YES
//GCC_WARN_FOUR_CHARACTER_CONSTANTS = NO // [NO]
//INSTALL_PATH = /dd/AtoZ/Products/Debug
//SKIP_INSTALL = YES


//USE DEFINED

//ONLY_LINK_ESSENTIAL_SYMBOLS = YES
//ZERO_LINK = NO


// $(HOME)/Library/Frameworks  $(AZBUILD)
// -Wno-missing-prototypes -Wno-format-security -Wno-unused-variable -Wno-unused-function -Wno-conversion -Wno-unused-value	-Wno-newline-eof -Wno-ignored-attributes -Wno-objc-property-no-attribute -Wno-sign-compare // Disable GCC compatibility warnings
// binaries).
// disabled for library code)
// Overrides Release.xcconfig when used at the target level.
// should reenable -Wimplicit-retain-self
// This file defines common settings that should be enabled for every new project. Typically, you want to use Debug, Release, or a similar variant instead.
// Whether function calls should be position-dependent (should always be
// Whether to strip debugging symbols when copying resources (like included
//$(AZBUILD)/include $(HEADER_SEARCH_PATHS)
//-fmodules
//// -fobjc-arc
//// -Wno-duplicate-method-arg
//// Disable GCC compatibility warnings
//// Disable legacy-compatible header searching
//// Whether to generate debugging symbols
////-no_compact_unwind
////-ObjC -framework Cocoa -framework Foundation -framework QuartzCore -lSansNib
////Alex Gray Xcode"
////ALWAYS_SEARCH_USER_PATHS = YES //NO
////HEADER_SEARCH_PATHS = $(HEADER_SEARCH_PATHS) /usr/local/include
////LIBRARY_SEARCH_PATHS = $(LIBRARY_SEARCH_PATHS) /usr/local/lib
//ALWAYS_SEARCH_USER_PATHS = YES // Disable legacy-compatible header searching
//ARCHS = $(ARCHS_STANDARD_32_64_BIT)
//ATOZ_GENERAL_OTHER_CFLAGS = //-Wdiv-by-zero -Wbad-function-cast -Wnested-externs -Wold-style-definition
//ATOZ_VERSION
//CLANG_ANALYZER_SECURITY_FLOATLOOPCOUNTER = NO  // [NO] Whether to warn when a floating-point value is used as a loop counter
//CLANG_ANALYZER_SECURITY_INSECUREAPI_RAND = NO  // [NO] Whether to warn about use of rand() and random() being used instead of arc4random()
//CLANG_ANALYZER_SECURITY_INSECUREAPI_STRCPY = NO  // [NO]Whether to warn about strcpy() and strcat()
//CLANG_ENABLE_MODULES = YES
//CLANG_LINK_OBJC_RUNTIME = YES
//CLANG_MODULES_AUTOLINK = YES
//CLANG_WARN_CONSTANT_CONVERSION = NO  // [NO] Warn about implicit conversions of constant values that cause the constant value to change, either through a loss of precision, or entirely in its meaning.
//CLANG_WARN_DEPRECATED_OBJC_IMPLEMENTATIONS = NO  //[NO]  Whether to warn when overriding deprecated methods
//CLANG_WARN_ENUM_CONVERSION = NO  //[NO]  Warn about implicit conversions between different kinds of enum values. For example, this can catch issues when using the wrong enum flag as an argument to a function or method.
//CLANG_WARN_INT_CONVERSION = NO  // [NO] Warn about implicit conversions between pointers and integers. For example, this can catch issues when one incorrectly intermixes using NSNumbers and raw integers.
//CLANG_WARN_SUSPICIOUS_IMPLICIT_CONVERSION = NO  //[NO]  Whether to warn on suspicious implicit conversions
//DEBUG_INFORMATION_FORMAT = dwarf-with-dsym  // The format of debugging symbols
//FRAMEWORK_SEARCH_PATHS = "$(HOME)/Library/Frameworks" $(SYSTEM_LIBRARY_DIR)/PrivateFrameworks
//FRAMEWORK_SEARCH_PATHS = $(inherited) $(DEVELOPER_FRAMEWORKS_DIR) $(BUILT_PRODUCTS_DIR) /Volumes/4x4/DerivedData/PrecompiledFrameworks
//GCC_C_LANGUAGE_STANDARD = gnu99
//GCC_DYNAMIC_NO_PIC = NO  // [NO] Static libs can be included in bundles so make them position independent
//GCC_ENABLE_OBJC_EXCEPTIONS = YES // [YES] Whether to enable exceptions for Objective-C
//GCC_ENABLE_OBJC_GC = unsupported
//GCC_GENERATE_DEBUGGING_SYMBOLS = YES
//GCC_GENERATE_TEST_COVERAGE_FILES = NO [NO]
//GCC_GENERATE_TEST_COVERAGE_FILES = NO
//GCC_INCREASE_PRECOMPILED_HEADER_SHARING = YES
//GCC_INCREASE_PRECOMPILED_HEADER_SHARING = NO
//GCC_INSTRUMENT_PROGRAM_FLOW_ARCS = NO
//GCC_INSTRUMENT_PROGRAM_FLOW_ARCS = NO [NO]
//GCC_MODEL_TUNING = G5
//GCC_OPTIMIZATION_LEVEL = s

//GCC_PRECOMPILE_PREFIX_HEADER = YES
//GCC_PRECOMPILE_PREFIX_HEADER = NO // Whether to precompile the prefix header (if one is specified)
//GCC_PREPROCESSOR_DEFINITIONS = DEBUG =1 $(inherited)
//GCC_STRICT_ALIASING = YES // [YES] Whether to enable strict aliasing, meaning that two pointers of different types (other than void * or any id type) cannot point to the same memory  location
//GCC_SYMBOLS_PRIVATE_EXTERN = NO  // [NO] Whether symbols not ex plicitly exported are hidden by default (this primarily only affects C++ code)Ïcurses
//GCC_THREADSAFE_STATICS = NO
//GCC_THREADSAFE_STATICS = YES // [YES] Whether static variables are thread-safe by default
//GCC_TREAT_WARNINGS_AS_ERRORS = NO  // [NO] Whether warnings are treated as errors
//GCC_UNROLL_LOOPS = NO
//GCC_VERSION = com.apple.compilers.llvmgcc42
//GCC_VERSION = com.apple.compilers.llvm.clang.1_0 // Which compiler to use
//GCC_WARN_64_TO_32_BIT_CONVERSION = NO  //[NO]  Whether to warn about 64-bit values being implicitly shortened to 32 bits
//GCC_WARN_ABOUT_MISSING_NEWLINE = YES
//GCC_WARN_ABOUT_MISSING_PROTOTYPES = YES
//GCC_WARN_ABOUT_MISSING_PROTOTYPES = NO  //[NO]  Whether to warn about missing function prototypes
//GCC_WARN_ABOUT_POINTER_SIGNEDNESS = NO  //[NO]  Whether to warn about implicit conversions in the signedness of the type a pointer is pointing to (e.g., 'int *' getting converted to 'unsigned int *')
//GCC_WARN_ALLOW_INCOMPLETE_PROTOCOL = YES // [YES] Whether to warn on a class not implementing all the required methods of a protocol it declares conformance to
//GCC_WARN_CHECK_SWITCH_STATEMENTS = YES
//GCC_WARN_FOUR_CHARACTER_CONSTANTS = NO  // [NO] Whether to warn about the use of four-character constants
//GCC_WARN_INITIALIZER_NOT_FULLY_BRACKETED = NO  // [NO] Whether to warn about an aggregate data type's initializer not being fully bracketed (e.g., array initializer syntax)
//GCC_WARN_MISSING_PARENTHESES = YES
//GCC_WARN_SIGN_COMPARE = YES
//GCC_WARN_SIGN_COMPARE = NO  // [NO] Whether to warn about unsafe comparisons between values of different signedness
//GCC_WARN_TYPECHECK_CALLS_TO_PRINTF = YES  // [YES] Whether to warn about the arguments to printf-style functions not matching the format specifiers
//GCC_WARN_UNUSED_FUNCTION = NO  // [NO] Whether to warn about static functions that are unused
//GCC_WARN_UNUSED_PARAMETER = NO[NO]
//HEADER_SEARCH_PATHS = $(HEADER_SEARCH_PATHS) $(BUILT_PRODUCTS_DIR)/include "$(SDKROOT)/usr/include/libxml2/**" /usr/include/libxml2 /usr/local/include
//LD_RUNPATH_SEARCH_PATHS = $(AZBUILD)
//LIBRARY_SEARCH_PATHS = $(SDKROOT)/usr/lib $(BUILT_PRODUCTS_DIR)
//LLVM_LTO = NO
//LLVM_VECTORIZE_LOOPS = NO
//OTHER_CFLAGS = $(OTHER_CFLAGS) -fmodules-prune-interval =30
//OTHER_CFLAGS = $(OTHER_CFLAGS) -fobjc-arc -Wno-auto-import
//OTHER_CFLAGS = $(inherited) $(ATOZ_GENERAL_OTHER_CFLAGS)
//OTHER_CFLAGS = $(OTHER_CFLAGS) -fmodules-cache-path ="$(AZBUILD)/../../AtoZModulesCache"
//OTHER_LDFLAGS = $(OTHER_LDFLAGS)  //  -fmodules
//PREBINDING = NO
//PRECOMPS_INCLUDE_HEADERS_FROM_BUILT_PRODUCTS_DIR = NO
//PRODUCT_NAME = AtoZ
//RUN_CLANG_STATIC_ANALYZER = NO// [NO] Whether to run the static analyzer with every build
//SDKROOT = macosx10.9
//STRIP_STYLE = debugging // Static libs should not have their internal globals or external symbols stripped.
//TEST_AFTER_BUILD = NO// Whether to run unit tests with every build
//USER_HEADER_SEARCH_PATHS = $(USER_HEADER_SEARCH_PATHS) $(SDKROOT)/usr/include/libxml2/** $(BUILT_PRODUCTS_DIR)/include /usr/include/libxml2 /usr/local/include
//USER_HEADER_SEARCH_PATHS = $(USER_HEADER_SEARCH_PATHS) $(SDKROOT)/usr/include/libxml2  // $(BUILT_PRODUCTS_DIR)/include"
//WARNING_CFLAGS = -Wmost -Wextra -Wcast-align -Wchar-subscripts -Wformat-security -Wmissing-format-attribute -Wpointer-arith -Wwrite-strings -Wno-format-y2k -Wno-unused-parameter -Wbad-function-cast -Wmissing-declarations -Wnested-externs
//WARNING_CFLAGS = $(WARNING_CFLAGS) -Wno-four-char-constants -Wno-protocol -Wno-format-security -Wno-unused-variable -Wno-unused-function -Wno-conversion	-Wno-gcc-compat	-Wno-unused-value	-Wno-newline-eof -Wno-ignored-attributes -Wno-selector	 -Wno-objc-property-no-attribute	-Wno-sign-compare
//ATOZ_VERSION = 0.0.1



// GENERATE_MASTER_OBJECT_FILE = YES

//INFOPLIST_FILE = Info.plist

// Whether to strip out code that isn't called from anywhere
//DEAD_CODE_STRIPPING = NO

//-umbrella AtoZ
//-no_pie -no_compact_unwind

// DEPLOYMENT_POSTPROCESSING		  = YES

// Enables the framework to be included from any location as long as the
// loader’s runpath search paths includes it. For example from an application
// bundle (inside the "Frameworks" folder) or shared folder
//-no_pie -no_compact_unwind

//:configuration = Debug

//$(HOME)/Library/Frameworks
//INSTALL_PATH = /

//:completeSettings = some

//ALWAYS_SEARCH_USER_PATHS = NO  
//HEADER_SEARCH_PATHS = Headers $(inherited) $(SDKROOT)/usr/include/libxml2

//LIBRARY_SEARCH_PATHS = $(inherited) $(SDKROOT)/usr/lib

//@loader_path @loader_path/.
//SKIP_IN
//$(AZBUILD) $(DEVELOPER_FRAMEWORKS_DIR) $(inherited)
//LD_DYLIB_INSTALL_NAME = $(INSTALL_PATH)/$(PRODUCT_NAME).$(WRAPPER_EXTENSION)/$(PRODUCT_NAME)

// When compiling this library, look for imports (written with quotes) in the
// library's own folder first. This avoids conflicts from other headers in the
// build folder.
// ./**

// -ObjC -headerpad_max_install_names -framework CoreData




//#define JATEMPLATE_SYNTAX_WARNINGS 1
//@import TwUI;

////#import <WebKit/WebKit.h>
//
////  #import <BlocksKit/BlocksKit.h>
////  #import <CocoaPuffs/CocoaPuffs.h>
////  #import <FunSize/FunSize.h>
//  #import <NoodleKit/NoodleKit.h>

//#define autorelease self
//
//#import <KVOMap/KVOMap.h>
//#import <AtoZAutoBox/AtoZAutoBox.h>
//#import <FunSize/FunSize.h>
//#import "F.h"
//#import "BlocksAdditions.h"


//#import <AtoZAppKit/AtoZAppKit.h>
//#import <AtoZBezierPath/AtoZBezierPath.h>
//#import <BlocksKit/A2DynamicDelegate.h>
//#import <BlocksKit/BlocksKit.h>
//#import <CFAAction/CFAAction.h>
//#import <CocoaPuffs/CocoaPuffs.h>
//#import <CocoatechCore/CocoatechCore.h>
//#import <DrawKit/DrawKit.h>
//#import <KSHTMLWriter/KSHTMLWriter.h>
//#import <NoodleKit/NoodleKit.h>
//#import <Rebel/Rebel.h>
//#import <UIKit/UIKit.h>

#endif
  //#import <ObjcAssociatedObjectHelpers/ObjcAssociatedObjectHelpers.h>
  //#import <AtoZAutoBox/AtoZAutoBox.h>
  //#import <BWTK/BWToolkitFramework.h>
  //#import <MenuApp/MenuApp.h>
  //#import <NMSSH/NMSSH.h>
  //#import <PhFacebook/PhFacebook.h>

  //#import <UAGithubEngine/UAGithubEngine.h>



/*
#import <AtoZAppKit/AtoZAppKit.h>
#import <AtoZBezierPath/AtoZBezierPath.h>
#import <BWTK/BWToolkitFramework.h>
#import <BlocksKit/A2DynamicDelegate.h>
#import <BlocksKit/BlocksKit.h>
#import <CFAAction/CFAAction.h>
#import <CocoaPuffs/CocoaPuffs.h>
#import <CocoatechCore/CocoatechCore.h>
#import <DrawKit/DrawKit.h>
#import <FunSize/FunSize.h>
#import <KSHTMLWriter/KSHTMLWriter.h>
#import <NoodleKit/NoodleKit.h>
#import <PhFacebook/PhFacebook.h>
#import <TwUI/TwUI.h>
#import <UAGithubEngine/UAGithubEngine.h>
#import <UIKit/UIKit.h>



  #import <Foundation/NSObjCRuntime.h>
  #import <QuartzCore/QuartzCore.h>
                                                          @import Darwin;
#import <ApplicationServices/ApplicationServices.h>   //  @import ApplicationServices;
#import <AudioToolbox/AudioToolbox.h>                 //  @import AudioToolbox;
#import <AVFoundation/AVFoundation.h>                 //  @import AVFoundation;
#import <CoreServices/CoreServices.h>                 //  @import CoreServices;
#import <Dispatch/Dispatch.h>                         //  @import Dispatch;
#import <SystemConfiguration/SystemConfiguration.h>   //  @import SystemConfiguration;
#import <WebKit/WebView.h>
@import RoutingHTTPServer;


#import <RoutingHTTPServer/RoutingHTTPServer.h>

#import "AOPProxy/AOPProxy.h"
#import "CollectionsKeyValueFilteringX/CollectionsKeyValueFiltering.h"
#import "JATemplate/JATemplate.h"
#import <KVOMap/KVOMap.h>
#import <ObjcAssociatedObjectHelpers/ObjcAssociatedObjectHelpers.h>
#import <AtoZAutoBox/AtoZAutoBox.h>
#import <MenuApp/MenuApp.h>
#import <NMSSH/NMSSH.h>
#import <Rebel/Rebel.h>


#import <MapKit/MapKit.h>
#import <RoutingHTTPServer/AZRouteResponse.h>

#import "objswitch.h"

*/
/*
//
//  ARC Helper
//
//  Version 2.2
//
//  Created by Nick Lockwood on 05/01/2012.
//  Copyright 2012 Charcoal Design
//
//  Distributed under the permissive zlib license
//  Get the latest version from here:
//
//  https://gist.github.com/1563325
//

//#import <Availability.h>
#undef ah_retain
#undef ah_dealloc
#undef ah_autorelease           // autorelease
#undef ah_dealloc               // dealloc
#if __has_feature(objc_arc)
#define ah_retain self
#define ah_release self
#define ah_autorelease self
#define ah_dealloc self
#else
#define ah_retain retain
#define ah_release release
#define ah_autorelease autorelease
#define ah_dealloc dealloc
#undef __bridge
#define __bridge
#undef __bridge_transfer
#define __bridge_transfer
#endif

//  Weak reference support

//#import <Availability.h>
#if !__has_feature(objc_arc_weak)
#undef ah_weak
#define ah_weak unsafe_unretained
#undef __ah_weak
#define __ah_weak __unsafe_unretained
#endif

//  Weak delegate support

//#import <Availability.h>
#undef ah_weak_delegate
#undef __ah_weak_delegate
#if __has_feature(objc_arc_weak) && \
(!(defined __MAC_OS_X_VERSION_MIN_REQUIRED) || \
__MAC_OS_X_VERSION_MIN_REQUIRED >= __MAC_10_8)
#define ah_weak_delegate weak
#define __ah_weak_delegate __weak
#else
#define ah_weak_delegate unsafe_unretained
#define __ah_weak_delegate __unsafe_unretained
#endif
*/
