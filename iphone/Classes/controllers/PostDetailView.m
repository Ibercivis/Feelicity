//
//  PostDetailView.m
//  hurrit
//
//  Created by Juanjo Molinero on 05/11/10.
//  Copyright 2010 BIFI. All rights reserved.
//

#import "PostDetailView.h"
#import "CommentsView.h"
#import "PostService.h"
#import "PhotoDetailView.h"
#import "PostMedia.h"
#import "MyLocation.h"
#import "RegexKitLite.h"

@implementation PostDetailView

@synthesize lblTitle;
@synthesize lblDescription;
@synthesize btnLike;
@synthesize btnComments;

@synthesize postId;
@synthesize place;
@synthesize comments;
@synthesize postType;
@synthesize postTitle;
@synthesize postDescription;

@synthesize player;

@synthesize pager;
@synthesize pagerBackground;
@synthesize scroller;
@synthesize pages;

- (void) viewDidLoad {
    [super viewDidLoad];
	
	if (pages == nil) pages = [[NSMutableArray alloc] init];
	
	if ([postType isEqualToString:@"post"]) {
		[self initPost];
		UIBarButtonItem* btnBack = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Inicio", nil)
																	style:UIBarButtonItemStyleBordered
																   target:self 
																   action:@selector(btnBackOnClick)];
		self.navigationItem.leftBarButtonItem = btnBack;
		[btnBack release];
	} else {
		[self initComment];
	}
	
	scroller.contentSize = CGSizeMake(scroller.frame.size.width * [pages count], scroller.frame.size.height);
	pager.numberOfPages = [pages count];
	pager.currentPage = 0;
	
	if (pager.numberOfPages == 0) {
		pagerBackground.hidden = YES;
	}
	
	[self loadScrollViewWithPage:0];
	[self loadScrollViewWithPage:1];
	
	UIBarButtonItem* nextBackButton = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Volver", nil) style:UIBarButtonItemStylePlain target:nil action:nil];
	self.navigationItem.backBarButtonItem = nextBackButton;
	[nextBackButton release];
	
	UIImageView* logo = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"bar_logo.png"]];
	[[self navigationItem] setTitleView:logo];
}

- (void) initPost {
	NSMutableDictionary* info = [[NSMutableDictionary alloc] init];
	[info setObject:[NSNumber numberWithInt:1] forKey:@"page"];
	MyLocation* myLocation = [MyLocation instance];
	if (myLocation.currentLocation) {
		[info setObject:[NSNumber numberWithDouble:myLocation.currentLocation.coordinate.longitude] forKey:@"longitude"];
		[info setObject:[NSNumber numberWithDouble:myLocation.currentLocation.coordinate.latitude] forKey:@"latitude"];
	}
	
	NSDictionary* results = [PostService getPostData:postId withExtraInfo:info];
	NSString* status = [results valueForKey:@"status"];
	if ([status isEqualToString:@"OK"]) {
		place = [results valueForKey:@"place"];	[place retain];
		comments = [results valueForKey:@"comments"]; [comments retain];
		
		lblTitle.text = [place valueForKey:@"place_name"];
		lblDescription.text = [[comments objectAtIndex:0] valueForKey:@"comment_content"];
		NSArray* files = [[comments objectAtIndex:0] valueForKey:@"files"];
		for (NSDictionary* file in files) {
			PostMedia* postMedia = [[PostMedia alloc] init];
			postMedia.mediaType = [file valueForKey:@"type"];
			postMedia.path = [file valueForKey:@"path"];
			[pages addObject:postMedia];
		}
		
		[self findYoutubeVideosIn:[[comments objectAtIndex:0] valueForKey:@"comment_content"]];
		[lblDescription flashScrollIndicators];
	} else {
		[self showError:[results valueForKey:@"message"] withTitle:NSLocalizedString(@"Error", nil)];
	}	
}

- (void) findYoutubeVideosIn:(NSString*)description {
	NSString* regex = @"\\[URL\\][^\\[]*\\[\\/URL\\]";
	for (NSString* match in [description componentsMatchedByRegex:regex]) {
		NSString* urlRegex = @"http:\\/\\/[^\\[]*";
		PostMedia* pm = [[PostMedia alloc] init];
		pm.mediaType = @"youtube";
		pm.path = [match stringByMatching:urlRegex];
		[pages addObject:pm];
	}
	
	lblDescription.text = [description stringByReplacingOccurrencesOfRegex:regex withString:NSLocalizedString(@"[Ver debajo]", nil)];
}

- (void) initComment {
    if (postTitle != (id)[NSNull null]) {
        lblTitle.text = postTitle;
    } else {
        lblTitle.text = NSLocalizedString(@"(sin título)", nil);
    }
	[self findYoutubeVideosIn:postDescription];
	[lblDescription flashScrollIndicators];
}

- (void) viewDidAppear:(BOOL)animated {
	if ([postType isEqualToString:@"post"]) {
		btnComments.hidden = FALSE;
	} else {
		btnComments.hidden = TRUE;
	}
}

- (void) btnBackOnClick {
	[self dismissModalViewControllerAnimated:YES];
}

- (void) score:(NSInteger) score {
	NSDictionary* response;
	if ([postType isEqualToString:@"post"]) {
		response = [PostService scorePost:postId withScore:[NSNumber numberWithInt:score]];
	} else {
		response = [PostService scoreComment:postId withScore:[NSNumber numberWithInt:score]];
	}
	
	NSString* status = [response valueForKey:@"status"];
	if ([status isEqualToString:@"OK"]) {
		[self showError:NSLocalizedString(@"Se ha añadido la puntuación correctamente.", nil) withTitle:@""];
	} else {
		NSString* message = [response valueForKey:@"message"];
		[self showError:message withTitle:@"Error"];
	}
}

