//
//  SearchView.h
//  hurrit
//
//  Created by Juanjo Molinero on 03/11/10.
//  Copyright 2010 BIFI. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LoadingView.h"


@interface SearchView : UIViewController <UISearchBarDelegate, UITableViewDataSource> {
	UISearchBar* theSearchBar;
	UITableView* resultsList;
	UIView* disableViewOverlay;
	NSMutableArray* resultsData;
	LoadingView* loadingView;
	
	UILabel* lblPager;
	UISegmentedControl* sgmPager;
	NSInteger currentPage;
	NSInteger totalPages;
}

@property (nonatomic, retain) NSMutableArray* resultsData;
@property (nonatomic, retain) UIView* disableViewOverlay;
@property (nonatomic, retain) LoadingView* loadingView;

@property (nonatomic, retain) IBOutlet UISearchBar* theSearchBar;
@property (nonatomic, retain) IBOutlet UITableView* resultsList;

@property (nonatomic, retain) IBOutlet UILabel* lblPager;
@property (nonatomic, retain) IBOutlet UISegmentedControl* sgmPager;
@property (nonatomic) NSInteger currentPage;
@property (nonatomic) NSInteger totalPages;

- (void) doSearch;
- (void) displayBarLogo;
- (void) showError:(NSString*)message;

- (IBAction) btnCancelTapped:(id)sender;

@end
