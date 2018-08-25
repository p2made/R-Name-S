#import "RNameController.h"
#include <stdlib.h>
#include <time.h>


@implementation RNameController


#pragma mark ## Private Methods ##

- (void) setRenamingKindViewToBox: (RenamingKinds) rkKind
{
	switch (rkKind) {
	case FIND_AND_REPLACE:
		[myBoxSettings setContentView: myViewFindAndReplace];
		[myTxtfldFindRepFindString selectText: self];
		break;
		
	case NUMBER_SEQUENTIALLY:
		[myBoxSettings setContentView: myViewSequentialNumber];
		[myTxtfldSeqNumPrefix selectText: self];
		break;
		
	case CHANGE_CHARACTERS_TO_ALL_UPPERCASES:
	case CHANGE_CHARACTERS_TO_ALL_LOWERCASES:
	case CHANGE_CHARACTERS_TO_CAPITALIZED_WORDS:
		[myBoxSettings setContentView: myViewChangeCases];
		break;
		
	case ADD_CHARACTERS_AT_BEGINNING:
	case ADD_CHARACTERS_BEFORE_EXTENSION:
	case ADD_CHARACTERS_AT_END:
		[myBoxSettings setContentView: myViewAddCharacters];
		[myTxtfldAddCharCharacters selectText: self];
		break;
		
	case REMOVE_CHARACTERS_FROM_BEGINNING:
	case REMOVE_CHARACTERS_FROM_END:
		[myBoxSettings setContentView: myViewRemoveCharactersFromBegginningOrEnd];
		[myTxtfldRemvCharBegOrEndNumberOfChars selectText: self];
		break;
		
	case REMOVE_CHARACTERS_AT_RANGE:
		[myBoxSettings setContentView: myViewRemoveCharactersAtRange];
		[myTxtfldRemvCharRangeNumOfChars selectText: self];
		break;
		
	case ADD_EXTENSION_TO_FILENAME:
	case REPLACE_EXTENSION_OF_FILENAME:
		[myBoxSettings setContentView: myViewAddOrReplaceExtension];
		[myCmboxAddOrRepExtExtension selectText: self];
		break;
		
	case REMOVE_EXTENSION_OF_FILENAME:
		[myBoxSettings setContentView: myViewRemoveExtension];
		break;
	}
}


// aSPaths is a array including absolute paths.
- (void) addSourcePaths: (NSArray *)aSPaths
{
	[myFrRenamer addAbsoluteSourcePaths: aSPaths];
	[myTblviewFilesList reloadData];
	[myPubtnSeqNumSort selectItemAtIndex: 0];
}



- (void) openPanelDidEnd:(NSOpenPanel *)sheet returnCode:(int)returnCode
{
   NSArray *aPaths;

   if (returnCode == NSOKButton) {
      aPaths = [sheet filenames];
		[self addSourcePaths: aPaths];
	}
}


- (void) setButtonToTableView
{
	NSTableColumn *tblcColumn;
	NSButtonCell *btncCell;

	tblcColumn = [myTblviewFilesList tableColumnWithIdentifier: TABLE_COLUMN_ID_ONOFF];
	btncCell = [[NSButtonCell alloc] init];
	[btncCell setButtonType:NSSwitchButton];
	[btncCell setTitle:@""];
	[tblcColumn setDataCell: btncCell];
	
	[myTblviewFilesList setIntercellSpacing: NSMakeSize(3.0 ,2.0)];
	
	[btncCell release];
}


- (void) showErrorMessageOfPathPairState: (PathPairState)ppsState
{
	NSBundle *bdlBundle = [NSBundle mainBundle];
	NSString *strErrMessage = nil;

	switch (ppsState) {
	case EXIST:
		strErrMessage = [bdlBundle localizedStringForKey: LSTR_ERR_MESSAGE_EXIST
                                                 value: nil
                                                 table: nil];   
		break;
	case LONG:
		strErrMessage = [bdlBundle localizedStringForKey: LSTR_ERR_MESSAGE_LONG
                                                 value: nil
                                                 table: nil];   
		break;
	case START_WITH_DOT:
		strErrMessage = [bdlBundle localizedStringForKey: LSTR_ERR_MESSAGE_DOT_BEGINNING
                                                 value: nil
                                                 table: nil];   
		break;
	case INVALID_REGEXP:
		strErrMessage = [bdlBundle localizedStringForKey: LSTR_ERR_MESSAGE_INVALID_REGEXP
                                                 value: nil
                                                 table: nil];   
		break;
	case INVALID_CHARACTER:
		strErrMessage = [bdlBundle localizedStringForKey: LSTR_ERR_MESSAGE_INVALID_CAHR
                                                 value: nil
                                                 table: nil];   
		break;
	default:
		break;
	}
	
	[myTxtfldErrorMessage setTitleWithMnemonic: strErrMessage];
   [NSApp beginSheet: myWindowErrorMessage
      modalForWindow: myWindowMain
       modalDelegate: nil
      didEndSelector: nil
         contextInfo: nil];
}


