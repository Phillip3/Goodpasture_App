//
//  TweetStorage.m
//  Goodpasture
//
//  Created by Phillip Trent on 11/26/13.
//  Copyright (c) 2013 Phillip Trent Coding. All rights reserved.
//

#import "TweetStorage.h"
#import "STTwitter.h"
#import "TwitterLoginInfoAndKey.h"
#import "NSObject_UniversalHeader.h"
@interface TweetStorage ()
@property (strong, nonatomic) NSString *sportSinceID;
@property (strong, nonatomic) NSString *sportMaxID;
@property (strong, nonatomic) NSString *announcementSinceID;
@property (strong, nonatomic) NSString *announcementMaxID;
@property (strong, nonatomic) NSTimer *timer;
@property (nonatomic) BOOL returnedNothing;
@property (nonatomic) int requestsMade;
@end

@implementation TweetStorage
#pragma mark - Setup
//---------------------------------------
//Setup:
//---------------------------------------
-(NSString *) sportSinceID
{
    if (!_sportSinceID) {
        _sportSinceID = [NSString string];
    }
    return _sportSinceID;
}
-(NSString *) sportMaxID
{
    if (!_sportMaxID) {
        _sportMaxID = [NSString string];
        NSLog(@"sport max id alloc init");
    }
    return _sportMaxID;
}
-(NSString *) announcementSinceID
{
    if (!_announcementSinceID) {
        _announcementSinceID = [NSString string];
    }
    return _announcementSinceID;
}
-(NSString *) announcementMaxID
{
    if (!_announcementMaxID) {
        _announcementMaxID = [NSString string];
    }
    return _announcementMaxID;
}
-(NSArray *) sportsTweets
{
    if (!_sportsTweets) {
        _sportsTweets = [NSArray array];
        NSLog(@"TweetStorage.sportsTweets init");
    }
    return _sportsTweets;
}
-(NSArray *) announcementTweets
{
    if (!_announcementTweets) {
        _announcementTweets = [NSArray array];
        NSLog(@"TweetStorage.announcementTweets init");
    }
    return _announcementTweets;
}
//---------------------------------------

#pragma mark Timer

//---------------------------------------
//Timer:
//---------------------------------------
-(void)setRequestsMadeToZero
{
    self.requestsMade = 0;
    NSLog(@"Requests set to zero");
}
//---------------------------------------

#pragma mark  Filter

//---------------------------------------
//Filter:
//---------------------------------------

-(void) getSportsTweetsFilteredWithWord:(NSString *)word successBlock:(void(^)(NSArray* tweets))successBlock
{
    NSLog(@"filterSportsTweets");
    
    NSArray *returnArray = [NSArray array];
    if (word) {
        NSMutableArray *tweetsContainingString = [[NSMutableArray alloc] init];
        
        for (NSDictionary *dict in self.sportsTweets) {
            
            NSString *tweet = [NSString stringWithString:[dict objectForKey:@"text"]];
            
            if ([tweet rangeOfString:word options:NSCaseInsensitiveSearch].length) {
                [tweetsContainingString addObject:dict];
            }
        }
        
        returnArray = [tweetsContainingString copy];
    } else {
        returnArray = self.sportsTweets;
    }
    successBlock(returnArray);
    
}
//---------------------------------------

#pragma mark - Sports Tweets

