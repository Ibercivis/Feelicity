//
//  MapDetailView.m
//  hurrit
//
//  Created by Juanjo Molinero on 01/12/10.
//  Copyright 2010 BIFI. All rights reserved.
//

#import "MapDetailView.h"
#import "PostAnnotation.h"


@implementation MapDetailView

@synthesize mapView;
@synthesize btnCancel;
@synthesize latitude;
@synthesize longitude;
@synthesize navigationItem;
@synthesize target;
@synthesize action;

- (void)viewDidLoad {
    [super viewDidLoad];
	
	[btnCancel setTarget:self];
	[btnCancel setAction:@selector(btnCancelOnClick)];
	
	MKCoordinateRegion region;
	MKCoordinateSpan span;
	span.latitudeDelta = 0.01;
	span.longitudeDelta = 0.01;
	region.span = span;
	CLLocationCoordinate2D center;
	center.longitude = [longitude doubleValue];
	center.latitude = [latitude doubleValue];
	region.center = center;
	
	PostAnnotation* myAnnotation = [[PostAnnotation alloc] initWithTitle:NSLocalizedString(@"Situación actual", nil) andSubtitle:@""];
	CLLocationCoordinate2D postLocation;
	postLocation.latitude = [latitude doubleValue];
	postLocation.longitude = [longitude doubleValue];
	[myAnnotation setCoordinate:postLocation];
	[mapView addAnnotation:myAnnotation];
	
	[mapView setRegion:region animated:TRUE];
	[mapView regionThatFits:region];
    mapView.delegate = self;
	
	UIImageView* logo = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"bar_logo.png"]];
	[[self navigationItem] setTitleView:logo];
}

- (MKAnnotationView*) mapView:(MKMapView *)myMapView viewForAnnotation:(id<MKAnnotation>) annotation {
	MKPinAnnotationView* annView = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"currentloc"];
	annView.animatesDrop = TRUE;
	[annView setEnabled:YES];
    annView.draggable = YES;

	return annView;
}

- (void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)annotationView didChangeDragState:(MKAnnotationViewDragState)newState fromOldState:(MKAnnotationViewDragState)oldState {
    if (newState == MKAnnotationViewDragStateEnding) {
        [self.target performSelector:self.action withObject:annotationView.annotation];
    }
}

- (void) btnCancelOnClick {
	[self dismissModalViewControllerAnimated:YES];
}

- (void) dealloc {
    [super dealloc];
}


@end
