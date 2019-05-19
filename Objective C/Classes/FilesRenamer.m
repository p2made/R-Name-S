//
//  FilesRenamer.m
//  Active R-Name
//
//  Created by Yoichi Tagaya on Wed Nov 06 2002.
//  Copyright (c) 2002 Yoichi Tagaya. All rights reserved.
//

#import "FilesRenamer.h"
#import <AppKit/NSWorkspace.h>


@implementation FilesRenamer

#pragma mark ## Private Methods ##

- (void) addAbsoluteSourceFilePath: (NSString *)strAbsoluteSFPath
{
	NSString *strRelativeSPath = [strAbsoluteSFPath lastPathComponent];
	if ([strRelativeSPath characterAtIndex: 0] == '.') { // Ignore dot file.
		return; 
	}

	if (myBAddingFiles == YES) {
		NSString *strCurrentDirectory = [strAbsoluteSFPath stringByDeletingLastPathComponent];
		NSArray *aRelativeSPath = [NSArray arrayWithObject: strRelativeSPath];
		[myRppcContainer addRelativeSourcePaths: aRelativeSPath
											atDirectory: strCurrentDirectory];
	}
}


- (void) addAbsoluteSourceFolderPath: (NSString *)strAbsoluteSFPath
{
	NSMutableArray *maRelativeSPaths;
	NSString *strCurrentDirectory;
	NSString *strRelativeSPath = [strAbsoluteSFPath lastPathComponent];
	
	if ([strRelativeSPath characterAtIndex: 0] == '.') { // ignore dot file.
		return;
	}
	
	maRelativeSPaths = [NSMutableArray arrayWithCapacity: 1];
	strCurrentDirectory = [strAbsoluteSFPath stringByDeletingLastPathComponent];

	if (myBAddingFolders == YES) {
		[maRelativeSPaths addObject: strRelativeSPath];
	}
	
	if (myBRecursingFolder == YES) { // check subpath
		NSFileManager *fm = [NSFileManager defaultManager];
		NSWorkspace *ws = [NSWorkspace sharedWorkspace];
		NSArray *aSubPaths = [fm subpathsAtPath: strAbsoluteSFPath];
		int iNumberOfSubPaths = [aSubPaths count];
		int i;
			
		// 'i' is incremented in the following block if a subpath is a dot folder or package.
		for (i=0; i<iNumberOfSubPaths; i++) { 
			NSString *strSubPath, *strRelativeSubPath,*strAbsoluteSubPath;
			BOOL bIsDirectory;
			
			strSubPath = [aSubPaths objectAtIndex: i];
			strRelativeSubPath = [strRelativeSPath stringByAppendingPathComponent: strSubPath];
			strAbsoluteSubPath = [strCurrentDirectory stringByAppendingPathComponent:
																							strRelativeSubPath];
			[fm fileExistsAtPath: strAbsoluteSubPath isDirectory: &bIsDirectory];
			
			if ([[strSubPath lastPathComponent] characterAtIndex: 0] == '.') {
				while ([[aSubPaths objectAtIndex: i+1]
									    hasPrefix: [NSString stringWithFormat: @"%@/", strSubPath]]) {
					i++;
				}
			}
			else if (bIsDirectory == NO) { // the subpath is a file.
				if (myBAddingFiles == YES) {
					[maRelativeSPaths addObject: strRelativeSubPath];
				}
			}
			else if ([ws isFilePackageAtPath: strAbsoluteSubPath] == NO) { // the subpath is a folder
				if (myBAddingFolders == YES) {
					[maRelativeSPaths addObject: strRelativeSubPath];
				}
			}
			else { // the subpath is a package.
				if (myBAddingFiles == YES) {
					[maRelativeSPaths addObject: strRelativeSubPath];
				}
				
				// go over if the next subpath is in the package.
				while ([[aSubPaths objectAtIndex: i+1]
									    hasPrefix: [NSString stringWithFormat: @"%@/", strSubPath]]) {
					i++;
				}
			}
		}
	} // recursing finished
	
	[myRppcContainer addRelativeSourcePaths: maRelativeSPaths
										 atDirectory: strCurrentDirectory];
}


