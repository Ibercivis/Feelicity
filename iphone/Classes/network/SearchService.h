//
//  SearchService.h
//  bidi
//
//  Created by Juanjo Molinero on 04/11/10.
//  Copyright 2010 BIFI. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface SearchService : NSObject {

}

+ (NSDictionary*) searchPostsWithString:(NSString*)theSearchString andPageNumber:(NSNumber*)pageNumber;
+ (NSDictionary*) searchPostsNearLatitudeNE:(NSNumber*) latitudeNE andLongitudeNE:(NSNumber*) longitudeNE andLatitudeSW:(NSNumber*) latitudeSW 
							 andLongitudeSW:(NSNumber*) longitudeSW withPageNumber:(NSNumber*)pageNumber;

+ (NSDictionary*) searchProfile:(NSString*)userId withString:(NSString*)query andPageNumber:(NSNumber*)pageNumber;
+ (NSDictionary*) searchProfile:(NSString*)userId nearLatitudeNE:(NSNumber*) latitudeNE andLongitudeNE:(NSNumber*) longitudeNE andLatitudeSW:(NSNumber*) latitudeSW 
				 andLongitudeSW:(NSNumber*) longitudeSW withPageNumber:(NSNumber*)pageNumber;

@end
