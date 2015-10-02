//
//  PostAnnotation.m
//  hurrit
//
//  Created by Juanjo Molinero on 09/11/10.
//  Copyright 2010 BIFI. All rights reserved.
//

#import "PostAnnotation.h"


@implementation PostAnnotation

@synthesize coordinate = _coordinate;
@synthesize postId;

-(id) initWithTitle:(NSString*)title andSubtitle:(NSString*)subtitle {
	self = [super init];
	_title = [title retain];
	_subtitle = [subtitle retain];
	
	return self;
}

- (NSString *)title {
	return _title;
}

- (NSString *)subtitle {
	return _subtitle;
}

- (void)setCoordinate:(CLLocationCoordinate2D)newCoordinate {
	_coordinate = newCoordinate;
}


-(void) dealloc {
	[_title release];
	[_subtitle release];
	
	[super dealloc];
}

@end
