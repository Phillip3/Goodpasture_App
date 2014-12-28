//
//  Announcements.m
//  Goodpasture Application
//
//  Created by Phillip Trent on 7/9/13.
//  Copyright (c) 2013 Phillip Trent Coding. All rights reserved.
//



#import "AnnouncementsViewController.h"
#import "TwitterLoginInfoAndKey.h"
#import "NSObject_UniversalHeader.h"
#define RED 0.096153846
#define GREEN 0.81923077
#define BLUE 0.97307692
#define RED2 0.6
#define GREEN2 1.0
#define BLUE2 1.0

@interface AnnouncementsViewController () <UITableViewDataSource, UITableViewDelegate>
@property (strong, nonatomic) IBOutlet UIActivityIndicatorView *spinner;
@property (strong ,nonatomic) IBOutlet UILabel *label;
@property (strong, nonatomic) UIBarButtonItem *backButton;
@property (strong, nonatomic) NSArray *dates;
@property (strong, nonatomic) NSMutableArray *numbers;
@property (strong) NSArray *tweets;
@end

@implementation AnnouncementsViewController

//---------------------------------------
//Setup:
//---------------------------------------
@synthesize tweets = _tweets;
float backgroundAlpha = 0.0;
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
    [self sortTweets];
}
-(NSArray *)dates
{
    if (!_dates) {
        _dates = [NSArray array];
    }
    return _dates;
}
-(NSMutableArray *)numbers
{
    if (!_numbers) {
        _numbers = [NSMutableArray array];
    }
    return _numbers;
}
//---------------------------------------



//---------------------------------------
//AccessingTwitter:
//---------------------------------------
-(void) accessTwitterStorageForMoreRecentTweets:(BOOL)recentTweets earlierTweets:(BOOL)earlierTweets
{
    //if we're looking for more recent tweets, get them and then set self.tweets
    if (recentTweets) {
        [self.tweetStorage getMoreRecentAnnouncementTweetsWithRefreshControl:self.refreshControl successBlock:^(){
            self.tweets = self.tweetStorage.announcementTweets;
            if (!self.tweets.count){
                [UIView animateWithDuration:.5 animations:^{
                    self.label.alpha = 1.0;
                }];
            }
        } errorBlock:^(){ [self errorMessage]; }];
    }
}
-(void) errorMessage
{
    [self networkErrorMessage];
    [UIApplication sharedApplication].networkActivityIndicatorVisible = false;
    if (self.refreshControl.isRefreshing) [self.refreshControl endRefreshing];
    [self.refreshControl setHidden:YES];
    if (self.spinner.isAnimating) [self.spinner stopAnimating];
}
-(IBAction) refresh
{
        [UIView animateWithDuration:.5 animations:^{
            self.label.alpha = 0.0;
        }];
    [self accessTwitterStorageForMoreRecentTweets:YES earlierTweets:NO];
}
-(void) networkErrorMessage
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Oh no!" message:@"There seems to be a problem accessing Twitter. Please check internet connection, and try again." delegate:nil cancelButtonTitle:@"Dismiss" otherButtonTitles:nil];
    [alert show];
}
-(void) sortTweets
{
    NSLog(@"Sort Tweets Called");
    BOOL dateIsInDates = FALSE;
    self.dates = @[];
    self.numbers = [NSMutableArray array];
    //cycle through all the self.tweets
    for (int tweetIndex = 0; tweetIndex<self.tweets.count; tweetIndex ++) {
        
        //create a formatter for the date
        //Wed Dec 01 17:08:03 +0000 2010
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"EEE MMM dd HH:mm:ss Z y"];
        
        NSString *rawTweetDate = [[self.tweets[tweetIndex] objectForKey:@"created_at"] description];
        NSDate *date = [formatter dateFromString:rawTweetDate];
        
        [formatter setDateFormat:@"EEEE, MMMM dd, yyyy"];
        if(DEBUG)NSLog(@"%@",[formatter stringFromDate:date]);
        NSString *tweetDate = [formatter stringFromDate:date];
        
        
        //cycle through all of the dates in self.dates
        for (NSString *date in self.dates){
            //if the tweet's date is equal to the date in self.dates
            if ([tweetDate isEqualToString:date]){
                dateIsInDates = TRUE;
                NSNumber *tweetNumber = [self.numbers objectAtIndex:[self.dates indexOfObject:tweetDate]];
                [self.numbers setObject:[NSNumber numberWithInt:(tweetNumber.intValue + 1)] atIndexedSubscript:[self.dates indexOfObject:tweetDate]];
                NSLog(@"date is in dates %@", date);
                NSLog(@"Number of tweets under %@ == %i", date, [[self.numbers objectAtIndex:[self.dates indexOfObject:tweetDate]] intValue]);
            }
        }
        //if the date from the tweet isn't in self.dates, add it, and add an integer in self.numbers to hold the number of tweets for that date
        if (!dateIsInDates) {
            NSLog(@"%@ is not in dates", tweetDate);
            //add the tweet's date to the beginning of the array
            self.dates  = [self.dates arrayByAddingObjectsFromArray:@[tweetDate]];
            NSNumber *tweetNumber = [NSNumber numberWithInt:1];
            [self.numbers addObject:tweetNumber];
            NSLog(@"Number of tweets under %@ == %i", tweetDate, tweetNumber.intValue);
        }
        dateIsInDates = FALSE;
    }
    NSLog(@"Number of self.numbers = %lu self.dates = %lu", (unsigned long)self.numbers.count, (unsigned long)self.dates.count);
    NSLog(@"self.tweets count = %lu", (unsigned long)self.tweets.count);
    [self.tableView reloadData];
}
//---------------------------------------



