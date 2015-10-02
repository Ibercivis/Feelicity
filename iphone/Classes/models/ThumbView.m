//
//  ThumbView.m
//  hurrit
//
//  Created by Juanjo Molinero on 03/12/10.
//  Copyright 2010 BIFI. All rights reserved.
//

#import "ThumbView.h"


@implementation ThumbView

@synthesize myParent;

- (void) touchesEnded:(NSSet*)touches withEvent:(UIEvent*)event {
	[myParent thumbOnClick];
}

@end
