//
//  TwitterFetcher.m
//  Goodpasture Application
//
//  Created by Phillip Trent on 7/8/13.
//  Copyright (c) 2013 Phillip Trent Coding. All rights reserved.
//

#import "TwitterFetcher.h"
#import <Accounts/Accounts.h>
#import <Social/Social.h>

#import "TwitterLoginInfoAndKey.h"
@interface TwitterFetcher()

@end

@implementation TwitterFetcher
+(NSArray *) searchTweetText: (NSArray *) tweets forString: (NSString *) string
{
    NSMutableArray *tweetsContainingString = [[NSMutableArray alloc] init];
    
    for (NSDictionary *dict in tweets) {
        
        NSString *tweet = [NSString stringWithString:[dict objectForKey:@"text"]];
        
        if ([tweet rangeOfString:string options:NSCaseInsensitiveSearch].length) {
            [tweetsContainingString addObject:dict];
        }
    }
    return [tweetsContainingString copy];
}

@end