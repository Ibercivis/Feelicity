//
//  PostMedia.h
//  hurrit
//
//  Created by Juanjo Molinero on 03/12/10.
//  Copyright 2010 BIFI. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PostDetailView.h"
#import "ThumbView.h"


@interface PostMedia : NSObject {
	NSString* mediaType;
	NSString* path;
	ThumbView* thumbView;
}

@property (nonatomic, retain) NSString* mediaType;
@property (nonatomic, retain) NSString* path;
@property (nonatomic, retain) ThumbView* thumbView;

- (NSString*) thumbURL;
- (NSString*) mediaURL;
- (void) loadThumbView:(PostDetailView*)parent;

@end
