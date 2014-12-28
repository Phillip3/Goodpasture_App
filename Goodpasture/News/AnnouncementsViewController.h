//
//  AnnouncementsViewController.h
//  Goodpasture Application
//
//  Created by Phillip Trent on 8/30/13.
//  Copyright (c) 2013 Phillip Trent Coding. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TweetStorage.h"
@interface AnnouncementsViewController : UITableViewController
@property (weak, nonatomic) TweetStorage *tweetStorage;
@end
