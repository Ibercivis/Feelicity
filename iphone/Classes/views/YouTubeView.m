//
//  YouTubeView.m
//  feelicity
//
//  Created by Juanjo Molinero on 06/07/11.
//  Copyright 2011 BIFI. All rights reserved.
//

#import "YouTubeView.h"

@implementation YouTubeView

@synthesize txtURL;
@synthesize btnAccept;
@synthesize btnCancel;
@synthesize target;
@synthesize action;

- (void) viewDidLoad {
    self.txtURL.text = @"";
}

- (IBAction) btnAcceptTapped:(id)sender {
    [self.target performSelector:self.action withObject:txtURL.text];
    [self.txtURL resignFirstResponder];
    self.hidden = YES;
}

- (IBAction) btnCancelTapped:(id)sender {
    [self.txtURL resignFirstResponder];
    self.hidden = YES;
}

@end
