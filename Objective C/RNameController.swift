//
//  RNameController.swift
//  R-Name (Upgraded)
//
//  Created by Pedro Plowman on 14/5/19.
//

import Cocoa
import FilesRenamer
import ControllerDefinitions
import TransparentDraggedWindow
import StringsManager

class RNameController: NSObject {
	FilesRenamer *myFrRenamer;
	NSArray *myAExtensionsList;
	StringsManager *mySmManager;

	@IBOutlet weak var zoopy: NSPopUpButton!

	// Windows and Views
	@IBOutlet weak var myWindowErrorMessage: Any!
	@IBOutlet weak var myWindowMain: Any!
	@IBOutlet weak var myWindowPreferences: Any!
	@IBOutlet weak var myWindowDonation: Any!

	@IBOutlet weak var myViewRemoveExtension: Any!
	@IBOutlet weak var myViewAddCharacters: Any!
	@IBOutlet weak var myViewAddOrReplaceExtension: Any!
	@IBOutlet weak var myViewSequentialNumber: Any!
	@IBOutlet weak var myViewRemoveCharactersFromBegginningOrEnd: Any!
	@IBOutlet weak var myViewFindAndReplace: Any!
	@IBOutlet weak var myViewRemoveCharactersAtRange: Any!
	@IBOutlet weak var myViewChangeCases: Any!

	// On Main Window
	@IBOutlet weak var *myBoxSettings: NSBox!
	@IBOutlet weak var myBtnAddFiles: Any!
	@IBOutlet weak var myBtnAddFolders: Any!
	@IBOutlet weak var myBtnRecursingFolder: Any!
	@IBOutlet weak var myBtnRenameNow: Any!
	@IBOutlet weak var myPidIndicator: Any!
	@IBOutlet weak var myPubtnRenamingMethods: Any!
	@IBOutlet weak var myTblviewFilesList: Any!
	@IBOutlet weak var myTxtfldStatusMessage: Any!

	// On Pref Window
	@IBOutlet weak var myBtnclPrefClearListAutomatically: Any!
	//	@IBOutlet weak var myBtnclPrefDoNothing: Any!
	@IBOutlet weak var myBtnclPrefQuitApplication: Any!
	@IBOutlet weak var myTxtviewPrefExtensionsList: Any!
	@IBOutlet weak var mySldrPrefOpaqueLevel: Any!

	// On Error Message Window
	@IBOutlet weak var myTxtfldErrorMessage: Any!



	// On View Change Cases
	@IBOutlet weak var myBtnChangeCasesPreserveExtension: Any!


	// On View Remove Characters At Range
	@IBOutlet weak var myBtnRemvCharRangePreserveExtension: Any!
	@IBOutlet weak var myBtnclRemvCharRangeFromEnd: Any!
	@IBOutlet weak var myBtnclRemvCharRangeFromBeginning: Any!
	@IBOutlet weak var myStprRemvCharRangeFromNumber: Any!
	@IBOutlet weak var myStprRemvCharRangeNumOfChars: Any!
	@IBOutlet weak var myTxtfldRemvCharRangeFromNumber: Any!
	@IBOutlet weak var myTxtfldRemvCharRangeNumOfChars: Any!


	// On View Find And Replace
	@IBOutlet weak var myBtnFindRepCaseInsensitive: Any!
	@IBOutlet weak var myBtnFindRepPreserveExtension: Any!
	@IBOutlet weak var myBtnFindRepRegularExpression: Any!
	@IBOutlet weak var myBtnFindRepReplaceAllFound: Any!
	@IBOutlet weak var myTxtfldFindRepFindString: Any!
	@IBOutlet weak var myTxtfldFindRepReplaceString: Any!


	// On View Remove Characters From Beginning Or End
	@IBOutlet weak var myBtnRemvCharBegOrEndPreserveExtension: Any!
	@IBOutlet weak var myStprRemvCharBegOrEndNumberOfChars: Any!
	@IBOutlet weak var myTxtfldRemvCharBegOrEndNumberOfChars: Any!


