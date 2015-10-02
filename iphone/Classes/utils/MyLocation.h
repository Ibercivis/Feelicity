//
//  MyLocation.h
//  hurrit
//
//  Created by Juanjo Molinero on 29/11/10.
//  Copyright 2010 BIFI. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>


@interface MyLocation : NSObject {
    BOOL initialized;
	CLLocation* currentLocation;
}

@property (nonatomic, retain) CLLocation* currentLocation;
@property (nonatomic) BOOL initialized;

+ (MyLocation*) instance;

@end
