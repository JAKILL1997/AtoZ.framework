/*
//  CWTask.m
//  Zangetsu
//
//  Created by Colin Wheeler on 8/30/10.
//  Copyright 2010. All rights reserved.
//
 
 Copyright (c) 2013, Colin Wheeler
 All rights reserved.
 
 Redistribution and use in source and binary forms, with or without
 modification, are permitted provided that the following conditions are met:
 
 - Redistributions of source code must retain the above copyright notice, this
 list of conditions and the following disclaimer.
 
 - Redistributions in binary form must reproduce the above copyright notice,
 this list of conditions and the following disclaimer in the documentation
 and/or other materials provided with the distribution.
 
 THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
 AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
 IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
 DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE
 FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
 DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR
 SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER
 CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY,
 OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
 OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 */

#import <AtoZUniversal/metamacros.h>
#import "CWTask.h"
//#import "Zangetsu.h"
//#import <extobjc_OSX/EXTScope.h>
//#import <ExtObjC/ExtObjC.h>

@interface CWTask ()
// Publicly declared
@property (readwrite, copy) NSString * executable;
@property (readwrite, retain) NSArray * arguments;
@property (readwrite, copy) NSString * directoryPath;
@property (readwrite, assign) NSInteger successCode;
// Privately Declared
@property (readwrite, assign) BOOL taskHasRun;
@property (readwrite, assign) BOOL inAsynchronous;
@property (readwrite, retain) NSPipe * pipe;
@property (readwrite, retain) NSTask * internalTask;
@end

@implementation CWTask

#pragma mark Public API -

- (id) initWithExecutable:(NSString *)exec
			 andArguments:(NSArray *)execArgs
			  atDirectory:(NSString *)path {
    self = [super init];
    if (self) {
		_executable = exec;
		_arguments = execArgs;
		_directoryPath = path;
		_successCode = kCWTaskNotLaunchedErrorCode;
		_taskHasRun = NO;
		_inAsynchronous = NO;
		_internalTask = [[NSTask alloc] init];
		_completionBlock = nil;
    }
    return self;
}

/**
 default implementation so if someone calls this and then
 tries to launch the task the method will immediately see
 that executable == nil and therefore will return immediatly
 with an error about the executable.
 
 @return an invalid CWTask object
 */
- (id) init {
    self = [super init];
    if (self) {
		_executable = nil;
		_arguments = nil;
		_directoryPath = nil;
		_successCode = kCWTaskNotLaunchedErrorCode;
		_taskHasRun = NO;
		_inAsynchronous = NO;
		_internalTask = nil;
		_completionBlock = nil;
    }
    return self;
}

/**
 * Description for debug information
 */
- (NSString *) description {
    return [NSString stringWithFormat:@"CWTask: Executable('%@')\nArguements: %@\nDirectory Path:%@",
			self.executable, self.arguments, self.directoryPath];
}

/**
 Configure arguments to the Task. This method is a private method.
 */
- (void) _configureTask {
	self.internalTask.launchPath = self.executable;
	self.pipe = [NSPipe pipe];
	self.internalTask.standardOutput = self.pipe;
	if (self.arguments.count > 0) {
		self.internalTask.arguments = self.arguments;
	}
	if (self.directoryPath) {
		self.internalTask.currentDirectoryPath = self.directoryPath;
	}
}

/**
 Runs all the validation methods & returns NO if any fail. Private Method.
 
 @param error a NSError object to be written to if something fails
 @return (BOOL) NO if the task fails any validation test, YES otherwise
 */
- (BOOL) _validateTask:(NSError **)error {
    if (![self _validateExecutable:error] ||
		![self _validateDirectoryPathIfApplicable:error] ||
		![self _validateTaskHasRun:error]) {
        return NO;
    }
    return YES;
}

/**
 Checks to make sure that the executable exists at the path specified.
 
 This is a private method. Checks for a non nil value of executable and checks 
 that the executable actually exists if either fail it writes out a 
 kCWTaskInvalidExecutable error to the NSError pointer and returns NO
 
 @param error a NSError object to be written to if something fails
 @return (BOOL) NO is the executable specified doesn't exist otherwise YES
 */
- (BOOL) _validateExecutable:(NSError **)error {
    if ((!self.executable) || ![[NSFileManager defaultManager] fileExistsAtPath:self.executable]) {
		if (error) {
			*error = [NSError errorWithDomain:kCWTaskErrorDomain
										 code:kCWTaskInvalidExecutableErrorCode
									 userInfo:@{ NSLocalizedFailureReasonErrorKey : @"Executable Path provided doesn't exist" }];
		}
        return NO;
    }
    return YES;
}

/**
 Private Method
 if there is a non nil directory path provided it validates that it actually 
 exists if that fails it writes out a kCWTaskInvalidDirectory error & returns NO
 
 @param error a NSError object to be written to if something fails
 @return (BOOL) YES if the directory path exists otherwise returns NO
 */
