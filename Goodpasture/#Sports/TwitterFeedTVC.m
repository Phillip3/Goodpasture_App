//
//  TwitterFeedTVC.m
//  Goodpasture
//
//  Created by Phillip Trent on 12/26/14.
//  Copyright (c) 2014 Phillip Trent. All rights reserved.
//

#import "TwitterFeedTVC.h"
#import "TwitterLoginInfoAndKey.h"
#import "NSObject_UniversalHeader.h"


@interface TwitterFeedTVC () <UITableViewDataSource, UITableViewDelegate>
@property (strong, nonatomic) IBOutlet UIActivityIndicatorView *spinner;
@property (strong, nonatomic) UIBarButtonItem *backButton;
@property (strong) NSArray *tweets;
@property (strong,nonatomic) NSString *titleString;
@property (strong, nonatomic) IBOutlet UILabel *noMoreTweetsLabel;
@end

@implementation TwitterFeedTVC
#pragma mark - Setup

//---------------------------------------
//Setup:
//---------------------------------------
@synthesize tweets=_tweets;
-(NSArray *)tweets
{
    if (!_tweets) {
        _tweets = [NSArray array];
    }
    return _tweets;
}
-(void) setTweets:(NSArray *)tweets
{
    _tweets = tweets;
    if (!tweets.count) [self accessTwitterStorageForMoreRecentTweets:NO earlierTweets:YES];
}
//---------------------------------------

#pragma mark - Accessing Twitter


//---------------------------------------
//AccessingTwitter:
//---------------------------------------
-(void) accessTwitterStorageForMoreRecentTweets:(BOOL)recentTweets earlierTweets:(BOOL)earlierTweets
{
    //if we're looking for more recent tweets, get them and then set self.tweets
    if (recentTweets) {
        [self.tweetStorage getMoreRecentSportsTweetsWithRefreshControl:self.refreshControl successBlock:^(){
            [self.tweetStorage getSportsTweetsFilteredWithWord:self.titleString successBlock:^(NSArray* tweets){
                NSMutableArray *newTweets = [tweets mutableCopy];
                [newTweets removeObjectsInArray:self.tweets];
                
                if (newTweets.count) {
                    NSMutableArray *indexPathArray = [[NSMutableArray alloc] init];
                    for (int i = 0; i<newTweets.count; i++) {
                        NSIndexPath *path = [NSIndexPath indexPathForItem:i inSection:0];
                        [indexPathArray addObject:path];
                    }
                    if (indexPathArray.count) {
                        [self.tableView beginUpdates];
                        [self.tableView insertRowsAtIndexPaths:indexPathArray withRowAnimation:UITableViewRowAnimationFade];
                        self.tweets = tweets;
                        [self.tableView endUpdates];
                    }
                } else {
                    self.tweets = tweets;
                }
            }];
        } errorBlock:^(){
            [self errorMessage];
        }];
    }
    
    //if we're looking for earlier tweets, get them and then set self.tweets
    if (earlierTweets) {
        if ([self.refreshControl isRefreshing])[self.refreshControl endRefreshing];
        [self.tweetStorage getPreviousSportsTweetsWithSpinner:self.spinner noMoreTweetsLabel:self.noMoreTweetsLabel successBlock:^(){
            [self.tweetStorage getSportsTweetsFilteredWithWord:self.titleString successBlock:^(NSArray *tweets){
                NSMutableArray *newTweets = [tweets mutableCopy];
                [newTweets removeObjectsInArray:self.tweets];
                if (newTweets.count) {
                    NSLog(@"There are new tweets in the earlierTweets Section");
                    NSMutableArray *indexPathArray = [[NSMutableArray alloc] init];
                    for (long i = self.tweets.count; i < (newTweets.count+self.tweets.count); i++) {
                        NSIndexPath *path = [NSIndexPath indexPathForItem:i inSection:0];
                        [indexPathArray addObject:path];
                    }
                    if (indexPathArray.count) {
                        [self.tableView beginUpdates];
                        [self.tableView insertRowsAtIndexPaths:indexPathArray withRowAnimation:UITableViewRowAnimationTop];
                        self.tweets = tweets;
                        [self.tableView endUpdates];
                    }
                } else {
                    NSLog(@"There are no new tweets in the earlierTweets Section");
                    self.tweets = tweets;
                }
                
            }];
        } errorBlock:^(){
            [self errorMessage];
            NSLog(@"errorBlock for earlier sports tweets");
        }];
    }
}
-(void) errorMessage
{
    [self.refreshControl setHidden:YES];
    [self.refreshControl endRefreshing];
    [self.spinner stopAnimating];
    [self.spinner setHidden:YES];
    [self.noMoreTweetsLabel setHidden:NO];
}
-(IBAction)refresh
{
    [self accessTwitterStorageForMoreRecentTweets:YES earlierTweets:NO];
}
//---------------------------------------


