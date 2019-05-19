//
//  RenamedPathPair.h
//  Active R-Name
//
//  Created by Yoichi Tagaya on Tue Nov 05 2002.
//  Copyright (c) 2002 Yoichi Tagaya. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Definitions.h"
#import "BetterCompareNSString.h"

@interface RenamedPathPair : NSObject {
	NSString *myStrCurrentDirectoryPath;
	NSString *myStrRelativeSourcePath;
	NSString *myStrRelativeDestinationPath;
	
	BOOL myBActualRenaming;
	PathPairState myPpsState;
}

// general methods
- (id) initWithRelativeSourcePath: (NSString *)strSPath
                      atDirectory: (NSString *)strDPath;
- (void) dealloc;

// about source
- (NSString *) absoluteSourcePath;
- (NSString *) relativeSourcePath;
- (NSString *) sourceLastPathComponent;

- (NSString *) currentDirectoryPath;

// about destination
- (PathPairState) setDestinationLastPathComponent: (NSString *)strDLastPathComponent;
- (NSString *) absoluteDestinationPath;
- (NSString *) relativeDestinationPath;
- (void) clearDestinationPath;

// This method returns the value which is changed by means of this method.
// If PathPairState is not OK or SAME_EXCEPT_CASES, this method does nothing.
- (BOOL) setActualRenaming: (BOOL)bActualRenaming;

- (BOOL) actualRenaming;

- (PathPairState) pathPairState;

- (void) setPathPairStateToInvalidRegrep;

- (BOOL) isFile;
- (BOOL) isFolder;

// This method synchronize move source path to destination path
// and return YES if moving path is success, otherwise NO.
- (BOOL) renameOldPathToNew;

// These methods compare relative source paths
- (NSComparisonResult) compare: (RenamedPathPair *)rppRight;
- (NSComparisonResult) caseInsensitiveCompare: (RenamedPathPair *)rppRight;
- (NSComparisonResult) reverseCompare: (RenamedPathPair *)rppRight;
- (NSComparisonResult) caseInsensitiveReverseCompare: (RenamedPathPair *)rppRight;
- (NSComparisonResult) compareSize: (RenamedPathPair *)rppRight;
- (NSComparisonResult) reverseCompareSize: (RenamedPathPair *)rppRight;
- (NSComparisonResult) compareDateModified: (RenamedPathPair *)rppRight;
- (NSComparisonResult) reverseCompareDateModified: (RenamedPathPair *)rppRight;
- (NSComparisonResult) compareDateCreated: (RenamedPathPair *)rppRight;
- (NSComparisonResult) reverseCompareDateCreated: (RenamedPathPair *)rppRight;

// For debug
- (NSString *) description;

@end
