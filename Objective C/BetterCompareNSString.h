//
//  BetterCompareNSString.h
//  R-Name
//
//  Created by Yoichi Tagaya on Thu Apr 04 2002.
//  Copyright (c) 2002 Yoichi Tagaya. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface NSString (BetterCompareNSString)  // Category of NSString

// This category add method that makes NSString compare themselves better than defaut one.

- (NSComparisonResult) reverseCompare: (NSString *)strRight;
- (NSComparisonResult) caseInsensitiveReverseCompare: (NSString *)strRight;

- (NSComparisonResult) compareSize: (NSString *)strRight;
- (NSComparisonResult) reverseCompareSize: (NSString *)strRight;

- (NSComparisonResult) compareDateModified: (NSString *)strRight;
- (NSComparisonResult) reverseCompareDateModified: (NSString *)strRight;

- (NSComparisonResult) compareDateCreated: (NSString *)strRight;
- (NSComparisonResult) reverseCompareDateCreated: (NSString *)strRight;

@end
