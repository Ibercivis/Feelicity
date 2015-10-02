//
//  PhotoDetailView.h
//  hurrit
//
//  Created by Juanjo Molinero on 22/11/10.
//  Copyright 2010 BIFI. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface PhotoDetailView : UIViewController {
	UIImageView* myImage;
	NSString* imageURL;
}

@property (nonatomic, retain) IBOutlet UIImageView* myImage;
@property (nonatomic, retain) NSString* imageURL;

@end
