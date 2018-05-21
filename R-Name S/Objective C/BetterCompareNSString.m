//
//  BetterCompareNSString.m
//  R-Name
//
//  Created by Yoichi Tagaya on Thu Apr 04 2002.
//  Copyright (c) 2001 Yoichi Tagaya. All rights reserved.
//

#import "BetterCompareNSString.h"


@implementation NSString (BetterCompareNSString) // Category of NSString

- (NSComparisonResult) reverseCompare: (NSString *)strRight
{
   return [strRight compare: self];
}


- (NSComparisonResult) caseInsensitiveReverseCompare: (NSString *)strRight
{
   return [strRight caseInsensitiveCompare: self];
}



- (NSComparisonResult) compareSize: (NSString *)strRight
{
   NSDictionary *dctAttribute;
   NSNumber *numSelf, *numRight;
   NSFileManager *fmDefault = [NSFileManager defaultManager];

   if ([fmDefault fileExistsAtPath: self] && [fmDefault fileExistsAtPath: strRight]) {
      dctAttribute = [fmDefault fileAttributesAtPath: self
                                        traverseLink: NO];
      numSelf = [dctAttribute objectForKey: NSFileSize];

      dctAttribute = [fmDefault fileAttributesAtPath: strRight
                                        traverseLink: NO];
      numRight = [dctAttribute objectForKey: NSFileSize];

      return [numSelf compare: numRight];
   }
   else {
      NSLog(@"compareDateModified:  File not exist");

      return NSOrderedSame;
   }   
}


- (NSComparisonResult) reverseCompareSize: (NSString *)strRight
{
   NSDictionary *dctAttribute;
   NSNumber *numSelf, *numRight;
   NSFileManager *fmDefault = [NSFileManager defaultManager];

   if ([fmDefault fileExistsAtPath: self] && [fmDefault fileExistsAtPath: strRight]) {
      dctAttribute = [fmDefault fileAttributesAtPath: self
                                        traverseLink: NO];
      numSelf = [dctAttribute objectForKey: NSFileSize];

      dctAttribute = [fmDefault fileAttributesAtPath: strRight
                                        traverseLink: NO];
      numRight = [dctAttribute objectForKey: NSFileSize];

      return [numRight compare: numSelf];
   }
   else {
      NSLog(@"compareDateModified:  File not exist");

      return NSOrderedSame;
   }   
}

- (NSComparisonResult) compareDateModified: (NSString *)strRight
{
   NSDictionary *dctAttribute;
   NSDate *dtSelf, *dtRight;
   NSFileManager *fmDefault = [NSFileManager defaultManager];

   if ([fmDefault fileExistsAtPath: self] && [fmDefault fileExistsAtPath: strRight]) {
      dctAttribute = [fmDefault fileAttributesAtPath: self
                                        traverseLink: NO];
      dtSelf = [dctAttribute objectForKey: NSFileModificationDate];
      
      dctAttribute = [fmDefault fileAttributesAtPath: strRight
                                        traverseLink: NO];
      dtRight = [dctAttribute objectForKey: NSFileModificationDate];

      return [dtSelf compare: dtRight];
   }
   else {
      NSLog(@"compareDateModified:  File not exist");
      
      return NSOrderedSame;
   }
}


- (NSComparisonResult) reverseCompareDateModified: (NSString *)strRight
{
   NSDictionary *dctAttribute;
   NSDate *dtSelf, *dtRight;
   NSFileManager *fmDefault = [NSFileManager defaultManager];

   if ([fmDefault fileExistsAtPath: self] && [fmDefault fileExistsAtPath: strRight]) {
      dctAttribute = [fmDefault fileAttributesAtPath: self
                                        traverseLink: NO];
      dtSelf = [dctAttribute objectForKey: NSFileModificationDate];

      dctAttribute = [fmDefault fileAttributesAtPath: strRight
                                        traverseLink: NO];
      dtRight = [dctAttribute objectForKey: NSFileModificationDate];

      return [dtRight compare: dtSelf];
   }
   else {
      NSLog(@"reverseCompareDateModified:  File not exist");

      return NSOrderedSame;
   }
}



- (NSComparisonResult) compareDateCreated: (NSString *)strRight
{
   NSDictionary *dctAttribute;
   NSDate *dtSelf, *dtRight;
   NSFileManager *fmDefault = [NSFileManager defaultManager];

   if ([fmDefault fileExistsAtPath: self] && [fmDefault fileExistsAtPath: strRight]) {
      dctAttribute = [fmDefault fileAttributesAtPath: self
                                        traverseLink: NO];
      dtSelf = [dctAttribute objectForKey: NSFileCreationDate];
      
      dctAttribute = [fmDefault fileAttributesAtPath: strRight
                                        traverseLink: NO];
      dtRight = [dctAttribute objectForKey: NSFileCreationDate];

      return [dtSelf compare: dtRight];
   }
   else {
      NSLog(@"compareDateCreated:  File not exist");
      
      return NSOrderedSame;
   }
}


- (NSComparisonResult) reverseCompareDateCreated: (NSString *)strRight
{
   NSDictionary *dctAttribute;
   NSDate *dtSelf, *dtRight;
   NSFileManager *fmDefault = [NSFileManager defaultManager];

   if ([fmDefault fileExistsAtPath: self] && [fmDefault fileExistsAtPath: strRight]) {
      dctAttribute = [fmDefault fileAttributesAtPath: self
                                        traverseLink: NO];
      dtSelf = [dctAttribute objectForKey: NSFileCreationDate];

      dctAttribute = [fmDefault fileAttributesAtPath: strRight
                                        traverseLink: NO];
      dtRight = [dctAttribute objectForKey: NSFileCreationDate];

      return [dtRight compare: dtSelf];
   }
   else {
      NSLog(@"reverseCompareDateCreated:  File not exist");

      return NSOrderedSame;
   }
}


@end
