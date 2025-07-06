//
//  ControllerDefinitions.swift
//  R-Name S
//
//  Created by Pedro Plowman on 21/5/18.
//  Copyright © 2018 p2made. All rights reserved.
//

enum RenamingKinds: Int {
	case findAndReplace = 0
	case numberSequentially // 1
	case changeCharactersToAllUppercases // 2
	case changeCharactersToAllLowercases // 3
	case changeCharactersToCapitalizedWords // 4
	case addCharactersAtBeginning // 5
	case addCharactersAtEnd // 6
	case addCharactersBeforeExtension // 7
	case removeCharactersFromBeginning // 8
	case removeCharactersFromEnd // 9
	case removeCharactersAtRange // 10
	case addExtensionToFilename // 11
	case replaceExtensionOfFilename // 12
	case removeExtensionOfFilename // 13
}

enum SortKinds: Int {
	case noSort = 0
	case byNameAToZCaseSensitive // 1
	case byNameAToZ // 2
	case byNameZToACaseSensitive // 3
	case byNameZToA // 4
	case bySmallestSizeToLargest // 5
	case byLargestSizeToSmallest // 6
	case byEarliestModificationDateToLatest // 7
	case byLatestModificationDateToEarliest // 8
	case byEarliestCreationDateToLatest // 9
	case byLatestCreationDateToEarliest // 10
}

let rNameRelativePlistPath = "Library/Preferences/R-Name.plist"

let currentVersionNumber = 210

// Show the donation window once per this value.
let donationWindowFrequency = 20

let tableColumnIdOnoff = "ON_OFF"
let tableColumnIdOld = "OLD"
let tableColumnIdNew = "NEW"

let maxExtensionsInViewOfCombobox = 12

let autoSaveNameMainWindow = "MainWindow"
let autoSaveNamePrefsWindow = "PrefsWindow"

// UserDefaults Keys
let udkeyAddFiles = "AddFiles"
let udkeyAddFolders = "AddFolders"
let udkeyRecurseFolder = "RecurseFolder"
let udkeySelectedMethod = "SelectedMethod"

let udkeyExtensionsList = "ExtensionsList"
let udkeyPrefClearListAutomatically = "PrefClearListAutomatically"
let udkeyPrefQuitApp = "PrefQuitApp"
let udkeyPrefOpaqeuLevel = "PrefOpaqueLevelOfWindows"

let udkeyChangeCasesPreserveExtension = "ChangeCasesPreserveExtension"

let udkeyRemvCharRangePreserveExtension = "RemvCharRangePreserveExtension"
let udkeyRemvCharRangeFromBeginnig = "RemvCharRangeFromBeginning"
let udkeyRemvCharRangeFromEnd = "RemvCharRangeFromEnd"
let udkeyRemvCharRangeFromNumber = "RemvCharRangeFromNumber"
let udkeyRemvCharRangeNumOfChars = "RemvCharRangeNumOfChars"

let udkeyFindRepCaseInsensitive = "FindRepCaseInsensitive"
let udkeyFindRepPreserveExtension = "FindRepPreserveExtension"
let udkeyFindRepRegexp = "FindRepRegexp"
let udkeyFindRepReplaceAll = "FindRepReplaceAll"

let udkeyRemvCharBegOrEndPreserveExtension = "RemvCharBegOrEndPreserveExtension"
let udkeyRemvCharBegOrEndNumOfChars = "RemvCharBegOrEndNumOfChars"

let udkeySeqNumPreserveExtension = "SeqNumPreserveExtension"
let udkeySeqNumSameFigs = "SeqNumSameFigs"
let udkeySeqNumSort = "SeqNumSort"
let udkeySeqNumFirstNum = "SeqNumFirstNum"
let udkeySeqNumLeastFigs = "SeqNumLeastFigs"
let udkeySeqNumStepVal = "SeqNumStepVal"

let udkeyPrefVersion = "PreferencesVersion"

// Localizable.strings
let lstrCheckWebUrl = "CheckWebURL"
let lstrUnicefWebUrl = "UNICEFWebURL"
let lstrUnicefDonationUrl = "UNICEFDonationURL"
let lstrMailForUnicefDonation = "AuthorsMailAddressForUNICEFDonation"
let lstrMessageDone = "MessageDone"
let lstrErrMessageExist = "ErrMessageExist"
let lstrErrMessageLong = "ErrMessageLong"
let lstrErrMessageDotBeginning = "ErrMessageDotBeginning"
let lstrErrMessageInvalidRegexp = "ErrMessageInvalidRegexp"
let lstrErrMessageInvalidCahr = "ErrMessageInvalidCharacter"
