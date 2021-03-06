
#define LBREAK @"-+*%%$%%*+-%s-+*%%$%%*+-%s-+*%%$%%*+-%s-+*%%$-+*%%$%%*+-%s-+*%%$%%*+-%s\n"

#define XDEFS NSUserDefaults.standardUserDefaults
#define CLR_BEG "\033[fg"
#define CLR_END "\033[;"
#define CLR_WHT CLR_BEG "239,239,239;%s"CLR_END
#define CLR_GRY CLR_BEG "150,150,150;%s" CLR_END
#define CLR_WOW CLR_BEG "241,196,15;%s" CLR_END
#define CLR_GRN CLR_BEG "46,204,113;%s" CLR_END
#define CLR_RED CLR_BEG "211,84,0;%s" CLR_END

#define SHOW_SECONDS 0
#define PRINT_START_FINISH_NOISE 0

#define ENABLED(X) X ? "ENABLED" : "DISABLED"



@import XCTest; /**  XCTestLog+RedGreen.m  *//* © 𝟮𝟬𝟭𝟯 𝖠𝖫𝖤𝖷 𝖦𝖱𝖠𝖸  𝗀𝗂𝗍𝗁𝗎𝖻.𝖼𝗈𝗆/𝗺𝗿𝗮𝗹𝗲𝘅𝗴𝗿𝗮𝘆 */

@implementation XCTest (Shutup) static BOOL onlyOnFail;

+ (void) setOnlyOnFail:(BOOL)only {

  @synchronized(self) {
    printf("Only Log On FAIL: " CLR_BEG "%s;%s\n", (onlyOnFail = only) ? "46,204,113" : "211,84,0", ENABLED(onlyOnFail));
  }
}

+ (BOOL) onlyOnFail { return onlyOnFail; }

@end

@interface RedGreenTestObserver : XCTestObserver
@property (readonly) BOOL xColorsON;
//@property XCTestRun *run;
//@property NSMutableDictionary *suitesElement,
//                              *currentSuiteElement,
//                              *currentCaseElement;
@end

@implementation RedGreenTestObserver   // (RedGreen)

__attribute__((constructor))
static void initialize_redgreen() {
  [XDEFS setObject:@"RedGreenTestObserver" forKey:@"XCTestObserverClass"];
  [XDEFS synchronize];
  printf("XTrace set XCTestObserverClass to %s\n", "RedGreenTestObserver");
}

__attribute__((destructor))
static void destroy_redgreen() {
  [XDEFS setObject:@"XCTestLog" forKey:@"XCTestObserverClass"];
  [XDEFS synchronize];
  printf("Xtrace reset XCTestObserverClass user defaults to %s\n", "XCTestObserverClass");
}


//+ (void) load	{

//  [NSUserDefaults.standardUserDefaults setObject:@"RedGreenTestObserver,XCTestLog" forKey:@"XCTestObserverClass"];
//  [NSUserDefaults.standardUserDefaults synchronize];


//  method_exchangeImplementations(	class_getInstanceMethod(self, @selector(testLogWithFormat:)),
//																	class_getInstanceMethod(self, @selector(testLogWithColorFormat:)));
//}

- init { return self = super.init ? ({

  const char *xcc = getenv("XcodeColors");
	_xColorsON = xcc &&
       !strcmp(xcc, "YES"),

  printf( CLR_WHT CLR_WOW CLR_WHT CLR_WOW CLR_WHT CLR_WOW "\n",
          "xcodecolors : ",
                  ENABLED(_xColorsON),
                          " | Noisy : ",
                                  ENABLED(PRINT_START_FINISH_NOISE),
                                  " | XCTestObserverClass : ",
                                  [[XDEFS objectForKey:@"XCTestObserverClass"] UTF8String]

                                  ); }), self : nil;
//  _document = @{}.mutableCopy;
  return self;
}


#pragma mark - Primary Result Logger

- (void) testCaseDidStop:(XCTestRun*)testRun {
//    XCTestCaseRun *testCaseRun = (XCTestCaseRun *) testRun;
//    XCTest *test = [testCaseRun test];
    if (!testRun.totalFailureCount)
      printf(CLR_GRN CLR_WHT CLR_GRY "\n", "PASS",
      [NSString stringWithFormat:@"%6.2fs ",testRun.testDuration].UTF8String,
        testRun.test.name.UTF8String);
}

