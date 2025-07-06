//
//  Definitions.swift
//  R-Name
//
//  Created by Pedro Plowman on 2018-5-18.
//  Copyright © 2018 Pedro Plowman. All rights reserved.
//  Open sourced licensed under the MIT license.
//

let maxFilenameLength = 255
let stringMadeOfInvalidChars = "/"

enum PathPairState: Int {
	case noDestination = 0
	case ok // 1
	case sameExceptCases // 2
	case same // 3
	case exist // 4
	case long // 5
	case startWithDot // 6
	case invalidRegexp // 7
	case invalidCharacter // 8
}

enum ViewOrder: Int {
	case none = 0
	case alphabetic // 1
	case caseInsensitiveAlphabetic // 2
	case reverseAlphabetic // 3
	case caseInsensitiveReverseAlphabetic // 4
	case size // 5
	case reverseSize // 6
	case dateModified // 7
	case reverseDateModified // 8
	case dateCreated // 9
	case reverseDateCreated // 10
}

enum RenamingMethods: Int {
	case findReplace = 0
	case regexpFindReplace // 1
	case sequentialNumber // 2
	case toLowercases // 3
	case toUppercases // 4
	case toCapitalized // 5
	case addAtBegging // 6
	case addAtEnd // 7
	case addBeforeExt // 8
	case removeCharacters // 9
	case addExtension // 10
	case changeExtension // 11
	case removeExtension // 12
}