- (BOOL) _validateDirectoryPathIfApplicable:(NSError **)error {
    if (self.directoryPath) {
        if (![[NSFileManager defaultManager] fileExistsAtPath:self.directoryPath]) {
			if (error) {
				*error = [NSError errorWithDomain:kCWTaskErrorDomain
											 code:kCWTaskInvalidDirectoryErrorCode
										 userInfo:@{ NSLocalizedFailureReasonErrorKey : @"The Directory Specified does not exist & is invalid" }];
			}
            return NO;
        }
    }
    return YES;
}

/**
 Private Method
 CWTask behaves just like  NSTask in that each task object may only run once. 
 This checks to see if it has already run and if it has write out a 
 kCWTaskAlreadyRun error to the error pointer and then  returns NO
 
 @param error a NSError object to be written to if something fails
 @return (BOOL) YES if the task has not been run, otherwise returns NO
 */
- (BOOL) _validateTaskHasRun:(NSError **)error {
    if (self.taskHasRun) {
		if (error) {
			*error = [NSError errorWithDomain:kCWTaskErrorDomain
										 code:kCWTaskAlreadyRunErrorCode
									 userInfo:@{ NSLocalizedFailureReasonErrorKey: @"This CWTask Instance has already been run" }];
		}
        return NO;
    }
    return YES;
}

- (NSString *) launchTask:(NSError **)error {
    if (![self _validateTask:error]) return nil;
	
    NSString * resultsString = nil;
	if (!self.taskHasRun) {
		[self _configureTask];
		resultsString = [self _resultsStringFromLaunchedTask:error];
		self.taskHasRun = YES;
		[self _performPostRunActionsIfApplicable];
	}
    return resultsString;
}

/**
 Private Method
 actual launching of the task and extracting the results from
 the NSPipe into a NSString object occur here
 
 @return a NSString object with the contents of the lauched tasks output
 */
- (NSString *) _resultsStringFromLaunchedTask:(NSError **)error {
    NSData * returnedData = nil;
    NSString * taskOutput = nil;

    @try {
        [self.internalTask launch];
    }
    @catch (NSException * e) {
		NSLog(@"caught exception: %@",e);
		if (error) {
			*error = [NSError errorWithDomain:kCWTaskErrorDomain
										 code:kCWTaskEncounteredExceptionOnRunErrorCode
									 userInfo:@{ NSLocalizedFailureReasonErrorKey : [e description] }];
		}
    }

    returnedData = [[self.pipe fileHandleForReading] readDataToEndOfFile];
    if (returnedData) {
        taskOutput = [[NSString alloc] initWithData:returnedData 
										   encoding:NSUTF8StringEncoding];
    }
    return taskOutput;
}

/**
 Private Method
 any post run actions after the task have been launched occurr here
 
 @param error a NSError object to be written to if something fails
 */
- (void) _performPostRunActionsIfApplicable {
    if (!self.internalTask.isRunning) {
		self.successCode = self.internalTask.terminationStatus;
    }
	if ((!self.inAsynchronous) && self.completionBlock) {
		self.completionBlock();
	}
}

-(void)launchTaskWithResult:(void (^)(NSString *output, NSError *error))block {
	NSString *uLabel = [NSString stringWithFormat:@"com.CWTask.%@_",self.executable];
	const char *uniqueLabel = [[uLabel stringByAppendingString:NSUUID.UUID.UUIDString]  UTF8String];
//  CWUUIDStringPrependedWithString()

	dispatch_queue_t queue = dispatch_queue_create(uniqueLabel, DISPATCH_QUEUE_SERIAL);
	self.inAsynchronous = YES;
  __weak __typeof(self) wSelf = self;
	dispatch_async(queue, ^{
//		@strongify(self);
		NSError * taskError;
		NSString * resultsString = nil;
		
		resultsString = [wSelf launchTask:&taskError];
		
		dispatch_async(dispatch_get_main_queue(), ^{
			block(resultsString, taskError);
		});
	});
	queue = nil;
}

- (void) launchTaskOnQueue:(NSOperationQueue *)queue 
	   withCompletionBlock:(void (^)(NSString * output, NSError * error))block {
	NSParameterAssert(!!queue);
  NSParameterAssert(!!block);
	self.inAsynchronous = YES;
//	@weakify(self);
    __weak __typeof(self) wSelf = self;
    [queue addOperationWithBlock:^{
//		@strongify(self);
		NSError * taskError;
		NSString * resultsString = nil;
		
		resultsString = [wSelf launchTask:&taskError];
		
		[[NSOperationQueue mainQueue] addOperationWithBlock:^{
			block (resultsString, taskError);
		}];
     }];
}

- (void) launchTaskOnGCDQueue:(dispatch_queue_t)queue
		  withCompletionBlock:(void (^)(NSString * output, NSError * error))block {
	NSParameterAssert(queue != nil);
	NSParameterAssert(block != nil);
	self.inAsynchronous = YES;
  __weak __typeof(self) wSelf = self;
    dispatch_async(queue, ^{
//		@strongify(self);
		NSError * taskError;
		NSString * resultsString = nil;

		resultsString = [wSelf launchTask:&taskError];

		dispatch_async (dispatch_get_main_queue (), ^{
			block (resultsString, taskError);
		});
	});
}

@end
