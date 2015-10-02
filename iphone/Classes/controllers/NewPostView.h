//
//  NewPostView.h
//  hurrit
//
//  Created by Juanjo Molinero on 03/11/10.
//  Copyright 2010 BIFI. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CommentsView.h"
#import "LoadingView.h"
#import "YouTubeView.h"
#import "PostAnnotation.h"

@interface NewPostView : UIViewController <UITextFieldDelegate, UIActionSheetDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate> {
	UIButton* btnMap;
	UIButton* btnAddPhoto;
    UIButton* btnYouTube;
	UIButton* btnUpload;
	UIImage* selectedImage;
	NSString* selectedVideo;
	NSString* postMediaType;
	NSString* postId;
	
	UITextField* postTitle;
	UITextView* postDescription;
	CommentsView* commentsView;
	
	UILabel* lblTitle;
	UILabel* lblDescription;
		
	LoadingView* loadingView;
    
    PostAnnotation* annotation;
}

@property (nonatomic, retain) IBOutlet UIButton* btnMap;
@property (nonatomic, retain) IBOutlet UIButton* btnAddPhoto;
@property (nonatomic, retain) IBOutlet UIButton* btnYouTube;
@property (nonatomic, retain) IBOutlet UIButton* btnUpload;
@property (nonatomic, retain) UIImage* selectedImage;
@property (nonatomic, retain) NSString* selectedVideo;
@property (nonatomic, retain) IBOutlet UITextField* postTitle;
@property (nonatomic, retain) IBOutlet UITextView* postDescription;
@property (nonatomic, retain) NSString* postId;
@property (nonatomic, retain) CommentsView* commentsView;
@property (nonatomic, retain) IBOutlet UILabel* lblTitle;
@property (nonatomic, retain) IBOutlet UILabel* lblDescription;

@property (nonatomic, retain) LoadingView* loadingView;
@property (nonatomic, retain) YouTubeView* youTubeView;

@property (nonatomic, retain) PostAnnotation* annotation;

- (IBAction) btnMapOnClick:(id)sender;
- (IBAction) btnAddPhotoOnClick:(id)sender;
- (IBAction) btnYouTubeTapped:(id)sender;
- (IBAction) btnUploadOnClick:(id)sender;

- (void) showError:(NSString*) message;
- (void) showMessage:(NSString*) message;
- (BOOL) errorsInFields;
- (void) dismissAndReload;
- (void) youTubeURLSelection:(NSString*)url;
- (void) coordinateSelected:(PostAnnotation*)annotation;

@end
