//
//  FirstViewController.m
//  hurrit
//
//  Created by Juanjo Molinero on 02/11/10.
//  Copyright 2010 BIDI. All rights reserved.
//

#import "MapView.h"
#import "LoginView.h"
#import "PostAnnotation.h"
#import "PostDetailView.h"
#import "SearchService.h"
#import "MyLocation.h"
#import "ImageUtils.h"
#import "HurritAppDelegate.h"

@implementation MapView

@synthesize mapView;
@synthesize locationManager;
@synthesize posts;
@synthesize loadingView;
@synthesize lblPager;
@synthesize sgmPager;
@synthesize totalPages;
@synthesize currentPage;
@synthesize annotations;
@synthesize initTimer;

#pragma mark View Load
- (void) viewDidLoad {
    [super viewDidLoad];
	
	[sgmPager addTarget:self action:@selector(pagerTapped:) forControlEvents:UIControlEventValueChanged];
	currentPage = 1;
	totalPages = 0;
	lblPager.text = @"";
	sgmPager.hidden = YES;
	annotations = [[NSMutableArray alloc] init];
	
	UIImageView* logo = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"bar_logo.png"]];
	[[self navigationItem] setTitleView:logo];
	
	mapView.delegate = self;
    self.loadingView = [LoadingView loadingViewInView:self.view];
    self.initTimer = [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(centerInUserPosition) userInfo:nil repeats:YES];
}

- (void) centerInUserPosition {
    MyLocation* myLocation = [MyLocation instance];
    if (myLocation.initialized) {
        mapView.showsUserLocation = TRUE;
		
		MKCoordinateRegion region;
		MKCoordinateSpan span;
		span.latitudeDelta = 0.01;
		span.longitudeDelta = 0.01;
		region.span = span;
		
		region.center = myLocation.currentLocation.coordinate;
		
		[mapView setRegion:region animated:TRUE];
		[mapView regionThatFits:region];
		
        [self.initTimer invalidate];
        
		[self.loadingView removeView];
    }
}

- (void) findPosts {
	//To calculate the search bounds...
	//First we need to calculate the corners of the map so we get the points
	CGPoint nePoint = CGPointMake(self.mapView.bounds.origin.x + mapView.bounds.size.width, mapView.bounds.origin.y);
	CGPoint swPoint = CGPointMake((self.mapView.bounds.origin.x), (mapView.bounds.origin.y + mapView.bounds.size.height));
	
	//Then transform those point into lat,lng values
	CLLocationCoordinate2D neCoord = [mapView convertPoint:nePoint toCoordinateFromView:mapView];
	CLLocationCoordinate2D swCoord = [mapView convertPoint:swPoint toCoordinateFromView:mapView];
	
	HurritAppDelegate* appDelegate = (HurritAppDelegate*) [[UIApplication sharedApplication] delegate];
	NSDictionary* results = nil;
	if ([appDelegate.currentCustomization isEqualToString:@""]) {
		results = [SearchService searchPostsNearLatitudeNE:[NSNumber numberWithDouble:neCoord.latitude] 
											andLongitudeNE:[NSNumber numberWithDouble:neCoord.longitude] 
											andLatitudeSW:[NSNumber numberWithDouble:swCoord.latitude]  
											andLongitudeSW:[NSNumber numberWithDouble:swCoord.longitude]
											withPageNumber:[NSNumber numberWithInt:currentPage]];
	} else {
		results = [SearchService searchProfile:appDelegate.currentCustomization 
								nearLatitudeNE:[NSNumber numberWithDouble:neCoord.latitude] 
								andLongitudeNE:[NSNumber numberWithDouble:neCoord.longitude] 
								andLatitudeSW:[NSNumber numberWithDouble:swCoord.latitude]
								andLongitudeSW:[NSNumber numberWithDouble:swCoord.longitude]
								withPageNumber:[NSNumber numberWithInt:currentPage]];
	}
	
	NSString* status = [results valueForKey:@"status"];
	if ([status isEqualToString:@"OK"]) {
		posts = [results valueForKey:@"results"];
		totalPages = [[results valueForKey:@"pages"] intValue];
		currentPage = [[results valueForKey:@"current_page"] intValue];
	} else {
		[self showError:[results valueForKey:@"message"]];
	}
}

