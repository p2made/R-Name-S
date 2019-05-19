//
//  RenamedPathPairContainer.h
//  Active R-Name
//
//  Created by Yoichi Tagaya on Wed Nov 06 2002.
//  Copyright (c) 2002 Yoichi Tagaya. All rights reserved.
//

// Inplement this selector on delegate if VIEW or CONTROLLER need
// progress indicator.
// - (void) endOneRenaming;

#import <Foundation/Foundation.h>
#import "Definitions.h"
#import "RenamedPathPair.h"

@interface RenamedPathPairContainer : NSObject {
	NSMutableArray *myMaViewOrder;
	NSMutableArray *myMaRenamingOrder;
	NSMutableArray *myMaPathPairsStates;
	id delegate;
}

- (id) init;
- (void) dealloc;

- (void) setDelegate: (id)anObject;
- (id) delegate;

- (unsigned) count;
- (void) clearRenamedPathPairs;
- (void) addRelativeSourcePaths: (NSArray *)aSPaths
						  atDirectory: (NSString *)strDPath;
- (RenamedPathPair *) pathPairAtViewIndex: (int)iIndex;

- (NSString *) sourceLastPathComponentAtViewIndex: (int)iIndex;
- (PathPairState) setDestinationLastPathComponent: (NSString *)strDLastPathComponent
												  AtViewIndex: (int)iIndex;

// This method returns the value which is changed by means of this method.
// If PathPairState is not OK or SAME_EXCEPT_CASES, this method does nothing.
- (BOOL) setActualRenaming: (BOOL)bActualRename AtViewIndex: (int)iIndex;

// This method returns YES if there are paths which are moved, otherwise NO.
- (BOOL) renameOldPathsToNew;

- (void) sortViewOrderBy: (ViewOrder)vo;

// For debug
- (NSString *) description;

@end
