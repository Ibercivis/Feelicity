//
//  CommentsView.m
//  hurrit
//
//  Created by Juanjo Molinero on 08/11/10.
//  Copyright 2010 BIFI. All rights reserved.
//

#import "CommentsView.h"
#import "PostDetailView.h"
#import "PostMedia.h"
#import "PostService.h"
#import "MyLocation.h"
#import "HurritAppDelegate.h"
#import "NewCommentView.h"


@implementation CommentsView

@synthesize btnNewComment;
@synthesize commentsTableView;
@synthesize comments;
@synthesize postId;
@synthesize password;

@synthesize lblPager;
@synthesize sgmPager;
@synthesize currentPage;
@synthesize totalPages;

@synthesize loadingView;


- (void) viewDidLoad {
    [super viewDidLoad];
	
	[btnNewComment setTarget:self];
	[btnNewComment setAction:@selector(btnNewCommentOnClick)];
	
	comments = [[NSMutableArray alloc] init];
	[sgmPager addTarget:self action:@selector(pagerTapped:) forControlEvents:UIControlEventValueChanged];
	currentPage = 1;
	totalPages = 0;
	lblPager.text = @"";
	sgmPager.hidden = YES;
	self.loadingView = [LoadingView loadingViewInView:self.view];
	[NSTimer scheduledTimerWithTimeInterval: 1.0 target:self selector:@selector(reloadComments) userInfo:nil repeats: NO];
	
	UIBarButtonItem* nextBackButton = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Volver", nil) style:UIBarButtonItemStylePlain target:nil action:nil];
	self.navigationItem.backBarButtonItem = nextBackButton;
	[nextBackButton release];
	
	UIImageView* logo = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"bar_logo.png"]];
	[[self navigationItem] setTitleView:logo];
}

/************************************************
 * Table view
 ************************************************/
- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [comments count] - 1;
}

- (UITableViewCell*) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath*)indexPath {
    static NSString* MyIdentifier = @"SearchResult";
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:MyIdentifier];
	
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:MyIdentifier] autorelease];
    }
	
    NSDictionary* data = [comments objectAtIndex:(indexPath.row + 1)];
	id comment_title = [data valueForKey:@"comment_content"];
	if (comment_title == [NSNull null] || [comment_title isEqualToString:@""]) {
		cell.textLabel.text = NSLocalizedString(@"(sin título)", nil);
	} else if (comment_title == nil) {
		cell.textLabel.text = NSLocalizedString(@"(Comentario eliminado)", nil);
		
	} else {
		cell.textLabel.text = comment_title;
	}
	
	cell.detailTextLabel.text = [data valueForKey:@"user_name"];
	
	NSNumber* editable = [data valueForKey:@"editable"];
	if (editable != nil) {
		cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
	}
	
    return cell;
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath*)indexPath {
	NSDictionary* data = [comments objectAtIndex:(indexPath.row + 1)];
	
	NSNumber* editable = [data valueForKey:@"editable"];
	if (editable == nil) {
		[commentsTableView deselectRowAtIndexPath:indexPath animated:YES];
		[self showError:NSLocalizedString(@"El comentario ha sido eliminado.", nil)];
	} else {
		PostDetailView* postView = [[PostDetailView alloc] initWithNibName:@"PostDetailView" bundle:[NSBundle mainBundle]];
		postView.postId = [data valueForKey:@"comment_id"];
		postView.postType = @"comment";
		postView.postTitle = [data valueForKey:@"comment_title"];
		postView.postDescription = [data valueForKey:@"comment_content"];
		postView.pages = [[NSMutableArray alloc] init];
		NSArray* files = [data valueForKey:@"files"];
		for (NSDictionary* file in files) {
			PostMedia* postMedia = [[PostMedia alloc] init];
			postMedia.mediaType = [file valueForKey:@"type"];
			postMedia.path = [file valueForKey:@"path"];
			[postView.pages addObject:postMedia];
		}
		
		[commentsTableView deselectRowAtIndexPath:indexPath animated:YES];
		[self.navigationController pushViewController:postView animated:YES];
		[postView release];		
	}
}