//---------------------------------------
//Sports Tweets:
//---------------------------------------
-(void) getSportsTweetsWithCount:(int)count
                         SinceID:(NSString *)sinceID
                        andMaxID:(NSString *)maxID
                      andSpinner:(UIActivityIndicatorView *)spinner
                orRefreshControl: (UIRefreshControl *) refreshControl
                    successBlock:(void(^)())successBlock
                      errorBlock:(void(^)())errorBlock
{
    if (!self.timer) {
        self.timer = [NSTimer scheduledTimerWithTimeInterval:TIME_INTERVAL_TWITTTER_REQUEST_SECONDS target:self selector:@selector(setRequestsMadeToZero) userInfo:nil repeats:YES];
        NSLog(@"timer made and fired");
    }
    self.requestsMade ++;
    self.returnedNothing = NO;
    //Make all indicators visible
    [UIApplication sharedApplication].networkActivityIndicatorVisible = TRUE;
    if (!spinner.isAnimating && spinner)[spinner startAnimating];
    if (!refreshControl.isRefreshing && refreshControl) [refreshControl beginRefreshing];
    
    //initialize the twitter wrapper
    STTwitterAPI *twitterWrapper = [STTwitterAPI twitterAPIOSWithFirstAccount];
    //verify that the twitter wrapper is good.
    [twitterWrapper verifyCredentialsWithSuccessBlock:^(NSString *username)
     {
         NSLog(@"Access granted for %@", username);
         
         //get the tweets for GCSSportstweets
         [twitterWrapper getUserTimelineWithScreenName:SPORTS_DESTINATION_TWITTER_USERNAME
                                               sinceID:sinceID
                                                 maxID:maxID
                                                 count:count
                                          successBlock:^(NSArray *statuses)
          {
              NSLog(@"SinceID: %@ MaxID: %@ Count: %i", sinceID.description, maxID.description, count);
              NSArray *tweetsToSetFromStatuses = [NSArray arrayWithArray:statuses];
              //If the since ID isn't set, set it to some value
              if (!self.sportSinceID) {
                  self.sportSinceID = [[statuses objectAtIndex:0] objectForKey:@"id_str"];
              }
              //filter through all the tweets that you just got to reset the since ID to the most recent tweet (tweet w/the largest id_str)
              if (statuses.count) {
                  for (NSDictionary *dict in statuses)
                  {
                      if ([self.sportSinceID longLongValue] < [[dict objectForKey:@"id_str"]longLongValue])
                      {
                          self.sportSinceID = [dict objectForKey:@"id_str"];
                      }
                  }
              }
              
              
              //Set the max ID to some initial value if it's nil
              if (!self.sportMaxID || [self.sportMaxID isEqualToString:@""]) {
                  self.sportMaxID = [[statuses objectAtIndex:0] objectForKey:@"id_str"];
              }
              //filter through all the statuses that were just retrieved, set to the least id_str value (the latest tweet)
              if (statuses.count) {
                  for (NSDictionary *dict in statuses)
                  {
                      if ([self.sportMaxID longLongValue] > [[dict objectForKey:@"id_str"]longLongValue])
                      {
                          self.sportMaxID = [NSString stringWithFormat:@"%lld",[[dict objectForKey:@"id_str"] longLongValue]-1];
                      }
                  }
              }
              
              
              
              //set the tweets that we just got from the statuses to the tweets of self
              if (sinceID){
                  NSLog(@"sinceID");
                  //If there was a since id passed to me, then we are looking for more recent tweets.
                  //Add the tweets that I just got to the beginning of self.sportsTweets
                  self.sportsTweets = [tweetsToSetFromStatuses arrayByAddingObjectsFromArray:self.sportsTweets];
              } else if (maxID) {
                  NSLog(@"maxID");
                  //else if there was a max id passed to me, then we are looking for earlier tweets.
                  //Add the tweets that I just got to the end of self.sportsTweets
                  self.sportsTweets = [self.sportsTweets arrayByAddingObjectsFromArray:tweetsToSetFromStatuses];
                  //if there are no more earlier tweets, set returnedNothing to YES
                  if (!tweetsToSetFromStatuses.count) {
                      NSLog(@"returned Nothing");
                      //self.returnedNothing = YES;
                  }
              } else if (!sinceID && !maxID)
              {
                  NSLog(@"neither since or max ID");
                  self.sportsTweets = tweetsToSetFromStatuses;
              }
              
              
              //stop the refresh control and the gear
              if ([spinner isAnimating])[spinner stopAnimating];
              if ([refreshControl isRefreshing]) [refreshControl endRefreshing];
              NSLog(@"sports tweets count = %lu", (unsigned long)self.sportsTweets.count);
              
              successBlock ();
          }errorBlock:^(NSError *error) {
              NSLog(@"-- error: %@", error);
              errorBlock();
          }];
         [NetworkIndicator stopNetworkIndicator];
     } errorBlock:^(NSError *error) {
         STTwitterAPI *twitterWrapper = [STTwitterAPI twitterAPIAppOnlyWithConsumerKey:CONSUMER_KEY consumerSecret:CONSUMER_SECRET];
         [twitterWrapper verifyCredentialsWithSuccessBlock:^(NSString *username)
          {
              NSLog(@"Access granted for %@", username);
              
              //get the tweets for GCSSportstweets
              [twitterWrapper getUserTimelineWithScreenName:SPORTS_DESTINATION_TWITTER_USERNAME
                                                    sinceID:sinceID
                                                      maxID:maxID
                                                      count:count
                                               successBlock:^(NSArray *statuses)
               {
                   NSLog(@"SinceID: %@ MaxID: %@ Count: %i", sinceID.description, maxID.description, count);
                   NSArray *tweetsToSetFromStatuses = [NSArray arrayWithArray:statuses];
                   //If the since ID isn't set, set it to some value
                   if (!self.sportSinceID) {
                       self.sportSinceID = [[statuses objectAtIndex:0] objectForKey:@"id_str"];
                   }
                   //filter through all the tweets that you just got to reset the since ID to the most recent tweet (tweet w/the largest id_str)
                   if (statuses.count) {
                       for (NSDictionary *dict in statuses)
                       {
                           if ([self.sportSinceID longLongValue] < [[dict objectForKey:@"id_str"]longLongValue])
                           {
                               self.sportSinceID = [dict objectForKey:@"id_str"];
                           }
                       }
                   }
                   
                   
                   //Set the max ID to some initial value if it's nil
                   if (!self.sportMaxID || [self.sportMaxID isEqualToString:@""]) {
                       self.sportMaxID = [[statuses objectAtIndex:0] objectForKey:@"id_str"];
                   }
                   //filter through all the statuses that were just retrieved, set to the least id_str value (the latest tweet)
                   if (statuses.count) {
                       for (NSDictionary *dict in statuses)
                       {
                           if ([self.sportMaxID longLongValue] > [[dict objectForKey:@"id_str"]longLongValue])
                           {
                               self.sportMaxID = [NSString stringWithFormat:@"%lld",[[dict objectForKey:@"id_str"] longLongValue]-1];
                           }
                       }
                   }
                   
                   
                   
                   //set the tweets that we just got from the statuses to the tweets of self
                   if (sinceID){
                       NSLog(@"sinceID");
                       //If there was a since id passed to me, then we are looking for more recent tweets.
                       //Add the tweets that I just got to the beginning of self.sportsTweets
                       self.sportsTweets = [tweetsToSetFromStatuses arrayByAddingObjectsFromArray:self.sportsTweets];
                   } else if (maxID) {
                       NSLog(@"maxID");
                       //else if there was a max id passed to me, then we are looking for earlier tweets.
                       //Add the tweets that I just got to the end of self.sportsTweets
                       self.sportsTweets = [self.sportsTweets arrayByAddingObjectsFromArray:tweetsToSetFromStatuses];
                       //if there are no more earlier tweets, set returnedNothing to YES
                       if (!tweetsToSetFromStatuses.count) {
                           NSLog(@"returned Nothing");
                           //self.returnedNothing = YES;
                       }
                   } else if (!sinceID && !maxID)
                   {
                       NSLog(@"neither since or max ID");
                       self.sportsTweets = tweetsToSetFromStatuses;
                   }
                   
                   
                   //stop the refresh control and the gear
                   if ([spinner isAnimating])[spinner stopAnimating];
                   if ([refreshControl isRefreshing]) [refreshControl endRefreshing];
                   NSLog(@"sports tweets count = %lu", (unsigned long)self.sportsTweets.count);
                   
                   successBlock ();
               }errorBlock:^(NSError *error) {
                   NSLog(@"-- error: %@", error);
                   errorBlock();
               }];
              [NetworkIndicator stopNetworkIndicator];
          } errorBlock:^(NSError *error) {
              NSLog(@"-- error: %@", error);
              errorBlock();
          }];
     }];
}
//---------------------------------------


