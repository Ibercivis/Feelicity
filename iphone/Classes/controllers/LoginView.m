//
//  LoginView.m
//  hurrit
//
//  Created by Juanjo Molinero on 03/11/10.
//  Copyright 2010 BIFI. All rights reserved.
//

#import "LoginView.h"
#import "LoginService.h"
#import "RegisterView.h"
#import "UIView+FindAndResignFirstResponder.h"
#import "HurritAppDelegate.h"


@implementation LoginView

@synthesize btnSignIn, btnSignUp, btnCancel;
@synthesize txtUser;
@synthesize txtPassword;
@synthesize loadingView;
@synthesize lblEmail;
@synthesize lblPassword;

static const CGFloat KEYBOARD_ANIMATION_DURATION = 0.3;
static const CGFloat MINIMUM_SCROLL_FRACTION = 0.2;
static const CGFloat MAXIMUM_SCROLL_FRACTION = 0.8;
static const CGFloat PORTRAIT_KEYBOARD_HEIGHT = 216;
static const CGFloat LANDSCAPE_KEYBOARD_HEIGHT = 162;

- (void) viewDidLoad {
	[super viewDidLoad];
}

- (IBAction) btnSignInOnClick:(id)sender {
	[self.view findAndResignFirstResponder];
	self.loadingView = [LoadingView loadingViewInView:self.view];
	[NSTimer scheduledTimerWithTimeInterval: 1.0 target:self selector:@selector(checkLogin) userInfo:nil repeats: NO];
}

- (void) checkLogin {
	NSDictionary* responseData = [LoginService loginWithEmail:txtUser.text andPassword:txtPassword.text];
	NSString* responseStatus = [responseData valueForKey:@"status"];
	
	if ([responseStatus isEqualToString:@"OK"]) {
		HurritAppDelegate* appDelegate = (HurritAppDelegate*) [[UIApplication sharedApplication] delegate];
		appDelegate.loggedIn = YES;
		appDelegate.btnSalirMapa.title = NSLocalizedString(@"Salir", nil);
		appDelegate.btnSalirBuscar.title = NSLocalizedString(@"Salir", nil);
        [self saveLoginCredentials];
		[self dismissModalViewControllerAnimated:YES];
	} else {
		NSString* responseMessage = [responseData valueForKey:@"message"];
		UIAlertView* alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Error", nil)
														message:responseMessage
													    delegate:self 
														cancelButtonTitle:NSLocalizedString(@"Aceptar", nil)
														otherButtonTitles:nil];
		[alert show];
		[alert release];
	}
	
	[self.loadingView removeView];
}

- (void) saveLoginCredentials {
    [[NSUserDefaults standardUserDefaults] setValue:self.txtUser.text forKey:@"savedUser"];
    [[NSUserDefaults standardUserDefaults] setValue:self.txtPassword.text forKey:@"savedPassword"];
}

- (IBAction) btnSignUpOnClick:(id)sender {
	RegisterView* registerView = [[RegisterView alloc] init];
	[self presentModalViewController:registerView animated:YES];
}

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    CGRect textFieldRect = [self.view.window convertRect:textField.bounds fromView:textField];
    CGRect viewRect = [self.view.window convertRect:self.view.bounds fromView:self.view];
	
	CGFloat midline = textFieldRect.origin.y + 0.5 * textFieldRect.size.height;
    CGFloat numerator =	midline - viewRect.origin.y	- MINIMUM_SCROLL_FRACTION * viewRect.size.height;
    CGFloat denominator = (MAXIMUM_SCROLL_FRACTION - MINIMUM_SCROLL_FRACTION) * viewRect.size.height;
    CGFloat heightFraction = numerator / denominator;
	
	if (heightFraction < 0.0) {
        heightFraction = 0.0;
    } else if (heightFraction > 1.0) {
        heightFraction = 1.0;
    }
	
	UIInterfaceOrientation orientation = [[UIApplication sharedApplication] statusBarOrientation];
    if (orientation == UIInterfaceOrientationPortrait || orientation == UIInterfaceOrientationPortraitUpsideDown) {
        animatedDistance = floor(PORTRAIT_KEYBOARD_HEIGHT * heightFraction);
    } else {
        animatedDistance = floor(LANDSCAPE_KEYBOARD_HEIGHT * heightFraction);
    }
	
	CGRect viewFrame = self.view.frame;
    viewFrame.origin.y -= animatedDistance;
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationBeginsFromCurrentState:YES];
    [UIView setAnimationDuration:KEYBOARD_ANIMATION_DURATION];
    
    [self.view setFrame:viewFrame];
    
    [UIView commitAnimations];
}

- (void) textFieldDidEndEditing:(UITextView*)textView {
    [self returnEverythingToPlace];
}

- (void) returnEverythingToPlace {
	CGRect viewFrame = self.view.frame;
    viewFrame.origin.y += animatedDistance;
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationBeginsFromCurrentState:YES];
    [UIView setAnimationDuration:KEYBOARD_ANIMATION_DURATION];
    
    [self.view setFrame:viewFrame];
    
    [UIView commitAnimations];
}
	
- (BOOL) textFieldShouldReturn:(UITextField *)textField {
	[textField resignFirstResponder];
	return NO;
}

- (IBAction) btnCancelTapped:(id)sender {
	[self dismissModalViewControllerAnimated:YES];
}

- (void) dealloc {
    [super dealloc];
}


@end
