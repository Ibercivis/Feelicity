//
//  SearchView.m
//  hurrit
//
//  Created by Juanjo Molinero on 03/11/10.
//  Copyright 2010 BIFI. All rights reserved.
//

#import "SearchView.h"
#import "PostDetailView.h"
#import "SearchService.h"
#import "ImageUtils.h"
#import "HurritAppDelegate.h"

@implementation SearchView

@synthesize theSearchBar, resultsList, resultsData, disableViewOverlay;
@synthesize loadingView;
@synthesize lblPager;
@synthesize sgmPager;
@synthesize currentPage;
@synthesize totalPages;

#pragma mark View Load
- (void) viewDidLoad {
    [super viewDidLoad];
	
	resultsData = [[NSMutableArray alloc] init];
	
	//disableViewOverlay = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 44.0f, 320.0f, 416.0f)];
    //disableViewOverlay.backgroundColor = [UIColor blackColor];
    //disableViewOverlay.alpha = 0;
	
	[sgmPager addTarget:self action:@selector(pagerTapped:) forControlEvents:UIControlEventValueChanged];
	currentPage = 1;
	totalPages = 0;
	
	lblPager.text = @"";
	sgmPager.hidden = YES;
	
	UIButton* btnTitle = [UIButton buttonWithType:UIButtonTypeCustom];
	btnTitle.bounds = CGRectMake(0, 0, 144, 40);
	[[self navigationItem] setTitleView:btnTitle];
}

- (void) viewDidAppear:(BOOL)animated {
    [theSearchBar becomeFirstResponder];
	[self displayBarLogo];
    [super viewDidAppear:animated];
}

- (void) displayBarLogo {
	UIButton* btnTitle = (UIButton*)[self navigationItem].titleView;
	UIImage* imageTitle = [ImageUtils findCurrentCustomizationAvatar];
	if (imageTitle.size.width <= 144 && imageTitle.size.height <= 40) {
		btnTitle.bounds = CGRectMake(0, 0, imageTitle.size.width, imageTitle.size.height);
	} else if (imageTitle.size.width > 144 && imageTitle.size.height <= 40) {
		btnTitle.bounds = CGRectMake(0, 0, 144, (imageTitle.size.height * 144 / imageTitle.size.width));
	} else if (imageTitle.size.width <= 144 && imageTitle.size.height > 40) {
		btnTitle.bounds = CGRectMake(0, 0, (imageTitle.size.width * 40 / imageTitle.size.height), 40);
	} else {
		if ((imageTitle.size.width - 144) > (imageTitle.size.height - 40)) {
			btnTitle.bounds = CGRectMake(0, 0, 144, (imageTitle.size.height * 144 / imageTitle.size.width));
		} else {
			btnTitle.bounds = CGRectMake(0, 0, (imageTitle.size.width * 40 / imageTitle.size.height), 40);
		}
	}
	
	[btnTitle setImage:imageTitle forState:UIControlStateNormal];
}

#pragma mark Search Bar
- (void) searchBarTextDidBeginEditing:(UISearchBar*)searchBar {
    [searchBar setShowsCancelButton:YES animated:YES];
    self.resultsList.allowsSelection = NO;
    self.resultsList.scrollEnabled = NO;
	
	// Fading in the disableViewOverlay
    self.disableViewOverlay.alpha = 0;
    [self.view addSubview:self.disableViewOverlay];
	
    [UIView beginAnimations:@"FadeIn" context:nil];
    [UIView setAnimationDuration:0.5];
    self.disableViewOverlay.alpha = 0.6;
    [UIView commitAnimations];
}

- (void) searchBarCancelButtonClicked:(UISearchBar*)searchBar {
    searchBar.text = @"";
    
    [searchBar setShowsCancelButton:NO animated:YES];
    [searchBar resignFirstResponder];
    resultsList.allowsSelection = YES;
    resultsList.scrollEnabled = YES;
	
	// Removing the disableViewOverlay
    [disableViewOverlay removeFromSuperview];
}

- (void) searchBarSearchButtonClicked:(UISearchBar*)searchBar {
    [disableViewOverlay removeFromSuperview];
	resultsList.allowsSelection = YES;
    resultsList.scrollEnabled = YES;
	[searchBar setShowsCancelButton:NO animated:YES];
	[searchBar resignFirstResponder];
	self.loadingView = [LoadingView loadingViewInView:self.view];
	[NSTimer scheduledTimerWithTimeInterval: 1.0 target:self selector:@selector(doSearch) userInfo:nil repeats: NO];
}

