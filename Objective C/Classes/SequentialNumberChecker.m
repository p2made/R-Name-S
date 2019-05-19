#import "SequentialNumberChecker.h"

@implementation SequentialNumberChecker



- (BOOL) control: (NSControl *)control textShouldEndEditing: (NSText *)fieldEditor
{
   return ([[control stringValue] length] != 0);
}


@end
