//
//  RNameController.swift
//  R-Name S
//
//  Created by Pedro Plowman on 14/5/19.
//  Copyright © 2019 p2made. All rights reserved.
//

import Cocoa
//import FilesRenamer
//import StringsManager
//import TransparentDraggedWindow

class RNameController: NSObject {
	//var myFrRenamer: FilesRenamer!
	//var myAExtensionsList: [AnyObject]!
	//var mySmManager: StringsManager!

	var myFrRenamer: FilesRenamer?
	var myAExtensionsList: [Any] = []
	var mySmManager: StringsManager?

	// Windows and Views
	@IBOutlet var myWindowErrorMessage: NSWindow!
	@IBOutlet var myWindowMain: NSWindow!
	@IBOutlet var myWindowPreferences: NSWindow!
	@IBOutlet var myWindowDonation: NSWindow!
	@IBOutlet var myViewRemoveExtension: NSView!
	@IBOutlet var myViewAddCharacters: NSView!
	@IBOutlet var myViewAddOrReplaceExtension: NSView!
	@IBOutlet var myViewSequentialNumber: NSView!
	@IBOutlet var myViewRemoveCharactersFromBegginningOrEnd: NSView!
	@IBOutlet var myViewFindAndReplace: NSView!
	@IBOutlet var myViewRemoveCharactersAtRange: NSView!
	@IBOutlet var myViewChangeCases: NSView!
	// On Main Window
	@IBOutlet var myBoxSettings: NSBox!
	@IBOutlet var myBtnAddFiles: Any!
	@IBOutlet var myBtnAddFolders: Any!
	@IBOutlet var myBtnRecursingFolder: Any!
	@IBOutlet var myBtnRenameNow: Any!
	@IBOutlet var myPidIndicator: Any!
	@IBOutlet var myPubtnRenamingMethods: Any!
	@IBOutlet var myTblviewFilesList: Any!
	@IBOutlet var myTxtfldStatusMessage: Any!
	// On Pref Window
	@IBOutlet var myBtnclPrefClearListAutomatically: Any!
	// IBOutlet id myBtnclPrefDoNothing;
	@IBOutlet var myBtnclPrefQuitApplication: Any!
	@IBOutlet var myTxtviewPrefExtensionsList: Any!
	@IBOutlet var mySldrPrefOpaqueLevel: Any!
	// On Error Message Window
	@IBOutlet var myTxtfldErrorMessage: Any!
	// On View Change Cases
	@IBOutlet var myBtnChangeCasesPreserveExtension: Any!
	// On View Remove Characters At Range
	@IBOutlet var myBtnRemvCharRangePreserveExtension: Any!
	@IBOutlet var myBtnclRemvCharRangeFromEnd: Any!
	@IBOutlet var myBtnclRemvCharRangeFromBeginning: Any!
	@IBOutlet var myStprRemvCharRangeFromNumber: Any!
	@IBOutlet var myStprRemvCharRangeNumOfChars: Any!
	@IBOutlet var myTxtfldRemvCharRangeFromNumber: Any!
	@IBOutlet var myTxtfldRemvCharRangeNumOfChars: Any!
	// On View Find And Replace
	@IBOutlet var myBtnFindRepCaseInsensitive: Any!
	@IBOutlet var myBtnFindRepPreserveExtension: Any!
	@IBOutlet var myBtnFindRepRegularExpression: Any!
	@IBOutlet var myBtnFindRepReplaceAllFound: Any!
	@IBOutlet var myTxtfldFindRepFindString: Any!
	@IBOutlet var myTxtfldFindRepReplaceString: Any!
	// On View Remove Characters From Beginning Or End
	@IBOutlet var myBtnRemvCharBegOrEndPreserveExtension: Any!
	@IBOutlet var myStprRemvCharBegOrEndNumberOfChars: Any!
	@IBOutlet var myTxtfldRemvCharBegOrEndNumberOfChars: Any!
	// On View Sequential Number
	@IBOutlet var myBtnSeqNumPreserveExtension: Any!
	@IBOutlet var myBtnSeqNumSameFigures: Any!
	@IBOutlet var myCmbboxSeqNumExtension: Any!
	@IBOutlet var myPubtnSeqNumSort: Any!
	@IBOutlet var myStprSeqNumFirstNumber: Any!
	@IBOutlet var myStprSeqNumLeastFigures: Any!
	@IBOutlet var myStprSeqNumStepValue: Any!
	@IBOutlet var myTxtfldSeqNumFirstNumber: Any!
	@IBOutlet var myTxtfldSeqNumLeastFigures: Any!
	@IBOutlet var myTxtfldSeqNumPrefix: Any!
	@IBOutlet var myTxtfldSeqNumStepValue: Any!
	@IBOutlet var myTxtfldSeqNumSuffix: Any!
	// On View Add Or Replace Extension
	@IBOutlet var myCmboxAddOrRepExtExtension: Any!
	// On View Add Characters
	@IBOutlet var myTxtfldAddCharCharacters: Any!

// MARK: ## Private Methods ##
	func setRenamingKindViewToBox(_ rkKind: RenamingKinds) {
		switch rkKind {
			case .findAndReplace:
				myBoxSettings.contentView = myViewFindAndReplace
				myTxtfldFindRepFindString.selectText(self)
			case .numberSequentially:
				myBoxSettings.contentView = myViewSequentialNumber
				myTxtfldSeqNumPrefix.selectText(self)
			case .changeCharactersToAllUppercases, .changeCharactersToAllLowercases, .changeCharactersToCapitalizedWords:
				myBoxSettings.contentView = myViewChangeCases
			case .addCharactersAtBeginning, .addCharactersBeforeExtension, .addCharactersAtEnd:
				myBoxSettings.contentView = myViewAddCharacters
				myTxtfldAddCharCharacters.selectText(self)
			case .removeCharactersFromBeginning, .removeCharactersFromEnd:
				myBoxSettings.contentView = myViewRemoveCharactersFromBegginningOrEnd
				myTxtfldRemvCharBegOrEndNumberOfChars.selectText(self)
			case .removeCharactersAtRange:
				myBoxSettings.contentView = myViewRemoveCharactersAtRange
				myTxtfldRemvCharRangeNumOfChars.selectText(self)
			case .addExtensionToFilename, .replaceExtensionOfFilename:
				myBoxSettings.contentView = myViewAddOrReplaceExtension
				myCmboxAddOrRepExtExtension.selectText(self)
			case .removeExtensionOfFilename:
				myBoxSettings.contentView = myViewRemoveExtension
			default:
				break
		}
	}