- (void) setExtensionsListToComboBox
{
   int iExtensions = [myAExtensionsList count];
   
   if (iExtensions <= MAX_EXTENSIONS_IN_VIEW_OF_COMBOBOX) {
      [myCmbboxSeqNumExtension setNumberOfVisibleItems: iExtensions];
      [myCmboxAddOrRepExtExtension setNumberOfVisibleItems: iExtensions];
   }
   else {
      [myCmbboxSeqNumExtension setNumberOfVisibleItems: MAX_EXTENSIONS_IN_VIEW_OF_COMBOBOX];
      [myCmboxAddOrRepExtExtension setNumberOfVisibleItems: MAX_EXTENSIONS_IN_VIEW_OF_COMBOBOX];
   }

   [myCmbboxSeqNumExtension noteNumberOfItemsChanged];
   [myCmboxAddOrRepExtExtension noteNumberOfItemsChanged];

   [myCmbboxSeqNumExtension reloadData];
   [myCmboxAddOrRepExtExtension reloadData];
}


- (void) setExtensionsListToArray
{
   NSScanner *scnScanner;
   NSCharacterSet *csReturn, *csTab;
   NSString *strScannedExtension;
   NSMutableArray *maTemp;

   csReturn = [NSCharacterSet characterSetWithCharactersInString:@"\n"];
   csTab = [NSCharacterSet characterSetWithCharactersInString:@"\t"];
   scnScanner = [NSScanner scannerWithString: [myTxtviewPrefExtensionsList string]];
   [scnScanner setCharactersToBeSkipped: csTab];
   maTemp = [NSMutableArray arrayWithCapacity: 20];
	
   while(![scnScanner isAtEnd]) {
      if([scnScanner scanUpToCharactersFromSet: csReturn intoString:&strScannedExtension]) {
         [maTemp addObject: strScannedExtension];
      }
      [scnScanner scanCharactersFromSet: csReturn intoString: nil];
   }
	
	[myAExtensionsList release];
	myAExtensionsList = [maTemp retain];
}


- (void) setExtensionsListToTextView
{
   NSEnumerator *enmExtension;
   NSString *strExtension;
   NSMutableString *mstrExtensions = [NSMutableString stringWithCapacity: 20];
   enmExtension = [myAExtensionsList objectEnumerator];
   while (strExtension = [enmExtension nextObject]) {
      [mstrExtensions appendFormat: @"%@\n", strExtension];
   }
   [myTxtviewPrefExtensionsList setString: mstrExtensions];
}


- (void) setOpaqueLevelOfWindowsToFloatValue: (float)fOpaqueLevel
{
	if (fOpaqueLevel < 0.3 || 1.0 < fOpaqueLevel) {
		fOpaqueLevel = 1.0;
	}
	[myWindowMain setAlphaValue: fOpaqueLevel];
	[myWindowPreferences setAlphaValue: fOpaqueLevel];
}



