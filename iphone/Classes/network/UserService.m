//
//  UserService.m
//  hurrit
//
//  Created by Juanjo Molinero on 14/02/11.
//  Copyright 2011 BIFI. All rights reserved.
//

#import "UserService.h"
#import "JSON.h"
#import "MyFormDataRequest.h"

@implementation UserService

+ (NSDictionary*) following {
	NSString* url = [NSString stringWithFormat:@"%@:%@/user/following", ServerURL, ServerPort];
	MyFormDataRequest* request = [[[MyFormDataRequest alloc] initWithURL:[NSURL URLWithString:url]] autorelease];
	[request startSynchronous];
	
	NSError* error = [request error];
	if (!error) {
		return [[request responseString] JSONValue];
	} else {
		return nil;
	}
}

+ (NSDictionary*) follow:(NSString*)interestingUser {
	NSString* url = [NSString stringWithFormat:@"%@:%@/user/follow", ServerURL, ServerPort];
	MyFormDataRequest* request = [[[MyFormDataRequest alloc] initWithURL:[NSURL URLWithString:url]] autorelease];
	[request setPostValue:interestingUser forKey:@"id"];
	[request startSynchronous];
	
	NSError* error = [request error];
	if (!error) {
		return [[request responseString] JSONValue];
	} else {
		return nil;
	}
}

+ (NSDictionary*) unfollow:(NSString*)boringUser {
	NSString* url = [NSString stringWithFormat:@"%@:%@/user/unfollow", ServerURL, ServerPort];
	MyFormDataRequest* request = [[[MyFormDataRequest alloc] initWithURL:[NSURL URLWithString:url]] autorelease];
	[request setPostValue:boringUser forKey:@"id"];
	[request startSynchronous];
	
	NSError* error = [request error];
	if (!error) {
		return [[request responseString] JSONValue];
	} else {
		return nil;
	}
}

+ (NSDictionary*) searchUserWithString:(NSString*)searchTerm {
	NSString* url = [NSString stringWithFormat:@"%@:%@/user/search", ServerURL, ServerPort];
	MyFormDataRequest* request = [[[MyFormDataRequest alloc] initWithURL:[NSURL URLWithString:url]] autorelease];
	[request setPostValue:searchTerm forKey:@"q"];
	[request startSynchronous];
	
	NSError* error = [request error];
	if (!error) {
		return [[request responseString] JSONValue];
	} else {
		return nil;
	}
}

+ (NSDictionary*) notifications {
	NSString* url = [NSString stringWithFormat:@"%@:%@/my_account/get_details", ServerURL, ServerPort];
	MyFormDataRequest* request = [[[MyFormDataRequest alloc] initWithURL:[NSURL URLWithString:url]] autorelease];
	[request startSynchronous];
	
	NSError* error = [request error];
	if (!error) {
		return [[request responseString] JSONValue];
	} else {
		return nil;
	}
}

+ (NSDictionary*) markAsRead:(NSNumber*)notification_id {
	NSString* url = [NSString stringWithFormat:@"%@:%@/my_account/remove_message", ServerURL, ServerPort];
	MyFormDataRequest* request = [[[MyFormDataRequest alloc] initWithURL:[NSURL URLWithString:url]] autorelease];
	[request setPostValue:notification_id forKey:@"id"];
	[request startSynchronous];
	
	NSError* error = [request error];
	if (!error) {
		return [[request responseString] JSONValue];
	} else {
		return nil;
	}
}

@end