	// aSPaths is a array including absolute paths.
	func addSourcePaths(_ aSPaths: [Any]?) {
		myFrRenamer.addAbsoluteSourcePaths(aSPaths)
		myTblviewFilesList.reloadData()
		myPubtnSeqNumSort.selectItem(at: 0)
	}

	func openPanelDidEnd(_ sheet: NSOpenPanel?, returnCode: Int) {
		var aPaths: [Any]

		if returnCode == NSOKButton {
			if let filenames = sheet?.filenames() {
				aPaths = filenames
			}
			addSourcePaths(aPaths)
		}
	}

	func setButtonToTableView() {
		var tblcColumn: NSTableColumn?
		var btncCell: NSButtonCell?

		tblcColumn = myTblviewFilesList.tableColumn(withIdentifier: TABLE_COLUMN_ID_ONOFF)
		btncCell = NSButtonCell()
		btncCell?.setButtonType(NSSwitchButton)
		btncCell?.title = ""
		if let btncCell = btncCell {
			tblcColumn?.dataCell = btncCell
		}

		myTblviewFilesList.setIntercellSpacing(NSMakeSize(3.0, 2.0))
	}

	func showErrorMessageOf(_ ppsState: PathPairState) {
		let bdlBundle = Bundle.main
		var strErrMessage: String? = nil

		switch ppsState {
			case EXIST:
				strErrMessage = bdlBundle.localizedString(forKey: LSTR_ERR_MESSAGE_EXIST, value: nil, table: nil)
			case LONG:
				strErrMessage = bdlBundle.localizedString(forKey: LSTR_ERR_MESSAGE_LONG, value: nil, table: nil)
			case START_WITH_DOT:
				strErrMessage = bdlBundle.localizedString(forKey: LSTR_ERR_MESSAGE_DOT_BEGINNING, value: nil, table: nil)
			case INVALID_REGEXP:
				strErrMessage = bdlBundle.localizedString(forKey: LSTR_ERR_MESSAGE_INVALID_REGEXP, value: nil, table: nil)
			case INVALID_CHARACTER:
				strErrMessage = bdlBundle.localizedString(forKey: LSTR_ERR_MESSAGE_INVALID_CAHR, value: nil, table: nil)
			default:
				break
		}

		myTxtfldErrorMessage.setTitleWithMnemonic(strErrMessage ?? "")
		NSApp.beginSheet(myWindowErrorMessage, modalForWindow: myWindowMain, modalDelegate: nil, didEndSelector: nil, contextInfo: nil)
	}

	func setExtensionsListToComboBox() {
		let iExtensions = Int(myAExtensionsList.count())

		if iExtensions <= MAX_EXTENSIONS_IN_VIEW_OF_COMBOBOX {
			myCmbboxSeqNumExtension.numberOfVisibleItems = iExtensions
			myCmboxAddOrRepExtExtension.numberOfVisibleItems = iExtensions
		} else {
			myCmbboxSeqNumExtension.numberOfVisibleItems = MAX_EXTENSIONS_IN_VIEW_OF_COMBOBOX
			myCmboxAddOrRepExtExtension.numberOfVisibleItems = MAX_EXTENSIONS_IN_VIEW_OF_COMBOBOX
		}

		myCmbboxSeqNumExtension.noteNumberOfItemsChanged()
		myCmboxAddOrRepExtExtension.noteNumberOfItemsChanged()

		myCmbboxSeqNumExtension.reloadData()
		myCmboxAddOrRepExtExtension.reloadData()
	}