- (void) loadPrefs
{
   NSUserDefaults *udDefaults = [NSUserDefaults standardUserDefaults];

   // About items on main window
   [myBtnAddFiles setState: [udDefaults integerForKey: UDKEY_ADD_FILES]];
   [self setAddFiles: myBtnAddFiles];
   [myBtnAddFolders setState: [udDefaults integerForKey: UDKEY_ADD_FOLDERS]];
   [self setAddFolders: myBtnAddFolders];
   [myBtnRecursingFolder setState: [udDefaults integerForKey: UDKEY_RECURSE_FOLDER]];
   [self setRecurseFolder: myBtnRecursingFolder];
   [myPubtnRenamingMethods selectItemAtIndex: [udDefaults integerForKey: UDKEY_SELECTED_METHOD]];
	[self setRenamingKindViewToBox: [[myPubtnRenamingMethods selectedItem] tag]];
		

	// About items on prefs window
   [myBtnclPrefClearListAutomatically setState: [udDefaults integerForKey: UDKEY_PREF_CLEAR_LIST_AUTOMATICALLY]];
//   [myBtnclPrefDoNothing setState: [udDefaults integerForKey: UDKEY_PREF_DO_NOTHING]];
   [myBtnclPrefQuitApplication setState: [udDefaults integerForKey: UDKEY_PREF_QUIT_APP]];
	[mySldrPrefOpaqueLevel setFloatValue: [udDefaults floatForKey: UDKEY_PREF_OPAQEU_LEVEL]];
	[self setOpaqueLevelOfWindowsToFloatValue: [mySldrPrefOpaqueLevel floatValue]];

   // Setting Extensions List.
   [myAExtensionsList release];
   myAExtensionsList = [[udDefaults arrayForKey: UDKEY_EXTENSIONS_LIST] retain];
   [self setExtensionsListToComboBox];
	[self setExtensionsListToTextView];


	// About items on setting views
   [myBtnChangeCasesPreserveExtension setState: [udDefaults integerForKey: UDKEY_CHANGE_CASES_PRESERVE_EXTENSION]];
	
   [myBtnRemvCharRangePreserveExtension setState: [udDefaults integerForKey: UDKEY_REMV_CHAR_RANGE_PRESERVE_EXTENSION]];
   [myBtnclRemvCharRangeFromBeginning setState: [udDefaults integerForKey: UDKEY_REMV_CHAR_RANGE_FROM_BEGINNIG]];
   [myBtnclRemvCharRangeFromEnd setState: [udDefaults integerForKey: UDKEY_REMV_CHAR_RANGE_FROM_END]];
   [myTxtfldRemvCharRangeFromNumber setIntValue: [udDefaults integerForKey: UDKEY_REMV_CHAR_RANGE_FROM_NUMBER]];
   [myStprRemvCharRangeFromNumber setIntValue: [udDefaults integerForKey: UDKEY_REMV_CHAR_RANGE_FROM_NUMBER]];
   [myTxtfldRemvCharRangeNumOfChars setIntValue: [udDefaults integerForKey: UDKEY_REMV_CHAR_RANGE_NUM_OF_CHARS]];
   [myStprRemvCharRangeNumOfChars setIntValue: [udDefaults integerForKey: UDKEY_REMV_CHAR_RANGE_NUM_OF_CHARS]];

   [ myBtnFindRepCaseInsensitive setState: [udDefaults integerForKey:  UDKEY_FIND_REP_CASE_INSENSITIVE]];
   [myBtnFindRepPreserveExtension setState: [udDefaults integerForKey: UDKEY_FIND_REP_PRESERVE_EXTENSION]];
   [myBtnFindRepRegularExpression setState: [udDefaults integerForKey: UDKEY_FIND_REP_REGEXP]];
   [myBtnFindRepReplaceAllFound setState: [udDefaults integerForKey: UDKEY_FIND_REP_REPLACE_ALL]];

   [myBtnRemvCharBegOrEndPreserveExtension setState: [udDefaults integerForKey: UDKEY_REMV_CHAR_BEG_OR_END_PRESERVE_EXTENSION]];
   [myTxtfldRemvCharBegOrEndNumberOfChars setIntValue: [udDefaults integerForKey: UDKEY_REMV_CHAR_BEG_OR_END_NUM_OF_CHARS]];
   [myStprRemvCharBegOrEndNumberOfChars setIntValue: [udDefaults integerForKey: UDKEY_REMV_CHAR_BEG_OR_END_NUM_OF_CHARS]];

   [myBtnSeqNumPreserveExtension setState: [udDefaults integerForKey: UDKEY_SEQ_NUM_PRESERVE_EXTENSION]];
   if ([udDefaults integerForKey: UDKEY_SEQ_NUM_PRESERVE_EXTENSION] == NSOnState) {
		[myCmbboxSeqNumExtension setEnabled: NO];
	}
	else {
		[myCmbboxSeqNumExtension setEnabled: YES];
	}
	[myBtnSeqNumSameFigures setState: [udDefaults integerForKey: UDKEY_SEQ_NUM_SAME_FIGS]];
   [myStprSeqNumFirstNumber setIntValue: [udDefaults integerForKey: UDKEY_SEQ_NUM_FIRST_NUM]];
   [myTxtfldSeqNumFirstNumber setIntValue: [udDefaults integerForKey: UDKEY_SEQ_NUM_FIRST_NUM]];
   [myStprSeqNumLeastFigures setIntValue: [udDefaults integerForKey: UDKEY_SEQ_NUM_LEAST_FIGS]];
   [myTxtfldSeqNumLeastFigures setIntValue: [udDefaults integerForKey: UDKEY_SEQ_NUM_LEAST_FIGS]];
   [myStprSeqNumStepValue setIntValue: [udDefaults integerForKey: UDKEY_SEQ_NUM_STEP_VAL]];
   [myTxtfldSeqNumStepValue setIntValue: [udDefaults integerForKey: UDKEY_SEQ_NUM_STEP_VAL]];

}

