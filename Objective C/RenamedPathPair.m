//
//  RenamedPathPair.m
//  Active R-Name
//
//  Created by Yoichi Tagaya on Tue Nov 05 2002.
//  Copyright (c) 2002 Yoichi Tagaya. All rights reserved.
//

#import "RenamedPathPair.h"



@implementation RenamedPathPair

#pragma mark ##PrivateMethods##

// This method set 'myBActualRenaming' and 'myBActualRenaming'.
- (void) checkAndSetPathPairState
{
	int iRDPLength = [myStrRelativeDestinationPath length];
	
	if (iRDPLength == 0) {
		myPpsState = NO_DESTINATION;
		myBActualRenaming = NO;
	}
	else if (iRDPLength > MAX_FILENAME_LENGTH) {
		myPpsState = LONG;
		myBActualRenaming = NO;
	}
	else if ([myStrRelativeDestinationPath isEqualToString: 
	                                      myStrRelativeSourcePath]) {
		myPpsState = SAME;
		myBActualRenaming = NO;
	}
	else if ([myStrRelativeDestinationPath caseInsensitiveCompare:
	                     myStrRelativeSourcePath] == NSOrderedSame) {
		myPpsState = SAME_EXCEPT_CASES;
		myBActualRenaming = YES;
	}
	else if ([[NSFileManager defaultManager] fileExistsAtPath:
					[myStrCurrentDirectoryPath stringByAppendingPathComponent: 
					                               myStrRelativeDestinationPath]]) {
		myPpsState = EXIST;
		myBActualRenaming = NO;
	}
	else if ([[myStrRelativeDestinationPath lastPathComponent] characterAtIndex: 0] == '.') {
		myPpsState = START_WITH_DOT;
		myBActualRenaming = NO;
	}
	else {
		myPpsState = OK;
		myBActualRenaming = YES;
	}
}




#pragma mark ##Public_Methods##

#pragma mark #GeneralMethods
// general methods
- (id) initWithRelativeSourcePath: (NSString *)strSPath
                      atDirectory: (NSString *)strDPath
{
   self = [super init];
   
	myStrRelativeSourcePath = [strSPath retain];
	myStrCurrentDirectoryPath = [strDPath retain];
	myStrRelativeDestinationPath = [[NSString alloc] init];
	myBActualRenaming = NO;
	myPpsState = NO_DESTINATION;
   
   return self;
}

- (void) dealloc
{
	[myStrRelativeSourcePath release];
	[myStrCurrentDirectoryPath release];
	[myStrRelativeDestinationPath release];

   [super dealloc];
}

- (NSString *) absoluteSourcePath
{
	return [myStrCurrentDirectoryPath stringByAppendingPathComponent: myStrRelativeSourcePath];
}

- (NSString *) relativeSourcePath
{
	return myStrRelativeSourcePath;
}

- (NSString *) sourceLastPathComponent
{
	return [myStrRelativeSourcePath lastPathComponent];
}

- (NSString *) currentDirectoryPath
{
	return myStrCurrentDirectoryPath;
}



- (PathPairState) setDestinationLastPathComponent: (NSString *)strDLastPathComponent
{
	NSRange rngInvalidChar;
	
	rngInvalidChar = [strDLastPathComponent rangeOfCharacterFromSet:
	                       [NSCharacterSet characterSetWithCharactersInString: STRING_MADE_OF_INVALID_CHARS]];
	if (rngInvalidChar.location == NSNotFound) {
		NSString *strRelativeDPath;
		strRelativeDPath = [[myStrRelativeSourcePath stringByDeletingLastPathComponent]
											stringByAppendingPathComponent: strDLastPathComponent];
		[myStrRelativeDestinationPath release];
		myStrRelativeDestinationPath = [strRelativeDPath retain];
		[self checkAndSetPathPairState];
	}
	else { // if invalid character is entered
		[myStrRelativeDestinationPath release];
		myStrRelativeDestinationPath = [[NSString alloc] init];
		myPpsState = INVALID_CHARACTER;
		myBActualRenaming = NO;
	}
	
	return myPpsState;
}


- (NSString *) absoluteDestinationPath
{
	if ([myStrRelativeDestinationPath length] == 0) {
		return @"";
	}
	else {
		return [myStrCurrentDirectoryPath stringByAppendingPathComponent: myStrRelativeDestinationPath];
	}
}

- (NSString *) relativeDestinationPath
{
	return myStrRelativeDestinationPath;
}

