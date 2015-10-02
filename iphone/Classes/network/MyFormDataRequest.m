//
//  MyFormDataRequest.m
//  hurrit
//
//  Created by Juanjo Molinero on 01/02/11.
//  Copyright 2011 BIFI. All rights reserved.
//

#import "MyFormDataRequest.h"
#import "HurritAppDelegate.h"
#import "JSON.h"

@implementation MyFormDataRequest

- (void) startSynchronous {
	HurritAppDelegate* appDelegate = (HurritAppDelegate*)[[UIApplication sharedApplication] delegate];
	if (appDelegate.internetActive) {
		NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
		NSArray *languages = [defaults objectForKey:@"AppleLanguages"];
		NSString *currentLanguage = [languages objectAtIndex:0];
		[super addRequestHeader:@"Accept-Language" value:currentLanguage];
		[super startSynchronous];
	}
}

- (NSString*) responseString {
	NSString* oldResponse = [super responseString];
	if (oldResponse == nil || [oldResponse isEqualToString:@""]) {
		NSMutableString* returnMessage = [[NSMutableString alloc] init];
		[returnMessage appendFormat:@"{\"status\": \"NOK\", \"message\": \"%@\"}", NSLocalizedString(@"No se puede realizar la acción seleccionada debido a la falta de conexión a Internet.", nil)];
		
		return returnMessage;
	} else {
		NSDictionary* parsedResponse = [oldResponse JSONValue];
		NSString* status = [parsedResponse valueForKey:@"status"];
		if ([status isEqualToString:@"NOK"]) {
			NSNumber* errorCode = [parsedResponse valueForKey:@"error_code"];
			if ([errorCode intValue] == 1) {
				HurritAppDelegate* appDelegate = (HurritAppDelegate*)[[UIApplication sharedApplication] delegate];
				appDelegate.loggedIn = NO;
				appDelegate.btnSalirMapa.title = NSLocalizedString(@"Entrar", nil);
				appDelegate.btnSalirBuscar.title = NSLocalizedString(@"Entrar", nil);
			}
		}
		
		return oldResponse;
	}
}

@end