- (void) tableView:(UITableView*)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath*)indexPath {
	// If row is deleted, remove it from the list.
	if (editingStyle == UITableViewCellEditingStyleDelete) {
		// delete your data item here
		NSDictionary* data = [comments objectAtIndex:(indexPath.row + 1)];
		NSNumber* editable = [data valueForKey:@"editable"];
		if (editable == nil) {
			[self showError:NSLocalizedString(@"El comentario ya ha sido eliminado.", nil)];
		} else if ([editable boolValue] == NO) {
			[self showError:NSLocalizedString(@"Solo puedes borrar tus propios comentarios.", nil)];
		} else {
			NSDictionary* response = [PostService deleteComment:[data valueForKey:@"comment_id"]];
			NSString* status = [response valueForKey:@"status"];
			if ([status isEqualToString:@"OK"]) {
				[comments removeObjectAtIndex:(indexPath.row + 1)];
				// Animate the deletion from the table.
				[tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
			} else {
				[self showError:NSLocalizedString(@"No se ha podido borrar el comentario.", nil)];
			}
		}
	}
}

- (void) btnNewCommentOnClick {
	HurritAppDelegate* appDelegate = (HurritAppDelegate*)[[UIApplication sharedApplication] delegate];
	
	if (appDelegate.loggedIn) {
        NewCommentView* newCommentView = [[NewCommentView alloc] init];
        newCommentView.postId = postId;
        newCommentView.commentsView = self;
        [self presentModalViewController:newCommentView animated:YES];
	} else {
		[self showError:NSLocalizedString(@"No puedes crear un nuevo post sin hacer login previamente.", nil)];
	}
}

- (void) reloadComments {
	NSMutableDictionary* info = [[NSMutableDictionary alloc] init];
	if (password != nil) {
		[info setObject:password forKey:@"password"];
	}
	[info setObject:[NSNumber numberWithInt:currentPage] forKey:@"page"];
	MyLocation* myLocation = [MyLocation instance];
	if (myLocation.currentLocation != nil) {
		[info setObject:[NSNumber numberWithDouble:myLocation.currentLocation.coordinate.longitude] forKey:@"longitude"];
		[info setObject:[NSNumber numberWithDouble:myLocation.currentLocation.coordinate.latitude] forKey:@"latitude"];
	}
	
	NSDictionary* post = [PostService getPostData:self.postId withExtraInfo:info];
	NSString* status = [post valueForKey:@"status"];
	if ([status isEqualToString:@"OK"]) {
		self.comments = [post valueForKey:@"comments"];
		[self.commentsTableView reloadData];
		
		totalPages = [[post valueForKey:@"pages"] intValue];
		currentPage = [[post valueForKey:@"current_page"] intValue];
		lblPager.text = [NSString stringWithFormat:NSLocalizedString(@"Pág. %d / %d", nil), currentPage, totalPages];
		
		if (totalPages == 0) {
			lblPager.text = @"";
			sgmPager.hidden = YES;
		} else if (totalPages > 1) {
			sgmPager.hidden = NO;
		}
	} else {
		[self showError:NSLocalizedString(@"No ha sido posible recargar los comentarios.", nil)];
	}

	
	[loadingView removeFromSuperview];
}

- (void) showError:(NSString*)message {
	UIAlertView* alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Error", nil)
													message:message
													delegate:self 
													cancelButtonTitle:NSLocalizedString(@"Aceptar", nil)
													otherButtonTitles:nil];
	[alert show];
	[alert release];
}

/************************************************
 * Pager
 ************************************************/
- (void) pagerTapped:(id)sender {
	if (sgmPager.selectedSegmentIndex == 0) { // Previous page
		if (currentPage > 1) {
			currentPage--;
			self.loadingView = [LoadingView loadingViewInView:self.view];
			[NSTimer scheduledTimerWithTimeInterval: 1.0 target:self selector:@selector(reloadComments) userInfo:nil repeats: NO];
		}
	} else { // Next page
		if (currentPage < totalPages) {
			currentPage++;
			self.loadingView = [LoadingView loadingViewInView:self.view];
			[NSTimer scheduledTimerWithTimeInterval: 1.0 target:self selector:@selector(reloadComments) userInfo:nil repeats: NO];
		}
	}
}

- (void) dealloc {
	[btnNewComment release];
	[commentsTableView release];
	[comments release];
	[postId release];
	[password release];
	[lblPager release];
	[sgmPager release];
	[loadingView release];
	
    [super dealloc];
}


@end
