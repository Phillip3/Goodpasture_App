//
//  HomeCellView.h
//  Goodpasture Application
//
//  Created by Phillip Trent on 7/5/13.
//  Copyright (c) 2013 Phillip Trent Coding. All rights reserved.
//

#import <UIKit/UIKit.h>
@interface HomeCellView : UICollectionViewCell
@property (strong, nonatomic) NSString *name;
@property (strong, nonatomic) UIColor *circleStrokeColor;
@property (nonatomic) BOOL tapped;
-(void) fadeToSolid;
@end
