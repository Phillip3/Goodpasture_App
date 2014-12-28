//
//  FlickrPhotoSetCollectionViewController.m
//  Goodpasture Application
//
//  Created by Phillip Trent on 10/16/13.
//  Copyright (c) 2013 Phillip Trent Coding. All rights reserved.
//

#define KEY_FOR_CELL [NSString stringWithFormat:@"%li", (long)indexPath.item]

#import "FlickrPhotoSetCollectionViewController.h"
#import "FlickrFetcher.h"
#import "FlickrPhotoCell.h"


@interface FlickrPhotoSetCollectionViewController ()
@property (strong, nonatomic) NSArray *flickrPhotos;
@property (strong, nonatomic) NSCache *flickrCellData;
@end

@implementation FlickrPhotoSetCollectionViewController
@synthesize photoSetID = _photoSetID;
-(void) setPhotoSetID:(NSString *)photoSetID
{
    _photoSetID = photoSetID;
    [self getPhotosForPhotoset];
}
-(NSString *) photoSetID
{
    if (!_photoSetID) {
        _photoSetID = [[NSString alloc] init];
    }
    return _photoSetID;
}
-(NSArray *) flickrPhotos{
    if (!_flickrPhotos) {
        _flickrPhotos = [[NSArray alloc] init];
    }
    return _flickrPhotos;
}
-(NSCache *) flickrCellData
{
    if (!_flickrCellData) {
        _flickrCellData = [[NSCache alloc] init];
    }
    return _flickrCellData;
}

-(void) getPhotosForPhotoset
{
    dispatch_queue_t fetchQ = dispatch_queue_create("Flickr PhotoSet Fetch", NULL);
    dispatch_async(fetchQ, ^{
        self.flickrPhotos = [FlickrFetcher getPhotosForPhotoSet:self.photoSetID withNumberOfPhotos:100 andPageNumber:1];
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.collectionView reloadData];
            if (!self.flickrPhotos.count) {
                [self showTheAccessToFlickrAlert];
            }
        });
    });
}
-(void) showTheAccessToFlickrAlert
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Oops!" message:@"Sorry! It seems that there was a problem accessing Flickr. Please try again later." delegate:Nil cancelButtonTitle:@"Dismiss" otherButtonTitles:nil];
    [alert show];
}
-(void) collectionView:(UICollectionView *)collectionView didEndDisplayingCell:(FlickrPhotoCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (![self.flickrCellData objectForKey:KEY_FOR_CELL]) {
        NSData *photoData = [NSData dataWithData:cell.imageData];
        [self.flickrCellData setObject:photoData forKey:KEY_FOR_CELL];
    }
    NSData *blackImage = [NSData dataWithContentsOfFile:@"default.jpg"];
    cell.imageData = blackImage;
}
-(void) collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    [self performSegueWithIdentifier:@"toPhoto" sender:self.flickrPhotos[indexPath.item]];
}
#pragma mark DataSource methods


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.flickrPhotos.count;
}


- (FlickrPhotoCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *identifier = @"Cell";
    [self.collectionView registerClass:[FlickrPhotoCell class] forCellWithReuseIdentifier:@"Cell"];
    FlickrPhotoCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
    if ([self.flickrCellData objectForKey:KEY_FOR_CELL]) {
        cell.imageData = [self.flickrCellData objectForKey:KEY_FOR_CELL];
    } else {
        cell.url = [FlickrFetcher urlForPhoto:self.flickrPhotos[indexPath.item] format:FlickrPhotoFormatLargeSquare];
    }
    return cell;
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = self.photoSetTitle;
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark Navigation-

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"toPhoto"]) {
        if ([sender isKindOfClass:[NSDictionary class]]) {
            NSDictionary *photoSender = (NSDictionary *)sender;
            if (photoSender) {
                if([[segue destinationViewController] respondsToSelector:@selector(setPhoto:)]) {
                    [[segue destinationViewController] performSelector:@selector(setPhoto:) withObject:photoSender];
                } else NSLog(@"Error: the destination view controller for toPhotoSet does not respond to setPhoto:");
                if([[segue destinationViewController] respondsToSelector:@selector(setPhotoArray:)]) {
                    [[segue destinationViewController] performSelector:@selector(setPhotoArray:) withObject:self.flickrPhotos];
                } else NSLog(@"Error: the destination view controller for toPhotoSet does not respond to setPhoto:");
            } else NSLog(@"Error: the NSDictionary *photoSender failed to initialize in prepareForSegue");
        } else NSLog(@"Error: the sender is not an NSDictionary");
    } else NSLog(@"Error: the segue identifier is not a toPhoto");
}
-(void) viewDidDisappear:(BOOL)animated
{
    [UIApplication sharedApplication].networkActivityIndicatorVisible = false;
}

@end
