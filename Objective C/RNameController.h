/* RNameController */

#import <Cocoa/Cocoa.h>
#import "FilesRenamer.h"
#import "ControllerDefinitions.h"
#import "TransparentDraggedWindow.h"
#import "StringsManager.h"

@interface RNameController : NSObject
{
	FilesRenamer *myFrRenamer;
	NSArray *myAExtensionsList;
	StringsManager *mySmManager;

	// Windows and Views
	IBOutlet id myWindowErrorMessage;
	IBOutlet id myWindowMain;
	IBOutlet id myWindowPreferences;
	IBOutlet id myWindowDonation;

	IBOutlet id myViewRemoveExtension;
	IBOutlet id myViewAddCharacters;
	IBOutlet id myViewAddOrReplaceExtension;
	IBOutlet id myViewSequentialNumber;
	IBOutlet id myViewRemoveCharactersFromBegginningOrEnd;
	IBOutlet id myViewFindAndReplace;
	IBOutlet id myViewRemoveCharactersAtRange;
	IBOutlet id myViewChangeCases;

	// On Main Window
	IBOutlet NSBox *myBoxSettings;
	IBOutlet id myBtnAddFiles;
	IBOutlet id myBtnAddFolders;
	IBOutlet id myBtnRecursingFolder;
	IBOutlet id myBtnRenameNow;
	IBOutlet id myPidIndicator;
	IBOutlet id myPubtnRenamingMethods;
	IBOutlet id myTblviewFilesList;
	IBOutlet id myTxtfldStatusMessage;

	// On Pref Window
	IBOutlet id myBtnclPrefClearListAutomatically;
	// IBOutlet id myBtnclPrefDoNothing;
	IBOutlet id myBtnclPrefQuitApplication;
	IBOutlet id myTxtviewPrefExtensionsList;
	IBOutlet id mySldrPrefOpaqueLevel;

	// On Error Message Window
	IBOutlet id myTxtfldErrorMessage;

	// On View Change Cases
	IBOutlet id myBtnChangeCasesPreserveExtension;

	// On View Remove Characters At Range
	IBOutlet id myBtnRemvCharRangePreserveExtension;
	IBOutlet id myBtnclRemvCharRangeFromEnd;
	IBOutlet id myBtnclRemvCharRangeFromBeginning;
	IBOutlet id myStprRemvCharRangeFromNumber;
	IBOutlet id myStprRemvCharRangeNumOfChars;
	IBOutlet id myTxtfldRemvCharRangeFromNumber;
	IBOutlet id myTxtfldRemvCharRangeNumOfChars;

	// On View Find And Replace
	IBOutlet id myBtnFindRepCaseInsensitive;
	IBOutlet id myBtnFindRepPreserveExtension;
	IBOutlet id myBtnFindRepRegularExpression;
	IBOutlet id myBtnFindRepReplaceAllFound;
	IBOutlet id myTxtfldFindRepFindString;
	IBOutlet id myTxtfldFindRepReplaceString;

	// On View Remove Characters From Beginning Or End
	IBOutlet id myBtnRemvCharBegOrEndPreserveExtension;
	IBOutlet id myStprRemvCharBegOrEndNumberOfChars;
	IBOutlet id myTxtfldRemvCharBegOrEndNumberOfChars;

	// On View Sequential Number
	IBOutlet id myBtnSeqNumPreserveExtension;
	IBOutlet id myBtnSeqNumSameFigures;
	IBOutlet id myCmbboxSeqNumExtension;
	IBOutlet id myPubtnSeqNumSort;
	IBOutlet id myStprSeqNumFirstNumber;
	IBOutlet id myStprSeqNumLeastFigures;
	IBOutlet id myStprSeqNumStepValue;
	IBOutlet id myTxtfldSeqNumFirstNumber;
	IBOutlet id myTxtfldSeqNumLeastFigures;
	IBOutlet id myTxtfldSeqNumPrefix;
	IBOutlet id myTxtfldSeqNumStepValue;
	IBOutlet id myTxtfldSeqNumSuffix;

	// On View Add Or Replace Extension
	IBOutlet id myCmboxAddOrRepExtExtension;

	// On View Add Characters
	IBOutlet id myTxtfldAddCharCharacters;
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
- (id) tableView                 : (NSTableView *)aTableView
	   objectValueForTableColumn : (NSTableColumn *)aTableColumn
							 row : (int)rowIndex;
- (void) tableView:       (NSTableView *)tableView
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
