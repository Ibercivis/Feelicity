//
//  CategoryService.m
//  hurrit
//
//  Created by Juanjo Molinero on 23/02/11.
//  Copyright 2011 BIFI. All rights reserved.
//

#import "CategoryService.h"
#import "JSON.h"
#import "MyFormDataRequest.h"

@implementation CategoryService

+ (NSDictionary*) all {
	NSString* url = [NSString stringWithFormat:@"%@:%@/category/all", ServerURL, ServerPort];
	MyFormDataRequest* request = [[[MyFormDataRequest alloc] initWithURL:[NSURL URLWithString:url]] autorelease];
	[request startSynchronous];
	
	NSError* error = [request error];
	if (!error) {
		return [[request responseString] JSONValue];
	} else {
		return nil;
	}
}


+ (NSDictionary*) my_categories {
	NSString* url = [NSString stringWithFormat:@"%@:%@/category/my_categories", ServerURL, ServerPort];
	MyFormDataRequest* request = [[[MyFormDataRequest alloc] initWithURL:[NSURL URLWithString:url]] autorelease];
	[request startSynchronous];
	
	NSError* error = [request error];
	if (!error) {
		return [[request responseString] JSONValue];
	} else {
		return nil;
	}
}

@end
