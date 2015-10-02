//
//  SearchService.m
//  bidi
//
//  Created by Juanjo Molinero on 04/11/10.
//  Copyright 2010 BIFI. All rights reserved.
//

#import "SearchService.h"
#import "JSON.h"
#import "MyFormDataRequest.h"


@implementation SearchService

+ (NSDictionary*) searchPostsWithString:(NSString*)theSearchString andPageNumber:(NSNumber*)pageNumber {
	NSString* url = [NSString stringWithFormat:@"%@:%@/home/search", ServerURL, ServerPort];
	MyFormDataRequest* request = [[[MyFormDataRequest alloc] initWithURL:[NSURL URLWithString:url]] autorelease];
	[request setPostValue:@"search" forKey:@"mode"];
	[request setPostValue:@"places" forKey:@"search_type"];
	[request setPostValue:theSearchString forKey:@"search_string"];
	[request setPostValue:pageNumber forKey:@"page"];
	[request startSynchronous];
	
	NSError* error = [request error];
	if (!error) {
		NSString* responseString = [request responseString];
		return [responseString JSONValue];
	} else {
		return nil;
	}
}

+ (NSDictionary*) searchPostsNearLatitudeNE:(NSNumber*) latitudeNE andLongitudeNE:(NSNumber*) longitudeNE andLatitudeSW:(NSNumber*) latitudeSW 
							 andLongitudeSW:(NSNumber*) longitudeSW withPageNumber:(NSNumber*)pageNumber {
	NSString* url = [NSString stringWithFormat:@"%@:%@/home/search", ServerURL, ServerPort];
	MyFormDataRequest* request = [[[MyFormDataRequest alloc] initWithURL:[NSURL URLWithString:url]] autorelease];
	[request setPostValue:@"map" forKey:@"mode"];
	[request setPostValue:@"places" forKey:@"search_type"];
	[request setPostValue:latitudeNE forKey:@"max_latitude"];
	[request setPostValue:longitudeNE forKey:@"max_longitude"];
	[request setPostValue:latitudeSW forKey:@"min_latitude"];
	[request setPostValue:longitudeSW forKey:@"min_longitude"];
	[request setPostValue:pageNumber forKey:@"page"];
	
	[request startSynchronous];
	
	NSError* error = [request error];
	if (!error) {
		NSString* responseString = [request responseString];
		return [responseString JSONValue];
	} else {
		return nil;
	}
}

+ (NSDictionary*) searchProfile:(NSString*)userId withString:(NSString*)query andPageNumber:(NSNumber*)pageNumber {
	NSString* url = [NSString stringWithFormat:@"%@:%@/home/search", ServerURL, ServerPort];
	MyFormDataRequest* request = [[[MyFormDataRequest alloc] initWithURL:[NSURL URLWithString:url]] autorelease];
	[request setPostValue:@"profile" forKey:@"mode"];
	[request setPostValue:userId forKey:@"user_id"];
	[request setPostValue:@"places" forKey:@"search_type"];
	[request setPostValue:query forKey:@"search_string"];
	[request setPostValue:pageNumber forKey:@"page"];
	[request startSynchronous];
	
	NSError* error = [request error];
	if (!error) {
		NSString* responseString = [request responseString];
		return [responseString JSONValue];
	} else {
		return nil;
	}
}

+ (NSDictionary*) searchProfile:(NSString*)userId nearLatitudeNE:(NSNumber*) latitudeNE andLongitudeNE:(NSNumber*) longitudeNE andLatitudeSW:(NSNumber*) latitudeSW 
							 andLongitudeSW:(NSNumber*) longitudeSW withPageNumber:(NSNumber*)pageNumber {
	NSString* url = [NSString stringWithFormat:@"%@:%@/home/search", ServerURL, ServerPort];
	MyFormDataRequest* request = [[[MyFormDataRequest alloc] initWithURL:[NSURL URLWithString:url]] autorelease];
	[request setPostValue:@"profile" forKey:@"mode"];
	[request setPostValue:userId forKey:@"user_id"];
	[request setPostValue:@"places" forKey:@"search_type"];
	// FIXME: [JUANJO] Hay que cambiar el controlador para que esto funcione
	//[request setPostValue:latitudeNE forKey:@"max_latitude"];
	//[request setPostValue:longitudeNE forKey:@"max_longitude"];
	//[request setPostValue:latitudeSW forKey:@"min_latitude"];
	//[request setPostValue:longitudeSW forKey:@"min_longitude"];
	[request setPostValue:pageNumber forKey:@"page"];
	
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
