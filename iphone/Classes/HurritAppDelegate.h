//
//  bidiAppDelegate.h
//  bidi
//
//  Created by Juanjo Molinero on 02/11/10.
//  Copyright 2010 BIFI. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "controllers/TabbarController.h"
#import <CoreLocation/CoreLocation.h>

@class Reachability;

@interface HurritAppDelegate : NSObject <UIApplicationDelegate, UITabBarControllerDelegate, CLLocationManagerDelegate> {
    UIWindow* window;
    TabbarController* tabBarController;
	UIBarButtonItem* btnSalirBuscar;
	UIBarButtonItem* btnSalirMapa;
	UIBarButtonItem* btnNewSearch;
	UIBarButtonItem* btnNewMap;
	
	Reachability* internetReachable;
	BOOL internetActive;
	BOOL loggedIn;
	
	NSString* currentCustomization;
	NSDictionary* currentCustomizationData;
	
	UITabBarItem* tabMap;
	UITabBarItem* tabSearch;
	
	CLLocationManager* locationManager;
}

@property (nonatomic, retain) IBOutlet UIWindow* window;
@property (nonatomic, retain) IBOutlet TabbarController* tabBarController;
@property (nonatomic, retain) IBOutlet UIBarButtonItem* btnSalirBuscar;
@property (nonatomic, retain) IBOutlet UIBarButtonItem* btnSalirMapa;
@property (nonatomic, retain) IBOutlet UIBarButtonItem* btnNewMap;
@property (nonatomic, retain) IBOutlet UIBarButtonItem* btnNewSearch;
@property (nonatomic) BOOL internetActive;
@property (nonatomic) BOOL loggedIn;
@property (nonatomic, retain) NSString* currentCustomization;
@property (nonatomic, retain) NSDictionary* currentCustomizationData;
@property (nonatomic, retain) IBOutlet UITabBarItem* tabMap;
@property (nonatomic, retain) IBOutlet UITabBarItem* tabSearch;
@property (nonatomic, retain) IBOutlet CLLocationManager* locationManager;

- (void) checkNetworkStatus:(NSNotification*)notice;
- (void) translate;
- (void) showError:(NSString*)message;
- (void) initLocationManager;

@end
