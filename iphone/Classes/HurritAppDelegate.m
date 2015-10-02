//
//  HurritAppDelegate.m
//  hurrit
//
//  Created by Juanjo Molinero on 02/11/10.
//  Copyright 2010 BIFI. All rights reserved.
//

#import "HurritAppDelegate.h"
#import "Reachability.h"
#import "MyLocation.h"
#import "LoginService.h"

@implementation HurritAppDelegate

@synthesize window;
@synthesize tabBarController;
@synthesize btnSalirBuscar;
@synthesize btnSalirMapa;
@synthesize btnNewMap;
@synthesize btnNewSearch;
@synthesize internetActive;
@synthesize loggedIn;
@synthesize tabMap;
@synthesize tabSearch;
@synthesize currentCustomization;
@synthesize currentCustomizationData;
@synthesize locationManager;

#pragma mark -
#pragma mark Application lifecycle

- (BOOL)application:(UIApplication*)application didFinishLaunchingWithOptions:(NSDictionary*)launchOptions {    
	[btnSalirBuscar setTarget:tabBarController];
	[btnSalirBuscar setAction:@selector(btnSalirOnClick)];
	
	[btnSalirMapa setTarget:tabBarController];
	[btnSalirMapa setAction:@selector(btnSalirOnClick)];
	

	[btnNewMap setTarget:tabBarController];
	[btnNewMap setAction:@selector(btnNewOnClick)];
	
	[btnNewSearch setTarget:tabBarController];
	[btnNewSearch setAction:@selector(btnNewOnClick)];
	
	[self translate];
	
	// Add the tab bar controller's view to the window and display.
	[window addSubview:tabBarController.view];
	[window makeKeyAndVisible];
	
	// check for internet connection
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(checkNetworkStatus:) name:kReachabilityChangedNotification object:nil];
	internetReachable = [[Reachability reachabilityForInternetConnection] retain];
	[internetReachable startNotifier];
	[self checkNetworkStatus:nil];
	
	[self initLocationManager];
	
    if ([[NSUserDefaults standardUserDefaults] valueForKey:@"savedUser"] != nil)  {
        NSDictionary* responseData = [LoginService loginWithEmail:[[NSUserDefaults standardUserDefaults] valueForKey:@"savedUser"] andPassword:[[NSUserDefaults standardUserDefaults] valueForKey:@"savedPassword"]];
        NSString* responseStatus = [responseData valueForKey:@"status"];
        
        if ([responseStatus isEqualToString:@"OK"]) {
            HurritAppDelegate* appDelegate = (HurritAppDelegate*) [[UIApplication sharedApplication] delegate];
            appDelegate.loggedIn = YES;
            appDelegate.btnSalirMapa.title = NSLocalizedString(@"Salir", nil);
            appDelegate.btnSalirBuscar.title = NSLocalizedString(@"Salir", nil);
            loggedIn = YES;
            btnSalirMapa.title = NSLocalizedString(@"Salir", nil);
            btnSalirBuscar.title = NSLocalizedString(@"Salir", nil);
        } else {
            loggedIn = NO;
            btnSalirMapa.title = NSLocalizedString(@"Entrar", nil);
            btnSalirBuscar.title = NSLocalizedString(@"Entrar", nil);
        }
    } else {
        loggedIn = NO;
        btnSalirMapa.title = NSLocalizedString(@"Entrar", nil);
        btnSalirBuscar.title = NSLocalizedString(@"Entrar", nil);
    }
	
	currentCustomization = @"";

	return YES;
}

- (void) checkNetworkStatus:(NSNotification*)notice {
	NetworkStatus internetStatus = [internetReachable currentReachabilityStatus];
	if (internetStatus != NotReachable) {
		self.internetActive = YES;
	} else {
		self.internetActive = NO;
	}
}

- (void) translate {
	tabMap.title = NSLocalizedString(@"Mapa", nil);
	tabSearch.title = NSLocalizedString(@"Nuevo momento", nil);
	btnSalirMapa.title = NSLocalizedString(@"Salir", nil);
	btnSalirBuscar.title = NSLocalizedString(@"Salir", nil);
}

#pragma mark -
#pragma mark Location Manager
- (void) initLocationManager {
	self.locationManager = [[CLLocationManager alloc] init];
	self.locationManager.delegate = self;
	self.locationManager.distanceFilter = kCLDistanceFilterNone;
	self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
	[locationManager startUpdatingLocation];	
}

- (void) locationManager:(CLLocationManager*) manager didUpdateToLocation:(CLLocation*) newLocation fromLocation:(CLLocation*) oldLocation {
	MyLocation* myLocation = [MyLocation instance];
	myLocation.currentLocation = newLocation;
    myLocation.initialized = YES;
}

- (void) locationManager:(CLLocationManager*)manager didFailWithError:(NSError*)error {
	//[self showError:NSLocalizedString(@"Ha habido un error tratando de encontrar su posicion.", nil)];
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


#pragma mark -
#pragma mark Memory management
- (void)dealloc {
	[btnSalirBuscar release];
	[btnSalirMapa release];
    [tabBarController release];
    [window release];
    [super dealloc];
}

@end

