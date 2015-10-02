//
//  ImageUtils.h
//  hurrit
//
//  Created by Juanjo Molinero on 22/02/11.
//  Copyright 2011 BIFI. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface ImageUtils : NSObject {

}

+ (NSString*) avatarSmallSizeURLFrom:(NSString*) commonURL;
+ (UIImage*) findCurrentCustomizationAvatar;
+ (UIImage*)imageWithImage:(UIImage*)image scaledToSize:(CGSize)newSize;

@end
