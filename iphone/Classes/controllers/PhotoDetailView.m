//
//  PhotoDetailView.m
//  hurrit
//
//  Created by Juanjo Molinero on 22/11/10.
//  Copyright 2010 BIFI. All rights reserved.
//

#import "PhotoDetailView.h"


@implementation PhotoDetailView

@synthesize myImage;
@synthesize imageURL;

- (void)viewDidLoad {
    [super viewDidLoad];
	
	[myImage setImage:[[UIImage alloc] initWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:imageURL]]]];
}

- (BOOL) shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation {
    return YES;
}

- (void)dealloc {
	[myImage release];
	
    [super dealloc];
}

@end
