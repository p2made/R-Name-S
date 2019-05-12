//
//  PerlWrapper.h
//  PerlWrapper
//
//  Created by Yoichi Tagaya on Tue Nov 05 2002.
//  Copyright (c) 2002 Yoichi Tagaya. All rights reserved.
//

#import <Foundation/Foundation.h>

#define INVALID_REG_EXP_EXCEPTION @"InvalidRegularExpressionException"

#define PERL_PATH @"/usr/bin/perl"
#define RELATIVE_SCRIPT_PATH @"/Contents/Resources/regex.pl"


@interface PerlWrapper : NSObject {
	NSString *myStrOrigin;
	NSString *myStrFound;
	NSString *myStrReplacedWith;
	NSMutableString *myMstrOptions;
	BOOL myBOptionG;
	BOOL myBOptionI;
	NSMutableString *myMstrScriptPath;
//	StringsManager *mySmManager;
}

- (id) init;
- (void) dealloc;

- (void) setOriginalString: (NSString *)strOrigin;
- (void) setStringToBeFound: (NSString *)strFound;
- (void) setStringToBeReplacedWith: (NSString *)strReplacedWith;
- (void) setOptionG: (BOOL) bOptionG;
- (void) setOptionI: (BOOL) bOptionI;

// This method throws a exception named "InvalidRegularExpressionException"
// if some strings above are wrong as regular expressions.
// Use defined exception name: INVALID_REG_EXP_EXCEPTION.
- (NSString *)replace;

@end