// Set autoreleased strings like these:
// the last path component = "hoge.txt"
// 	if 'bPreservingExtension' == YES
// 		strFilename = "hoge"
// 		strExtension = "txt"
// 	if 'bPreservingExtension' == NO
// 		strFilename = "hoge.txt"
// 		strExtension = ""
- (void) sourceFilename: (NSString **)strFilename
			  andExtension: (NSString **)strExtension
         withExtensionPreserved: (BOOL)bPreservingExtension
			       atIndex: (int) iIndex
{
	NSString *strTemp;
	
	strTemp = [myRppcContainer sourceLastPathComponentAtViewIndex: iIndex];
	if (bPreservingExtension == YES) {
		*strExtension = [strTemp pathExtension];
		*strFilename = [strTemp stringByDeletingPathExtension];
	}
	else {
		*strExtension = [NSString string];
		*strFilename = strTemp;
	}
}

- (NSString *) stringAppendedExtension: (NSString *)strExt toFilename: (NSString *)strFname
{
	if ([strFname length] == 0) {
		return [NSString stringWithFormat: @".%@", strExt];
	}
	else if ([strExt length] == 0) {
		return [NSString stringWithString: strFname];
	}
	else {
		return [strFname stringByAppendingPathExtension: strExt];
	}
}



// Making a renamed filename //
/////////////////////////////////////////////////////////////////

// the 1st argument of ALL methods: sourcefilename


- (NSString *) findAndReplaceWithArguments: (NSArray *)aArguments
{
	NSString *strSourceFilename = [aArguments objectAtIndex: 0];
	NSString *strFind = [aArguments objectAtIndex: 1];
	NSString *strReplaceWith = [aArguments objectAtIndex: 2];
	BOOL  bCaseInsensitive = [[aArguments objectAtIndex: 3] boolValue];
	BOOL bReplacingAllFound = [[aArguments objectAtIndex: 4] boolValue];
	NSString *strRenamedFilename;
	
	[smManager setCaseSensitive: !bCaseInsensitive];
	[smManager setReplaceAllFound: bReplacingAllFound];
	[smManager modifyString: strSourceFilename
	               toString: &strRenamedFilename
						    find: strFind
						 replace: strReplaceWith];

	return strRenamedFilename;
}
			  
- (NSString *) regularExpressionFindAndReplaceWithArguments: (NSArray *)aArguments
{
	NSString *strSourceFilename = [aArguments objectAtIndex: 0];
	NSString *strFind = [aArguments objectAtIndex: 1];
	NSString *strReplaceWith = [aArguments objectAtIndex: 2];
	BOOL  bCaseInsensitive = [[aArguments objectAtIndex: 3] boolValue];
	BOOL bReplacingAllFound = [[aArguments objectAtIndex: 4] boolValue];
	NSString *strRenamedFilename;

	[pwRegexp setOriginalString: strSourceFilename];
	[pwRegexp setStringToBeFound: strFind];
	[pwRegexp setStringToBeReplacedWith: strReplaceWith];
	[pwRegexp setOptionG: bReplacingAllFound];
	[pwRegexp setOptionI: bCaseInsensitive];
	strRenamedFilename = [pwRegexp replace];
	
	return strRenamedFilename;
}

											
- (NSString *) changeCharactersToLowercasesWithArguments: (NSArray *)aArguments
{
	NSString *strSourceFilename = [aArguments objectAtIndex: 0];
	return [strSourceFilename lowercaseString];
}


- (NSString *) changeCharactersToUppercasesWithArguments: (NSArray *)aArguments
{
	NSString *strSourceFilename = [aArguments objectAtIndex: 0];
	return [strSourceFilename uppercaseString];
}


- (NSString *) changeCharactersCapitalizedWithArguments: (NSArray *)aArguments
{
	NSString *strSourceFilename = [aArguments objectAtIndex: 0];
	return [strSourceFilename capitalizedString];
}


- (NSString *) addStringAtBeggingWithArguments: (NSArray *)aArguments
{
	NSString *strSourceFilename = [aArguments objectAtIndex: 0];
	NSString *strAdd = [aArguments objectAtIndex: 1];

	return [NSString stringWithFormat: @"%@%@", strAdd, strSourceFilename];
}

- (NSString *) addStringAtEndWithArguments: (NSArray *)aArguments
{
	NSString *strSourceFilename = [aArguments objectAtIndex: 0];
	NSString *strAdd = [aArguments objectAtIndex: 1];
	
	return [NSString stringWithFormat: @"%@%@", strSourceFilename, strAdd];
}


//- (NSString *) addStringBeforeExtensionWithArguments: (NSArray *)aArguments
//{
//	return nil;
//}


