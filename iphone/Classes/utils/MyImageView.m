//
//  MyImageView.m
//  Tecnimap
//
//  Created by Juan Jose Molinero Horno on 2/16/10.
//  Copyright 2010 Iritec. All rights reserved.
//

#import "MyImageView.h"
#import "ImageCacheObject.h"
#import "ImageCache.h"

static ImageCache* imageCache = nil;

#define SPINNY_TAG 5555   

@implementation MyImageView

- (void) loadImageFromURL:(NSURL*)url {
    if (connection != nil) {
        [connection cancel];
        [connection release];
        connection = nil;
    }
    if (data != nil) {
        [data release];
        data = nil;
    }
    
    if (imageCache == nil) {
        imageCache = [[ImageCache alloc] initWithMaxSize:2 * 1024 * 1024];  // 2 MB Image cache
	}
    
    [urlString release];
    urlString = [[url absoluteString] copy];
    UIImage* cachedImage = [imageCache imageForKey:urlString];
    if (cachedImage != nil) {
        if ([[self subviews] count] > 0) {
            [[[self subviews] objectAtIndex:0] removeFromSuperview];
        }
        UIImageView *imageView = [[[UIImageView alloc] initWithImage:cachedImage] autorelease];
        imageView.contentMode = UIViewContentModeScaleAspectFit;
        imageView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        [self addSubview:imageView];
        imageView.frame = self.bounds;
        [imageView setNeedsLayout]; 
        [self setNeedsLayout];
        return;
    }
        
	UIActivityIndicatorView* spinny = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    spinny.tag = SPINNY_TAG;
	
    spinny.center = CGPointMake(25.0, 25.0);
    [spinny startAnimating];
    [self addSubview:spinny];
    [spinny release];
    
    NSURLRequest *request = [NSURLRequest requestWithURL:url 
												cachePolicy:NSURLRequestUseProtocolCachePolicy 
												timeoutInterval:60.0];
    connection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
}

- (void) connection:(NSURLConnection *)connection didReceiveData:(NSData *)incrementalData {
    if (data == nil) {
        data = [[NSMutableData alloc] initWithCapacity:2048];
    }
    [data appendData:incrementalData];
}

- (void) connectionDidFinishLoading:(NSURLConnection*)aConnection {
    [connection release];
    connection = nil;
    
    UIView* spinny = [self viewWithTag:SPINNY_TAG];
    [spinny removeFromSuperview];
	
    if ([[self subviews] count] > 0) {
        [[[self subviews] objectAtIndex:0] removeFromSuperview];
    }
    
    UIImage* image = [UIImage imageWithData:data];
    
    [imageCache insertImage:image withSize:[data length] forKey:urlString];
    
    UIImageView* imageView = [[[UIImageView alloc] initWithImage:image] autorelease];
    imageView.contentMode = UIViewContentModeScaleAspectFit;
    imageView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    [self addSubview:imageView];
    imageView.frame = self.bounds;
    [imageView setNeedsLayout]; 
    [self setNeedsLayout];
    [data release];
    data = nil;
}

- (void) dealloc {
    [connection cancel];
    [connection release];
    [data release];
    [super dealloc];
}

@end