//---------------------------------------
//Delegate Methods:
//---------------------------------------
-(NSString*)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    NSString *returnValue = @"";
    if (self.tweets.count) {
        returnValue =  [self.dates[section] description];
    }
    return returnValue;
}
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == self.tweets.count-1) {
        [self accessTwitterStorageForMoreRecentTweets:NO earlierTweets:YES];
    }
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    NSInteger returnValue = 1;
    if (self.tweets.count) {
        returnValue = [self.numbers[section] intValue];
    }
    return returnValue;
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    NSInteger returnValue = 1;
    if (self.tweets.count) {
        returnValue = self.dates.count;
    }
    return returnValue;
}
-(NSString *) tweetForRow: (NSUInteger) row
{
    NSString *returnValue;
    if (self.tweets.count) {
        returnValue = [[self.tweets[row] objectForKey:@"text"] description];
    }
    return returnValue;
}
-(NSString *) tweetForIndex: (NSIndexPath *)indexPath
{
    NSString *returnValue = @"";
    long indexForTweet = indexPath.row;
        if (self.tweets.count) {
            for (int sectionIndex = 0; sectionIndex<indexPath.section; sectionIndex ++) {
                indexForTweet = indexForTweet + [[self.numbers objectAtIndex:sectionIndex] intValue];
            }
            returnValue = [self tweetForRow:indexForTweet];
        }
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
    cell.textLabel.text = [self tweetForIndex:indexPath];
    if ([cell.textLabel.text isEqualToString:@""]){}
        else{
            [cell setHidden:NO];
        }
    //cell.detailTextLabel.text = [self dateForTweetOnRow:indexPath.row];
    return cell;
}
-(CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat returnValue = 150;
    NSString *tweetText = [self tweetForIndex:indexPath];
    CGSize textSize = [tweetText sizeWithAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:18]}];
    returnValue = ((textSize.height*textSize.width)/self.view.bounds.size.width)+80;
    NSLog(@"size of table view cell = %f", returnValue);
    return returnValue;
}
-(CGFloat) tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 100;
}
//---------------------------------------
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (!self.tweets.count) {
        UIView *tempView=[[UIView alloc]initWithFrame:CGRectMake(0,200,300,244)];
        return tempView;
    }
    UIView *tempView=[[UIView alloc]initWithFrame:CGRectMake(0,200,300,244)];
    tempView.backgroundColor=[UIColor colorWithRed:RED2 green:GREEN2 blue:BLUE2 alpha:1.0];
    
    UILabel *tempLabel=[[UILabel alloc]initWithFrame:CGRectMake(15,0,300,22)];
    tempLabel.backgroundColor=[UIColor clearColor];
    tempLabel.textColor = [UIColor blackColor]; //here you can change the text color of header.
    tempLabel.font = [UIFont systemFontOfSize:[UIFont systemFontSize]];
    tempLabel.text=[self tableView:self.tableView titleForHeaderInSection:section];
    
    [tempView addSubview:tempLabel];
    
    return tempView;
}

//---------------------------------------
//Lifecycle:
//---------------------------------------
-(void) viewDidLayoutSubviews
{
    self.refreshControl.hidden = NO;
}
-(void) viewDidDisappear:(BOOL)animated
{
    [UIApplication sharedApplication].networkActivityIndicatorVisible = false;
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.refreshControl addTarget:self action:@selector(refresh) forControlEvents:UIControlEventValueChanged];
    if (self.navigationController.navigationBarHidden) {
        [self.navigationController setNavigationBarHidden:NO animated:YES];
    }
    self.title = @"News";
    if (self.tweetStorage.announcementTweets.count) {
        self.tweets = self.tweetStorage.announcementTweets;
    } else {
        [self refresh];
    }
    [self.navigationController.navigationBar setTintColor:[UIColor colorWithRed:RED green:GREEN blue:BLUE alpha:1.0]];
    self.spinner.hidesWhenStopped = YES;
    
}
//---------------------------------------
@end