// If 'numOfCharacters' is negative, characters which is leftside of index is removed.
- (NSString *) removeCharactersWithArguments: (NSArray *)aArguments
{
	NSString *strSourceFilename = [aArguments objectAtIndex: 0];
	int numOfCharacters = [[aArguments objectAtIndex: 1] intValue];
	int iIndex = [[aArguments objectAtIndex: 2] intValue];
	int iFilenameLength = [strSourceFilename length];
	int iLeft, iLength;
	NSMutableString *mstrRet;
	
	if (iFilenameLength <= iIndex) { // the index is out of range.
		iLeft = 0;
		iLength = 0;
	}
	else if (numOfCharacters >= 0) { // make range head to tail.
		iLeft = iIndex;
		iLength = (iLeft+numOfCharacters <= iFilenameLength) ? numOfCharacters
		                                                     : iFilenameLength-iLeft;
	}
	else { // make range tail to head.
		int iTempLeft = iFilenameLength - iIndex + numOfCharacters;
		if (iTempLeft >= 0) {
			iLeft = iTempLeft;
			iLength = -numOfCharacters;
		}
		else {
			iLeft = 0;
			iLength = iFilenameLength - iIndex;
		}
	}
	
	mstrRet = [NSMutableString stringWithString: strSourceFilename];
	[mstrRet deleteCharactersInRange: NSMakeRange(iLeft, iLength)];
	
	return mstrRet;
}


- (NSString *) addExtensionWithArguments: (NSArray *)aArguments
{
	NSString *strSourceFilename = [aArguments objectAtIndex: 0];
	NSString *strExt = [aArguments objectAtIndex: 1];

	return [strSourceFilename stringByAppendingPathExtension: strExt];
}


- (NSString *) changeExtensionWithArguments: (NSArray *)aArguments
{
	NSString *strSourceFilename = [aArguments objectAtIndex: 0];
	NSString *strExt = [aArguments objectAtIndex: 1];
	NSString *strSourceFilenameRemovedExt = [strSourceFilename stringByDeletingPathExtension];
	
	return [strSourceFilenameRemovedExt stringByAppendingPathExtension: strExt];
}


- (NSString *) removeExtensionWithArguments: (NSArray *)aArguments
{
	NSString *strSourceFilename = [aArguments objectAtIndex: 0];

	return [strSourceFilename stringByDeletingPathExtension];
}


// END OF Making a renamed filename //
/////////////////////////////////////////////////////////////////




- (PathPairState) makeRenamedFilenamesWithMethod: (RenameingMethods)rmMethods
											  withArguments: (NSArray *)aArguments
								  withExtensionPreserved: (BOOL) bPreservingExtension
{
	int iNumOfPathPairs = [myRppcContainer count];
	PathPairState ppsStateRet = OK;
	int iIndex;
	
	for (iIndex=0; iIndex<iNumOfPathPairs; iIndex++) {
		NSAutoreleasePool *alpool = [[NSAutoreleasePool alloc] init];
		NSString *strExtension, *strFilename;
		NSString *strChangedFilename = nil, *strFilenameAppendedExtension;
		NSMutableArray *maArgumentsWithSourceFilename;
		PathPairState ppsStateTemp = OK;
		
		[self sourceFilename: &strFilename andExtension: &strExtension withExtensionPreserved: bPreservingExtension atIndex: iIndex];
		maArgumentsWithSourceFilename = [NSMutableArray arrayWithObject: strFilename];
		[maArgumentsWithSourceFilename addObjectsFromArray: aArguments];
		
		NS_DURING // raise exception if invalid regular expression is entered.
			switch (rmMethods) {
			case FIND_REPLACE:
				strChangedFilename = [self findAndReplaceWithArguments: maArgumentsWithSourceFilename];
				break;
			case REGEXP_FIND_REPLACE:
				strChangedFilename = [self regularExpressionFindAndReplaceWithArguments: maArgumentsWithSourceFilename];
				break;
			case TO_LOWERCASES:
				strChangedFilename = [self changeCharactersToLowercasesWithArguments: maArgumentsWithSourceFilename];
				break;
			case TO_UPPERCASES:
				strChangedFilename = [self changeCharactersToUppercasesWithArguments: maArgumentsWithSourceFilename];
				break;
			case TO_CAPITALIZED:
				strChangedFilename = [self changeCharactersCapitalizedWithArguments: maArgumentsWithSourceFilename];
				break;
			case ADD_AT_BEGGING:
				strChangedFilename = [self addStringAtBeggingWithArguments: maArgumentsWithSourceFilename];
				break;
			case ADD_AT_END:
			case ADD_BEFORE_EXT:
				strChangedFilename = [self addStringAtEndWithArguments: maArgumentsWithSourceFilename];
				break;
			case REMOVE_CHARACTERS:
				strChangedFilename = [self removeCharactersWithArguments: maArgumentsWithSourceFilename];
				break;
			case ADD_EXTENSION:
				strChangedFilename = [self addExtensionWithArguments: maArgumentsWithSourceFilename];
				break;
			case CHANGE_EXTENSION:
				strChangedFilename = [self changeExtensionWithArguments: maArgumentsWithSourceFilename];
				break;
			case REMOVE_EXTENSION:
				strChangedFilename = [self removeExtensionWithArguments: maArgumentsWithSourceFilename];
				break;
			case SEQUENTIAL_NUMBER:
				// do nothing.
				strChangedFilename = nil;
				NSLog(@"'SEQUENTIAL_NUMBER' cannot be handled.");
				break;
			}

			strFilenameAppendedExtension = [self stringAppendedExtension: strExtension
																			toFilename: strChangedFilename];
			ppsStateTemp = [myRppcContainer setDestinationLastPathComponent: strFilenameAppendedExtension
																				AtViewIndex: iIndex];
		NS_HANDLER
			if ([[localException name] isEqualToString: INVALID_REG_EXP_EXCEPTION]) {
				[[myRppcContainer pathPairAtViewIndex: iIndex] setPathPairStateToInvalidRegrep];
				ppsStateTemp = INVALID_REGEXP;
			}
			else {
				[localException raise];
			}
		NS_ENDHANDLER

		
		if (ppsStateTemp != OK) {
			ppsStateRet = ppsStateTemp;
		}
		
		[alpool release];
	}

	return ppsStateRet;

}