- (void) testCaseDidFail:(XCTestRun*)testRun
         withDescription:(NSString*)description
                  inFile:(NSString*)filePath
                  atLine:(NSUInteger)lineNumber {

  XCTest *test = [testRun test];


  printf( CLR_RED " #%lu " CLR_GRY " " CLR_WHT "\n", "FAIL",
    testRun.failureCount,
    [[test.name substringToIndex:test.name.length-1]
              substringFromIndex:[test.name rangeOfString:@" "].location].UTF8String,
    description.UTF8String);
}

//- (void)startObserving {
//    printf("%s\n",NSStringFromSelector(_cmd).UTF8String);
//    [super startObserving];
//}
//- (void)stopObserving {
//    printf("%s\n",NSStringFromSelector(_cmd).UTF8String);
//    [super stopObserving];
//}

- (void) testSuiteDidStart:(XCTestRun*)testRun { // self.run = testRun;

  /*! prints:
    [fg241,196,15;All tests[; 22 (XCTestSuite)  | [fg241,196,15;GVoiceTests.xctest[; 22 (XCTestSuite)  | [fg241,196,15;GVTests[; 19 (XCTestCaseSuite)
  */
  NSUInteger count = [(id)testRun testCaseCount];
  if (!count) return;
  printf(CLR_WOW " %lu (" CLR_WHT ") %s",
  testRun.test.name.UTF8String,
  count,
  testRun.test.className.UTF8String,
  [testRun.test isKindOfClass:NSClassFromString(@"XCTestCaseSuite")] ? "\n" : " | "

                        );

//object_getClassName([(id)testRun testRunClass]));
//    XCTestSuite *testSuite = (XCTestSuite *) [testRun test];
//    _tests[testSuite.name] = @[].mutableCopy;
//    _currentSuiteElement = @{@"testsuite:"];
//    [_currentSuiteElement addAttribute:[@"name" stringValue:[testSuite name]]];

//    printf("%s\n%s\n\n",NSStringFromSelector(_cmd).UTF8String, testSuite.description.UTF8String);

//    self.currentSuiteElement = [GDataXMLElement elementWithName:@"testsuite"];
//    [_currentSuiteElement addAttribute:[GDataXMLNode attributeWithName:@"name" stringValue:[testSuite name]]];
}

- (void)testSuiteDidStop:(XCTestRun *)testRun {
//    XCTestSuiteRun *testSuiteRun = (XCTestSuiteRun *) testRun;
//    printf("%s\n%s\n\n",NSStringFromSelector(_cmd).UTF8String, testSuiteRun.description.UTF8String);
//    if (_currentSuiteElement) {
//        [_currentSuiteElement addAttribute:[GDataXMLNode attributeWithName:@"name" stringValue:[[testSuiteRun test] name]]];
//        [_currentSuiteElement addAttribute:[GDataXMLNode attributeWithName:@"tests" stringValue:[NSString stringWithFormat:@"%d", [testSuiteRun testCaseCount]]]];
//        [_currentSuiteElement addAttribute:[GDataXMLNode attributeWithName:@"errors" stringValue:[NSString stringWithFormat:@"%d", [testSuiteRun unexpectedExceptionCount]]]];
//        [_currentSuiteElement addAttribute:[GDataXMLNode attributeWithName:@"failures" stringValue:[NSString stringWithFormat:@"%d", [testSuiteRun failureCount]]]];
//        [_currentSuiteElement addAttribute:[GDataXMLNode attributeWithName:@"skipped" stringValue:@"0"]];
//        [_currentSuiteElement addAttribute:[GDataXMLNode attributeWithName:@"time" stringValue:[NSString stringWithFormat:@"%f", [testSuiteRun testDuration]]]];
//        [_suitesElement addChild:_currentSuiteElement];
//        self.currentSuiteElement = nil;
//    }
}

#pragma mark - Noisy

