//
//  HomeViewController.m
//  Goodpasture Application
//
//  Created by Phillip Trent on 7/5/13.
//  Copyright (c) 2013 Phillip Trent Coding. All rights reserved.
//

#import "HomeViewController.h"
#import "HomeCellView.h"
#import "TweetStorage.h"
#import "HomeModel-Swift.h"

@interface HomeViewController () <UICollectionViewDataSource, UICollectionViewDelegate>
@property (strong, nonatomic) HomeModel *model;
@property (strong, nonatomic) TweetStorage *tweetStorage;
@property (strong, nonatomic) NSArray *allCells;
@property (strong, nonatomic) IBOutlet UICollectionView *collectionView;
@property (strong, nonatomic) HomeCellView *currentlyTouchedCell;
@end


@implementation HomeViewController

//---------------------------------------
//Setup Methods:
//---------------------------------------
-(HomeModel *) model
{
    if (!_model) _model = [[HomeModel alloc] initWithAllCells];
    return _model;
}
-(TweetStorage *) tweetStorage
{
    if (!_tweetStorage) _tweetStorage = [[TweetStorage alloc] init];
    NSLog(@"TweetStorage alloc init");
    return _tweetStorage;
}
-(void) setupCell: (HomeCellView *) cell withInfo: (HomeCell *) homeCell
{
    cell.name = homeCell.name;
    cell.circleStrokeColor = homeCell.circleStrokeColor;
}
-(void) setup
{
    self.allCells = @[self.model.sports, self.model.media, self.model.news, self.model.grades, self.model.calendar, self.model.about];
}
//---------------------------------------


//---------------------------------------
//Taps:
//---------------------------------------

-(IBAction)longPress:(UILongPressGestureRecognizer*)sender
{
    CGPoint location = [sender locationInView:self.view];
    NSIndexPath *path = [self.collectionView indexPathForItemAtPoint:location];
    HomeCellView *cell = (HomeCellView *) [self.collectionView cellForItemAtIndexPath:path];
    
    if (sender.state == UIGestureRecognizerStateBegan) {
        NSLog(@"Began");
        cell.tapped = YES;
        self.currentlyTouchedCell = cell;
    } else if (sender.state == UIGestureRecognizerStateCancelled) {
        NSLog(@"Cancelled");
        [self.currentlyTouchedCell fadeToSolid];
    } else if (sender.state == UIGestureRecognizerStateChanged) {
        NSLog(@"Changed");
        if (self.currentlyTouchedCell != cell) {
            sender.enabled = NO;
        }
    } else if (sender.state == UIGestureRecognizerStateEnded) {
        NSLog(@"Ended");
        [cell fadeToSolid];
        if ([cell.name  isEqualToString: @"#Sports"]) {
            [self performSegueWithIdentifier:@"toVersus" sender:self];
            
        } else if ([cell.name isEqualToString:@"Media"]){
            [self performSegueWithIdentifier:@"toMedia" sender:self];
            
        } else if ([cell.name isEqualToString:@"News"]){
            [self performSegueWithIdentifier:@"toAnnouncements" sender:self];
            
        } else if ([cell.name isEqualToString:@"Grades"]){
            [self performSegueWithIdentifier:@"toGrades" sender:self];
            
        } else if ([cell.name isEqualToString:@"Calendar"]){
            [self performSegueWithIdentifier:@"toUpcomingEvents" sender:self];
            
        } else if ([cell.name isEqualToString:@"About"]){
            [self performSegueWithIdentifier:@"toAbout" sender:self];
        }
    } else if (sender.state == UIGestureRecognizerStateFailed) {
        NSLog(@"Failed");
        [cell fadeToSolid];
    }
    sender.enabled = YES;
}
//---------------------------------------

//---------------------------------------
//CollectionView Data Source:
//---------------------------------------
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    HomeCellView *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"Cell" forIndexPath:indexPath];
    cell.circleStrokeColor = [self.allCells[indexPath.item] circleStrokeColor];
    cell.name = [self.allCells[indexPath.item] name];
    
    return cell;
}
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return 6;
}

//---------------------------------------


//---------------------------------------
//Lifecycle:
//---------------------------------------
- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setup];
    self.title = @"Home";
}
-(void) viewWillAppear:(BOOL)animated
{
    if (!self.navigationController.navigationBarHidden)[self.navigationController setNavigationBarHidden:YES animated:YES];
    [self.navigationController.navigationBar setBackgroundColor:[UIColor clearColor]];
}
-(void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.destinationViewController respondsToSelector:@selector(setTweetStorage:)]) {
        
        [segue.destinationViewController setTweetStorage:self.tweetStorage];
    }
}
//---------------------------------------
@end
