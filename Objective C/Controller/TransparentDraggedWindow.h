//
//  TransparentDraggedWindow.h
//  WindowTester
//
//  Created by Yoichi Tagaya on Wed May 01 2002.
//  Copyright (c) 2001 Yoichi Tagaya. All rights reserved.
//

#import <AppKit/AppKit.h>

@interface NSObject(DragToWindowOperation)
- (BOOL) performDragToWindowOperation: (id <NSDraggingInfo>)sender;
@end


@interface TransparentDraggedWindow : NSWindow {

}

- (id) initWithContentRect: (NSRect)contentRect
                 styleMask: (unsigned int)aStyle
                   backing: (NSBackingStoreType)bufferingType
                     defer: (BOOL)flag;

- (unsigned int) draggingEntered: (id <NSDraggingInfo>)sender;
- (unsigned int) draggingUpdated: (id <NSDraggingInfo>)sender;
- (void) draggingExited: (id <NSDraggingInfo>)sender;

- (BOOL) prepareForDragOperation: (id <NSDraggingInfo>)sender;
- (BOOL) performDragOperation: (id <NSDraggingInfo>)sender;
- (void) concludeDragOperation: (id <NSDraggingInfo>)sender;

@end
