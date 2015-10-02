//
//  RegisterView.m
//  hurrit
//
//  Created by Juanjo Molinero on 17/11/10.
//  Copyright 2010 BIFI. All rights reserved.
//

#import "RegisterView.h"
#import "LoginService.h"
#import "UIView+FindAndResignFirstResponder.h"


@implementation RegisterView

@synthesize txtEmail;
@synthesize txtNickname;
@synthesize txtPassword;
@synthesize txtPasswordConfirmation;
@synthesize btnSend;
@synthesize btnCancel;
@synthesize loadingView;
@synthesize lblEmail;
@synthesize lblNickname;
@synthesize lblPassword;
@synthesize lblPasswordConfirmation;

static const CGFloat KEYBOARD_ANIMATION_DURATION = 0.3;
static const CGFloat MINIMUM_SCROLL_FRACTION = 0.2;
static const CGFloat MAXIMUM_SCROLL_FRACTION = 0.8;
static const CGFloat PORTRAIT_KEYBOARD_HEIGHT = 216;
static const CGFloat LANDSCAPE_KEYBOARD_HEIGHT = 162;

-(void) viewDidLoad {
	[super viewDidLoad];
}


- (IBAction) btnSendOnClick:(id)sender {
	[self.view findAndResignFirstResponder];
	
	if ([txtEmail.text isEqualToString:@""]) {
		[self showError:NSLocalizedString(@"El campo email esta vacío.", nil)];
	} else if ([txtPassword.text isEqualToString:@""]) {
		[self showError:NSLocalizedString(@"El campo password esta vacío.", nil)];
	} else if ([txtPasswordConfirmation.text isEqualToString:@""]) {
		[self showError:NSLocalizedString(@"El campo de confirmación del password esta vacío.", nil)];
	} else if (![txtPassword.text isEqualToString:txtPasswordConfirmation.text]) {
		[self showError:NSLocalizedString(@"El campo password y el de confirmación del password no coinciden.", nil)];
	} else {
		self.loadingView = [LoadingView loadingViewInView:self.view];
		[NSTimer scheduledTimerWithTimeInterval: 1.0 target:self selector:@selector(checkSignUp) userInfo:nil repeats: NO];		
	}	
}

- (void) checkSignUp {
	NSDictionary* responseData = [LoginService registerWithEmail:txtEmail.text nickname:txtNickname.text andPassword:txtPassword.text];
	NSString* responseStatus = [responseData valueForKey:@"status"];
	
	if ([responseStatus isEqualToString:@"OK"]) {
		[self dismissModalViewControllerAnimated:YES];
	} else {
		NSString* responseMessage = [responseData valueForKey:@"message"];
		[self showError:responseMessage];
	}		
	
	[self.loadingView removeView];
}

- (IBAction) btnCancelOnClick:(id)sender {
	[self dismissModalViewControllerAnimated:YES];
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

- (void)textFieldDidEndEditing:(UITextField *)textField {
    CGRect viewFrame = self.view.frame;
    viewFrame.origin.y += animatedDistance;
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationBeginsFromCurrentState:YES];
    [UIView setAnimationDuration:KEYBOARD_ANIMATION_DURATION];
    
    [self.view setFrame:viewFrame];
    
    [UIView commitAnimations];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
	[textField resignFirstResponder];
	return NO;
}

- (void)dealloc {
	[txtEmail release];
	[txtNickname release];
	[txtPassword release];
	[txtPasswordConfirmation release];
	[btnSend release];
	[btnCancel release];
	
    [super dealloc];
}

@end
