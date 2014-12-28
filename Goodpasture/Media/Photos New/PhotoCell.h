//
//  PhotoCell.h
//  Goodpasture
//
//  Created by Phillip Trent on 7/17/14.
//  Copyright (c) 2014 Phillip Trent Coding. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PhotoCell : UICollectionViewCell
@property (strong, nonatomic) NSURL *photoURL;
@property (strong, nonatomic) NSData *imageData;
@property (nonatomic) BOOL black;
@end
