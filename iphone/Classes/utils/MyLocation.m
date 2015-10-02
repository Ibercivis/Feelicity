//
//  MyLocation.m
//  hurrit
//
//  Created by Juanjo Molinero on 29/11/10.
//  Copyright 2010 BIFI. All rights reserved.
//

#import "MyLocation.h"

static MyLocation* gInstance = NULL;

@implementation MyLocation

@synthesize currentLocation;
@synthesize initialized;

+ (MyLocation*) instance {
	@synchronized(self) {
		if (gInstance == NULL) {
			gInstance = [[self alloc] init];
            gInstance.initialized = NO;
        }
    }
	
	return (gInstance);
}

@end
