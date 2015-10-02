//
//  CommentsView.h
//  hurrit
//
//  Created by Juanjo Molinero on 08/11/10.
//  Copyright 2010 BIFI. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LoadingView.h"



@interface CommentsView : UIViewController <UITableViewDataSource> {
	UIBarButtonItem* btnNewComment;
	UITableView* commentsTableView;
	NSMutableArray* comments;
	NSString* postId;
	NSString* password;
	
	UILabel* lblPager;
	UISegmentedControl* sgmPager;
	NSInteger currentPage;
	NSInteger totalPages;
	
	LoadingView* loadingView;
}

@property (nonatomic, retain) IBOutlet UIBarButtonItem* btnNewComment;
@property (nonatomic, retain) IBOutlet UITableView* commentsTableView;
@property (nonatomic, retain) NSMutableArray* comments;
@property (nonatomic, retain) NSString* postId;
@property (nonatomic, retain) NSString* password;

@property (nonatomic, retain) IBOutlet UILabel* lblPager;
@property (nonatomic, retain) IBOutlet UISegmentedControl* sgmPager;
@property (nonatomic) NSInteger currentPage;
@property (nonatomic) NSInteger totalPages;

@property (nonatomic, retain) LoadingView* loadingView;

- (void) showError:(NSString*)message;
- (void) reloadComments;

@end
