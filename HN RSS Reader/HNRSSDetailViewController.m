//
//  HNRSSDetailViewController.m
//  HN RSS Reader
//
//  Created by Camron Schwoegler on 10/17/13.
//  Copyright (c) 2013 Camron Schwoegler. All rights reserved.
//

#import "HNRSSDetailViewController.h"
#import "HNRSSDetailView.h"
#import "HNRSSWebViewController.h"

@implementation HNRSSDetailViewController

@synthesize item;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nil bundle:nil];
    if (self) {
        // setup navigationItem
            // back button
            // share sheet
    }
    return self;
}

- (void)loadView
{
    NSArray *tbControllers = [NSArray arrayWithObjects:webView, webView2, nil];
    
    UITabBarController *tbc = [[UITabBarController alloc] init];
    [tbc setViewControllers:tbControllers];
    
    CGRect frame = [[UIScreen mainScreen] bounds];
    
    
}

@end
