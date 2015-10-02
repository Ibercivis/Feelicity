//
//  UserService.h
//  hurrit
//
//  Created by Juanjo Molinero on 14/02/11.
//  Copyright 2011 BIFI. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface UserService : NSObject {

}

+ (NSDictionary*) following;
+ (NSDictionary*) follow:(NSString*)interestingUser;
+ (NSDictionary*) unfollow:(NSString*)boringUser;
+ (NSDictionary*) searchUserWithString:(NSString*)searchTerm;
+ (NSDictionary*) notifications;
+ (NSDictionary*) markAsRead:(NSNumber*)notification_id;

@end
