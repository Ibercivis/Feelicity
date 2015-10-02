//
//  YouTubeView.h
//  feelicity
//
//  Created by Juanjo Molinero on 06/07/11.
//  Copyright 2011 BIFI. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YouTubeView : UIView {
    
}

@property (nonatomic, retain) IBOutlet UITextField* txtURL;
@property (nonatomic, retain) IBOutlet UIButton* btnAccept;
@property (nonatomic, retain) IBOutlet UIButton* btnCancel;
@property (nonatomic, assign) id target;
@property (nonatomic) SEL action;

- (IBAction) btnAcceptTapped:(id)sender;
- (IBAction) btnCancelTapped:(id)sender;

- (void) viewDidLoad;

@end