	func setExtensionsListToArray() {
		var scnScanner: Scanner?
		var csReturn: CharacterSet?
		var csTab: CharacterSet?
		var strScannedExtension: String
		var maTemp: [AnyHashable]

		csReturn = CharacterSet(charactersIn: "\n")
		csTab = CharacterSet(charactersIn: "\t")
		scnScanner = Scanner(string: myTxtviewPrefExtensionsList.string())
		scnScanner?.charactersToBeSkipped = csTab
		maTemp = [AnyHashable](repeating: 0, count: 20)

		while !scnScanner?.isAtEnd() {
			if let csReturn = csReturn {
				if scnScanner?.scanUpToCharacters(from: csReturn, into: &strScannedExtension) ?? false {
					maTemp.append(strScannedExtension)
				}
			}
			if let csReturn = csReturn {
				scnScanner?.scanCharacters(from: csReturn, into: nil)
			}
		}
		myAExtensionsList = maTemp
	}

	func setExtensionsListToTextView() {
		var enmExtension: NSEnumerator?
		var strExtension: String
		var mstrExtensions = String(repeating: "\0", count: 20)
		enmExtension = myAExtensionsList.objectEnumerator()
		while strExtension = enmExtension?.nextObject() as? String ?? "" {
			mstrExtensions += "\(strExtension)\n"
		}
		myTxtviewPrefExtensionsList.string = mstrExtensions
	}

	func setOpaqueLevelOfWindowsToFloatValue(_ fOpaqueLevel: Float) {
		var fOpaqueLevel = fOpaqueLevel
		if fOpaqueLevel < 0.3 || 1.0 < fOpaqueLevel {
			fOpaqueLevel = 1.0
		}
		myWindowMain.alphaValue = CGFloat(fOpaqueLevel)
		myWindowPreferences.alphaValue = CGFloat(fOpaqueLevel)
	}

	func loadPrefs() {
		let udDefaults = UserDefaults.standard

		// About items on main window
		myBtnAddFiles.state = udDefaults.integer(forKey: UDKEY_ADD_FILES)
		setAddFiles(myBtnAddFiles)
		myBtnAddFolders.state = udDefaults.integer(forKey: UDKEY_ADD_FOLDERS)
		setAddFolders(myBtnAddFolders)
		myBtnRecursingFolder.state = udDefaults.integer(forKey: UDKEY_RECURSE_FOLDER)
		setRecurseFolder(myBtnRecursingFolder)
		myPubtnRenamingMethods.selectItem(at: udDefaults.integer(forKey: UDKEY_SELECTED_METHOD))
		setRenamingKindViewToBox(Int(myPubtnRenamingMethods.selectedItem?.tag ?? 0))

		// About items on prefs window
		myBtnclPrefClearListAutomatically.state = udDefaults.integer(forKey: UDKEY_PREF_CLEAR_LIST_AUTOMATICALLY)
		// [myBtnclPrefDoNothing setState: [udDefaults integerForKey: UDKEY_PREF_DO_NOTHING]];
		myBtnclPrefQuitApplication.state = udDefaults.integer(forKey: UDKEY_PREF_QUIT_APP)
		mySldrPrefOpaqueLevel = NSNumber(value: udDefaults.float(forKey: UDKEY_PREF_OPAQEU_LEVEL))
		setOpaqueLevelOfWindowsToFloatValue(mySldrPrefOpaqueLevel.floatValue)

		// Setting Extensions List.

		myAExtensionsList = udDefaults.array(forKey: UDKEY_EXTENSIONS_LIST)
		setExtensionsListToComboBox()
		setExtensionsListToTextView()

		// About items on setting views
		myBtnChangeCasesPreserveExtension.state = udDefaults.integer(forKey: UDKEY_CHANGE_CASES_PRESERVE_EXTENSION)

		myBtnRemvCharRangePreserveExtension.state = udDefaults.integer(forKey: UDKEY_REMV_CHAR_RANGE_PRESERVE_EXTENSION)
		myBtnclRemvCharRangeFromBeginning.state = udDefaults.integer(forKey: UDKEY_REMV_CHAR_RANGE_FROM_BEGINNIG)
		myBtnclRemvCharRangeFromEnd.state = udDefaults.integer(forKey: UDKEY_REMV_CHAR_RANGE_FROM_END)
		myTxtfldRemvCharRangeFromNumber = NSNumber(value: udDefaults.integer(forKey: UDKEY_REMV_CHAR_RANGE_FROM_NUMBER))
		myStprRemvCharRangeFromNumber = NSNumber(value: udDefaults.integer(forKey: UDKEY_REMV_CHAR_RANGE_FROM_NUMBER))
		myTxtfldRemvCharRangeNumOfChars = NSNumber(value: udDefaults.integer(forKey: UDKEY_REMV_CHAR_RANGE_NUM_OF_CHARS))
		myStprRemvCharRangeNumOfChars = NSNumber(value: udDefaults.integer(forKey: UDKEY_REMV_CHAR_RANGE_NUM_OF_CHARS))

		myBtnFindRepCaseInsensitive.state = udDefaults.integer(forKey: UDKEY_FIND_REP_CASE_INSENSITIVE)
		myBtnFindRepPreserveExtension.state = udDefaults.integer(forKey: UDKEY_FIND_REP_PRESERVE_EXTENSION)
		myBtnFindRepRegularExpression.state = udDefaults.integer(forKey: UDKEY_FIND_REP_REGEXP)
		myBtnFindRepReplaceAllFound.state = udDefaults.integer(forKey: UDKEY_FIND_REP_REPLACE_ALL)

		myBtnRemvCharBegOrEndPreserveExtension.state = udDefaults.integer(forKey: UDKEY_REMV_CHAR_BEG_OR_END_PRESERVE_EXTENSION)
		myTxtfldRemvCharBegOrEndNumberOfChars = NSNumber(value: udDefaults.integer(forKey: UDKEY_REMV_CHAR_BEG_OR_END_NUM_OF_CHARS))
		myStprRemvCharBegOrEndNumberOfChars = NSNumber(value: udDefaults.integer(forKey: UDKEY_REMV_CHAR_BEG_OR_END_NUM_OF_CHARS))

		myBtnSeqNumPreserveExtension.state = udDefaults.integer(forKey: UDKEY_SEQ_NUM_PRESERVE_EXTENSION)
		if udDefaults.integer(forKey: UDKEY_SEQ_NUM_PRESERVE_EXTENSION) == NSControl.StateValue.on.rawValue {
			myCmbboxSeqNumExtension.enabled = false
		} else {
			myCmbboxSeqNumExtension.enabled = true
		}
		myBtnSeqNumSameFigures.state = udDefaults.integer(forKey: UDKEY_SEQ_NUM_SAME_FIGS)
		myStprSeqNumFirstNumber = NSNumber(value: udDefaults.integer(forKey: UDKEY_SEQ_NUM_FIRST_NUM))
		myTxtfldSeqNumFirstNumber = NSNumber(value: udDefaults.integer(forKey: UDKEY_SEQ_NUM_FIRST_NUM))
		myStprSeqNumLeastFigures = NSNumber(value: udDefaults.integer(forKey: UDKEY_SEQ_NUM_LEAST_FIGS))
		myTxtfldSeqNumLeastFigures = NSNumber(value: udDefaults.integer(forKey: UDKEY_SEQ_NUM_LEAST_FIGS))
		myStprSeqNumStepValue = NSNumber(value: udDefaults.integer(forKey: UDKEY_SEQ_NUM_STEP_VAL))
		myTxtfldSeqNumStepValue = NSNumber(value: udDefaults.integer(forKey: UDKEY_SEQ_NUM_STEP_VAL))
	}

