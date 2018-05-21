//
//  PerlWrapper.m
//  PerlWrapper
//
//  Created by Yoichi Tagaya on Tue Nov 05 2002.
//  Copyright (c) 2002 Yoichi Tagaya. All rights reserved.
//

#import "PerlWrapper.h"


@implementation PerlWrapper
- (id) init
{
   self = [super init];
	
	myStrOrigin = [[NSString alloc] init];
	myStrFound = [[NSString alloc] init];
	myStrReplacedWith = [[NSString alloc] init];
	myMstrOptions = [[NSMutableString alloc] init];
	myBOptionG = NO;
	myBOptionI = NO;
	
	myMstrScriptPath = [[NSMutableString alloc] init];
	[myMstrScriptPath appendString: [[NSBundle mainBundle] bundlePath]];
	[myMstrScriptPath appendString: RELATIVE_SCRIPT_PATH];
	
//	mySmManager = [[StringsManager alloc] init];

   return self;
}


- (void) dealloc
{
	[myStrOrigin release];
	[myStrFound release];
	[myStrReplacedWith release];
	[myMstrOptions release];
	[myMstrScriptPath release];
//	[mySmManager release];

   [super dealloc];
}

- (void) setOriginalString: (NSString *)strOrigin
{
	[myStrOrigin release];
	myStrOrigin = [strOrigin retain];
}

- (void) setStringToBeFound: (NSString *)strFound
{
	[myStrFound release];
	myStrFound = [strFound retain];
}

- (void) setStringToBeReplacedWith: (NSString *)strReplacedWith
{
	[myStrReplacedWith release];
	myStrReplacedWith = [strReplacedWith retain];
}

- (void) setOptionG: (BOOL) bOptionG
{
	myBOptionG = bOptionG;
	[myMstrOptions release];
	myMstrOptions = [[NSMutableString alloc] init];
	if (myBOptionG == YES) {
		[myMstrOptions appendString: @"g"];
	}
	if (myBOptionI == YES) {
		[myMstrOptions appendString: @"i"];
	}		
}

- (void) setOptionI: (BOOL) bOptionI
{
	myBOptionI = bOptionI;
	[myMstrOptions release];
	myMstrOptions = [[NSMutableString alloc] init];
	if (myBOptionG == YES) {
		[myMstrOptions appendString: @"g"];
	}
	if (myBOptionI == YES) {
		[myMstrOptions appendString: @"i"];
	}		
}


// This method throws a exception.
- (NSString *)replace
{
	NSTask *tkPerl = [[[NSTask alloc] init] autorelease];
	NSPipe *ppOutput = [[[NSPipe alloc] init] autorelease];
	NSArray *aArguments;
	
	// preparing for launching the task
	aArguments = [NSArray arrayWithObjects: myMstrScriptPath, myStrOrigin,
														 myStrFound, myStrReplacedWith,
														 myMstrOptions, nil];
	[tkPerl setArguments: aArguments];
	[tkPerl setLaunchPath: PERL_PATH];
	[tkPerl setStandardOutput: ppOutput];
	
	// ready
	[tkPerl launch];
	[tkPerl waitUntilExit];
	
//	printf("The termination status is %d\n", [tkPerl terminationStatus]);
	if ([tkPerl terminationStatus] == 0) {
		NSData *dtOutput = [[ppOutput fileHandleForReading] availableData];
		NSString *strOutput = [[NSString alloc] initWithData: dtOutput
		                                            encoding: NSUTF8StringEncoding];
		[strOutput autorelease];
		
		return strOutput;
	}
	else {
		[NSException raise: INVALID_REG_EXP_EXCEPTION
		            format: @"Invalid Regular Expression"];
		return @"";
	}
}

@end
