//
//  Definitions.swift
//  R-Name
//
//  Created by Pedro Plowman on 2018-5-18.
//  Copyright © 2018 Pedro Plowman. All rights reserved.
//  Open sourced licensed under the MIT license.
//

import Foundation // necessary?

let MAX_FILENAME_LENGTH = 255
let STRING_MADE_OF_INVALID_CHARS = "/"

enum PathPairState : Int {
	case no_DESTINATION = 0
	case ok = 1
	case same_EXCEPT_CASES = 2
	case same = 3
	case exist = 4
	case long = 5
	case start_WITH_DOT = 6
	case invalid_REGEXP = 7
	case invalid_CHARACTER = 8
}

enum ViewOrder : Int {
	case none = 0
	case alphabetic = 1
	case case_INSENSITIVE_ALPHABETIC = 2
	case reverse_ALPHABETIC = 3
	case case_INSENSITIVE_REVERSE_ALPHABETIC = 4
	case size = 5
	case reverse_SIZE = 6
	case date_MODIFIED = 7
	case reverse_DATE_MODIFIED = 8
	case date_CREATED = 9
	case reverse_DATE_CREATED = 10
}

enum RenameingMethods : Int {
	case find_REPLACE = 0
	case regexp_FIND_REPLACE
	case sequential_NUMBER
	case to_LOWERCASES
	case to_UPPERCASES
	case to_CAPITALIZED
	case add_AT_BEGGING
	case add_AT_END
	case add_BEFORE_EXT
	case remove_CHARACTERS
	case add_EXTENSION
	case change_EXTENSION
	case remove_EXTENSION
}
