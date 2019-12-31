//
//  UISearchBar+SSAdd.m
//  hxsc
//
//  Created by soldoros on 2017/7/20.
//  Copyright © 2017年 soldoros. All rights reserved.


#import "UISearchBar+SSAdd.h"

@implementation UISearchBar (SSAdd)

-(void)changeLeftPlaceholder:(NSString *)placeholder color:(UIColor *)color {
    self.placeholder = placeholder;
    UITextField *searchField = [self valueForKey:@"searchField"];
    if (searchField) {
        searchField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:self.placeholder ?: @"" attributes:@{NSForegroundColorAttributeName: color ?: self.tintColor}];
    }
    SEL centerSelector = NSSelectorFromString([NSString stringWithFormat:@"%@%@", @"setCenter", @"Placeholder:"]);
    if ([self respondsToSelector:centerSelector]) {
        BOOL centeredPlaceholder = NO;
        NSMethodSignature *signature = [[UISearchBar class] instanceMethodSignatureForSelector:centerSelector];
        NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:signature];
        [invocation setTarget:self];
        [invocation setSelector:centerSelector];
        [invocation setArgument:&centeredPlaceholder atIndex:2];
        [invocation invoke];
    }
}



@end
