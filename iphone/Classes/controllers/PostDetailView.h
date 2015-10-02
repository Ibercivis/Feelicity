//
//  PostDetailView.h
//  hurrit
//
//  Created by Juanjo Molinero on 05/11/10.
//  Copyright 2010 BIFI. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MediaPlayer/MediaPlayer.h>


@interface PostDetailView : UIViewController <UIScrollViewDelegate> {
	UIButton* btnLike;
	UIButton* btnComments;
	UILabel* lblTitle;
	UITextView* lblDescription;
	
	NSString* postId;
	NSDictionary* place;
	NSArray* comments;
	NSString* postType;
	NSString* postTitle;
	NSString* postDescription;
	
	MPMoviePlayerController* player;
	
	UIPageControl* pager;
	UIView* pagerBackground;
	UIScrollView* scroller;
	NSMutableArray* pages;
}

@property (nonatomic, retain) IBOutlet UIButton* btnLike;
@property (nonatomic, retain) IBOutlet UIButton* btnComments;
@property (nonatomic, retain) IBOutlet UILabel* lblTitle;
@property (nonatomic, retain) IBOutlet UITextView* lblDescription;

@property (nonatomic, retain) NSString* postId;
@property (nonatomic, retain) NSDictionary* place;
@property (nonatomic, retain) NSArray* comments;
@property (nonatomic, retain) NSString* postType;
@property (nonatomic, retain) NSString* postTitle;
@property (nonatomic, retain) NSString* postDescription;

@property (nonatomic, retain) MPMoviePlayerController* player;

@property (nonatomic, retain) IBOutlet UIPageControl* pager;
@property (nonatomic, retain) IBOutlet UIView* pagerBackground;
@property (nonatomic, retain) IBOutlet UIScrollView* scroller;
@property (nonatomic, retain) NSMutableArray* pages;

- (IBAction) btnCommentsOnClick:(id)sender;
- (IBAction) btnLikeOnClick:(id)sender;
- (IBAction) changePage:(id)sender;


- (void) btnBackOnClick;
- (void) showError:(NSString*)message withTitle:(NSString*) title;
- (void) initPost;
- (void) initComment;
- (void) loadScrollViewWithPage:(int)page;
- (void) thumbOnClick;
- (void) embedYouTubeVideo:(NSString*)url withFrame:(CGRect)frame onWebview:(UIWebView*)webview;
- (void) findYoutubeVideosIn:(NSString*)description;

@end