- (void) doSearch {
	NSMutableArray* results = [[NSMutableArray alloc] init];
	HurritAppDelegate* appDelegate = (HurritAppDelegate*) [[UIApplication sharedApplication] delegate];
	NSDictionary* searchResults = nil;
	if ([appDelegate.currentCustomization isEqualToString:@""]) {
		searchResults = [SearchService searchPostsWithString:theSearchBar.text andPageNumber:[NSNumber numberWithInt:currentPage]];
	} else {
		searchResults = [SearchService searchProfile:appDelegate.currentCustomization withString:theSearchBar.text andPageNumber:[NSNumber numberWithInt:currentPage]];
	}
	
	NSString* status = [searchResults valueForKey:@"status"];
	if ([status isEqualToString:@"OK"]) {
		NSArray* posts = [searchResults valueForKey:@"results"];
		for (NSDictionary* post in posts) {
			NSMutableDictionary* result = [[NSMutableDictionary alloc] init];
			[result setValue:[post valueForKey:@"place_id"] forKey:@"id"];
			[result setValue:[post valueForKey:@"place_name"] forKey:@"title"];
			[result setValue:[post valueForKey:@"last_updater_name"] forKey:@"user"];
			[results addObject:result];
		}
	} else {
		NSString* errorMessage = [searchResults valueForKey:@"message"];
		[self showError:errorMessage];
	}
    
    [resultsData removeAllObjects];
    [resultsData addObjectsFromArray:results];
    [resultsList reloadData];
	
	totalPages = [[searchResults valueForKey:@"pages"] intValue];
	currentPage = [[searchResults valueForKey:@"current_page"] intValue];
	lblPager.text = [NSString stringWithFormat:NSLocalizedString(@"Pág. %d / %d", nil), currentPage, totalPages];
	
	if (totalPages == 0) {
		lblPager.text = @"";
		sgmPager.hidden = YES;
	} else if (totalPages > 1) {
		sgmPager.hidden = NO;
	}
	
	[self.loadingView removeView];
}

#pragma mark Table View
- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [resultsData count];
}

- (UITableViewCell*) tableView:(UITableView*)tableView cellForRowAtIndexPath:(NSIndexPath*)indexPath {
    static NSString* MyIdentifier = @"SearchResult";
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:MyIdentifier];
	
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:MyIdentifier] autorelease];
    }
	
    NSDictionary* data = [resultsData objectAtIndex:indexPath.row];
    cell.textLabel.text = [data valueForKey:@"title"];
	cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
	
    return cell;
}

- (void) tableView:(UITableView*)tableView didSelectRowAtIndexPath:(NSIndexPath*)indexPath {
	NSDictionary* data = [resultsData objectAtIndex:indexPath.row];
	
	PostDetailView* postView = [[PostDetailView alloc] initWithNibName:@"PostDetailView" bundle:[NSBundle mainBundle]];
	postView.postId = [data valueForKey:@"id"];
	postView.postType = @"post";
	
	[resultsList deselectRowAtIndexPath:indexPath animated:YES];
	
	UINavigationController* navigationController = [[UINavigationController alloc] initWithRootViewController:postView];
    navigationController.navigationBar.tintColor = [UIColor lightGrayColor];
	
	[self presentModalViewController:navigationController animated:YES];
}

#pragma mark Button Actions
- (void) pagerTapped:(id)sender {
	if (sgmPager.selectedSegmentIndex == 0) { // Previous page
		if (currentPage > 1) {
			currentPage--;
			self.loadingView = [LoadingView loadingViewInView:self.view];
			[NSTimer scheduledTimerWithTimeInterval: 1.0 target:self selector:@selector(doSearch) userInfo:nil repeats: NO];
		}
	} else { // Next page
		if (currentPage < totalPages) {
			currentPage++;
			self.loadingView = [LoadingView loadingViewInView:self.view];
			[NSTimer scheduledTimerWithTimeInterval: 1.0 target:self selector:@selector(doSearch) userInfo:nil repeats: NO];
		}
	}
}

- (IBAction) btnCancelTapped:(id)sender {
    [self dismissModalViewControllerAnimated:YES];
}

#pragma mark User Warning
- (void) showError:(NSString*)message {
	UIAlertView* alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Error", nil)
													message:message
												   delegate:self 
										  cancelButtonTitle:NSLocalizedString(@"Aceptar", nil)
										  otherButtonTitles:nil];
	[alert show];
	[alert release];
}

#pragma mark Memory Management
- (void)dealloc {
	[theSearchBar release];
	[resultsList release];
	[lblPager release];
	[sgmPager release];
	[resultsData dealloc];
	
    [super dealloc];
}


@end