- (void) writePrefs
{
   NSUserDefaults *udDefaults = [NSUserDefaults standardUserDefaults];


   // About items on main window
   [udDefaults setInteger: [myBtnAddFiles state]
                   forKey: UDKEY_ADD_FILES];
   [udDefaults setInteger: [myBtnAddFolders state]
                   forKey: UDKEY_ADD_FOLDERS];
   [udDefaults setInteger: [myBtnRecursingFolder state]
                   forKey: UDKEY_RECURSE_FOLDER];
   [udDefaults setInteger: [myPubtnRenamingMethods indexOfSelectedItem]
                   forKey: UDKEY_SELECTED_METHOD];


	// About items on prefs window
   [udDefaults setObject: myAExtensionsList
	               forKey: UDKEY_EXTENSIONS_LIST];
   [udDefaults setInteger: [myBtnclPrefClearListAutomatically state]
                   forKey: UDKEY_PREF_CLEAR_LIST_AUTOMATICALLY];
//   [udDefaults setInteger: [myBtnclPrefDoNothing state]
//                   forKey: UDKEY_PREF_DO_NOTHING];
   [udDefaults setInteger: [myBtnclPrefQuitApplication state]
                   forKey: UDKEY_PREF_QUIT_APP];
	[udDefaults setFloat: [mySldrPrefOpaqueLevel floatValue]
	                forKey: UDKEY_PREF_OPAQEU_LEVEL];
	
	
	// About items on setting views
   [udDefaults setInteger: [myBtnChangeCasesPreserveExtension state]
                   forKey: UDKEY_CHANGE_CASES_PRESERVE_EXTENSION];
						 
   [udDefaults setInteger: [myBtnRemvCharRangePreserveExtension state]
                   forKey: UDKEY_REMV_CHAR_RANGE_PRESERVE_EXTENSION];
   [udDefaults setInteger: [myBtnclRemvCharRangeFromBeginning state]
                   forKey: UDKEY_REMV_CHAR_RANGE_FROM_BEGINNIG];
   [udDefaults setInteger: [myBtnclRemvCharRangeFromEnd state]
                   forKey: UDKEY_REMV_CHAR_RANGE_FROM_END];
   [udDefaults setInteger: [myTxtfldRemvCharRangeFromNumber intValue]
                   forKey: UDKEY_REMV_CHAR_RANGE_FROM_NUMBER];
   [udDefaults setInteger: [myTxtfldRemvCharRangeNumOfChars intValue]
                   forKey: UDKEY_REMV_CHAR_RANGE_NUM_OF_CHARS];
						 
   [udDefaults setInteger: [ myBtnFindRepCaseInsensitive state]
                   forKey:  UDKEY_FIND_REP_CASE_INSENSITIVE];
   [udDefaults setInteger: [myBtnFindRepPreserveExtension state]
                   forKey: UDKEY_FIND_REP_PRESERVE_EXTENSION];
   [udDefaults setInteger: [myBtnFindRepRegularExpression state]
                   forKey: UDKEY_FIND_REP_REGEXP];
   [udDefaults setInteger: [myBtnFindRepReplaceAllFound state]
                   forKey: UDKEY_FIND_REP_REPLACE_ALL];

   [udDefaults setInteger: [myBtnRemvCharBegOrEndPreserveExtension state]
                   forKey: UDKEY_REMV_CHAR_BEG_OR_END_PRESERVE_EXTENSION];
   [udDefaults setInteger: [myTxtfldRemvCharBegOrEndNumberOfChars intValue]
                   forKey: UDKEY_REMV_CHAR_BEG_OR_END_NUM_OF_CHARS];
						 
   [udDefaults setInteger: [myBtnSeqNumPreserveExtension state]
                   forKey: UDKEY_SEQ_NUM_PRESERVE_EXTENSION];
   [udDefaults setInteger: [myBtnSeqNumSameFigures state]
                   forKey: UDKEY_SEQ_NUM_SAME_FIGS];
   [udDefaults setInteger: [[myPubtnSeqNumSort selectedItem] tag]
                   forKey: UDKEY_SEQ_NUM_SORT];
   [udDefaults setInteger: [myTxtfldSeqNumFirstNumber intValue]
                   forKey: UDKEY_SEQ_NUM_FIRST_NUM];
   [udDefaults setInteger: [myTxtfldSeqNumLeastFigures intValue]
                   forKey: UDKEY_SEQ_NUM_LEAST_FIGS];
   [udDefaults setInteger: [myTxtfldSeqNumStepValue intValue]
                   forKey: UDKEY_SEQ_NUM_STEP_VAL];
						 
	[udDefaults synchronize];
}


- (void) careForSomethingAfterRenaming: (id)sender
{
	if ([myBtnclPrefClearListAutomatically state] == NSOnState) {
		[myPidIndicator setDoubleValue: 0.0];
		[myFrRenamer clearRenamedPathPairs];
		[myTblviewFilesList reloadData];
		[myTxtfldStatusMessage setTitleWithMnemonic: @""];
	}
	else { //
		[NSApp terminate: self];
	}
}



