//
//  FilesRenamer.h
//  Active R-Name
//
//  Created by Yoichi Tagaya on Wed Nov 06 2002.
//  Copyright (c) 2002 Yoichi Tagaya. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RenamedPathPair.h"
#import "RenamedPathPairContainer.h"
#import "StringsManager.h"
#import "PerlWrapper.h"

@interface FilesRenamer : NSObject {
	RenamedPathPairContainer *myRppcContainer;
	BOOL myBAddingFiles; // default: YES
	BOOL myBAddingFolders; // default: NO
	BOOL myBRecursingFolder; // default: YES
	
	// utilities
	StringsManager *smManager;
	PerlWrapper *pwRegexp;
}

- (id) initWithController: (id)idController;
- (void) dealloc;

- (void) clearRenamedPathPairs;
- (void) addAbsoluteSourcePaths: (NSArray *)aAbsoluteSPaths;

- (int) countOfAddedPaths;
- (NSString *) relativeSourcePathAtIndex: (int)iIndex;
- (NSString *) relativeDestinationPathAtIndex: (int)iIndex;
- (BOOL) actualRenamingAtIndex: (int)iIndex;
- (PathPairState) pathPairStateAtIndex: (int)iIndex;

- (void) sortPathPairsOrderBy: (ViewOrder)voOder;


// This method returns the value which is changed by means of this method.
// If PathPairState is not OK or SAME_EXCEPT_CASES, this method does nothing.
- (BOOL) setActualRenaming: (BOOL)bActualRename AtIndex: (int)iIndex;

// This method returns YES if there are paths which are moved, otherwise NO.
- (BOOL) renameOldPathsToNew;


// "Add to List" options
- (void) setAddingFiles: (BOOL)bAdd;
- (BOOL) addingFiles;
- (void) setAddingFolders: (BOOL)bAdd;
- (BOOL) addingFolders;
- (void) setRecursingFolder: (BOOL)bRec;
- (BOOL) recursingFolder;


// Renaming Methods

- (PathPairState) findString: (NSString *)strFind
			  replaceWithString: (NSString *)strReplaceWith
				 caseInsensitive: (BOOL) bCaseInsensitive
			  replacingAllFound: (BOOL)bReplacingAllFound
			preservingExtension: (BOOL)bPreservingExtension;
			  
- (PathPairState) regularExpressionFindString: (NSString *)strFind
			                   replaceWithString: (NSString *)strReplaceWith
										caseInsensitive: (BOOL) bCaseInsensitive
			                   replacingAllFound: (BOOL)bReplacingAllFound
								  preservingExtension: (BOOL)bPreservingExtension;

// If strExtension is nil, the extension of file is preserved.
- (PathPairState) sequentialNumberWithPrefix: (NSString *)strPrefix
                                  withSuffix: (NSString *)strSuffix
										 withExtension: (NSString *)strExtension
									  withFirstNumber: (int) iFirstNumber
									    withStepValue: (int) iStepValue
								  withMinimumFigures: (int) iMinimumFigures
								         sameFigures: (BOOL) bSameFigures;
											
- (PathPairState) changeCharactersToLowercasesWithExtensionPreserved: (BOOL)bPreservingExtension;
- (PathPairState) changeCharactersToUppercasesWithExtensionPreserved: (BOOL)bPreservingExtension;
- (PathPairState) changeCharactersCapitalizedWithExtensionPreserved: (BOOL)bPreservingExtension;

- (PathPairState) addStringAtBegging: (NSString *)strAdd;
- (PathPairState) addStringAtEnd: (NSString *)strAdd;
- (PathPairState) addStringBeforeExtension: (NSString *)strAdd;

// If 'numOfCharacters' is negative, characters which is leftside of index is removed
// and the index is measured from end of filenames.
- (PathPairState) removeCharacters: (int)numOfCharacters
                         fromIndex: (int)iIndex
					preservingExtension: (BOOL)bPreservingExtension;

- (PathPairState) addExtension: (NSString *)strExtension;
- (PathPairState) changeExtension: (NSString *)strExtension;
- (PathPairState) removeExtension;



// For debug
- (NSString *) description;

@end
