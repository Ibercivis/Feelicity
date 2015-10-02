//
//  PostService.m
//  bidi
//
//  Created by Juanjo Molinero on 04/11/10.
//  Copyright 2010 BIFI. All rights reserved.
//

#import "PostService.h"
#import "JSON.h"
#import "MyFormDataRequest.h"
#import "ImageUtils.h"

@implementation PostService

+ (NSDictionary*) getPostData:(NSString*) postId withExtraInfo:(NSDictionary*)info {
	NSString* url = [NSString stringWithFormat:@"%@:%@/view/get_place_data", ServerURL, ServerPort];
	MyFormDataRequest* request = [[[MyFormDataRequest alloc] initWithURL:[NSURL URLWithString:url]] autorelease];
	[request setPostValue:postId forKey:@"id"];
	if (info != nil) {
		if ([info valueForKey:@"password"] != nil) {
			[request setPostValue:[info valueForKey:@"password"] forKey:@"password"];
		}
		if ([info valueForKey:@"latitude"] != nil) {
			[request setPostValue:[info valueForKey:@"latitude"] forKey:@"latitude"];
		}
		if ([info valueForKey:@"longitude"] != nil) {
			[request setPostValue:[info valueForKey:@"longitude"] forKey:@"longitude"];
		}
		if ([info valueForKey:@"page"] != nil) {
			[request setPostValue:[info valueForKey:@"page"] forKey:@"page"];
		}
	}
	
	[request startSynchronous];
	
	NSError* error = [request error];
	if (!error) {
		NSString* responseString = [request responseString];
		return [responseString JSONValue];
	} else {
		return nil;
	}
}

+ (NSDictionary*) scorePost:(NSString*) postId withScore:(NSNumber*)score {	
	NSString* url = [NSString stringWithFormat:@"%@:%@/view/add_place_scoring", ServerURL, ServerPort];
	MyFormDataRequest* request = [[[MyFormDataRequest alloc] initWithURL:[NSURL URLWithString:url]] autorelease];
	[request setPostValue:postId forKey:@"place_id"];
	[request setPostValue:score forKey:@"value"];
	[request startSynchronous];
	
	NSError* error = [request error];
	if (!error) {
		NSString* responseString = [request responseString];
		return [responseString JSONValue];
	} else {
		return nil;
	}
}

+ (NSDictionary*) scoreComment:(NSString*) commentId withScore:(NSNumber*) score {
	NSString* url = [NSString stringWithFormat:@"%@:%@/view/add_comment_scoring", ServerURL, ServerPort];
	MyFormDataRequest* request = [[[MyFormDataRequest alloc] initWithURL:[NSURL URLWithString:url]] autorelease];
	[request setPostValue:commentId forKey:@"comment_id"];
	[request setPostValue:score forKey:@"value"];
	[request startSynchronous];
	
	NSError* error = [request error];
	if (!error) {
		NSString* responseString = [request responseString];
		return [responseString JSONValue];
	} else {
		return nil;
	}
}

+ (NSDictionary*) newPostWithName:(NSString*)placeName andDescription:(NSString*)description andCoordinates:(CLLocationCoordinate2D)coordinates {
	NSString* url = [NSString stringWithFormat:@"%@:%@/content/new_place", ServerURL, ServerPort];
	MyFormDataRequest* request = [[[MyFormDataRequest alloc] initWithURL:[NSURL URLWithString:url]] autorelease];
	[request setPostValue:placeName forKey:@"place_name"];
	[request setPostValue:[NSString stringWithFormat:@"%f", coordinates.latitude] forKey:@"latitude"];
	[request setPostValue:[NSString stringWithFormat:@"%f", coordinates.longitude] forKey:@"longitude"];	
	[request setPostValue:placeName forKey:@"comment_title"];
	[request setPostValue:description forKey:@"comment_content"];
	
	[request startSynchronous];
	
	NSError* error = [request error];
	if (!error) {
		NSString* responseString = [request responseString];
		return [responseString JSONValue];
	} else {
		return nil;
	}
}

