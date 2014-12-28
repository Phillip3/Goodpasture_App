//
//  FlickrPhotoViewController.m
//  Goodpasture Application
//
//  Created by Phillip Trent on 10/16/13.
//  Copyright (c) 2013 Phillip Trent Coding. All rights reserved.
//
#define KEY_FOR_CELL [NSString stringWithFormat:@"%li", (long)indexPath.item]

#import "FlickrPhotoViewController.h"
#import "FlickrFetcher.h"
#import "PhotoCell.h"


@interface FlickrPhotoViewController () <UICollectionViewDelegate, UICollectionViewDataSource>
@property (strong, nonatomic) IBOutlet UICollectionView *collectionView;
@property (strong, nonatomic) NSCache *flickrCellData;
@end

@implementation FlickrPhotoViewController
@synthesize photo = _photo;
-(NSCache *)flickrCellData
{
    if (!_flickrCellData) {
        _flickrCellData = [[NSCache alloc]init];
    }
    return _flickrCellData;
}
-(NSDictionary *) photo
{
    if (!_photo) _photo = [[NSDictionary alloc] init];
    return _photo;
}
- (IBAction)doneButton:(UIButton *)sender {
    [self dismissViewControllerAnimated:YES completion:^(){}];
}

#pragma mark Getting the Photo Methods

#pragma mark UIViewController Methods
- (void)viewDidLoad
{
    [super viewDidLoad];
    
	// Do any additional setup after loading the view.
}
-(void)viewDidLayoutSubviews
{
    if (![self.photo  isEqual: @{@"": @""}]) {
        NSInteger indexOfPhotoInArray = [self.photoArray indexOfObject:self.photo];
        NSIndexPath *indexPath = [NSIndexPath indexPathForItem:indexOfPhotoInArray inSection:0];
        [self.collectionView scrollToItemAtIndexPath:indexPath atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:NO];
        NSLog(@"viewWillAppear with photo array count = %lu, index of photo = %li", (unsigned long)self.photoArray.count, (long)indexOfPhotoInArray);
        self.photo = @{@"": @""};
    }
}
#pragma mark UICollectionView Methods
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    PhotoCell *cell = [self.collectionView dequeueReusableCellWithReuseIdentifier:@"Photo" forIndexPath:indexPath];
    if ([self.flickrCellData objectForKey:KEY_FOR_CELL]) {
        cell.imageData = [self.flickrCellData objectForKey:KEY_FOR_CELL];
        NSLog(@"imageData set for cell item number %li", (long)indexPath.item);
    } else {
        cell.photoURL = [FlickrFetcher urlForPhoto:self.photoArray[indexPath.item] format:FlickrPhotoFormatLarge];
        NSLog(@"photoURL set for item number %li", (long)indexPath.item);
    }
    return cell;
}
-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*) collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    CGFloat width = self.collectionView.frame.size.width - 16;
    CGFloat height = self.collectionView.frame.size.height - 16;
    CGFloat lesser;
    
    if (width>height)lesser = height;
    else lesser = width;
    
    CGSize cellSize = CGSizeMake(lesser, lesser);
    return cellSize;
}
-(void)collectionView:(UICollectionView *)collectionView didEndDisplayingCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath
{
    PhotoCell *photoCell = (PhotoCell *) cell;
    if (![self.flickrCellData objectForKey:KEY_FOR_CELL]) {
        NSData *photoData = [NSData dataWithData:photoCell.imageData];
        [self.flickrCellData setObject:photoData forKey:KEY_FOR_CELL];
    }
    photoCell.imageData = nil;
    photoCell.black = YES;
}
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.photoArray.count;
}
@end