	func writePrefs() {
		var udDefaults = UserDefaults.standard

		// About items on main window
		udDefaults.set(myBtnAddFiles.state(), forKey: UDKEY_ADD_FILES)
		udDefaults.set(myBtnAddFolders.state(), forKey: UDKEY_ADD_FOLDERS)
		udDefaults.set(myBtnRecursingFolder.state(), forKey: UDKEY_RECURSE_FOLDER)
		udDefaults.set(myPubtnRenamingMethods.indexOfSelectedItem(), forKey: UDKEY_SELECTED_METHOD)

		// About items on prefs window
		udDefaults.set(myAExtensionsList, forKey: UDKEY_EXTENSIONS_LIST)
		udDefaults.set(myBtnclPrefClearListAutomatically.state(), forKey: UDKEY_PREF_CLEAR_LIST_AUTOMATICALLY)
		// [udDefaults setInteger: [myBtnclPrefDoNothing state]
		// forKey: UDKEY_PREF_DO_NOTHING];
		udDefaults.set(myBtnclPrefQuitApplication.state(), forKey: UDKEY_PREF_QUIT_APP)
		udDefaults.set(mySldrPrefOpaqueLevel.floatValue, forKey: UDKEY_PREF_OPAQEU_LEVEL)

		// About items on setting views
		udDefaults.set(myBtnChangeCasesPreserveExtension.state(), forKey: UDKEY_CHANGE_CASES_PRESERVE_EXTENSION)

		udDefaults.set(myBtnRemvCharRangePreserveExtension.state(), forKey: UDKEY_REMV_CHAR_RANGE_PRESERVE_EXTENSION)
		udDefaults.set(myBtnclRemvCharRangeFromBeginning.state(), forKey: UDKEY_REMV_CHAR_RANGE_FROM_BEGINNIG)
		udDefaults.set(myBtnclRemvCharRangeFromEnd.state(), forKey: UDKEY_REMV_CHAR_RANGE_FROM_END)
		udDefaults.set(myTxtfldRemvCharRangeFromNumber.intValue, forKey: UDKEY_REMV_CHAR_RANGE_FROM_NUMBER)
		udDefaults.set(myTxtfldRemvCharRangeNumOfChars.intValue, forKey: UDKEY_REMV_CHAR_RANGE_NUM_OF_CHARS)

		udDefaults.set(myBtnFindRepCaseInsensitive.state(), forKey: UDKEY_FIND_REP_CASE_INSENSITIVE)
		udDefaults.set(myBtnFindRepPreserveExtension.state(), forKey: UDKEY_FIND_REP_PRESERVE_EXTENSION)
		udDefaults.set(myBtnFindRepRegularExpression.state(), forKey: UDKEY_FIND_REP_REGEXP)
		udDefaults.set(myBtnFindRepReplaceAllFound.state(), forKey: UDKEY_FIND_REP_REPLACE_ALL)

		udDefaults.set(myBtnRemvCharBegOrEndPreserveExtension.state(), forKey: UDKEY_REMV_CHAR_BEG_OR_END_PRESERVE_EXTENSION)
		udDefaults.set(myTxtfldRemvCharBegOrEndNumberOfChars.intValue, forKey: UDKEY_REMV_CHAR_BEG_OR_END_NUM_OF_CHARS)

		udDefaults.set(myBtnSeqNumPreserveExtension.state(), forKey: UDKEY_SEQ_NUM_PRESERVE_EXTENSION)
		udDefaults.set(myBtnSeqNumSameFigures.state(), forKey: UDKEY_SEQ_NUM_SAME_FIGS)
		udDefaults.set(myPubtnSeqNumSort.selectedItem?.tag ?? 0, forKey: UDKEY_SEQ_NUM_SORT)
		udDefaults.set(myTxtfldSeqNumFirstNumber.intValue, forKey: UDKEY_SEQ_NUM_FIRST_NUM)
		udDefaults.set(myTxtfldSeqNumLeastFigures.intValue, forKey: UDKEY_SEQ_NUM_LEAST_FIGS)
		udDefaults.set(myTxtfldSeqNumStepValue.intValue, forKey: UDKEY_SEQ_NUM_STEP_VAL)

		udDefaults.synchronize()
	}

