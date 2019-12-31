//
//  UISearchBar+ClearBackground.m
//  SSChat
//
//  Created by GJS on 2019/12/31.
//  Copyright © 2019 soldoros. All rights reserved.
//

#import "UISearchBar+ClearBackground.h"

@implementation UISearchBar (ClearBackground)

- (void)clearBackground {
    for (UIView *view in self.subviews.lastObject.subviews) {
        if ([view isKindOfClass:NSClassFromString(@"UISearchBarBackground")]) {
            view.layer.contents = nil;
            break;
        }
    }
}

@end