#pragma mark ## Public Methods ##


- (id) init
{
   self = [super init];
	myFrRenamer = [[FilesRenamer alloc] initWithController: self];
	myAExtensionsList = [[NSArray alloc] init];
	mySmManager = [[StringsManager alloc] init];
	return self;
}

- (void) dealloc
{
	[myFrRenamer release];
	[myAExtensionsList release];
	[mySmManager release];
	[super dealloc];
}

- (void) awakeFromNib
{
	[myWindowMain registerForDraggedTypes:
	                        [NSArray arrayWithObject: NSFilenamesPboardType]];
	[self setButtonToTableView];
	
	{	// Check "~/Library/Preferences/R-Name" exists
		NSString *strPlistPath = [NSString stringWithFormat: @"%@/%@", NSHomeDirectory(), RNAME_RELATIVE_PLIST_PATH];
		NSFileManager *fmManager = [NSFileManager defaultManager];
		if ([fmManager fileExistsAtPath: strPlistPath]) {
			[self loadPrefs];
		}
		else {
			[self setRenamingKindViewToBox: FIND_AND_REPLACE];
			
			[myAExtensionsList release];
			myAExtensionsList = [[NSArray alloc] initWithObjects: @"jpg", @"gif", @"png", @"   ", @"mov", @"mpg", @"mp3", @"   ", @"txt", @"html", nil];
			[self setExtensionsListToComboBox];
			[self setExtensionsListToTextView];
		}
	}
	
	[myWindowMain makeKeyAndOrderFront: self];
	
	srand(time(NULL));
	{ // UNICEF Window
	   NSUserDefaults *udDefaults = [NSUserDefaults standardUserDefaults];
		if ([udDefaults integerForKey: UDKEY_PREF_VERSION] < CURRENT_VERSION_NUMBER
		    || rand()%DONATION_WINDOW_FREQUENCY == 0) {
			[myWindowDonation makeKeyAndOrderFront: self];
			[udDefaults setInteger: CURRENT_VERSION_NUMBER
			                forKey: UDKEY_PREF_VERSION];
		}
	}
}

- (void) endOneRenaming
{
   [myPidIndicator incrementBy: 1.0];
   [myPidIndicator displayIfNeeded];
}


#pragma mark ## Application Delegates ##


- (BOOL) application: (NSApplication *)theApplication
            openFile: (NSString *)filename
{
	[self addSourcePaths: [NSArray arrayWithObject: filename]];
	return YES;
}



- (void) applicationDidFinishLaunching: (NSNotification *)aNotification
{
}


- (void) applicationWillTerminate: (NSNotification *)aNotification
{
	[self writePrefs];
}




#pragma mark ## Window Delegates ##

// This method terminates application when the main window close.
- (void) windowWillClose: (NSNotification *)aNotification
{
	if ([[[aNotification object] frameAutosaveName] isEqualToString: AUTO_SAVE_NAME_MAIN_WINDOW]) {
		[NSApp terminate: self];
	}
}


 - (void) windowDidResignKey: (NSNotification *)aNotification
{
	if ([[[aNotification object] frameAutosaveName] isEqualToString: AUTO_SAVE_NAME_PREFS_WINDOW]) {
		[self setExtensionsListToArray];
		//[self writePrefs];
	}
}



// This method adds dragged files to the list.
- (BOOL) performDragToWindowOperation: (id <NSDraggingInfo>)sender
{
	NSPasteboard *pb = [sender draggingPasteboard];
   NSArray *aPaths = [pb propertyListForType: NSFilenamesPboardType];
	[self addSourcePaths: aPaths];
	return YES;
}




#pragma mark ## Protocol NSTableDataSource ##

// These method set list of files to Table View.
- (int) numberOfRowsInTableView: (NSTableView *)aTableView
{
	return [myFrRenamer countOfAddedPaths];;
}


- (id) tableView                 : (NSTableView *)aTableView
       objectValueForTableColumn : (NSTableColumn *)aTableColumn
                             row : (int)rowIndex
{	
	if([[aTableColumn identifier] isEqualToString: TABLE_COLUMN_ID_ONOFF]) {
		if ([myFrRenamer actualRenamingAtIndex: rowIndex] == YES) {
			return [NSNumber numberWithInt: NSOnState];
		}
		else {
			return [NSNumber numberWithInt: NSOffState];
		}
	}
	else if ([[aTableColumn identifier] isEqualToString: TABLE_COLUMN_ID_OLD]) {
		return [mySmManager stringWithSlushAndColonConverted: [myFrRenamer relativeSourcePathAtIndex: rowIndex]];
	}
	else { // if TABLE_COLUMN_ID_NEW
		return [mySmManager stringWithSlushAndColonConverted: [myFrRenamer relativeDestinationPathAtIndex: rowIndex]];
	}
}


