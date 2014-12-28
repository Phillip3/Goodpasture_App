//
//  MediaViewController.m
//  Goodpasture Application
//
//  Created by Phillip Trent on 7/14/13.
//  Copyright (c) 2013 Phillip Trent Coding. All rights reserved.
//

#import "MediaViewController.h"
#import "NSObject_UniversalHeader.h"
#define RED 0.2
#define GREEN 0.8
#define BLUE 0
@interface MediaViewController () <UICollectionViewDataSource, UICollectionViewDelegate>
@property (strong, nonatomic) IBOutlet UICollectionView *collectionView;

@end

@implementation MediaViewController
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *identifier = @"";
    UICollectionViewCell *cell;
    if (indexPath.item == 0) {
        identifier = @"Photos";
    } else if (indexPath.item == 1) {
        identifier = @"Videos";
    }
    cell = [self.collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
    return cell;
}
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return 2;
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    if (self.navigationController.navigationBarHidden) {
        [self.navigationController setNavigationBarHidden:NO animated:YES];
    }
    //[self.navigationController.navigationBar setBackgroundColor:[UIColor colorWithRed:RED green:GREEN blue:BLUE alpha:0.5]];
    [self.navigationController.navigationBar setTintColor:[UIColor colorWithRed:RED green:GREEN blue:BLUE alpha:1.0]];

    for (UIBarButtonItem *item in self.navigationController.toolbarItems) {
        [item setTintColor:[UIColor colorWithRed:RED green:GREEN blue:BLUE alpha:1.0]];
    }
    self.navigationController.title = @"Media";
    self.title = @"Media";
}
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell *cell = [collectionView cellForItemAtIndexPath:indexPath];
    if ([cell.reuseIdentifier isEqualToString:@"Photos"]){
        
        [self performSegueWithIdentifier:@"toPhotos" sender:self];
        
    } else if ([cell.reuseIdentifier isEqualToString:@"Videos"])
    {
        [self performSegueWithIdentifier:@"toVideos" sender:self];

    }
}
@end