// This method is called by makeSequentialNumberedFiles:::::::
- (NSString *) makeStringOfNumber: (int)iNumber
                   minNumOfFigures: (int)iMinFigures
{
   NSMutableString *mstrNumber = [NSMutableString stringWithFormat: @"%d", iNumber];
   int iDigitsOfNumber = [mstrNumber length];
   
   int iDefferenceOfDigits = iMinFigures - iDigitsOfNumber;
   while (iDefferenceOfDigits > 0) {
      [mstrNumber insertString: @"0" atIndex: 0];
      --iDefferenceOfDigits;
   }

   return mstrNumber;
}




#pragma mark ## Public Methods ##

- (id) initWithController: (id)idController
{
   self = [super init];
	
	myRppcContainer = [[RenamedPathPairContainer alloc] init];
	[myRppcContainer setDelegate: idController];
	myBAddingFiles = YES;
	myBAddingFolders = NO;
	myBRecursingFolder = YES;
	
	// utilities
	smManager = [[StringsManager alloc] init];
	pwRegexp = [[PerlWrapper alloc] init];

	return self;
}

- (void) dealloc
{
	[myRppcContainer release];
	
	// utilities
	[smManager release];
	[pwRegexp release];
	
	[super dealloc];
}



- (void) clearRenamedPathPairs
{
	[myRppcContainer clearRenamedPathPairs];
}


- (void) addAbsoluteSourcePaths: (NSArray *)aAbsoluteSPaths
{
	NSString *strAbsoluteSPath;
	NSFileManager *fm = [NSFileManager defaultManager];
	NSWorkspace *ws = [NSWorkspace sharedWorkspace];
	NSEnumerator *enmAbsoluteSPaths = [aAbsoluteSPaths objectEnumerator];
	
	while ((strAbsoluteSPath = [enmAbsoluteSPaths nextObject]) != nil) {
		BOOL bIsDirectory;
		NSAutoreleasePool *arpool = [[NSAutoreleasePool alloc] init];
		
		[fm fileExistsAtPath: strAbsoluteSPath isDirectory: &bIsDirectory];
		if (!bIsDirectory || [ws isFilePackageAtPath: strAbsoluteSPath]) {
			 // the path is a file or package.
			[self addAbsoluteSourceFilePath: strAbsoluteSPath];
		}
		else { // the path is a folder.
			[self addAbsoluteSourceFolderPath: strAbsoluteSPath];
		}
		
		[arpool release];
	}
}


- (int) countOfAddedPaths
{
	return [myRppcContainer count];
}


- (NSString *) relativeSourcePathAtIndex: (int)iIndex
{
	return [[myRppcContainer pathPairAtViewIndex: iIndex] relativeSourcePath];
}

