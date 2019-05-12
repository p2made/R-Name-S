//
//  StringsManager.h
//  R-Name
//
//  Created by tayo on Tue Apr 02 2002.
//  Copyright (c) 2002 tayo. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface StringsManager : NSObject {
BOOL bMyCaseSensitive;  // default YES;
BOOL bMyReplaceAllFound;     // default YES;
}

- (id) init;
- (void) dealloc;

// Configuring StringManager
- (BOOL) caseSensitive;
- (void) setCaseSensitive: (BOOL)bCaseSensitive;
- (BOOL) replaceAllFound;
- (void) setReplaceAllFound: (BOOL)bReplaceAllFound;





// This method find & replace string.
// This method returns YES if string was found & replaced, otherwise NO.
// For example
// 	strString = @"Hello, World"
// 	strFind = @"Hello"
// 	strReplace = @"Good morning"
//			--> Return YES, strStringModified = @"Good morning, World".
- (BOOL) modifyString: (NSString *)strStringToModify
             toString: (NSString **)strStringModified
                 find: (NSString *)strFind
              replace: (NSString *)strReplace;



// This method returns string that is converted '/' and ':'
- (NSString *) stringWithSlushAndColonConverted: (NSString *)strBefore;
              
@end
