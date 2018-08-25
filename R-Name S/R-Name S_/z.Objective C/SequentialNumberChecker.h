/* SequentialNumberChecker */

#import <Cocoa/Cocoa.h>

@interface SequentialNumberChecker : NSObject
{
}


// Delegate NSTextField
// txtfldMyStartWithNumOfSequentialNumber and txtfldMyMinimumDigitsOfSequentialNumber in
// class R_NameController cannot be empty.
- (BOOL) control: (NSControl *)control textShouldEndEditing: (NSText *)fieldEditor;



@end
