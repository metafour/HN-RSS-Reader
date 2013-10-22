//
//  HNRSSViewController.m
//  HN RSS Reader
//
//  Created by Camron Schwoegler on 10/17/13.
//  Copyright (c) 2013 Camron Schwoegler. All rights reserved.
//

#import "HNRSSViewController.h"
#import "HNRSSChannel.h"
#import "HNRSSItem.h"
#import "HNRSSDetailViewController.h"

@implementation HNRSSViewController

- (id)init
{
    self = [super initWithStyle:UITableViewStylePlain];
    
    if (self) {
        [self fetchEntries];
    }
    
    return self;
}

- (id)initWithStyle:(UITableViewStyle)style
{
    return [self init];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self setRefreshControl:[[UIRefreshControl alloc] init]];
    [[self refreshControl] setTintColor:[UIColor purpleColor]];
    [[self refreshControl] addTarget:self action:@selector(refreshTable:) forControlEvents:UIControlEventValueChanged];
    
}

- (void)fetchEntries
{
    // object to contain response
    xmlData = [[NSMutableData alloc] init];
    
    NSURL *url = [NSURL URLWithString:@"https://news.ycombinator.com/rss"];
    
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    
    dataConnection = [[NSURLConnection alloc] initWithRequest:request delegate:self startImmediately:YES];
}

- (void)refreshTable:(UIRefreshControl *)rc
{
    [self fetchEntries];
    [rc endRefreshing];
}

#pragma mark UITableView Delegate methods

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    HNRSSItem *item = [[channel items] objectAtIndex:[indexPath row]];
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UITableViewCell"];
    
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"UITableViewCell"];
    }
    
    UILabel *cellLabel = [cell textLabel];
    UILabel *cellDetailLabel = [cell detailTextLabel];
    NSString *hostname = [[[item link] componentsSeparatedByString:@"/"] objectAtIndex:2];
    
    // cellLabel properties
    [cellLabel setNumberOfLines:0];
    [cellLabel setFont:[UIFont systemFontOfSize:12]];
    [cellLabel setLineBreakMode:NSLineBreakByWordWrapping];
    
    if ([item read] == YES) {
        [cellLabel setTextColor:[UIColor lightGrayColor]];
    }
    
    // cellDetailLabel properties
    [cellDetailLabel setFont:[UIFont systemFontOfSize:10]];
    [cellDetailLabel setTextColor:[UIColor lightGrayColor]];
    
    // set label contents
    [cellLabel setText:[item title]];
    [cellDetailLabel setText:hostname];

    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [[channel items] count];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    HNRSSItem *item = [[channel items] objectAtIndex:[indexPath row]];
    
    HNRSSDetailViewController *dvc = [[HNRSSDetailViewController alloc] init];
    [dvc setItem:item];
    
    [[self navigationController] pushViewController:dvc animated:YES];
    
}


#pragma mark NSURLConnectionData Delegate methods

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    [xmlData appendData:data];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    NSXMLParser *parser = [[NSXMLParser alloc] initWithData:xmlData];
    
    [parser setDelegate:self];
    
    [parser parse];
    
    xmlData = nil;
    
    dataConnection = nil;
    
    [[self tableView] reloadData];
    
    NSLog(@"%@\n%@\n%@", channel, [channel title], [channel infoString]);
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    // release unused objects
    dataConnection = nil;
    xmlData = nil;
    
    NSString *errorString = [NSString stringWithFormat:@"Failed to load data: %@", [error localizedDescription]];
    
    UIAlertView *av = [[UIAlertView alloc] initWithTitle:@"Catastrophic Failure!" message:errorString delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];;
    
    [av show];
}

#pragma mark NSXMLParser Delegate methods

- (void)parser:(NSXMLParser *)parser
didStartElement:(NSString *)elementName
  namespaceURI:(NSString *)namespaceURI
 qualifiedName:(NSString *)qualifiedName
    attributes:(NSDictionary *)attributeDict
{
    NSLog(@"%@ found a %@", self, elementName);
    
    if ([elementName isEqual:@"channel"]) {
        channel = [[HNRSSChannel alloc] init];
        
        [channel setParentParserDelegate:self];
        
        [parser setDelegate:channel];
    }
    
}

@end