- (void) tableView:       (NSTableView *)tableView
         setObjectValue : (id)object 
          forTableColumn: (NSTableColumn *)tableColumn 
                     row: (int)rowIndex
{
	if ([[tableColumn identifier] isEqualToString: TABLE_COLUMN_ID_ONOFF]) {
		[myFrRenamer setActualRenaming: ([object intValue] == NSOnState)
		                       AtIndex: rowIndex];
	}
}



#pragma mark ## Delegates NSTableView ##

- (void) tableView: (NSTableView *)aTableView
   willDisplayCell: (id)aCell
    forTableColumn: (NSTableColumn *)aTableColumn
	            row: (int)rowIndex
{
	if ([[aTableColumn identifier] isEqualToString: TABLE_COLUMN_ID_ONOFF]) {
		PathPairState ppsState = [myFrRenamer pathPairStateAtIndex: rowIndex];
		if (ppsState == OK || ppsState == SAME_EXCEPT_CASES) {
			[aCell setEnabled: YES];
		}
		else {
			[aCell setEnabled: NO];
		}
	}
}





#pragma mark ## Protocol NSComboBoxDataSource ##

- (int) numberOfItemsInComboBox: (NSComboBox *)aComboBox
{
	return [myAExtensionsList count];
}


- (id) comboBox: (NSComboBox *)aComboBox objectValueForItemAtIndex: (int)index
{
	return [myAExtensionsList objectAtIndex: index];
}


- (NSString *) comboBoxCell: (NSComboBoxCell *)aComboBoxCell
            completedString: (NSString *)uncompletedString
{
	NSEnumerator *enmExtensions = [myAExtensionsList objectEnumerator];
	NSString *strExtension;
	while (strExtension = [enmExtensions nextObject]) {
		if ([strExtension hasPrefix: uncompletedString]) {
			return strExtension;
		}
	}
	
	return [NSString stringWithString: uncompletedString];
}



#pragma mark ## Actions ##

- (IBAction)checkTheWebsite:(id)sender
{
	NSBundle *bdlBundle;
   NSString *strWebURL;
	NSURL *urlWebURL;
	
	bdlBundle = [NSBundle mainBundle];
	strWebURL = [bdlBundle localizedStringForKey: LSTR_CHECK_WEB_URL
                                          value: nil
                                          table: nil];
	urlWebURL = [NSURL URLWithString: strWebURL];
	[[NSWorkspace sharedWorkspace] openURL: urlWebURL];
}

- (IBAction)clearList:(id)sender
{
	[myFrRenamer clearRenamedPathPairs];
	[myTblviewFilesList reloadData];
	[myBtnRenameNow setEnabled: NO];
}

- (IBAction)doUNICEF:(id)sender
{
	NSBundle *bdlBundle;
	NSString *strURL;
	NSURL *urlURL;
	
	bdlBundle = [NSBundle mainBundle];
	switch ([sender tag]) {
	case 1:
		strURL = [bdlBundle localizedStringForKey: LSTR_UNICEF_DONATION_URL
                                          value: nil
                                          table: nil];
		break;
	case 2:
		strURL = [bdlBundle localizedStringForKey: LSTR_UNICEF_WEB_URL
                                          value: nil
                                          table: nil];
		break;
	default:
		strURL = [bdlBundle localizedStringForKey: LSTR_MAIL_FOR_UNICEF_DONATION
                                          value: nil
                                          table: nil];
		break;
	}
	urlURL = [NSURL URLWithString: strURL];
	[[NSWorkspace sharedWorkspace] openURL: urlURL];
}

- (IBAction)okayErrorMessageWindow:(id)sender
{
   [myWindowErrorMessage orderOut:self];
   [NSApp endSheet: myWindowErrorMessage];
}

- (IBAction)openFiles:(id)sender
{
   NSOpenPanel *op = [NSOpenPanel openPanel];

   [op setCanChooseDirectories: YES];
   [op setAllowsMultipleSelection: YES];

   [op beginSheetForDirectory: nil
                         file: nil
                        types: nil
               modalForWindow: myWindowMain
                modalDelegate: self
               didEndSelector: @selector(openPanelDidEnd: returnCode:)
                  contextInfo: NULL];      
}

- (IBAction)preserveExtensionOfSequentialNumbering:(id)sender
{
	if ([sender state] == NSOnState) {
		[myCmbboxSeqNumExtension setEnabled: NO];
	}
	else {
		[myCmbboxSeqNumExtension setEnabled: YES];
	}
}