- (void)testCaseDidStart:(XCTestRun *)testRun { // self.run = testRun;

  if (!PRINT_START_FINISH_NOISE) return;

  // prints:   [fg150,150,150;XCTestCaseRun[; ([fg241,196,15;1[; Tests)
  XCTest *test = [testRun test];
  printf(CLR_GRY " (" CLR_WOW " Tests) \n",
          object_getClassName(test.testRunClass),
                      @(test.testCaseCount).stringValue.UTF8String);

//      if (testRun.failureCount==1)
//    printf(CLR_BEG CLR_WHT ";START:%s - %s\n\n" CLR_END,test.name.UTF8String, test.description.UTF8String);
//    self.currentCaseElement = [GDataXMLElement elementWithName:@"testcase"];
//    [_currentCaseElement addAttribute:[GDataXMLNode attributeWithName:@"name" stringValue:[test name]]];
}



@end

/*
    printf("\n%s\n%s & %s\n\n",NSStringFromSelector(_cmd).UTF8String, test.description.UTF8String, testRun.description.UTF8String);
    [_currentCaseElement addAttribute:[GDataXMLNode attributeWithName:@"name" stringValue:[test name]]];
    [_currentCaseElement addAttribute:[GDataXMLNode attributeWithName:@"classname" stringValue:NSStringFromClass([test class])]];
    [_currentCaseElement addAttribute:[GDataXMLNode attributeWithName:@"time" stringValue:[NSString stringWithFormat:@"%f", [testCaseRun testDuration]]]];
    [_currentSuiteElement addChild:_currentCaseElement];
    self.currentCaseElement = nil;

  printf("\n%s\n%s\ndescription:%s\nfile[%lu]:%s\n\n",NSStringFromSelector(_cmd).UTF8String, , description.UTF8String, lineNumber, filePath.description.UTF8String);

    GDataXMLElement *failureElement = [GDataXMLElement elementWithName:@"failure"];
    [failureElement setStringValue:description];
    [_currentCaseElement addChild:failureElement];

+ (NSMutableArray*) errors	{	static dispatch_once_t pred;	static NSMutableArray *_errors = nil;

	dispatch_once(&pred, ^{ _errors = NSMutableArray.new; });	return _errors;
}

+ (NSString*) updatedOutputFormat:(NSString*)fmt	{ return [fmt isEqualToString:kXCTestCaseFormat] ? kRGTestCaseFormat : fmt; }



- (void) testLogWithColorFormat:(NSString *)format, ... NS_FORMAT_FUNCTION(1,2)	{

	va_list arguments;	va_start(arguments, format);

//  printf("has prefix: %s", [format hasPrefix:@"Test Suite"] ? "YES" : "NO");  // format:\n\"%s\"\n", format.UTF8String);

	if      ([format hasPrefix:@"Test Suite"] && PRINT_START_FINISH_NOISE) {

  //   || [format hasSuffix:@"started.\n"]) && PRINT_START_FINISH_NOISE) {

    printf("%s%s%s", xColorsON ? CLR_BEG CLR_GRY : "",
                    [NSString stringWithFormat:format,arguments].UTF8String,
                    xColorsON ? CLR_END : "");
											
	}

  else if ([format hasPrefix:@"Test Case"]) {

		NSArray   * args = [[NSString.alloc initWithFormat:kXCTestCaseArgsFormat arguments:arguments]
                           componentsSeparatedByString:kRGArgsSeparator];

		NSArray * mParts = [args[0] componentsSeparatedByString:@" "];
		NSString   * log = args[1],
             * color = [NSString stringWithUTF8String:[log.uppercaseString isEqualToString:kXCTestPassed] ? CLR_GRN : CLR_RED],
         * messenger = mParts[0],
            * method = [mParts[1] stringByReplacingOccurrencesOfString:@"]" withString:@""],
            * output = xColorsON
                     ? [NSString stringWithFormat:kRGTestCaseXCOutputFormat, color, log.uppercaseString, messenger, method, SHOW_SECONDS ? args[2] : @""]
							       : [NSString stringWithFormat:kRGTestCaseOutputFormat, log.uppercaseString, args[0], SHOW_SECONDS ? args[2] : @""];

		if (!SHOW_SECONDS) output = [output stringByReplacingOccurrencesOfString:@"(s)" withString:@""];

		printf("%s", output.UTF8String);

		if (![_errors[self.className]count]) return;

		[_errors[self.className] enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) { printf("%s\n", [obj UTF8String]); }];
		[_errors[self.className] removeAllObjects];

	}

  else if ([format rangeOfString:@"error"].location != NSNotFound) {

		NSArray *args = [[NSString.alloc initWithFormat:kXCTestErrorArgsFormat arguments:arguments]
                        componentsSeparatedByString:kRGArgsSeparator];
    id x = !xColorsON ? ({ [NSString stringWithFormat:kRGTestErrorOutputFormat, args[1], args[3]]; }) : ({

			NSUInteger  failureLoc;

      (failureLoc = [args[3] rangeOfString:@"failed"].location) != NSNotFound ?

				[NSString stringWithFormat:kRGTestErrorXCOutputFormat,CLR_RED, args[1], args[3]] : ({

			NSString * problem = [args[3] substringToIndex:failureLoc],
                * reason = [args[3] substringFromIndex:failureLoc + @"failed ".length];


      [NSString stringWithFormat:@""   CLR_BEG CLR_WOW ";#%lu"  CLR_END
                                  "%s" CLR_BEG CLR_GRY ";%@"	  CLR_END
                                       CLR_BEG CLR_WHT ";  %@ " CLR_END
                                       CLR_BEG CLR_RED ";%@"	  CLR_END,
        (NSUInteger)[_errors[self.className]count]+1,
        [_errors[self.className]count] < 10 ? " ": "", args[1],
        problem,
        reason];

    }); });
    if (x) [_errors[self.className] = _errors[self.className] ?: @[].mutableCopy addObject:x];

	}

//  else printf("format:\n\"%s\"\n\nFELL THROUGH!\n", format.UTF8String); // objc_msgSend(self, @selector(testLogWithFormat:arguments:),format,arguments);

	va_end(arguments);
}



          * const kXCTestCaseFormat 				= @"Test Case '%@' %s (%.3f seconds).\n",
          * const kXCTestSuiteStartFormat		= @"Test Suite '%@' started at %@\n",
          * const kXCTestSuiteFinishFormat 		= @"Test Suite '%@' finished at %@.\n",
          * const kXCTestSuiteFinishLongFormat	= @"Test Suite '%@' finished at %@.\n"
                                                  "Executed %ld test%s, with %ld failure%s (%ld unexpected) in %.3f (%.3f) seconds\n",
          * const kXCTestSuiteFinishLongFormatNew	=
@"Test Suite '%@' %s at %@.\n",
 "\t Executed %lu test%s, with %lu failure%s (%lu unexpected) in %.3f (%.3f) seconds",

#define ENABLED(X) X ? "ENABLED" : "DISABLED"

NSString  * const kRGTestCaseFormat 				= @"%@: %s (%.3fs)",
          * const kXCTestErrorFormat	 			= @"%@:%lu: error: %@ : %@\n",
          * const kXCTestCaseArgsFormat 			= @"%@|%s|%.5f",
          * const kXCTestErrorArgsFormat 		= @"%@|%lu|%@|%@",
          * const kRGArgsSeparator 				= @"|",

          * const kXCTestPassed 					= @"PASSED",
          * const kXCTTestFailed 					= @"FAILED",
          * const kRGTestCaseXCOutputFormat 	= @"" CLR_BEG       "%@;%@:" CLR_END CLR_BEG CLR_GRY ";%@ " 		CLR_END
                                                    CLR_BEG CLR_WHT ";%@"  CLR_END CLR_BEG CLR_GRY ";] (%@s)" CLR_END "\n",
          * const kRGTestCaseOutputFormat 		= @"%@: %@ (%@s)\n",
          * const kRGTestErrorXCOutputFormat 	= @"\t\033[fg%s;Line %@: %@\033[;\n",
          * const kRGTestErrorOutputFormat 		= @"\tLine %@: %@\n";
@import ObjectiveC;
 #import <stdarg.h>

 */