- (MKAnnotationView*) mapView:(MKMapView *)myMapView viewForAnnotation:(id<MKAnnotation>) annotation {
    //static NSString *parkingAnnotationIdentifier=@"annotationIdentifier";
	if (annotation == myMapView.userLocation) {
		return nil;
	} else {
        //MKAnnotationView *annotationView=[mapView dequeueReusableAnnotationViewWithIdentifier:parkingAnnotationIdentifier];
        //If one isn't available, create a new one
        //if(!annotationView){
		MKPinAnnotationView* annView = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"currentloc"];
		annView.animatesDrop = NO;
		annView.rightCalloutAccessoryView = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
		[annView setEnabled:YES];
		[annView setCanShowCallout:YES];
        annView.image = [UIImage imageNamed:@"annotationIcon.png"];
        
		return annView;
	}
}

- (void) mapView:(MKMapView*)mapView annotationView:(MKAnnotationView*)view calloutAccessoryControlTapped:(UIControl*)control {
	PostDetailView* postView = [[PostDetailView alloc] initWithNibName:@"PostDetailView" bundle:[NSBundle mainBundle]];
	PostAnnotation* annotation = view.annotation;
	postView.postId = annotation.postId;
	postView.postType = @"post";

	UINavigationController* myNavigationController = [[UINavigationController alloc] initWithRootViewController:postView];
    myNavigationController.navigationBar.tintColor = [UIColor lightGrayColor];
	
	[self presentModalViewController:myNavigationController animated:YES];
}

- (void) showPostsInScreen {
	[mapView removeAnnotations:annotations];
	[annotations removeAllObjects];
	
	[self findPosts];
	for (NSDictionary* post in posts) {
		PostAnnotation* myAnnotation = [[PostAnnotation alloc] initWithTitle:[post valueForKey:@"place_name"] andSubtitle:[post valueForKey:@"last_updater_name"]];
		CLLocationCoordinate2D postLocation;
		NSString* latitude = [post valueForKey:@"latitude"];
		NSString* longitude = [post valueForKey:@"longitude"];
		postLocation.latitude = [latitude doubleValue];
		postLocation.longitude = [longitude doubleValue];
		[myAnnotation setCoordinate:postLocation];
		myAnnotation.postId = [post valueForKey:@"place_id"];
		[annotations addObject:myAnnotation];
	}
	
	[mapView addAnnotations:annotations];
	lblPager.text = [NSString stringWithFormat:NSLocalizedString(@"Pág. %d / %d", nil), currentPage, totalPages];

	if (totalPages == 0) {
		lblPager.text = @"";
		sgmPager.hidden = YES;
	} else if (totalPages > 1) {
		sgmPager.hidden = NO;
	}
}

- (void) mapView:(MKMapView*)mapView regionDidChangeAnimated:(BOOL)animated {
    [self showPostsInScreen];
}

#pragma mark Action Buttons
- (void) pagerTapped:(id)sender {
	if (sgmPager.selectedSegmentIndex == 0) { // Previous page
		if (currentPage > 1) {
			currentPage--;
			[self showPostsInScreen];
		}
	} else { // Next page
		if (currentPage < totalPages) {
			currentPage++;
			[self showPostsInScreen];
		}
	}
}

#pragma mark User Warning
- (void) showError:(NSString*)message {                  
	UIAlertView* alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Error", nil)
													message:message
													delegate:self 
													cancelButtonTitle:NSLocalizedString(@"Aceptar", nil)
													otherButtonTitles:nil];
	[alert show];
	[alert release];
}

#pragma mark Memory Management
- (void) dealloc {
	[mapView release];
	[locationManager release];
	[posts release];
	[lblPager release];
	[sgmPager release];
	
    [super dealloc];
}

@end
