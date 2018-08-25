//
//  StringsManager.m
//  R-Name
//
//  Created by tayo on Tue Apr 02 2002.
//  Copyright (c) 2002 tayo. All rights reserved.
//

#import "StringsManager.h"


@implementation StringsManager

///////// Unavailable Functions for class users //////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark Unavailable_Functions_for_class_users






/////////// Public Methods ///////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark Public_Methods


- (id) init
{
   self = [super init];
   
   bMyCaseSensitive = YES;
   bMyReplaceAllFound = YES;
   
   return self;
}

- (void) dealloc
{
   [super dealloc];
}


// Configuring an StringManager ///////////////////////
- (BOOL) caseSensitive
{
   return bMyCaseSensitive;
}

- (void) setCaseSensitive: (BOOL)bCaseSensitive
{
   bMyCaseSensitive = bCaseSensitive;
}

- (BOOL) replaceAllFound
{
   return bMyReplaceAllFound;
}

- (void) setReplaceAllFound: (BOOL)bReplaceAllFound
{
   bMyReplaceAllFound = bReplaceAllFound;
}

// End Configuring an StringManager ///////////////////





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
              replace: (NSString *)strReplace
{
   NSScanner *scScanner;
   NSString *strScaned;
   BOOL bFound = NO;
   NSMutableString *mstrModifiedString;
   
   mstrModifiedString = [NSMutableString stringWithCapacity: [strStringToModify length]];
   
   scScanner = [NSScanner scannerWithString: strStringToModify];
   [scScanner setCaseSensitive: bMyCaseSensitive];
   [scScanner setCharactersToBeSkipped: nil];
   
   // In this case, for example
   // find: "me", replace: "you",   "me and me" --> "you and you"
   if (bMyReplaceAllFound == YES) {
      while(![scScanner isAtEnd]) {
         if ([scScanner scanUpToString: strFind intoString: &strScaned]) {
            [mstrModifiedString appendString: strScaned];
         }
         if ([scScanner scanString: strFind intoString: &strScaned]) {
            [mstrModifiedString appendString: strReplace];
            bFound = YES;
         }
      }
   }
   // In this case, for example
   // find: "me", replace: "you",   "me and me" --> "you and me"
   else { // bMyReplaceAllFound == NO
      while(![scScanner isAtEnd]) {
         if ([scScanner scanUpToString:strFind intoString: &strScaned]) {
            [mstrModifiedString appendString: strScaned];
         }
         if ([scScanner scanString:strFind intoString:nil]) {
            if (bFound == NO) {
               [mstrModifiedString appendString: strReplace];
            }
            else {
               [mstrModifiedString appendString: strFind];            
            }
            
            bFound = YES;      
         }
      }
   }
   
   *strStringModified = mstrModifiedString;
   return bFound;
}





// This method returns string that is converted '/' and ':'
- (NSString *) stringWithSlushAndColonConverted: (NSString *)strBefore
{
   NSMutableString *strAfter = [NSMutableString stringWithCapacity: [strBefore length]];
   NSScanner *scScanner = [NSScanner scannerWithString: strBefore];
   NSCharacterSet *csSlushOrColon = [NSCharacterSet characterSetWithCharactersInString: @"/:"];
   NSString *strNoSlushOrColon, *strSlushOrColon;

   if (strBefore == nil) {
      return nil;
   }
   if ([strBefore length] == 0) {
      return @"";
   }

   [scScanner setCharactersToBeSkipped: nil];
   while(![scScanner isAtEnd]) {
      if ([scScanner scanUpToCharactersFromSet: csSlushOrColon intoString: &strNoSlushOrColon]) {
         [strAfter appendString: strNoSlushOrColon];
      }
      if ([scScanner scanCharactersFromSet: csSlushOrColon intoString: &strSlushOrColon]) {
         int iCount;

         for (iCount = 0; iCount < [strSlushOrColon length]; iCount++) {
            if ([strSlushOrColon characterAtIndex: iCount] == '/') {
               [strAfter appendString: @":"];
            }
            else { // if it is ':'
               [strAfter appendString: @"/"];
            }
         }
      }
   }

   return strAfter;
}




@end
