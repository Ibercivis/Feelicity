//
//  ThumbView.h
//  hurrit
//
//  Created by Juanjo Molinero on 03/12/10.
//  Copyright 2010 BIFI. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PostDetailView.h"
#import "MyImageView.h"

@interface ThumbView : MyImageView {
	PostDetailView* myParent;
}

@property (nonatomic, retain) PostDetailView* myParent;

@end