	// On View Sequential Number
	@IBOutlet weak var myBtnSeqNumPreserveExtension: Any!
	@IBOutlet weak var myBtnSeqNumSameFigures: Any!
	@IBOutlet weak var myCmbboxSeqNumExtension: Any!
	@IBOutlet weak var myPubtnSeqNumSort: Any!
	@IBOutlet weak var myStprSeqNumFirstNumber: Any!
	@IBOutlet weak var myStprSeqNumLeastFigures: Any!
	@IBOutlet weak var myStprSeqNumStepValue: Any!
	@IBOutlet weak var myTxtfldSeqNumFirstNumber: Any!
	@IBOutlet weak var myTxtfldSeqNumLeastFigures: Any!
	@IBOutlet weak var myTxtfldSeqNumPrefix: Any!
	@IBOutlet weak var myTxtfldSeqNumStepValue: Any!
	@IBOutlet weak var myTxtfldSeqNumSuffix: Any!


	// On View Add Or Replace Extension
	@IBOutlet weak var myCmboxAddOrRepExtExtension: Any!


	// On View Add Characters
	@IBOutlet weak var myTxtfldAddCharCharacters: Any!

}
/* RNameController */



@interface RNameController : NSObject
{
}



#pragma mark ## Public Methods ##

- (id) init;
- (void) dealloc;
- (void) awakeFromNib;

- (void) endOneRenaming;

#pragma mark ## Application Delegaters ##

- (BOOL) application: (NSApplication *)theApplication
openFile: (NSString *)filename;

- (void) applicationDidFinishLaunching: (NSNotification *)aNotification;

- (void) applicationWillTerminate: (NSNotification *)aNotification;



#pragma mark ## Window Delegaters ##

// This method terminates application when the main window close.
- (void) windowWillClose: (NSNotification *)aNotification;

- (void) windowDidResignKey: (NSNotification *)aNotification;


// This method adds dragged files to the list.
- (BOOL) performDragToWindowOperation: (id <NSDraggingInfo>)sender;




#pragma mark ## Protocol NSTableDataSource ##

// These method set list of files to Table View.
- (int) numberOfRowsInTableView: (NSTableView *)aTableView;
- (id) tableView				 : (NSTableView *)aTableView
objectValueForTableColumn : (NSTableColumn *)aTableColumn
row : (int)rowIndex;
- (void) tableView:	   (NSTableView *)tableView
setObjectValue : (id)object
forTableColumn: (NSTableColumn *)tableColumn
row: (int)rowIndex;



#pragma mark ## Delegates NSTableVeiw ##

- (void) tableView: (NSTableView *)aTableView
willDisplayCell: (id)aCell
forTableColumn: (NSTableColumn *)aTableColumn
row: (int)rowIndex;




#pragma mark ## Protocol NSComboBoxDataSource ##

- (int) numberOfItemsInComboBox: (NSComboBox *)aComboBox;
- (id) comboBox: (NSComboBox *)aComboBox objectValueForItemAtIndex: (int)index;
- (NSString *)comboBoxCell:(NSComboBoxCell *)aComboBoxCell completedString:(NSString *)uncompletedString;


#pragma mark ## Actions ##

- (IBAction)checkTheWebsite:(id)sender;
- (IBAction)clearList:(id)sender;
- (IBAction)doUNICEF:(id)sender;
- (IBAction)okayErrorMessageWindow:(id)sender;
- (IBAction)openFiles:(id)sender;
- (IBAction)preserveExtensionOfSequentialNumbering:(id)sender;
- (IBAction)renameActually:(id)sender;
- (IBAction)setRenameMethod:(id)sender;
- (IBAction)setAddFiles:(id)sender;
- (IBAction)setAddFolders:(id)sender;
- (IBAction)setOpaqueLevelOfWindows:(id)sender;
- (IBAction)setRecurseFolder:(id)sender;
- (IBAction)showNewNames:(id)sender;
- (IBAction)sortFilesOfList:(id)sender;


@end