#pragma mark  Getting More Sports Tweets

//---------------------------------------
//Getting more Sports Tweets:
//---------------------------------------

-(void) getPreviousSportsTweetsWithSpinner:(UIActivityIndicatorView *)spinner
                         noMoreTweetsLabel: (UILabel *) noMoreTweetsLabel
                              successBlock:(void(^)())successBlock
                                errorBlock:(void(^)())errorBlock
{
    NSLog(@"Previous Sports Tweets");
    if (!self.returnedNothing && self.requestsMade <= MAX_NUMBER_OF_TWITTER_REQUESTS) {
        if(noMoreTweetsLabel.hidden==NO) noMoreTweetsLabel.hidden = YES;
        [self getSportsTweetsWithCount:DEFAULT_NUMBER_OF_TWEETS_TO_RETRIEVE SinceID:nil andMaxID:self.sportMaxID andSpinner:spinner orRefreshControl:nil successBlock:successBlock errorBlock:errorBlock];
    } else {
        [spinner stopAnimating];
        noMoreTweetsLabel.hidden = NO;
        errorBlock();
    }
}

-(void) getMoreRecentSportsTweetsWithRefreshControl:(UIRefreshControl *)refreshControl
                                       successBlock:(void(^)())successBlock
                                         errorBlock:(void(^)())errorBlock
{
    NSLog(@"More Recent Sports Tweets");
    if (!self.sportsTweets.count) {
        [self getSportsTweetsWithCount:DEFAULT_NUMBER_OF_TWEETS_TO_RETRIEVE SinceID:nil andMaxID:nil andSpinner:nil orRefreshControl:refreshControl successBlock:successBlock errorBlock:errorBlock];
    } else {
        [self getSportsTweetsWithCount:DEFAULT_NUMBER_OF_TWEETS_TO_RETRIEVE SinceID:self.sportSinceID andMaxID:nil andSpinner:nil orRefreshControl:refreshControl successBlock:successBlock errorBlock:errorBlock];
    }
    
}
//---------------------------------------

