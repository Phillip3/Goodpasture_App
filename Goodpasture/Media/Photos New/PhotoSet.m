//
//  PhotoSet.m
//  Goodpasture Application
//
//  Created by Phillip Trent on 10/16/13.
//  Copyright (c) 2013 Phillip Trent Coding. All rights reserved.
//

#import "PhotoSet.h"

@implementation PhotoSet
-(PhotoSet *)initWithTitle:(NSString *)title
                        ID:(NSString *)setID
               description:(NSString *)setDescription
                 imageData:(NSData *)imageData
{
    PhotoSet *photoSet = [[PhotoSet alloc] init];
    photoSet.title = [NSString stringWithString:title];
    photoSet.setID = [NSString stringWithString:setID];
    photoSet.setDescription = [NSString stringWithString:setDescription];
    photoSet.imageData = [NSData dataWithData:imageData];
    return photoSet;
}
@end