- (IBAction)renameActually:(id)sender
{
	[myPidIndicator setMaxValue: [myFrRenamer countOfAddedPaths]];
   [myPidIndicator setDoubleValue: 0.0];
	
	[myFrRenamer renameOldPathsToNew];
	
	{
	   NSBundle *bdlBundle = [NSBundle mainBundle];
		NSString *strDone = [bdlBundle localizedStringForKey: LSTR_MESSAGE_DONE
                                                     value: nil
                                                     table: nil];   
		[myTxtfldStatusMessage setTitleWithMnemonic: strDone];
	}

	[self performSelector: @selector(careForSomethingAfterRenaming:)
				  withObject: self
				  afterDelay: 1.5];

	[myBtnRenameNow setEnabled: NO];
}

- (IBAction)setRenameMethod:(id)sender
{
	RenamingKinds rkKind = [[sender selectedItem] tag];
	[self setRenamingKindViewToBox: rkKind];
}

- (IBAction)setAddFiles:(id)sender
{
	if ([sender state] == NSOnState) {
		[myFrRenamer setAddingFiles: YES];
	}
	else { // NSOffState
		[myFrRenamer setAddingFiles: NO];
	}
}

- (IBAction)setAddFolders:(id)sender
{
	if ([sender state] == NSOnState) {
		[myFrRenamer setAddingFolders: YES];
	}
	else { // NSOffState
		[myFrRenamer setAddingFolders: NO];
	}
}

- (IBAction)setOpaqueLevelOfWindows:(id)sender
{
	[self setOpaqueLevelOfWindowsToFloatValue: [sender floatValue]];
}

- (IBAction)setRecurseFolder:(id)sender
{
	if ([sender state] == NSOnState) {
		[myFrRenamer setRecursingFolder: YES];
	}
	else { // NSOffState
		[myFrRenamer setRecursingFolder: NO];
	}
}