	func careForSomething(afterRenaming sender: Any?) {
		if myBtnclPrefClearListAutomatically.state() == .on {
			myPidIndicator = NSNumber(value: 0.0)
			myFrRenamer.clearRenamedPathPairs()
			myTblviewFilesList.reloadData()
			myTxtfldStatusMessage.setTitleWithMnemonic("")
		} else {
			NSApp.terminate(self)
		}
	}

// MARK: ## Public Methods ##
	init() {
		super.init()
		myFrRenamer = FilesRenamer(controller: self)
		myAExtensionsList = [Any]()
		mySmManager = StringsManager()
	}

	deinit {
	}

	func awakeFromNib() {
		myWindowMain.registerForDraggedTypes([.fileURL])
		setButtonToTableView()

		do {
			// Check "~/Library/Preferences/R-Name" exists
			let strPlistPath = "\(NSHomeDirectory())/\(RNAME_RELATIVE_PLIST_PATH)"
			let fmManager = FileManager.default
			if fmManager.fileExists(atPath: strPlistPath) {
				loadPrefs()
			} else {
				setRenamingKindViewToBox(FIND_AND_REPLACE)
				myAExtensionsList = ["jpg", "gif", "png", "   ", "mov", "mpg", "mp3", "   ", "txt", "html"]
				setExtensionsListToComboBox()
				setExtensionsListToTextView()
			}
		}

		myWindowMain.makeKeyAndOrderFront(self)

		srand(time(nil))

		do {
			// UNICEF Window
			let udDefaults = UserDefaults.standard
			if udDefaults.integer(forKey: UDKEY_PREF_VERSION) < CURRENT_VERSION_NUMBER || arc4random() % DONATION_WINDOW_FREQUENCY == 0 {
				myWindowDonation.makeKeyAndOrderFront(self)
				udDefaults.set(CURRENT_VERSION_NUMBER, forKey: UDKEY_PREF_VERSION)
			}
		}
	}

	func endOneRenaming() {
		myPidIndicator.increment(by: 1.0)
		myPidIndicator.displayIfNeeded()
	}

// MARK: ## Application Delegates ##
	func application(_ theApplication: NSApplication, openFile filename: String) -> Bool {
		addSourcePaths([filename])
		return true
	}

	/*
	- (void) applicationDidFinishLaunching: (NSNotification *)aNotification
	{
	}
	*/
	func applicationWillTerminate(_ aNotification: Notification) {
		writePrefs()
	}

// MARK: ## Window Delegates ##

	// This method terminates application when the main window close.
	func windowWillClose(_ aNotification: Notification) {
		if (aNotification.object?.frameAutosaveName == AUTO_SAVE_NAME_MAIN_WINDOW) {
			NSApp.terminate(self)
		}
	}

	func windowDidResignKey(_ aNotification: Notification) {
		if (aNotification.object?.frameAutosaveName == AUTO_SAVE_NAME_PREFS_WINDOW) {
			setExtensionsListToArray()
			//[self writePrefs];
		}
	}

	// This method adds dragged files to the list.
	func performDrag(toWindowOperation sender: NSDraggingInfo?) -> Bool {
		let pb: NSPasteboard? = sender?.draggingPasteboard
		let aPaths = pb?.propertyList(forType: .fileURL) as? [Any]
		addSourcePaths(aPaths)
		return true
	}

