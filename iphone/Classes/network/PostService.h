//
//  PostService.h
//  bidi
//
//  Created by Juanjo Molinero on 04/11/10.
//  Copyright 2010 BIFI. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>


@interface PostService : NSObject {

}

+ (NSDictionary*) getPostData:(NSString*) postId withExtraInfo:(NSDictionary*)info;
+ (NSDictionary*) scorePost:(NSString*) postId withScore:(NSNumber*) score;
+ (NSDictionary*) scoreComment:(NSString*) commentId withScore:(NSNumber*) score;

+ (NSDictionary*) newPostWithName:(NSString*)placeName andDescription:(NSString*)description andCoordinates:(CLLocationCoordinate2D)coordinates;
+ (NSDictionary*) newCommentForPost:(NSString*)postId 
					withCoordinates:(CLLocationCoordinate2D)coordinates 
					andTitle:(NSString*)title 
					andDescription:(NSString*)description;
+ (NSDictionary*) addImage:(UIImage*)image toComment:(NSString*)commentId;
+ (NSDictionary*) addVideo:(NSString*)video toComment:(NSString*)commentId;
+ (NSDictionary*) sendNotificationFor:(NSString*) postId withMessage:(NSString*) message andRecipients:(NSString*) recipients;
+ (NSDictionary*) deleteComment:(NSString*)commentId;

@end