- (NSString *) relativeDestinationPathAtIndex: (int)iIndex
{
	return [[myRppcContainer pathPairAtViewIndex: iIndex] relativeDestinationPath];
}


- (BOOL) actualRenamingAtIndex: (int)iIndex
{
	return [[myRppcContainer pathPairAtViewIndex: iIndex] actualRenaming];
}

- (PathPairState) pathPairStateAtIndex: (int)iIndex
{
	return [[myRppcContainer pathPairAtViewIndex: iIndex] pathPairState];
}


- (void) sortPathPairsOrderBy: (ViewOrder)voOder
{
	[myRppcContainer sortViewOrderBy: voOder];
}


- (BOOL) setActualRenaming: (BOOL)bActualRename AtIndex: (int)iIndex
{
	return [myRppcContainer setActualRenaming: bActualRename AtViewIndex: iIndex];
}


- (BOOL) renameOldPathsToNew
{
	return [myRppcContainer renameOldPathsToNew];
}


// "Add to List" options
- (void) setAddingFiles: (BOOL)bAdd
{
	myBAddingFiles = bAdd;
}

- (BOOL) addingFiles
{
	return myBAddingFiles;
}

- (void) setAddingFolders: (BOOL)bAdd
{
	myBAddingFolders = bAdd;
}

- (BOOL) addingFolders
{
	return myBAddingFolders;
}

- (void) setRecursingFolder: (BOOL)bRec
{
	myBRecursingFolder = bRec;
}

- (BOOL) recursingFolder
{
	return myBRecursingFolder;
}






// Renaming Methods

- (PathPairState) findString: (NSString *)strFind
			  replaceWithString: (NSString *)strReplaceWith
				 caseInsensitive: (BOOL) bCaseInsensitive
			  replacingAllFound: (BOOL)bReplacingAllFound
			preservingExtension: (BOOL)bPreservingExtension
{
	NSArray *aArguments = [NSArray arrayWithObjects: strFind,
	                                                 strReplaceWith,
																	 [NSNumber numberWithBool:  bCaseInsensitive],
																	 [NSNumber numberWithBool: bReplacingAllFound],
																	 nil];
	
	return [self makeRenamedFilenamesWithMethod: FIND_REPLACE
											withArguments: aArguments
					         withExtensionPreserved: bPreservingExtension];
}

			  
- (PathPairState) regularExpressionFindString: (NSString *)strFind
			                   replaceWithString: (NSString *)strReplaceWith
										caseInsensitive: (BOOL)bCaseInsensitive
			                   replacingAllFound: (BOOL)bReplacingAllFound
								  preservingExtension: (BOOL)bPreservingExtension
{
	NSArray *aArguments = [NSArray arrayWithObjects: strFind,
	                                                 strReplaceWith,
																	 [NSNumber numberWithBool:  bCaseInsensitive],
																	 [NSNumber numberWithBool: bReplacingAllFound],
																	 nil];
	
	return [self makeRenamedFilenamesWithMethod: REGEXP_FIND_REPLACE
											withArguments: aArguments
					         withExtensionPreserved: bPreservingExtension];
}

			  

// If strExtension is nil, the extension of file is preserved.
- (PathPairState) sequentialNumberWithPrefix: (NSString *)strPrefix
                                  withSuffix: (NSString *)strSuffix
										 withExtension: (NSString *)strExtension
									  withFirstNumber: (int) iFirstNumber
									    withStepValue: (int) iStepValue
								  withMinimumFigures: (int) iMinimumFigures
								         sameFigures: (BOOL) bSameFigures
{
	int iNumOfPathPairs = [myRppcContainer count];
	PathPairState ppsStateRet = OK;
	int iIndex;
	
	int iMaxFigures = [[NSString stringWithFormat: @"%d", [myRppcContainer count]+(iFirstNumber-1)] length];
	int iSequence = iFirstNumber;

	for (iIndex=0; iIndex<iNumOfPathPairs; iIndex++) {
		NSAutoreleasePool *alpool = [[NSAutoreleasePool alloc] init];
		NSString *strExtensionToAdd, *strNumber;
		NSString *strNumberedFilenameWithoutExtension, *strFilenameAppendedExtension;
		PathPairState ppsStateTemp;
			
		// Making string of number. 3 ways because of 3 states.
      if (bSameFigures == YES) {
         if (iMinimumFigures <= iMaxFigures) {
            strNumber = [self makeStringOfNumber: iSequence minNumOfFigures: iMaxFigures];
         }
         else {
            strNumber = [self makeStringOfNumber: iSequence minNumOfFigures: iMinimumFigures];
         }
      }
      else { // bSameFigures == NO
         strNumber = [self makeStringOfNumber: iSequence minNumOfFigures: iMinimumFigures];
      }

		// Set extension either preserved one or new one.
		if (strExtension == nil) {
			NSString *strSourceFilename = [myRppcContainer sourceLastPathComponentAtViewIndex: iIndex];
			strExtensionToAdd = [strSourceFilename pathExtension];
		}
		else {
			strExtensionToAdd = strExtension;
		}
		
		strNumberedFilenameWithoutExtension = [NSString stringWithFormat: @"%@%@%@", strPrefix
		                                                                           , strNumber
																											, strSuffix];
		strFilenameAppendedExtension = [self stringAppendedExtension: strExtensionToAdd
																		  toFilename: strNumberedFilenameWithoutExtension];
		ppsStateTemp = [myRppcContainer setDestinationLastPathComponent: strFilenameAppendedExtension
																		    AtViewIndex: iIndex];
		if (ppsStateTemp != OK) {
			ppsStateRet = ppsStateTemp;
		}
				
		[alpool release];
		iSequence += iStepValue;
	}

	return ppsStateRet;
}

			  
											
