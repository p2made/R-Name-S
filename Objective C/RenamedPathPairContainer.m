//
//  RenamedPathPairContainer.m
//  Active R-Name
//
//  Created by Yoichi Tagaya on Wed Nov 06 2002.
//  Copyright (c) 2002 Yoichi Tagaya. All rights reserved.
//

#import "RenamedPathPairContainer.h"


@implementation RenamedPathPairContainer


#pragma mark ## Private Methods ##

- (BOOL) havingSameSourceInContainer: (NSString *)strSPath AtDirectory: (NSString *)strDPath
{
	NSString *strAbsoluteSourcePath = [strDPath stringByAppendingPathComponent: strSPath];
	NSEnumerator *enmPathPairs = [myMaViewOrder reverseObjectEnumerator];
	RenamedPathPair *rppTemp;
	
	while ((rppTemp = [enmPathPairs nextObject]) != nil) {
		NSAutoreleasePool *arpool = [[NSAutoreleasePool alloc] init];
		if ([[rppTemp absoluteSourcePath] isEqualToString: strAbsoluteSourcePath]) {
			[arpool release];
			return YES;
		}
		[arpool release];
	}
	return NO;
}



#pragma mark ## Public Methods ##

- (id) init
{
	NSNumber *numYes = [NSNumber numberWithBool: YES];
	NSNumber *numNo = [NSNumber numberWithBool: NO];

   self = [super init];
	
	myMaViewOrder = [[NSMutableArray alloc] initWithCapacity: 10];
	myMaRenamingOrder = [[NSMutableArray alloc] initWithCapacity: 10];
	myMaPathPairsStates = [[NSMutableArray alloc] initWithObjects: numYes, // NO_DESTINATION
	                                                               numNo,  // OK
	                                                               numNo,  // SAME_EXCEPT_CASES
	                                                               numNo,  // SAME
	                                                               numNo,  // EXIST
	                                                               numNo,  // LONG
	                                                               numNo,  // START_WITH_DOT
	                                                               numNo,  // INVALID_REGEXP
	                                                               nil];	
	delegate = nil;
	return self;
}


- (void) dealloc
{
	[myMaViewOrder release];
	[myMaRenamingOrder release];
	[myMaPathPairsStates release];
	if (delegate != nil) {
		[delegate release];
	}
	
   [super dealloc];
}


- (void) setDelegate: (id)anObject
{
	if (delegate != nil) {
		[delegate release];
	}
	delegate = [anObject retain];
}

- (id) delegate
{
	return delegate;
}



- (unsigned) count
{
	return [myMaViewOrder count];
}
	
	
- (void) clearRenamedPathPairs
{
	NSNumber *numYes = [NSNumber numberWithBool: YES];
	NSNumber *numNo = [NSNumber numberWithBool: NO];
	
	[myMaViewOrder release];
	[myMaRenamingOrder release];
	[myMaPathPairsStates release];

	myMaViewOrder = [[NSMutableArray alloc] initWithCapacity: 10];
	myMaRenamingOrder = [[NSMutableArray alloc] initWithCapacity: 10];
	myMaPathPairsStates = [[NSMutableArray alloc] initWithObjects: numYes, // NO_DESTINATION
	                                                               numNo,  // OK
	                                                               numNo,  // SAME_EXCEPT_CASES
	                                                               numNo,  // SAME
	                                                               numNo,  // EXIST
	                                                               numNo,  // LONG
	                                                               numNo,  // START_WITH_DOT
	                                                               numNo,  // INVALID_REGEXP
	                                                               nil];
}


