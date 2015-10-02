//
//  MapDetailView.h
//  hurrit
//
//  Created by Juanjo Molinero on 01/12/10.
//  Copyright 2010 BIFI. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>


@interface MapDetailView : UIViewController <MKMapViewDelegate> {
	MKMapView* mapView;
	UIBarButtonItem* btnCancel;
	NSNumber* latitude;
	NSNumber* longitude;
	UINavigationItem* navigationItem;
}

@property (nonatomic, retain) IBOutlet MKMapView* mapView;
@property (nonatomic, retain) IBOutlet UIBarButtonItem* btnCancel;
@property (nonatomic, retain) NSNumber* latitude;
@property (nonatomic, retain) NSNumber* longitude;
@property (nonatomic, retain) IBOutlet UINavigationItem* navigationItem;
@property(nonatomic, assign) id target;
@property(nonatomic) SEL action;

- (void) btnCancelOnClick;

@end