+ (NSDictionary*) newCommentForPost:(NSString*)postId withCoordinates:(CLLocationCoordinate2D)coordinates andTitle:(NSString*)title 
					andDescription:(NSString*)description {
	NSString* url = [NSString stringWithFormat:@"%@:%@/content/new_comment", ServerURL, ServerPort];
	MyFormDataRequest* request = [[[MyFormDataRequest alloc] initWithURL:[NSURL URLWithString:url]] autorelease];
	[request setPostValue:postId forKey:@"place_id"];
	[request setPostValue:[NSString stringWithFormat:@"%f", coordinates.latitude] forKey:@"latitude"];
	[request setPostValue:[NSString stringWithFormat:@"%f", coordinates.longitude] forKey:@"longitude"];	
	[request setPostValue:title forKey:@"comment_title"];
	[request setPostValue:description forKey:@"comment_content"];
	[request startSynchronous];
	
	NSError* error = [request error];
	if (!error) {
		NSString* responseString = [request responseString];
		return [responseString JSONValue];
	} else {
		return nil;
	}
}

+ (NSDictionary*) addImage:(UIImage*)image toComment:(NSString*)commentId {
	NSString* url = [NSString stringWithFormat:@"%@:%@/content/upload_file", ServerURL, ServerPort];
	MyFormDataRequest* request = [[[MyFormDataRequest alloc] initWithURL:[NSURL URLWithString:url]] autorelease];
	[request setPostValue:commentId forKey:@"comment_id"];
	[request setPostValue:@"image" forKey:@"type"];
    
    UIImage* smallImage = [ImageUtils imageWithImage:image scaledToSize:CGSizeMake(640, 480)];
	NSData* imageData = UIImagePNGRepresentation(smallImage);
	[request setData:imageData forKey:@"file"];
	[request startSynchronous];
	
	NSError* error = [request error];
	if (!error) {
		NSString* responseString = [request responseString];
		return [responseString JSONValue];
	} else {
		return nil;
	}
}

+ (NSDictionary*) addVideo:(NSString*)video toComment:(NSString*)commentId {
	NSString* url = [NSString stringWithFormat:@"%@:%@/content/upload_file", ServerURL, ServerPort];
	MyFormDataRequest* request = [[[MyFormDataRequest alloc] initWithURL:[NSURL URLWithString:url]] autorelease];
	[request setPostValue:commentId forKey:@"comment_id"];
	[request setPostValue:@"youtube" forKey:@"type"];
    [request setPostValue:video forKey:@"file"];
	[request startSynchronous];
	
	NSError* error = [request error];
	if (!error) {
		NSString* responseString = [request responseString];
		return [responseString JSONValue];
	} else {
		return nil;
	}
}

+ (NSDictionary*) sendNotificationFor:(NSString*) postId withMessage:(NSString*) message andRecipients:(NSString*) recipients {
	NSString* url = [NSString stringWithFormat:@"%@:%@/notification/notify", ServerURL, ServerPort];
	MyFormDataRequest* request = [[[MyFormDataRequest alloc] initWithURL:[NSURL URLWithString:url]] autorelease];
	[request setPostValue:postId forKey:@"element_id"];
	[request setPostValue:message forKey:@"message"];
	[request setPostValue:recipients forKey:@"receivers"];
	[request startSynchronous];
	
	NSError* error = [request error];
	if (!error) {
		NSString* responseString = [request responseString];
		return [responseString JSONValue];
	} else {
		return nil;
	}
}

+ (NSDictionary*) deleteComment:(NSString*)commentId {
	NSString* url = [NSString stringWithFormat:@"%@:%@/content/remove_comment", ServerURL, ServerPort];
	MyFormDataRequest* request = [[[MyFormDataRequest alloc] initWithURL:[NSURL URLWithString:url]] autorelease];
	[request setPostValue:commentId forKey:@"comment_id"];
	[request startSynchronous];
	
	NSError* error = [request error];
	if (!error) {
		NSString* responseString = [request responseString];
		return [responseString JSONValue];
	} else {
		return nil;
	}
}

@end