	// MARK: ## Protocol NSTableDataSource ##
	// These method set list of files to Table View.
	func numberOfRowsInTableView(_ aTableView: NSTableView) -> Int32 {
		return myFrRenamer.countOfAddedPaths()

	}

	func tableView(_ aTableView: NSTableView, objectValueForTableColumn aTableColumn: NSTableColumn, row rowIndex: Int32) -> Any {
		if aTableColumn.identifier().isEqual(to: TABLE_COLUMN_ID_ONOFF) {
			if myFrRenamer.actualRenamingAtIndex(rowIndex) == true {
				return NSNumber(int: NSControlStateValueOn)
			} else {
				return NSNumber(int: NSControlStateValueOff)

			}
		} else if aTableColumn.identifier().isEqual(to: TABLE_COLUMN_ID_OLD) {
			return mySmManager.stringWithSlushAndColonConverted(myFrRenamer.relativeSourcePathAtIndex(rowIndex))
		} else {
			// if TABLE_COLUMN_ID_NEW
			return mySmManager.stringWithSlushAndColonConverted(myFrRenamer.relativeDestinationPathAtIndex(rowIndex))

		}
	}

	func tableView(_ tableView: NSTableView, setObjectValue object: Any, forTableColumn tableColumn: NSTableColumn, row rowIndex: Int32) {
		if tableColumn.identifier().isEqual(to: TABLE_COLUMN_ID_ONOFF) {
			myFrRenamer.setActualRenaming((object.int32Value == NSControlStateValueOn), AtIndex: rowIndex)
		}
	}

	// MARK: ## Delegates NSTableView ##
	func tableView(_ aTableView: NSTableView, willDisplayCell aCell: Any, forTableColumn aTableColumn: NSTableColumn, row rowIndex: Int32) {
		if aTableColumn.identifier().isEqual(to: TABLE_COLUMN_ID_ONOFF) {
			PathPairState.ppsState = myFrRenamer.pathPairStateAtIndex(rowIndex)
			if ppsState == OK || ppsState == SAME_EXCEPT_CASES {
				aCell.enabled = true
			} else {
				aCell.enabled = false

			}
		}
	}

	// MARK: ## Protocol NSComboBoxDataSource ##
	func numberOfItemsInComboBox(_ aComboBox: NSComboBox) -> Int32 {
		return Int32(myAExtensionsList.count())
	}

	func comboBox(_ aComboBox: NSComboBox, objectValueForItemAtIndex index: Int32) -> Any {
		return myAExtensionsList.object(at: index)
	}

	func comboBoxCell(_ aComboBoxCell: NSComboBoxCell, completedString uncompletedString: String) -> String {
		var enmExtensions: NSEnumerator = myAExtensionsList.objectEnumerator()
		var strExtension: String
		while strExtension = enmExtensions.nextObject() {
			if strExtension.hasPrefix(uncompletedString) {
				return strExtension
			}
		}
		return NSString(string: uncompletedString)
	}

	// MARK: ## Actions ##
	@IBAction func checkTheWebsite(_ sender: Any) {
		var bdlBundle: Bundle
		var strWebURL: String
		var urlWebURL: NSURL
		bdlBundle = NSBundle.mainBundle()
		strWebURL = bdlBundle.localizedStringForKey(LSTR_CHECK_WEB_URL, value: nil, table: nil)
		urlWebURL = NSURL(string: strWebURL)
		NSWorkspace.shared.openURL(urlWebURL)
	}

	@IBAction func clearList(_ sender: Any) {
		myFrRenamer.clearRenamedPathPairs()
		myTblviewFilesList.reloadData()
		myBtnRenameNow.enabled = false
	}

	@IBAction func doUNICEF(_ sender: Any) {
		var bdlBundle: Bundle
		var strURL: String
		var urlURL: NSURL
		bdlBundle = NSBundle.mainBundle()
		switch sender.tag() {
			case 1:

			strURL = bdlBundle.localizedStringForKey(LSTR_UNICEF_DONATION_URL, value: nil, table: nil)
			break
			case 2:

			strURL = bdlBundle.localizedStringForKey(LSTR_UNICEF_WEB_URL, value: nil, table: nil)
			break
			default:

			strURL = bdlBundle.localizedStringForKey(LSTR_MAIL_FOR_UNICEF_DONATION, value: nil, table: nil)
			break
		}
		urlURL = NSURL(string: strURL)
		NSWorkspace.shared.openURL(urlURL)
	}

	@IBAction func okayErrorMessageWindow(_ sender: Any) {
		myWindowErrorMessage.orderOut(self)
		NSApp.endSheet(myWindowErrorMessage)
	}

	@IBAction func openFiles(_ sender: Any) {
		var op: NSOpenPanel = NSOpenPanel.openPanel()
		op.canChooseDirectories = true
		op.allowsMultipleSelection = true
		op.beginSheetForDirectory(nil, file: nil, types: nil, modalForWindow: myWindowMain, modalDelegate: self, didEndSelector: "openPanelDidEnd:returnCode:", contextInfo: nil)
	}

