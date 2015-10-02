//
//  PostAnnotation.h
//  hurrit
//
//  Created by Juanjo Molinero on 09/11/10.
//  Copyright 2010 BIFI. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

@interface PostAnnotation : NSObject <MKAnnotation> {
	NSString* _title;
	NSString* _subtitle;
	CLLocationCoordinate2D _coordinate;
	NSString* postId;
}

@property (nonatomic, retain) NSString* postId;

-(id) initWithTitle:(NSString*)title andSubtitle:(NSString*)subtitle;

@end
