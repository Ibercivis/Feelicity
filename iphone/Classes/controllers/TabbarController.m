//
//  TabbarController.m
//  hurrit
//
//  Created by Juanjo Molinero on 04/11/10.
//  Copyright 2010 BIFI. All rights reserved.
//

#import "TabbarController.h"
#import "LoginView.h"
#import "LoginService.h"
#import "HurritAppDelegate.h"
#import "SearchView.h"

@implementation TabbarController

- (void) btnSalirOnClick {
	HurritAppDelegate* appDelegate = (HurritAppDelegate*)[[UIApplication sharedApplication] delegate];
	
	if (appDelegate.loggedIn) {
		NSDictionary* responseData = [LoginService logout];
		NSString* responseStatus = [responseData valueForKey:@"status"];
	
		if ([responseStatus isEqualToString:@"OK"]) {
			appDelegate.loggedIn = NO;
			appDelegate.btnSalirMapa.title = NSLocalizedString(@"Entrar", nil);
			appDelegate.btnSalirBuscar.title = NSLocalizedString(@"Entrar", nil);
            [[NSUserDefaults standardUserDefaults] setValue:nil forKey:@"savedUser"];
            [[NSUserDefaults standardUserDefaults] setValue:nil forKey:@"savedPassword"];
		} else {
			NSString* responseMessage = [responseData valueForKey:@"message"];
			[self showError:responseMessage];
		}
	} else {
		LoginView* loginView = [[LoginView alloc] init];
		[self presentModalViewController:loginView animated:YES];
	}
}

- (void) btnNewOnClick {
	//HurritAppDelegate* appDelegate = (HurritAppDelegate*)[[UIApplication sharedApplication] delegate];
    
    SearchView* searchView = [[SearchView alloc] init];
    [self presentModalViewController:searchView animated:YES];
	
	//if (appDelegate.loggedIn) {
	//	NewPostView* newPostView = [[NewPostView alloc] init];
	//	newPostView.postType = @"post";
	//	[self presentModalViewController:newPostView animated:YES];
	//} else {
	//	[self showError:NSLocalizedString(@"No puedes crear un nuevo post sin hacer login previamente.", nil)];
	//}
}

- (void) showError:(NSString*)message {
	UIAlertView* alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Error", nil)
													message:message
													delegate:self 
													cancelButtonTitle:NSLocalizedString(@"Aceptar", nil)
													otherButtonTitles:nil];
	[alert show];
	[alert release];
}

- (void)dealloc {
    [super dealloc];
}


@end