@import ObjectiveC;
#import "NSObject+CleanDescription.h"

//  NSObject+AutoDescribe.m  AutoDescribe   Created by Simon Strandgaard on 10/5/12.

@implementation NSObject (AutoDescribe)

- (NSArray*) auto_uncodableKeys  { return nil; }
- (NSArray*) auto_codableKeys    {

    NSMutableArray *array = @[].mutableCopy;
    Class class = self.class;
    while (class != NSObject.class) {

      unsigned int outCount = 0, i;
      objc_property_t *properties = class_copyPropertyList(class, &outCount);

      for (i = 0; i < outCount; i++) {
        objc_property_t property = properties[i];
        const char *propName = property_getName(property);
        if(propName) {
//            const char *propType = getPropertyType(property);
            NSString *propertyName = [NSString stringWithUTF8String:propName];
//            NSString *propertyType = [NSString stringWithUTF8String:propType];
//            [results setObject:propertyType forKey:propertyName];
            [array addObject:propertyName];
        }
      }
      free(properties);
      class = class.superclass;
    }

    // returning a copy here to make sure the dictionary is immutable
//    return [NSDictionary dictionaryWithDictionary:results];
//    while (class != NSObject.class)
//    {
//        unsigned int count;
//        objc_property_t *properties = class_copyPropertyList(class, &count);
//        for (int i = 0; i < count; i++) {
//
//            objc_property_t property = properties[i];
//            const char   *attributes = property_getAttributes(property);
//            NSString       *encoding = [NSString stringWithCString:attributes encoding:NSUTF8StringEncoding];
//            if (![[encoding componentsSeparatedByString:@","] containsObject:@"R"]) {
//
//                //omit read-only properties
//                const char *name = property_getName(property);
//                [array addObject:[NSString stringWithCString:name encoding:NSUTF8StringEncoding]]; // key
//            }
//        }
//        free(properties);
//        class = class.superclass;
//    }
    [array removeObjectsInArray:self.auto_uncodableKeys];
    return array;
}

