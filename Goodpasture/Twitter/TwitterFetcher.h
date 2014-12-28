//
//  TwitterFetcher.h
//  Goodpasture Application
//
//  Created by Phillip Trent on 7/8/13.
//  Copyright (c) 2013 Phillip Trent Coding. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "STTwitter.h"

@interface TwitterFetcher : NSObject
+(NSArray *) searchTweetText: (NSArray *) tweets forString: (NSString *) string;
@end