- (PathPairState) changeCharactersToLowercasesWithExtensionPreserved: (BOOL)bPreservingExtension
{
	return [self makeRenamedFilenamesWithMethod: TO_LOWERCASES
											withArguments: [NSArray array]
					         withExtensionPreserved: bPreservingExtension];
}

			  
- (PathPairState) changeCharactersToUppercasesWithExtensionPreserved: (BOOL)bPreservingExtension
{
	return [self makeRenamedFilenamesWithMethod: TO_UPPERCASES
											withArguments: [NSArray array]
					         withExtensionPreserved: bPreservingExtension];
}

			  
- (PathPairState) changeCharactersCapitalizedWithExtensionPreserved: (BOOL)bPreservingExtension
{
	return [self makeRenamedFilenamesWithMethod: TO_CAPITALIZED
											withArguments: [NSArray array]
					         withExtensionPreserved: bPreservingExtension];
}

			  

- (PathPairState) addStringAtBegging: (NSString *)strAdd
{
	return [self makeRenamedFilenamesWithMethod: ADD_AT_BEGGING
											withArguments: [NSArray arrayWithObject: strAdd]
					         withExtensionPreserved: NO];
}

			  
- (PathPairState) addStringAtEnd: (NSString *)strAdd
{
	return [self makeRenamedFilenamesWithMethod: ADD_AT_END
											withArguments: [NSArray arrayWithObject: strAdd]
					         withExtensionPreserved: NO];
}

			  
- (PathPairState) addStringBeforeExtension: (NSString *)strAdd
{
	return [self makeRenamedFilenamesWithMethod: ADD_BEFORE_EXT
											withArguments: [NSArray arrayWithObject: strAdd]
					         withExtensionPreserved: YES];
}

			  

// If 'numOfCharacters' is negative, characters which is leftside of index is removed.
- (PathPairState) removeCharacters: (int)numOfCharacters
                         fromIndex: (int)iIndex
					preservingExtension: (BOOL)bPreservingExtension
{
	NSArray *aArguments = [NSArray arrayWithObjects: [NSNumber numberWithInt: numOfCharacters],
																	 [NSNumber numberWithInt: iIndex],
																	 nil];
	
	return [self makeRenamedFilenamesWithMethod: REMOVE_CHARACTERS
											withArguments: aArguments
					         withExtensionPreserved: bPreservingExtension];
}

			  

- (PathPairState) addExtension: (NSString *)strExtension
{
	return [self makeRenamedFilenamesWithMethod: ADD_EXTENSION
											withArguments: [NSArray arrayWithObject: strExtension]
					         withExtensionPreserved: NO];
}

			  
- (PathPairState) changeExtension: (NSString *)strExtension
{
	return [self makeRenamedFilenamesWithMethod: CHANGE_EXTENSION
											withArguments: [NSArray arrayWithObject: strExtension]
					         withExtensionPreserved: NO];
}

			  
- (PathPairState) removeExtension
{
	return [self makeRenamedFilenamesWithMethod: REMOVE_EXTENSION
											withArguments: [NSArray array]
					         withExtensionPreserved: NO];
}






// For debug
- (NSString *) description
{
	return [myRppcContainer description];
}




@end