#pragma mark - Announcement Tweets

//---------------------------------------
//Announcement Tweets:
//---------------------------------------

-(void) getAnnouncementTweetsWithCount:(int)count
                               SinceID:(NSString *)sinceID
                              andMaxID:(NSString *)maxID
                            andSpinner:(UIActivityIndicatorView *)spinner
                      orRefreshControl:(UIRefreshControl *)refreshControl
                          successBlock:(void(^)())successBlock
                            errorBlock:(void(^)())errorBlock
{
    NSLog(@"getAnnouncementTweets");
    if (!self.timer) {
        self.timer = [NSTimer scheduledTimerWithTimeInterval:TIME_INTERVAL_TWITTTER_REQUEST_SECONDS
                                                      target:self
                                                    selector:@selector(setRequestsMadeToZero)
                                                    userInfo:nil
                                                     repeats:YES];
        NSLog(@"timer made and fired");
    }
    self.requestsMade ++;
    self.returnedNothing = NO;
    //Make all indicators visible
    [NetworkIndicator startNetworkIndicator];
    if (!spinner.isAnimating && spinner)[spinner startAnimating];
    if (!refreshControl.isRefreshing && refreshControl) [refreshControl beginRefreshing];
    
    //initialize the twitter wrapper
    STTwitterAPI *twitterWrapper = [STTwitterAPI twitterAPIAppOnlyWithConsumerKey:CONSUMER_KEY consumerSecret:CONSUMER_SECRET];
    
    //verify that the twitter wrapper is good.
    [twitterWrapper verifyCredentialsWithSuccessBlock:^(NSString *username)
     {
         NSLog(@"Access granted for %@", username);
         
         //get the tweets for GCSSportstweets
         [twitterWrapper getUserTimelineWithScreenName:ANNOUNCEMENTS_DESTINATION_TWITTER_USERNAME
                                               sinceID:sinceID
                                                 maxID:maxID
                                                 count:count
                                          successBlock:^(NSArray *statuses)
          {
              if (statuses.count) {
                  
                  NSLog(@"SinceID: %@ MaxID: %@ Count: %i", sinceID.description, maxID.description, count);
                  NSArray *tweetsToSetFromStatuses = [NSArray arrayWithArray:statuses];
                  //If the since ID isn't set, set it to some value
                  if (!self.announcementSinceID) {
                      self.announcementSinceID = [[statuses objectAtIndex:0] objectForKey:@"id_str"];
                  }
                  //filter through all the tweets that you just got to reset the since ID to the most recent tweet (tweet w/the largest id_str)
                  if (statuses.count) {
                      for (NSDictionary *dict in statuses)
                      {
                          if ([self.announcementSinceID longLongValue] < [[dict objectForKey:@"id_str"]longLongValue])
                          {
                              self.announcementSinceID = [dict objectForKey:@"id_str"];
                          }
                      }
                  }
                  
                  
                  //Set the max ID to some initial value if it's nil
                  if (!self.announcementMaxID || [self.announcementMaxID isEqualToString:@""]) {
                      self.announcementMaxID = [[statuses objectAtIndex:0] objectForKey:@"id_str"];
                  }
                  //filter through all the statuses that were just retrieved, set to the least id_str value (the latest tweet)
                  if (statuses.count) {
                      for (NSDictionary *dict in statuses)
                      {
                          if ([self.announcementMaxID longLongValue] > [[dict objectForKey:@"id_str"]longLongValue])
                          {
                              self.announcementMaxID = [NSString stringWithFormat:@"%lld",[[dict objectForKey:@"id_str"] longLongValue]-1];
                          }
                      }
                  }
                  
                  
                  
                  //set the tweets that we just got from the statuses to the tweets of self
                  if (sinceID){
                      NSLog(@"sinceID");
                      //If there was a since id passed to me, then we are looking for more recent tweets.
                      //Add the tweets that I just got to the beginning of self.sportsTweets
                      self.announcementTweets = [tweetsToSetFromStatuses arrayByAddingObjectsFromArray:self.announcementTweets];
                  } else if (maxID) {
                      NSLog(@"maxID");
                      //else if there was a max id passed to me, then we are looking for earlier tweets.
                      //Add the tweets that I just got to the end of self.sportsTweets
                      self.announcementTweets = [self.announcementTweets arrayByAddingObjectsFromArray:tweetsToSetFromStatuses];
                      //if there are no more earlier tweets, set returnedNothing to YES
                      if (!tweetsToSetFromStatuses.count) {
                          NSLog(@"returned Nothing");
                          //self.returnedNothing = YES;
                      }
                  } else if (!sinceID && !maxID)
                  {
                      NSLog(@"neither since or max ID");
                      self.announcementTweets = tweetsToSetFromStatuses;
                  }
                  
              }
              
              //stop the refresh control and the gear
              if ([spinner isAnimating])[spinner stopAnimating];
              if ([refreshControl isRefreshing]) [refreshControl endRefreshing];
              NSLog(@"sports tweets count = %lu", (unsigned long)self.announcementTweets.count);
              
              successBlock ();
          }errorBlock:^(NSError *error) {
              NSLog(@"-- error: %@", error);
              errorBlock();
          }];
         [NetworkIndicator stopNetworkIndicator];
     } errorBlock:^(NSError *error) {
         NSLog(@"-- error %@", error);
         errorBlock();
     }];
}
//---------------------------------------