- (IBAction)showNewNames:(id)sender
{
	PathPairState ppsState = OK;
	RenamingKinds rkKind = [[myPubtnRenamingMethods selectedItem] tag];
	switch (rkKind) {
	case FIND_AND_REPLACE:
	{
		BOOL bRegExp = ([myBtnFindRepRegularExpression state] == NSOnState) ? YES : NO;
		BOOL bCaseInsensitive = ([ myBtnFindRepCaseInsensitive state] == NSOnState) ? YES : NO;
		BOOL bReplacingAllFound = ([myBtnFindRepReplaceAllFound state] == NSOnState) ? YES : NO;
		BOOL bPreservingExtension = ([myBtnFindRepPreserveExtension state] == NSOnState) ? YES : NO;
		NSString *strFind = [mySmManager stringWithSlushAndColonConverted: [myTxtfldFindRepFindString stringValue]];
		NSString *strReplaceWith = [mySmManager stringWithSlushAndColonConverted: [myTxtfldFindRepReplaceString stringValue]];
		if (bRegExp) {
			ppsState = [myFrRenamer regularExpressionFindString: strFind
			                                  replaceWithString: strReplaceWith
															caseInsensitive: bCaseInsensitive
														 replacingAllFound: bReplacingAllFound
								                 preservingExtension: bPreservingExtension];
		}
		else { // NSOffState
			ppsState = [myFrRenamer findString: strFind
			                 replaceWithString: strReplaceWith
									 caseInsensitive: bCaseInsensitive
			                 replacingAllFound: bReplacingAllFound
			               preservingExtension: bPreservingExtension];
		}
		break;
	}
	case NUMBER_SEQUENTIALLY:
	{
		NSString *strPrefix = [mySmManager stringWithSlushAndColonConverted: [myTxtfldSeqNumPrefix stringValue]];
		NSString *strSuffix = [mySmManager stringWithSlushAndColonConverted: [myTxtfldSeqNumSuffix stringValue]];
		int iFirstNumber = [myTxtfldSeqNumFirstNumber intValue];
		int iStepValue = [myTxtfldSeqNumStepValue intValue];
		int iMinimumFigures = [myTxtfldSeqNumLeastFigures intValue];
		BOOL bSameFigures = ([myBtnSeqNumSameFigures state] == NSOnState) ? YES : NO;
		NSString *strExtension;
		if ([myBtnSeqNumPreserveExtension state] == NSOnState) {
			strExtension = nil;
		}
		else {
			strExtension = [mySmManager stringWithSlushAndColonConverted: [myCmbboxSeqNumExtension stringValue]];
		}
		ppsState = [myFrRenamer sequentialNumberWithPrefix: strPrefix
															 withSuffix: strSuffix
										             withExtension: strExtension
								            	  withFirstNumber: iFirstNumber
									                withStepValue: iStepValue
								              withMinimumFigures: iMinimumFigures
								                     sameFigures: bSameFigures];
		break;
	}
	case CHANGE_CHARACTERS_TO_ALL_UPPERCASES:
	{
		BOOL bPreservingExtension = ([myBtnChangeCasesPreserveExtension state] == NSOnState) ? YES : NO;
		ppsState = [myFrRenamer changeCharactersToUppercasesWithExtensionPreserved: bPreservingExtension];
		break;
	}
	case CHANGE_CHARACTERS_TO_ALL_LOWERCASES:
	{
		BOOL bPreservingExtension = ([myBtnChangeCasesPreserveExtension state] == NSOnState) ? YES : NO;
		ppsState = [myFrRenamer changeCharactersToLowercasesWithExtensionPreserved: bPreservingExtension];
		break;
	}
	case CHANGE_CHARACTERS_TO_CAPITALIZED_WORDS:
	{
		BOOL bPreservingExtension = ([myBtnChangeCasesPreserveExtension state] == NSOnState) ? YES : NO;
		ppsState = [myFrRenamer changeCharactersCapitalizedWithExtensionPreserved: bPreservingExtension];
		break;
	}
	case ADD_CHARACTERS_AT_BEGINNING:
	{
		NSString *strAdd = [mySmManager stringWithSlushAndColonConverted: [myTxtfldAddCharCharacters stringValue]];
		ppsState = [myFrRenamer addStringAtBegging: strAdd];
		break;
	}
	case ADD_CHARACTERS_AT_END:
	{
		NSString *strAdd = [mySmManager stringWithSlushAndColonConverted: [myTxtfldAddCharCharacters stringValue]];
		ppsState = [myFrRenamer addStringAtEnd: strAdd];
		break;
	}
	case ADD_CHARACTERS_BEFORE_EXTENSION:
	{
		NSString *strAdd = [mySmManager stringWithSlushAndColonConverted: [myTxtfldAddCharCharacters stringValue]];
		ppsState = [myFrRenamer addStringBeforeExtension: strAdd];
		break;
	}
	case REMOVE_CHARACTERS_FROM_BEGINNING:
	{
		int iNumOfCharacters = [myTxtfldRemvCharBegOrEndNumberOfChars intValue];
		BOOL bPreservingExtension = ([myBtnRemvCharBegOrEndPreserveExtension state] == NSOnState) ? YES : NO;
		ppsState = [myFrRenamer removeCharacters: iNumOfCharacters
                                     fromIndex: 0
					            preservingExtension: bPreservingExtension];
		break;
	}
	case REMOVE_CHARACTERS_FROM_END:
	{
		int iNumOfCharacters = -[myTxtfldRemvCharBegOrEndNumberOfChars intValue];
		BOOL bPreservingExtension = ([myBtnRemvCharBegOrEndPreserveExtension state] == NSOnState) ? YES : NO;
		ppsState = [myFrRenamer removeCharacters: iNumOfCharacters
                                     fromIndex: 0
					            preservingExtension: bPreservingExtension];
		break;
	}
	case REMOVE_CHARACTERS_AT_RANGE:
	{
		BOOL bPreservingExtension = ([myBtnRemvCharRangePreserveExtension state] == NSOnState) ? YES : NO;
		int iIndex = [myTxtfldRemvCharRangeFromNumber intValue] - 1;
		int iNumOfCharacters = [myTxtfldRemvCharRangeNumOfChars intValue];
		if ([myBtnclRemvCharRangeFromEnd state] == NSOnState) {
			iNumOfCharacters *= -1;
		}
		ppsState = [myFrRenamer removeCharacters: iNumOfCharacters
                                     fromIndex: iIndex
					            preservingExtension: bPreservingExtension];
		break;
	}
	case ADD_EXTENSION_TO_FILENAME:
	{
		NSString *strExtension = [mySmManager stringWithSlushAndColonConverted: [myCmboxAddOrRepExtExtension stringValue]];
		ppsState = [myFrRenamer addExtension: strExtension];
		break;
	}
	case REPLACE_EXTENSION_OF_FILENAME:
	{
		NSString *strExtension = [mySmManager stringWithSlushAndColonConverted: [myCmboxAddOrRepExtExtension stringValue]];
		ppsState = [myFrRenamer changeExtension: strExtension];
		break;
	}
	case REMOVE_EXTENSION_OF_FILENAME:
	{
		ppsState = [myFrRenamer removeExtension];
		break;
	}
	} // end of swith statement.
	
	[myTblviewFilesList reloadData];
	if (ppsState!=OK && ppsState!=SAME_EXCEPT_CASES && ppsState!=SAME) {
		[self showErrorMessageOfPathPairState: ppsState];
	}
	else {
		[myBtnRenameNow setEnabled: YES];
	}
}

- (IBAction)sortFilesOfList:(id)sender
{
	[myFrRenamer sortPathPairsOrderBy: [[sender selectedItem] tag]];
	[myTblviewFilesList reloadData];
}

@end
