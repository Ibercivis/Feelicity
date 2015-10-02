//
//  ImageUtils.m
//  hurrit
//
//  Created by Juanjo Molinero on 22/02/11.
//  Copyright 2011 BIFI. All rights reserved.
//

#import "ImageUtils.h"
#import "HurritAppDelegate.h"

@implementation ImageUtils

+ (NSString*) avatarSmallSizeURLFrom:(NSString*) commonURL {
	return [NSString stringWithFormat:@"%@:%@%@_small.jpg", ServerURL, ServerPort, commonURL];
}

+ (UIImage*) findCurrentCustomizationAvatar {
	HurritAppDelegate* appDelegate = (HurritAppDelegate*) [[UIApplication sharedApplication] delegate];
	if ([appDelegate.currentCustomization isEqualToString:@""]) {
		return [UIImage imageNamed:@"bar_logo.png"];
	} else {
		NSString* imagePath = [ImageUtils avatarSmallSizeURLFrom:[appDelegate.currentCustomizationData valueForKey:@"avatar"]];
		return [[UIImage alloc] initWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:imagePath]]]; // FIXME: [JUANJO] Cachear el avatar
	}
}

+ (UIImage*)imageWithImage:(UIImage*)image scaledToSize:(CGSize)newSize {
    UIGraphicsBeginImageContext( newSize );
    [image drawInRect:CGRectMake(0,0,newSize.width,newSize.height)];
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return newImage;
}

@end