- (void) addRelativeSourcePaths: (NSArray *)aSPaths
						  atDirectory: (NSString *)strDPath
{
	NSString *strTempSPath;
	NSMutableArray *maTempPairs = [NSMutableArray arrayWithCapacity: 10];
	NSEnumerator *enmSPaths  = [aSPaths objectEnumerator];

	while ((strTempSPath = [enmSPaths nextObject]) != nil) {
		RenamedPathPair *rppTemp;
		NSAutoreleasePool *arpool = [[NSAutoreleasePool alloc] init];
		
		if ([self havingSameSourceInContainer: strTempSPath AtDirectory: strDPath] == NO) {
			rppTemp = [[[RenamedPathPair alloc] initWithRelativeSourcePath: strTempSPath
																	         atDirectory: strDPath] autorelease];
			[maTempPairs addObject: rppTemp];
		}
		[arpool release];
	}
	
	[myMaViewOrder addObjectsFromArray: maTempPairs];
	// IF YOU WANT TO MAKE THIS PROGRAM HAVE PRICISE RENAMING ORDER,
	// MODIFY THE FOLLOWING LINE.
	[myMaRenamingOrder addObjectsFromArray: maTempPairs];
}


- (RenamedPathPair *) pathPairAtViewIndex: (int)iIndex
{
	return [myMaViewOrder objectAtIndex: iIndex];
}


- (NSString *) sourceLastPathComponentAtViewIndex: (int)iIndex
{
	return [[myMaViewOrder objectAtIndex: iIndex] sourceLastPathComponent];
}


- (PathPairState) setDestinationLastPathComponent: (NSString *)strDLastPathComponent
												  AtViewIndex: (int)iIndex
{
	return [[myMaViewOrder objectAtIndex: iIndex] setDestinationLastPathComponent: strDLastPathComponent];
}


- (BOOL) setActualRenaming: (BOOL)bActualRename AtViewIndex: (int)iIndex
{
	return [[self pathPairAtViewIndex: iIndex] setActualRenaming: bActualRename];
}

// This method returns YES if there are paths which are moved, otherwise NO.
- (BOOL) renameOldPathsToNew
{
	RenamedPathPair *rppTemp;
	NSEnumerator *enmPathPairs = [myMaRenamingOrder reverseObjectEnumerator];
	BOOL bRet = NO;
	
	while ((rppTemp = [enmPathPairs nextObject]) != nil) {
		NSAutoreleasePool *arpool = [[NSAutoreleasePool alloc] init];
		if ([rppTemp renameOldPathToNew] == YES) {
			bRet = YES;
		}
		if (delegate!=nil && [delegate respondsToSelector: @selector(endOneRenaming)]) {
			[delegate endOneRenaming];
		}
		[arpool release];
	}
	
	return bRet;
}

- (void) sortViewOrderBy: (ViewOrder)vo
{
	switch (vo) {
	case NONE:
		break;
	case ALPHABETIC:
		[myMaViewOrder sortUsingSelector: @selector(compare:)];
		break;
	case CASE_INSENSITIVE_ALPHABETIC:
		[myMaViewOrder sortUsingSelector: @selector(caseInsensitiveCompare:)];
		break;
	case REVERSE_ALPHABETIC:
		[myMaViewOrder sortUsingSelector: @selector(reverseCompare:)];
		break;
	case CASE_INSENSITIVE_REVERSE_ALPHABETIC:
		[myMaViewOrder sortUsingSelector: @selector(caseInsensitiveReverseCompare:)];
		break;
	case SIZE:
		[myMaViewOrder sortUsingSelector: @selector(compareSize:)];
		break;
	case REVERSE_SIZE:
		[myMaViewOrder sortUsingSelector: @selector(reverseCompareSize:)];
		break;
	case DATE_MODIFIED:
		[myMaViewOrder sortUsingSelector: @selector(compareDateModified:)];
		break;
	case REVERSE_DATE_MODIFIED:
		[myMaViewOrder sortUsingSelector: @selector(reverseCompareDateModified:)];
		break;
	case DATE_CREATED:
		[myMaViewOrder sortUsingSelector: @selector(compareDateCreated:)];
		break;
	case REVERSE_DATE_CREATED:
		[myMaViewOrder sortUsingSelector: @selector(reverseCompareDateCreated:)];
		break;
	}
}



// For debug
- (NSString *) description
{
	return [myMaViewOrder description];
}




@end
