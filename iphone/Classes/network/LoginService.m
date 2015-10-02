//
//  LoginService.m
//  hurrit
//
//  Created by Juanjo Molinero on 15/11/10.
//  Copyright 2010 BIFI. All rights reserved.
//

#import "LoginService.h"
#import "JSON.h"
#import "MyFormDataRequest.h"

@implementation LoginService

+ (NSDictionary*) registerWithEmail:(NSString*) email nickname:(NSString*)nickname andPassword:(NSString*) password {	
	NSString* url = [NSString stringWithFormat:@"%@:%@/register/save", ServerURL, ServerPort];
	MyFormDataRequest* request = [[[MyFormDataRequest alloc] initWithURL:[NSURL URLWithString:url]] autorelease];
	[request setPostValue:email forKey:@"email"];
	[request setPostValue:password forKey:@"password"];
	[request setPostValue:nickname forKey:@"nickname"];
	[request startSynchronous];
	
	NSError* error = [request error];
	if (!error) {
		return [[request responseString] JSONValue];
	} else {
		return nil;
	}
}

+ (NSDictionary*) loginWithEmail:(NSString*) email andPassword:(NSString*) password {
	NSString* url = [NSString stringWithFormat:@"%@:%@/common/login", ServerURL, ServerPort];
	MyFormDataRequest* request = [[[MyFormDataRequest alloc] initWithURL:[NSURL URLWithString:url]] autorelease];
	[request setPostValue:email forKey:@"login_email"];
	[request setPostValue:password forKey:@"login_password"];
	[request startSynchronous];
	
	NSError* error = [request error];
	if (!error) {
		[[NSHTTPCookieStorage sharedHTTPCookieStorage] setCookies:[request responseCookies]
														    forURL:[NSURL URLWithString:ServerURL]
															mainDocumentURL:nil];
		NSString* responseString = [request responseString];
		return [responseString JSONValue];
	} else {
		return nil;
	}
}

+ (NSDictionary*) logout {
	NSString* url = [NSString stringWithFormat:@"%@:%@/common/logout", ServerURL, ServerPort];
	MyFormDataRequest* request = [[[MyFormDataRequest alloc] initWithURL:[NSURL URLWithString:url]] autorelease];
	[request startSynchronous];
	[request responseCookies];
	
	NSError* error = [request error];
	if (!error) {
		NSString* responseString = [request responseString];
		return [responseString JSONValue];
	} else {
		return nil;
	}
}

@end