- (IBAction) btnLikeOnClick:(id)sender {
	[self score:1];
}

- (IBAction) btnCommentsOnClick:(id)sender {
	CommentsView* commentsView = [[CommentsView alloc] initWithNibName:@"CommentsView" bundle:nil];
	commentsView.postId = postId;
	[self.navigationController pushViewController:commentsView animated:YES];
	[commentsView release];
}

- (void) thumbOnClick {
	PostMedia* postMedia = [pages objectAtIndex:pager.currentPage];
	if ([postMedia.mediaType isEqualToString:@"image"]) {
		PhotoDetailView* photoView = [[PhotoDetailView alloc] initWithNibName:@"PhotoDetailView" bundle:nil];
		photoView.imageURL = [postMedia mediaURL];
		[self.navigationController pushViewController:photoView animated:YES];
		[photoView release];
	} else if ([postMedia.mediaType isEqualToString:@"video"]) {
		player = [[MPMoviePlayerController alloc] initWithContentURL: [NSURL URLWithString:[postMedia mediaURL]]];
		// Register to receive a notification when the movie has finished playing. 
		[[NSNotificationCenter defaultCenter] addObserver:self 
												 selector:@selector(moviePlayBackDidFinish:) 
												 name:MPMoviePlayerDidExitFullscreenNotification 
												 object:nil];
		[[player view] setFrame: [self.view bounds]];
		[self.view addSubview:[player view]];
		player.fullscreen = TRUE;
		[player play];
	}
}

- (void) moviePlayBackDidFinish:(NSNotification*)notification {
	// Remove observer
	[[NSNotificationCenter defaultCenter] removeObserver:self name:MPMoviePlayerPlaybackDidFinishNotification object:nil];
	[player stop];
	[player autorelease];
	
	// Pop out view
	[[player view] removeFromSuperview];
	
}

#pragma mark Scroll View
- (void)loadScrollViewWithPage:(int)page {
    if (page < 0)
        return;
    if (page >= [pages count])
        return;
    
	PostMedia* postMedia = [pages objectAtIndex:page];
	[postMedia loadThumbView:self];
	    
    if (postMedia.thumbView.superview == nil) {
		CGRect frame = scroller.frame;
		frame.origin.x = frame.size.width * page;
		frame.origin.y = 0;
		
		if ([postMedia.mediaType isEqualToString:@"youtube"]) {
			UIWebView* wv = [[UIWebView alloc] init];
			frame.size.width = 240;
			frame.size.height = 126;
			wv.frame = frame;
			[self embedYouTubeVideo:[postMedia mediaURL] withFrame:wv.frame onWebview:wv];
			[scroller addSubview:wv];
			return;
		}
		
		// Media thumnail
		postMedia.thumbView.frame = frame;
		[scroller addSubview:postMedia.thumbView];		
    }
}

- (void) embedYouTubeVideo:(NSString*)url withFrame:(CGRect)frame onWebview:(UIWebView*)webview {  
	NSString* embedHTML = @"\
		<html><head>\
		<style type=\"text/css\">\
		body {\
		background-color: transparent;\
		color: white;\
		}\
		</style>\
		</head><body style=\"margin:0\">\
		<embed id=\"yt\" src=\"%@\" type=\"application/x-shockwave-flash\" width=\"%0.0f\" height=\"%0.0f\"></embed>\
		</body></html>";
	
	NSString* html = [NSString stringWithFormat:embedHTML, url, frame.size.width, frame.size.height];
	[webview loadHTMLString:html baseURL:nil];
}

- (void)scrollViewDidScroll:(UIScrollView *)sender {
    // We don't want a "feedback loop" between the UIPageControl and the scroll delegate in
    // which a scroll event generated from the user hitting the page control triggers updates from
    // the delegate method. We use a boolean to disable the delegate logic when the page control is used.
    //if (pageControlUsed) {
        // do nothing - the scroll was initiated from the page control, not the user dragging
    //    return;
    // }
	
    // Switch the indicator when more than 50% of the previous/next page is visible
    CGFloat pageWidth = scroller.frame.size.width;
    int page = floor((scroller.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
    pager.currentPage = page;
    
    // load the visible page and the page on either side of it (to avoid flashes when the user starts scrolling)
    [self loadScrollViewWithPage:page - 1];
    [self loadScrollViewWithPage:page];
    [self loadScrollViewWithPage:page + 1];
    
    // A possible optimization would be to unload the views+controllers which are no longer visible
}

- (IBAction) changePage:(id)sender {
    int page = pager.currentPage;
	
    // load the visible page and the page on either side of it (to avoid flashes when the user starts scrolling)
    [self loadScrollViewWithPage:page - 1];
    [self loadScrollViewWithPage:page];
    [self loadScrollViewWithPage:page + 1];
    
	// update the scroll view to the appropriate page
    CGRect frame = scroller.frame;
    frame.origin.x = frame.size.width * page;
    frame.origin.y = 0;
    [scroller scrollRectToVisible:frame animated:YES];
    
	// Set the boolean used when scrolls originate from the UIPageControl. See scrollViewDidScroll: above.
    //pageControlUsed = YES;
}

////////////////////////////////////////////////////////////////////////

- (void) showError:(NSString*)message withTitle:(NSString*) title {
	UIAlertView* alert = [[UIAlertView alloc] initWithTitle:title
													message:message
													delegate:self 
													cancelButtonTitle:NSLocalizedString(@"Aceptar", nil)
													otherButtonTitles:nil];
	[alert show];
	[alert release];
}

- (void) dealloc {
	[lblTitle release];
	[lblDescription release];
	[btnLike release];
	[btnComments release];
	[pager release];
	[scroller release];
	[pages release];
	
    [super dealloc];
}


@end
