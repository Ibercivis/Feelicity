//
//  RegisterView.h
//  hurrit
//
//  Created by Juanjo Molinero on 17/11/10.
//  Copyright 2010 BIFI. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LoadingView.h"

@interface RegisterView : UIViewController {
	UITextField* txtEmail;
	UITextField* txtNickname;
	UITextField* txtPassword;
	UITextField* txtPasswordConfirmation;
	UIButton* btnSend;
	UIButton* btnCancel;
	CGFloat animatedDistance;
	LoadingView* loadingView;
	
	UILabel* lblEmail;
	UILabel* lblNickname;
	UILabel* lblPassword;
	UILabel* lblPasswordConfirmation;
}

@property (nonatomic, retain) IBOutlet UITextField* txtEmail;
@property (nonatomic, retain) IBOutlet UITextField* txtNickname;
@property (nonatomic, retain) IBOutlet UITextField* txtPassword;
@property (nonatomic, retain) IBOutlet UITextField* txtPasswordConfirmation;
@property (nonatomic, retain) IBOutlet UIButton* btnSend;
@property (nonatomic, retain) IBOutlet UIButton* btnCancel;
@property (nonatomic, retain) LoadingView* loadingView;

@property (nonatomic, retain) IBOutlet UILabel* lblEmail;
@property (nonatomic, retain) IBOutlet UILabel* lblNickname;
@property (nonatomic, retain) IBOutlet UILabel* lblPassword;
@property (nonatomic, retain) IBOutlet UILabel* lblPasswordConfirmation;

- (IBAction) btnSendOnClick:(id)sender;
- (IBAction) btnCancelOnClick:(id)sender;

- (void) showError:(NSString*)message;
- (void) checkSignUp;

@end