	@IBAction func preserveExtensionOfSequentialNumbering(_ sender: Any) {
		if sender.state() == NSControlStateValueOn {
			myCmbboxSeqNumExtension.enabled = false
		} else {
			myCmbboxSeqNumExtension.enabled = true

		}
	}

	@IBAction func renameActually(_ sender: Any) {
		myPidIndicator.maxValue = myFrRenamer.countOfAddedPaths()
		myPidIndicator.doubleValue = 0.0
		myFrRenamer.renameOldPathsToNew()
			var bdlBundle: Bundle = NSBundle.mainBundle()
			var strDone: String = bdlBundle.localizedStringForKey(LSTR_MESSAGE_DONE, value: nil, table: nil)
			myTxtfldStatusMessage.setTitleWithMnemonic(strDone)

		self.performSelector("careForSomethingAfterRenaming:", withObject: self, afterDelay: 1.5)
		myBtnRenameNow.enabled = false
	}

	@IBAction func setRenameMethod(_ sender: Any) {
		RenamingKinds.rkKind = Int32(sender.selectedItem().tag())
		self.renamingKindViewToBox = rkKind
	}

	@IBAction func setAddFiles(_ sender: Any) {
		if sender.state() == NSControlStateValueOn {
			myFrRenamer.addingFiles = true
		} else {
			// NSControlStateValueOff
			myFrRenamer.addingFiles = false

		}
	}

	@IBAction func setAddFolders(_ sender: Any) {
		if sender.state() == NSControlStateValueOn {
			myFrRenamer.addingFolders = true
		} else {
			// NSControlStateValueOff
			myFrRenamer.addingFolders = false

		}
	}

	@IBAction func setOpaqueLevelOfWindows(_ sender: Any) {
		self.opaqueLevelOfWindowsToFloatValue = sender.floatValue()
	}

	@IBAction func setRecurseFolder(_ sender: Any) {
		if sender.state() == NSControlStateValueOn {
			myFrRenamer.recursingFolder = true
		} else {
			// NSControlStateValueOff
			myFrRenamer.recursingFolder = false

		}
	}

