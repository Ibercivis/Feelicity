//
//  MyImageView.h
//  Tecnimap
//
//  Created by Juan Jose Molinero Horno on 2/16/10.
//  Copyright 2010 Iritec. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface MyImageView : UIView {
	NSURLConnection *connection;
    NSMutableData *data;
    NSString *urlString; // key for image cache dictionary
}

-(void)loadImageFromURL:(NSURL*)url;

@end