- (NSString*) autoDescribe {

	// Don't try to autoDescribe NSManagedObject subclasses (Core Data does this already)
  BOOL managed = [self isKindOfClass:NSClassFromString(@"NSManagedObject")];
  return managed ? self.description : [self autoDescribe:self.class var:NULL];
}
- (NSString*) autoDescribeVar:(const char*)name { return [self autoDescribe:self.class var:name]; }
- (NSString*) autoDescribe:(Class)classType
                          var:(const char*)name {

  unsigned int       count;
  objc_property_t *propList = class_copyPropertyList(classType, &count);
  NSMutableString *propPrnt = name ? [NSMutableString stringWithFormat:@"\n\n%20s * %s =\n\n", self.className.UTF8String, name]
                                   : @"".mutableCopy;

  NSMutableArray *nilKeys = @[].mutableCopy;

  for ( int i = 0; i < count; i++ ){

    if (i) [propPrnt appendString:@"\n"];
    objc_property_t  property = propList[i];
    NSString * propNameString = [NSString stringWithUTF8String:property_getName(property)];
    if(!property_getName(property)) continue;
    @try {

      id value = [self valueForKey:propNameString];
      if (!value) { [nilKeys addObject:propNameString]; continue; }

      if ([propNameString isEqualToString:@"nanoObjectDictionaryRepresentation"])

        [propPrnt appendFormat:@"nanoObjectDictionaryRepresentation (%@) COUNT:%lu", [value className], [value count]];

      else [propPrnt appendFormat:@"%20s   %@",propNameString.UTF8String, value];
    }
    @catch (NSException *exc) {
      [propPrnt appendFormat:@"Can't get value for property %@ through KVO 😡",propNameString];
    }
  }
  free(propList);
  if (!name) {
    NSString *nCounter = !nilKeys.count ? @"" :[NSString stringWithFormat:@" (NULL Keys: %@)",[nilKeys componentsJoinedByString:@", "]],
             *insert  = [NSString stringWithFormat:@"%@%@%@\n", LBREAK, NSStringFromClass(classType), nCounter];
    [propPrnt insertString:insert atIndex:0];
  }

  Class superClass = class_getSuperclass(classType);   // Now see if we need to map any superclasses as well.
  !superClass || [superClass isEqual:NSObject.class] ?:
    [propPrnt appendFormat:@"\n%@", [self autoDescribe:superClass var:NULL]];

  return propPrnt;
}

@end
