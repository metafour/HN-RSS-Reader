//
//  HNRSSViewController.h
//  HN RSS Reader
//
//  Created by Camron Schwoegler on 10/17/13.
//  Copyright (c) 2013 Camron Schwoegler. All rights reserved.
//

#import <Foundation/Foundation.h>

@class HNRSSChannel;

@interface HNRSSViewController : UITableViewController <NSXMLParserDelegate>
{
    NSURLConnection *dataConnection;
    NSMutableData *xmlData;
    HNRSSChannel *channel;
}

- (void)fetchEntries;

@end
