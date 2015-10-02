//
//  LoginView.h
//  hurrit
//
//  Created by Juanjo Molinero on 03/11/10.
//  Copyright 2010 BIFI. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LoadingView.h"


@interface LoginView : UIViewController {
	UIButton* btnSignIn;
	UIButton* btnSignUp;
	UIButton* btnCancel;
	UITextField* txtUser;
	UITextField* txtPassword;
	CGFloat animatedDistance;
	LoadingView* loadingView;
	
	UILabel* lblEmail;
	UILabel* lblPassword;
}

@property (nonatomic, retain) IBOutlet UIButton* btnSignIn;
@property (nonatomic, retain) IBOutlet UIButton* btnSignUp;
@property (nonatomic, retain) IBOutlet UIButton* btnCancel;
@property (nonatomic, retain) IBOutlet UITextField* txtUser;
@property (nonatomic, retain) IBOutlet UITextField* txtPassword;
@property (nonatomic, retain) LoadingView* loadingView;
@property (nonatomic, retain) IBOutlet UILabel* lblEmail;
@property (nonatomic, retain) IBOutlet UILabel* lblPassword;

- (IBAction) btnSignInOnClick:(id)sender;
- (IBAction) btnSignUpOnClick:(id)sender;
- (IBAction) btnCancelTapped:(id)sender;

- (void) checkLogin;
- (void) returnEverythingToPlace;
- (void) saveLoginCredentials;

@end
