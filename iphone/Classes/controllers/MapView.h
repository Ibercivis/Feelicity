//
//  FirstViewController.h
//  hurrit
//
//  Created by Juanjo Molinero on 02/11/10.
//  Copyright 2010 BIDI. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>
#import "LoadingView.h"

@interface MapView : UIViewController <MKMapViewDelegate> {
	MKMapView* mapView;
	CLLocationManager* locationManager;
	NSArray* posts;
	LoadingView* loadingView;
	
	UILabel* lblPager;
	UISegmentedControl* sgmPager;
	NSInteger totalPages;
	NSInteger currentPage;
	
	NSMutableArray* annotations;
}

@property (nonatomic, retain) IBOutlet MKMapView* mapView;
@property (nonatomic, retain) CLLocationManager* locationManager;
@property (nonatomic, retain) NSArray* posts;
@property (nonatomic, retain) LoadingView* loadingView;
@property (nonatomic, retain) NSTimer* initTimer;

@property (nonatomic, retain) IBOutlet UILabel* lblPager;
@property (nonatomic, retain) IBOutlet UISegmentedControl* sgmPager;
@property (nonatomic) NSInteger totalPages;
@property (nonatomic) NSInteger currentPage;

@property (nonatomic, retain) NSMutableArray* annotations;

- (void) findPosts;
- (void) showError:(NSString*) message;
- (void) showPostsInScreen;
- (void) centerInUserPosition;

@end