- (void) clearDestinationPath
{
	[myStrRelativeDestinationPath release];
	myStrRelativeDestinationPath = [[NSString alloc] init];
	myBActualRenaming = NO;
	myPpsState = NO_DESTINATION;
}


- (BOOL) setActualRenaming: (BOOL) bActualRenaming
{
	if (myPpsState == OK || myPpsState == SAME_EXCEPT_CASES) {
		return myBActualRenaming = bActualRenaming;
	}
	else {
		return myBActualRenaming = NO;
	}
}


- (BOOL) actualRenaming
{
	return myBActualRenaming;
}

- (PathPairState) pathPairState
{
	return myPpsState;
}

- (void) setPathPairStateToInvalidRegrep
{
	myPpsState = INVALID_REGEXP;
}


- (BOOL) isFile
{
	return ![self isFolder];
}


- (BOOL) isFolder
{
	BOOL bFol;
	[[NSFileManager defaultManager] fileExistsAtPath: [self absoluteSourcePath]
													 isDirectory: &bFol];
	return bFol;
}



// This method synchronize move source path to destination path.
- (BOOL) renameOldPathToNew
{
	NSString *strMp = [self absoluteSourcePath];
	NSString *strTp = [self absoluteDestinationPath];

	if (myBActualRenaming == YES) {
		if (myPpsState == OK) {
			return [[NSFileManager defaultManager] movePath: strMp
			                                         toPath: strTp
																 handler: nil];

		}
		else { // if (myPpsState == SAME_EXCEPT_CASES)
			NSMutableString *mstrTempPath;
			int iAppend = 0;
			do {
				mstrTempPath = [NSMutableString stringWithString: strMp];
				[mstrTempPath appendFormat: @"%d", iAppend];
				iAppend++;
			} while ([[NSFileManager defaultManager] fileExistsAtPath: mstrTempPath]);
			
			if ([[NSFileManager defaultManager] movePath: strMp
															  toPath: mstrTempPath
															 handler: nil]) {
				return [[NSFileManager defaultManager] movePath: mstrTempPath
			                                            toPath: strTp
															    	 handler: nil];
			}
			return NO;
		}
	}
	else { // if (myBActualRenaming == NO)
		return NO;
	}
}



#pragma mark # Compare Method

- (NSComparisonResult) compare: (RenamedPathPair *)rppRight
{
	return [myStrRelativeSourcePath compare: [rppRight relativeSourcePath]];
}

- (NSComparisonResult) caseInsensitiveCompare: (RenamedPathPair *)rppRight
{
	return [myStrRelativeSourcePath caseInsensitiveCompare: [rppRight relativeSourcePath]];
}

- (NSComparisonResult) reverseCompare: (RenamedPathPair *)rppRight
{
	return [myStrRelativeSourcePath reverseCompare: [rppRight relativeSourcePath]];
}

- (NSComparisonResult) caseInsensitiveReverseCompare: (RenamedPathPair *)rppRight
{
	return [myStrRelativeSourcePath caseInsensitiveReverseCompare: [rppRight relativeSourcePath]];
}

- (NSComparisonResult) compareSize: (RenamedPathPair *)rppRight
{
	return [[self absoluteSourcePath] compareSize: [rppRight absoluteSourcePath]];
}

- (NSComparisonResult) reverseCompareSize: (RenamedPathPair *)rppRight
{
	return [[self absoluteSourcePath] reverseCompareSize: [rppRight absoluteSourcePath]];
}

- (NSComparisonResult) compareDateModified: (RenamedPathPair *)rppRight
{
	return [[self absoluteSourcePath] compareDateModified: [rppRight absoluteSourcePath]];
}

- (NSComparisonResult) reverseCompareDateModified: (RenamedPathPair *)rppRight
{
	return [[self absoluteSourcePath] reverseCompareDateModified: [rppRight absoluteSourcePath]];
}

- (NSComparisonResult) compareDateCreated: (RenamedPathPair *)rppRight
{
	return [[self absoluteSourcePath] compareDateCreated: [rppRight absoluteSourcePath]];
}

- (NSComparisonResult) reverseCompareDateCreated: (RenamedPathPair *)rppRight
{
	return [[self absoluteSourcePath] reverseCompareDateCreated: [rppRight absoluteSourcePath]];
}



- (NSString *) description
{
	NSArray *aTemp = [NSArray arrayWithObjects: myStrCurrentDirectoryPath,
	                                            myStrRelativeSourcePath,
															  myStrRelativeDestinationPath,
															  [NSNumber numberWithBool: myBActualRenaming],
															  [NSNumber numberWithInt: myPpsState],
															  nil];
	return [aTemp description];
}


@end
