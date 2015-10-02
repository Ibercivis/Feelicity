//
//  PostMedia.m
//  hurrit
//
//  Created by Juanjo Molinero on 03/12/10.
//  Copyright 2010 BIFI. All rights reserved.
//

#import "PostMedia.h"

@implementation PostMedia

@synthesize mediaType;
@synthesize path;
@synthesize thumbView;

- (NSString*) thumbURL {
	if ([mediaType isEqualToString:@"image"]) {
		return [NSString stringWithFormat:@"%@:%@%@_mid.jpg", ServerURL, ServerPort, path];
	}
	
	return nil;
}

- (NSString*) mediaURL {
	if ([mediaType isEqualToString:@"image"]) {
		return [NSString stringWithFormat:@"%@:%@%@.jpg", ServerURL, ServerPort, path];
	} else if ([mediaType isEqualToString:@"youtube"]) {
		return path;
	}
	
	return nil;
}

- (void) loadThumbView:(PostDetailView*)parent {
	if (thumbView == nil) {
		thumbView = [[ThumbView alloc] init];
		[thumbView loadImageFromURL:[NSURL URLWithString:[self thumbURL]]];
		[thumbView setUserInteractionEnabled:YES];
		self.thumbView.myParent = parent;
	}
}

@end