#pragma mark - Delegate Methods

//---------------------------------------
//Delegate Methods:
//---------------------------------------
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == self.tweets.count-1) {
        [self accessTwitterStorageForMoreRecentTweets:NO earlierTweets:YES];
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return self.tweets.count;
}
-(NSString *) tweetForRow: (NSUInteger) row
{
    NSString *returnValue;
    returnValue = [[self.tweets[row] objectForKey:@"text"] description];
    
    return returnValue;
}
-(NSString *) dateForTweetOnRow: (NSUInteger) row
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    
    //Wed Dec 01 17:08:03 +0000 2010
    [formatter setDateFormat:@"EEE MMM dd HH:mm:ss Z y"];
    NSDate *date = [formatter dateFromString:[[self.tweets[row] objectForKey:@"created_at"] description]];
    
    [formatter setDateFormat:@"EEEE, MMMM dd, yyyy"];
    
    return [formatter stringFromDate:date];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Tweet";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:(UITableViewCellStyleDefault)reuseIdentifier:@"Tweet"];
    }
    // Configure the cell...
    cell.textLabel.text = [self tweetForRow:indexPath.row];
    cell.detailTextLabel.text = [self dateForTweetOnRow:indexPath.row];
    [cell setHidden:NO];
    return cell;
}
-(CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat returnValue = 150;
    NSString *tweetText = [self tweetForRow:indexPath.row];
    CGSize textSize = [tweetText sizeWithAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:18]}];
    returnValue = ((textSize.height*textSize.width)/self.view.bounds.size.width)+80;
    NSLog(@"size of table view cell = %f", returnValue);
    return returnValue;
}

//---------------------------------------


#pragma mark - Lifecycle
//---------------------------------------
//Lifecycle:
//---------------------------------------
-(void) viewDidDisappear:(BOOL)animated
{
    [UIApplication sharedApplication].networkActivityIndicatorVisible = false;
}
- (void) viewDidAppear:(BOOL)animated
{
    if (!self.tweets.count) {
        self.refreshControl.hidden = NO;
        [self.refreshControl beginRefreshing];
    }
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.refreshControl addTarget:self action:@selector(refresh) forControlEvents:UIControlEventValueChanged];
    if (self.navigationController.navigationBarHidden) {
        [self.navigationController setNavigationBarHidden:NO animated:YES];
    }
    self.noMoreTweetsLabel.hidden = YES;
    self.noMoreTweetsLabel.text = @"No More Tweets";
    self.noMoreTweetsLabel.alpha = 1.0;
    NSString *titleString = [NSString string];
    if ([self.title isEqualToString:@"#AllSports"]) {
        titleString = nil;
    } else {
        titleString = [self.title substringFromIndex:1];
    }
    self.titleString = titleString;
    if (self.tweetStorage.sportsTweets.count) {
        [self.tweetStorage getSportsTweetsFilteredWithWord:self.titleString successBlock:^(NSArray *tweets){
            self.tweets = tweets;
            if (!tweets.count) {
                [self accessTwitterStorageForMoreRecentTweets:NO earlierTweets:YES];
            }
        }];
    } else {
        [self refresh];
    }
    self.spinner.hidesWhenStopped = YES;
}
//---------------------------------------
@end
