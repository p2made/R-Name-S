//
//  ControllerDefinitions.swift
//  R-Name S
//
//  Created by Pedro Plowman on 21/5/18.
//  Copyright © 2018 p2made. All rights reserved.
//

import Foundation

enum RenamingKinds : Int {
    case find_AND_REPLACE = 0
    case number_SEQUENTIALLY = 1
    case change_CHARACTERS_TO_ALL_UPPERCASES = 2
    case change_CHARACTERS_TO_ALL_LOWERCASES = 3
    case change_CHARACTERS_TO_CAPITALIZED_WORDS = 4
    case add_CHARACTERS_AT_BEGINNING = 5
    case add_CHARACTERS_AT_END = 6
    case add_CHARACTERS_BEFORE_EXTENSION = 7
    case remove_CHARACTERS_FROM_BEGINNING = 8
    case remove_CHARACTERS_FROM_END = 9
    case remove_CHARACTERS_AT_RANGE = 10
    case add_EXTENSION_TO_FILENAME = 11
    case replace_EXTENSION_OF_FILENAME = 12
    case remove_EXTENSION_OF_FILENAME = 13
}

enum SortKinds : Int {
    case no_SORT = 0
    case by_NAME_A_TO_Z_CASE_SENSITIVE = 1
    case by_NAME_A_TO_Z = 2
    case by_NAME_Z_TO_A_CASE_SENSITIVE = 3
    case by_NAME_Z_TO_A = 4
    case by_SMALLEST_SIZE_TO_LARGEST = 5
    case by_LARGEST_SIZE_TO_SMALLEST = 6
    case by_EARLIEST_MODIFICATION_DATE_TO_LATEST = 7
    case by_LATEST_MODIFICATION_DATE_TO_EARLIEST = 8
    case by_EARLIEST_CREATION_DATE_TO_LATEST = 9
    case by_LATEST_CREATION_DATE_TO_EARLIEST = 10
}

let RNAME_RELATIVE_PLIST_PATH = "Library/Preferences/R-Name.plist"
//#define DEFAULT_PLIST_RELATIVE_PATH @"Contents/Resources/DefaultPrefs.plist"

let CURRENT_VERSION_NUMBER = 210

// Show the donation window once per this value.
let DONATION_WINDOW_FREQUENCY = 20
let TABLE_COLUMN_ID_ONOFF = "ON_OFF"
let TABLE_COLUMN_ID_OLD = "OLD"
let TABLE_COLUMN_ID_NEW = "NEW"
let MAX_EXTENSIONS_IN_VIEW_OF_COMBOBOX = 12
let AUTO_SAVE_NAME_MAIN_WINDOW = "MainWindow"
let AUTO_SAVE_NAME_PREFS_WINDOW = "PrefsWindow"

// UserDefaults Keys
let UDKEY_ADD_FILES = "AddFiles"
let UDKEY_ADD_FOLDERS = "AddFolders"
let UDKEY_RECURSE_FOLDER = "RecurseFolder"
let UDKEY_SELECTED_METHOD = "SelectedMethod"
let UDKEY_EXTENSIONS_LIST = "ExtensionsList"
let UDKEY_PREF_CLEAR_LIST_AUTOMATICALLY = "PrefClearListAutomatically"
let UDKEY_PREF_QUIT_APP = "PrefQuitApp"
let UDKEY_PREF_OPAQEU_LEVEL = "PrefOpaqueLevelOfWindows"
let UDKEY_CHANGE_CASES_PRESERVE_EXTENSION = "ChangeCasesPreserveExtension"
let UDKEY_REMV_CHAR_RANGE_PRESERVE_EXTENSION = "RemvCharRangePreserveExtension"
let UDKEY_REMV_CHAR_RANGE_FROM_BEGINNIG = "RemvCharRangeFromBeginning"
let UDKEY_REMV_CHAR_RANGE_FROM_END = "RemvCharRangeFromEnd"
let UDKEY_REMV_CHAR_RANGE_FROM_NUMBER = "RemvCharRangeFromNumber"
let UDKEY_REMV_CHAR_RANGE_NUM_OF_CHARS = "RemvCharRangeNumOfChars"
let UDKEY_FIND_REP_CASE_INSENSITIVE = "FindRepCaseInsensitive"
let UDKEY_FIND_REP_PRESERVE_EXTENSION = "FindRepPreserveExtension"
let UDKEY_FIND_REP_REGEXP = "FindRepRegexp"
let UDKEY_FIND_REP_REPLACE_ALL = "FindRepReplaceAll"
let UDKEY_REMV_CHAR_BEG_OR_END_PRESERVE_EXTENSION = "RemvCharBegOrEndPreserveExtension"
let UDKEY_REMV_CHAR_BEG_OR_END_NUM_OF_CHARS = "RemvCharBegOrEndNumOfChars"
let UDKEY_SEQ_NUM_PRESERVE_EXTENSION = "SeqNumPreserveExtension"
let UDKEY_SEQ_NUM_SAME_FIGS = "SeqNumSameFigs"
let UDKEY_SEQ_NUM_SORT = "SeqNumSort"
let UDKEY_SEQ_NUM_FIRST_NUM = "SeqNumFirstNum"
let UDKEY_SEQ_NUM_LEAST_FIGS = "SeqNumLeastFigs"
let UDKEY_SEQ_NUM_STEP_VAL = "SeqNumStepVal"
let UDKEY_PREF_VERSION = "PreferencesVersion"

// Localizable.strings
let LSTR_CHECK_WEB_URL = "CheckWebURL"
let LSTR_UNICEF_WEB_URL = "UNICEFWebURL"
let LSTR_UNICEF_DONATION_URL = "UNICEFDonationURL"
let LSTR_MAIL_FOR_UNICEF_DONATION = "AuthorsMailAddressForUNICEFDonation"
let LSTR_MESSAGE_DONE = "MessageDone"
let LSTR_ERR_MESSAGE_EXIST = "ErrMessageExist"
let LSTR_ERR_MESSAGE_LONG = "ErrMessageLong"
let LSTR_ERR_MESSAGE_DOT_BEGINNING = "ErrMessageDotBeginning"
let LSTR_ERR_MESSAGE_INVALID_REGEXP = "ErrMessageInvalidRegexp"
let LSTR_ERR_MESSAGE_INVALID_CAHR = "ErrMessageInvalidCharacter"