#pragma mark  Getting More Announcement Tweets

//---------------------------------------
//Getting More Announcement Tweets:
//---------------------------------------
-(void) getPreviousAnnouncementTweetsWithSpinner:(UIActivityIndicatorView *)spinner
                                    successBlock:(void(^)())successBlock
                                      errorBlock:(void(^)())errorBlock
{
    NSLog(@"Previous Sports Tweets");
    if (!self.returnedNothing && self.requestsMade <= MAX_NUMBER_OF_TWITTER_REQUESTS) {
        [self getAnnouncementTweetsWithCount:DEFAULT_NUMBER_OF_TWEETS_TO_RETRIEVE
                                     SinceID:nil
                                    andMaxID:self.sportMaxID
                                  andSpinner:spinner
                            orRefreshControl:nil
                                successBlock:successBlock
                                  errorBlock:errorBlock];
    } else {
        [spinner stopAnimating];
        errorBlock();
    }
}


-(void) getMoreRecentAnnouncementTweetsWithRefreshControl:(UIRefreshControl *)refreshControl
                                             successBlock:(void(^)())successBlock
                                               errorBlock:(void(^)())errorBlock
{
    NSLog(@"More Recent Announcement Tweets");
    if (!self.announcementTweets.count) {
        [self getAnnouncementTweetsWithCount:DEFAULT_NUMBER_OF_TWEETS_TO_RETRIEVE
                                     SinceID:nil
                                    andMaxID:nil
                                  andSpinner:nil
                            orRefreshControl:refreshControl
                                successBlock:successBlock
                                  errorBlock:errorBlock];
    } else {
        [self getAnnouncementTweetsWithCount:DEFAULT_NUMBER_OF_TWEETS_TO_RETRIEVE
                                     SinceID:self.announcementSinceID
                                    andMaxID:nil
                                  andSpinner:nil
                            orRefreshControl:refreshControl
                                successBlock:successBlock errorBlock:errorBlock];
    }
    
}
//---------------------------------------




@end
