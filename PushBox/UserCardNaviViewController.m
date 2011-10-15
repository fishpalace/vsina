//
//  UserCardNaviViewController.m
//  PushBox
//
//  Created by Gabriel Yeah on 11-10-15.
//  Copyright (c) 2011年 同济大学. All rights reserved.
//

#import "UserCardNaviViewController.h"

@implementation UserCardNaviViewController

@synthesize contentViewController;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

- (UserCardContentViewController*)contentViewController
{
	if (!contentViewController) {
		contentViewController = [[UserCardContentViewController alloc] init];
		contentViewController.parent = self;
	}
	return  contentViewController;
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
	[self.view addSubview:self.contentViewController.view];
	CGRect frame = CGRectMake(self.view.frame.origin.x + 60, self.view.frame.origin.y - 5, contentViewController.view.frame.size.width, contentViewController.view.frame.size.height);

	self.contentViewController.view.frame = frame;
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
