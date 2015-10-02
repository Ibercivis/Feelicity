//
//  UIView+FindAndResignFirstResponder.m
//  hurrit
//
//  Created by Juanjo Molinero on 26/11/10.
//  Copyright 2010 BIFI. All rights reserved.
//

#import "UIView+FindAndResignFirstResponder.h"


@implementation UIView (FindAndResignFirstResponder)

- (BOOL)findAndResignFirstResponder {
    if (self.isFirstResponder) {
        [self resignFirstResponder];
        return YES;     
    }
    for (UIView *subView in self.subviews) {
        if ([subView findAndResignFirstResponder])
            return YES;
    }
    return NO;
}

@end
