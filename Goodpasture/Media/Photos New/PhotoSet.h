//
//  PhotoSet.h
//  Goodpasture Application
//
//  Created by Phillip Trent on 10/16/13.
//  Copyright (c) 2013 Phillip Trent Coding. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PhotoSet : NSObject
@property (strong, nonatomic) NSString *title;
@property (strong, nonatomic) NSString *setID;
@property (strong, nonatomic) NSString *setDescription;
@property (strong, nonatomic) NSData *imageData;

-(PhotoSet *)initWithTitle:(NSString *)title
                        ID:(NSString *)setID
               description:(NSString *)setDescription
                 imageData:(NSData *)imageData;
@end
