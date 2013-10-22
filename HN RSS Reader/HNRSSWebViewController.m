//
//  HNRSSWebViewController.m
//  HN RSS Reader
//
//  Created by Camron Schwoegler on 10/17/13.
//  Copyright (c) 2013 Camron Schwoegler. All rights reserved.
//

#import "HNRSSWebViewController.h"
#import "HNRSSItem.h"

@implementation HNRSSWebViewController

@synthesize item;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nil bundle:nil];
    if (self) {
        UIWebView *webView = [[UIWebView alloc] init];

        NSURL *url = [NSURL URLWithString:[item link]];
        NSURLRequest *request = [NSURLRequest requestWithURL:url];

        [webView loadRequest:request];
    }
    return self;
}

@end
