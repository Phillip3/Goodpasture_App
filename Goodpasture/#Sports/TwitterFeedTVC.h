//
//  Header.h
//  Goodpasture
//
//  Created by Phillip Trent on 12/26/14.
//  Copyright (c) 2014 Phillip Trent. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TweetStorage.h"

@interface TwitterFeedTVC : UITableViewController
@property (strong, nonatomic) TweetStorage *tweetStorage;
@end