	@IBAction func showNewNames(_ sender: Any) {
		PathPairState.ppsState = OK
		RenamingKinds.rkKind = Int32(myPubtnRenamingMethods.selectedItem().tag())
		switch rkKind {
			case RenamingKinds.FIND_AND_REPLACE:

				var bRegExp: Bool = (myBtnFindRepRegularExpression.state() == NSControlStateValueOn) ? true : false
				var bCaseInsensitive: Bool = (myBtnFindRepCaseInsensitive.state() == NSControlStateValueOn) ? true : false
				var bReplacingAllFound: Bool = (myBtnFindRepReplaceAllFound.state() == NSControlStateValueOn) ? true : false
				var bPreservingExtension: Bool = (myBtnFindRepPreserveExtension.state() == NSControlStateValueOn) ? true : false
				var strFind: String = mySmManager.stringWithSlushAndColonConverted(myTxtfldFindRepFindString.stringValue())
				var strReplaceWith: String = mySmManager.stringWithSlushAndColonConverted(myTxtfldFindRepReplaceString.stringValue())
				if bRegExp {
					ppsState = myFrRenamer.regularExpressionFindString(strFind, replaceWithString: strReplaceWith, caseInsensitive: bCaseInsensitive, replacingAllFound: bReplacingAllFound, preservingExtension: bPreservingExtension)
				} else {
					// NSControlStateValueOff
					ppsState = myFrRenamer.findString(strFind, replaceWithString: strReplaceWith, caseInsensitive: bCaseInsensitive, replacingAllFound: bReplacingAllFound, preservingExtension: bPreservingExtension)

				}
				break

			case RenamingKinds.NUMBER_SEQUENTIALLY:

				var strPrefix: String = mySmManager.stringWithSlushAndColonConverted(myTxtfldSeqNumPrefix.stringValue())
				var strSuffix: String = mySmManager.stringWithSlushAndColonConverted(myTxtfldSeqNumSuffix.stringValue())
				var iFirstNumber: Int32 = myTxtfldSeqNumFirstNumber.int32Value
				var iStepValue: Int32 = myTxtfldSeqNumStepValue.int32Value
				var iMinimumFigures: Int32 = myTxtfldSeqNumLeastFigures.int32Value
				var bSameFigures: Bool = (myBtnSeqNumSameFigures.state() == NSControlStateValueOn) ? true : false
				var strExtension: String
				if myBtnSeqNumPreserveExtension.state() == NSControlStateValueOn {
					strExtension = nil
				} else {
					strExtension = mySmManager.stringWithSlushAndColonConverted(myCmbboxSeqNumExtension.stringValue())

				}
				ppsState = myFrRenamer.sequentialNumberWithPrefix(strPrefix, withSuffix: strSuffix, withExtension: strExtension, withFirstNumber: iFirstNumber, withStepValue: iStepValue, withMinimumFigures: iMinimumFigures, sameFigures: bSameFigures)
				break

			case RenamingKinds.CHANGE_CHARACTERS_TO_ALL_UPPERCASES:

				var bPreservingExtension: Bool = (myBtnChangeCasesPreserveExtension.state() == NSControlStateValueOn) ? true : false
				ppsState = myFrRenamer.changeCharactersToUppercasesWithExtensionPreserved(bPreservingExtension)
				break

			case RenamingKinds.CHANGE_CHARACTERS_TO_ALL_LOWERCASES:

				var bPreservingExtension: Bool = (myBtnChangeCasesPreserveExtension.state() == NSControlStateValueOn) ? true : false
				ppsState = myFrRenamer.changeCharactersToLowercasesWithExtensionPreserved(bPreservingExtension)
				break

			case RenamingKinds.CHANGE_CHARACTERS_TO_CAPITALIZED_WORDS:

				var bPreservingExtension: Bool = (myBtnChangeCasesPreserveExtension.state() == NSControlStateValueOn) ? true : false
				ppsState = myFrRenamer.changeCharactersCapitalizedWithExtensionPreserved(bPreservingExtension)
				break

			case RenamingKinds.ADD_CHARACTERS_AT_BEGINNING:

				var strAdd: String = mySmManager.stringWithSlushAndColonConverted(myTxtfldAddCharCharacters.stringValue())
				ppsState = myFrRenamer.addStringAtBegging(strAdd)
				break

			case RenamingKinds.ADD_CHARACTERS_AT_END:

				var strAdd: String = mySmManager.stringWithSlushAndColonConverted(myTxtfldAddCharCharacters.stringValue())
				ppsState = myFrRenamer.addStringAtEnd(strAdd)
				break

			case RenamingKinds.ADD_CHARACTERS_BEFORE_EXTENSION:

				var strAdd: String = mySmManager.stringWithSlushAndColonConverted(myTxtfldAddCharCharacters.stringValue())
				ppsState = myFrRenamer.addStringBeforeExtension(strAdd)
				break

			case RenamingKinds.REMOVE_CHARACTERS_FROM_BEGINNING:

				var iNumOfCharacters: Int32 = myTxtfldRemvCharBegOrEndNumberOfChars.int32Value
				var bPreservingExtension: Bool = (myBtnRemvCharBegOrEndPreserveExtension.state() == NSControlStateValueOn) ? true : false
				ppsState = myFrRenamer.removeCharacters(iNumOfCharacters, fromIndex: 0, preservingExtension: bPreservingExtension)
				break

			case RenamingKinds.REMOVE_CHARACTERS_FROM_END:

				var iNumOfCharacters: Int32 = -myTxtfldRemvCharBegOrEndNumberOfChars.int32Value
				var bPreservingExtension: Bool = (myBtnRemvCharBegOrEndPreserveExtension.state() == NSControlStateValueOn) ? true : false
				ppsState = myFrRenamer.removeCharacters(iNumOfCharacters, fromIndex: 0, preservingExtension: bPreservingExtension)
				break

			case RenamingKinds.REMOVE_CHARACTERS_AT_RANGE:

				var bPreservingExtension: Bool = (myBtnRemvCharRangePreserveExtension.state() == NSControlStateValueOn) ? true : false
				var iIndex: Int32 = myTxtfldRemvCharRangeFromNumber.int32Value-1
				var iNumOfCharacters: Int32 = myTxtfldRemvCharRangeNumOfChars.int32Value
				if myBtnclRemvCharRangeFromEnd.state() == NSControlStateValueOn {
					iNumOfCharacters *= -1
				}
				ppsState = myFrRenamer.removeCharacters(iNumOfCharacters, fromIndex: iIndex, preservingExtension: bPreservingExtension)
				break

			case RenamingKinds.ADD_EXTENSION_TO_FILENAME:

				var strExtension: String = mySmManager.stringWithSlushAndColonConverted(myCmboxAddOrRepExtExtension.stringValue())
				ppsState = myFrRenamer.addExtension(strExtension)
				break

			case RenamingKinds.REPLACE_EXTENSION_OF_FILENAME:

				var strExtension: String = mySmManager.stringWithSlushAndColonConverted(myCmboxAddOrRepExtExtension.stringValue())
				ppsState = myFrRenamer.changeExtension(strExtension)
				break

			case RenamingKinds.REMOVE_EXTENSION_OF_FILENAME:

				ppsState = myFrRenamer.removeExtension()
				break
		}
		// end of swith statement.
		myTblviewFilesList.reloadData()
		if ppsState != OK && ppsState != SAME_EXCEPT_CASES && ppsState != SAME {
			self.showErrorMessageOfPathPairState(ppsState)
		} else {
			myBtnRenameNow.enabled = true

		}
	}

	@IBAction func sortFilesOfList(_ sender: Any) {
		myFrRenamer.sortPathPairsOrderBy(Int32(sender.selectedItem().tag()))
		myTblviewFilesList.reloadData()
	}
}
