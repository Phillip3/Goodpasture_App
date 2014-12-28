//
//  TweetStorage.h
//  Goodpasture
//
//  Created by Phillip Trent on 11/26/13.
//  Copyright (c) 2013 Phillip Trent Coding. All rights reserved.
//
// Everything in here should happen on an alternate thread. You need to make sure to take care of all spinners and indicators.
#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface TweetStorage : NSObject
@property (strong, nonatomic) NSArray *sportsTweets;
@property (strong, nonatomic) NSArray *announcementTweets;
@property (strong, nonatomic) UIAlertView *problemsAccessingTwitter;
@property (strong, nonatomic) UIAlertView *tooManyRequestsMade;

-(void) getSportsTweetsFilteredWithWord:(NSString *)word
                           successBlock:(void(^)(NSArray* tweets))successBlock;

-(void) getPreviousSportsTweetsWithSpinner:(UIActivityIndicatorView *)spinner
                         noMoreTweetsLabel: (UILabel *) noMoreTweetsLabel
                              successBlock:(void(^)())successBlock
                                errorBlock:(void(^)())errorBlock;

-(void) getMoreRecentSportsTweetsWithRefreshControl:(UIRefreshControl *)refreshControl
                                       successBlock:(void(^)())successBlock
                                         errorBlock:(void(^)())errorBlock;

-(void) getPreviousAnnouncementTweetsWithSpinner:(UIActivityIndicatorView *)spinner
                                    successBlock:(void(^)())successBlock
                                      errorBlock:(void(^)())errorBlock;


-(void) getMoreRecentAnnouncementTweetsWithRefreshControl:(UIRefreshControl *)refreshControl
                                             successBlock:(void(^)())successBlock
                                               errorBlock:(void(^)())errorBlock;

@end
