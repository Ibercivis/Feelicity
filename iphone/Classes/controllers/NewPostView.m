//
//  NewPostView.m
//  hurrit
//
//  Created by Juanjo Molinero on 03/11/10.
//  Copyright 2010 BIFI. All rights reserved.
//

#import "NewPostView.h"
#import "PostService.h"
#import "MyLocation.h"
#import "MapDetailView.h"
#import "MyLocation.h"
#import "QuartzCore/QuartzCore.h"
#import "ImageUtils.h"
#import "HurritAppDelegate.h"

@implementation NewPostView

@synthesize btnAddPhoto, btnYouTube, btnMap, btnUpload, selectedImage, selectedVideo;
@synthesize postTitle;
@synthesize postDescription;
@synthesize postId;
@synthesize commentsView;
@synthesize lblTitle;
@synthesize lblDescription;
@synthesize loadingView;
@synthesize youTubeView;
@synthesize annotation;

#pragma mark View Load
- (void) viewDidLoad {
    [super viewDidLoad];
	
	UIImageView* logo = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"bar_logo.png"]];
	[[self navigationItem] setTitleView:logo];
    
    self.youTubeView = [[[NSBundle mainBundle] loadNibNamed:@"YouTubeView" owner:self options:nil] objectAtIndex:0];
    CGRect frame = CGRectMake(5, 50, 308, 239);
    self.youTubeView.frame = frame;
    [self.youTubeView.layer setCornerRadius:10.0];
    [self.youTubeView.layer setMasksToBounds:YES];
    self.youTubeView.target = self;
    self.youTubeView.action = @selector(youTubeURLSelection:);
    [self.youTubeView viewDidLoad];
    [self.view addSubview:self.youTubeView];
    self.youTubeView.hidden = YES;
}

- (void) actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
	if (buttonIndex != 2) {
		UIImagePickerController* picker = [[UIImagePickerController alloc] init];
		picker.delegate = self;
		
		if (buttonIndex == 0) {
			picker.sourceType = UIImagePickerControllerSourceTypeCamera;
            picker.cameraCaptureMode = UIImagePickerControllerCameraCaptureModePhoto;
			//picker.mediaTypes = [UIImagePickerController availableMediaTypesForSourceType:UIImagePickerControllerSourceTypeCamera];
		} else if (buttonIndex == 1) {
			picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
			picker.mediaTypes = [UIImagePickerController availableMediaTypesForSourceType:UIImagePickerControllerSourceTypePhotoLibrary];
		}
		
		[self presentModalViewController:picker animated:YES];
	}
}

- (void) imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
	[picker dismissModalViewControllerAnimated:YES];
	
	NSString* mediaType = [info objectForKey:@"UIImagePickerControllerMediaType"];
	if ([mediaType isEqualToString:@"public.image"]) { // Photo
		selectedImage = [info objectForKey:@"UIImagePickerControllerOriginalImage"];
		[selectedImage retain];
		postMediaType = @"image";
	}
}

- (void) dismissAndReload {
    postTitle.text = @"";
    postDescription.text = @"";
    postMediaType = @"";
    
    HurritAppDelegate* appDelegate = (HurritAppDelegate*)[[UIApplication sharedApplication] delegate];
    appDelegate.tabBarController.selectedIndex = 1;
    
    [self showMessage:NSLocalizedString(@"Momento feliz creado correctamente", nil)];
}

- (BOOL) errorsInFields {
	NSMutableString* errorMessage = [[NSMutableString alloc] init];

	BOOL errors = FALSE;
	
	if ([postTitle.text isEqualToString:@""]) {
		errors = TRUE;
		[errorMessage appendString:NSLocalizedString(@"El campo título esta vacío.\n", nil)];
	}
	
	if ([postDescription.text isEqualToString:@""]) {
		errors = TRUE;
		[errorMessage appendString:NSLocalizedString(@"El campo descripción esta vacío.\n", nil)];
	}
	
	if (errors) {
		[self showError:errorMessage];
	}
	
	return errors;
}

- (BOOL) textFieldShouldReturn:(UITextField*) textField {
    [textField resignFirstResponder]; 
    return YES;
}

#pragma mark Button Actions
- (IBAction) btnMapOnClick:(id)sender {
	MapDetailView* mapView = [[MapDetailView alloc] init];
    mapView.target = self;
    mapView.action = @selector(coordinateSelected:);
	MyLocation* myLocation = [MyLocation instance];
	mapView.latitude = [NSNumber numberWithDouble:myLocation.currentLocation.coordinate.latitude];
	mapView.longitude = [NSNumber numberWithDouble:myLocation.currentLocation.coordinate.longitude];
	[self presentModalViewController:mapView animated:YES];
}

- (void) coordinateSelected:(PostAnnotation*)selectedAnnotation {
    self.annotation = selectedAnnotation;
}

- (IBAction) btnAddPhotoOnClick:(id)sender {
	UIActionSheet* popupQuery = [[UIActionSheet alloc]
								 initWithTitle:NSLocalizedString(@"Coger foto de:", nil)
								 delegate:self
								 cancelButtonTitle:NSLocalizedString(@"Cancelar", nil)
								 destructiveButtonTitle:nil
								 otherButtonTitles:NSLocalizedString(@"Camara", nil), NSLocalizedString(@"Biblioteca", nil), nil];
	
    popupQuery.actionSheetStyle = UIActionSheetStyleBlackOpaque;
    [popupQuery showInView:self.view];
    [popupQuery release];
}

- (IBAction) btnYouTubeTapped:(id)sender {
    self.youTubeView.hidden = NO;
}

- (void) youTubeURLSelection:(NSString*)url {
    postMediaType = @"youtube";
    self.selectedVideo = url;
}

- (IBAction) btnUploadOnClick:(id)sender {
    HurritAppDelegate* appDelegate = (HurritAppDelegate*)[[UIApplication sharedApplication] delegate];
	
	if (appDelegate.loggedIn) {
        self.loadingView = [LoadingView loadingViewInView:self.view];
        [NSTimer scheduledTimerWithTimeInterval: 0.5 target:self selector:@selector(doUpload) userInfo:nil repeats: NO];
	} else {
		[self showError:NSLocalizedString(@"No puedes crear un nuevo post sin hacer login previamente.", nil)];
	}
}

- (void) doUpload {
	if (![self errorsInFields]) {
		// Create post
		MyLocation* myLocation = [MyLocation instance];
        CLLocationCoordinate2D currentCoordinate = myLocation.currentLocation.coordinate;
        if (self.annotation != nil) {
            currentCoordinate = self.annotation.coordinate;
        }
        NSDictionary* response = [PostService newPostWithName:postTitle.text andDescription:postDescription.text 
									 andCoordinates:currentCoordinate];
		NSString* status = [response valueForKey:@"status"];
		
		// Upload file
		if ([status isEqualToString:@"OK"] && postMediaType != nil) {
			NSDictionary* fileUploadResponse;
			if ([postMediaType isEqualToString:@"image"]) {	
				fileUploadResponse = [PostService addImage:selectedImage toComment:[response valueForKey:@"comment_id"]];
			} else if ([postMediaType isEqualToString:@"youtube"]) {
                fileUploadResponse = [PostService addVideo:selectedVideo toComment:[response valueForKey:@"comment_id"]];
            }
            
			NSString* fileUploadStatus = [fileUploadResponse valueForKey:@"status"];
			if ([fileUploadStatus isEqualToString:@"OK"]) {
				[self dismissAndReload];
			} else {
				NSString* message = [response valueForKey:@"message"];
				[self showError:message];
			}
		} else if ([status isEqualToString:@"NOK"]) {
			NSString* message = [response valueForKey:@"message"];
			[self showError:message];
		} else {
            [self dismissAndReload];
        }
	}
	
	[loadingView removeFromSuperview];
}

- (void) touchesEnded:(NSSet*)touches withEvent:(UIEvent*)event {
	if ([postDescription isFirstResponder]) {		
		[postDescription resignFirstResponder];
	}
}

#pragma mark User Warning
- (void) showError:(NSString*) message {
	UIAlertView* alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Error", nil)
													message:message
												    delegate:self 
													cancelButtonTitle:NSLocalizedString(@"Aceptar", nil)
													otherButtonTitles:nil];
	[alert show];
	[alert release];
}

- (void) showMessage:(NSString*) message {
	UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@""
													message:message
                                                   delegate:self 
                                          cancelButtonTitle:NSLocalizedString(@"Aceptar", nil)
                                          otherButtonTitles:nil];
	[alert show];
	[alert release];
}

#pragma mark Memory Management
- (void) dealloc {
    [selectedImage release];
	[btnAddPhoto release];
	[btnMap release];
	[btnUpload release];
    [super dealloc];
}

@end
