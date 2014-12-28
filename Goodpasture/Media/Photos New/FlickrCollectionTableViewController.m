//
//  FlickrCollectionTableViewController.m
//  Goodpasture Application
//
//  Created by Phillip Trent on 10/16/13.
//  Copyright (c) 2013 Phillip Trent Coding. All rights reserved.
//

#import "FlickrCollectionTableViewController.h"
#import "PhotoSet.h"
#import "FlickrFetcher.h"
#import "FlickrPhotoCell.h"
#import "NSObject_UniversalHeader.h"
#define RED 0.2
#define GREEN 0.8
#define BLUE 0
@interface FlickrCollectionTableViewController ()
@property (strong, nonatomic) NSArray *allPhotosets;
@end

@implementation FlickrCollectionTableViewController
-(NSArray *) allPhotosets
{
    if (!_allPhotosets) {
        _allPhotosets = [[NSArray alloc] init];
    }
    return _allPhotosets;
}
-(NSIndexPath *) tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"Selected row at index %li which is %@", (long)indexPath.row, [self titleForRow:indexPath.row]);
    [self performSegueWithIdentifier:@"toPhotoSet" sender:self.allPhotosets[indexPath.row]];
    return indexPath;
}
- (IBAction)refresh {
    
    [UIApplication sharedApplication].networkActivityIndicatorVisible = true;
    if (!self.refreshControl.isRefreshing)[self.refreshControl beginRefreshing];
    if (self.refreshControl.hidden) self.refreshControl.hidden = NO;
    
    dispatch_queue_t fetchQ = dispatch_queue_create("PhotoSetQueue", NULL);
    dispatch_async(fetchQ, ^{
        
        NSMutableArray *photoSetsToSetFromFlickr = [[NSMutableArray alloc] init];
        NSArray *photoSets = [FlickrFetcher getPhotoSetsForApplicationCollection];
        
        for (NSDictionary *set in photoSets)
        {
            PhotoSet *photoSet = [[PhotoSet alloc] initWithTitle:[set objectForKey:@"title"] ID:[set objectForKey:@"id"] description:[set objectForKey:@"description"] imageData:nil];
            [photoSetsToSetFromFlickr addObject:photoSet];
            NSLog(@"%@ %@ %@", photoSet.title, photoSet.setDescription, photoSet.setID);
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            //prettily insert tableview cells
            NSMutableArray *indexPaths = [NSMutableArray array];
            for (int i = 0; i<photoSetsToSetFromFlickr.count; i++) {
                if (!self.allPhotosets.count) {
                    //get all the index paths to insert
                    NSIndexPath *indexPath = [NSIndexPath indexPathForItem:i inSection:0];
                    [indexPaths addObject:indexPath];
                }
            }
            self.allPhotosets = [photoSetsToSetFromFlickr copy];
            [self.tableView insertRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationAutomatic];
            
            if (self.refreshControl.isRefreshing)[self.refreshControl endRefreshing];
            if (!self.refreshControl.hidden) self.refreshControl.hidden = YES;
            [UIApplication sharedApplication].networkActivityIndicatorVisible = false;
            NSLog(@"%lu", (unsigned long)self.allPhotosets.count);
            if (!self.allPhotosets.count) {
                [self showTheAccessToFlickrAlert];
            }
        });
    });

}
-(void) showTheAccessToFlickrAlert
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"This is embarrassing..." message:@"Sorry! It seems that there was a problem accessing Flickr. To refresh, pull down. " delegate:Nil cancelButtonTitle:@"Dismiss" otherButtonTitles:nil];
    [alert show];
    if ([self.refreshControl isRefreshing])[self.refreshControl endRefreshing];
    [self.refreshControl setHidden:YES];
    
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return self.allPhotosets.count;
}
-(NSString *) descriptionForRow:(NSUInteger)row
{
    NSString *returnValue;
    returnValue = [[self.allPhotosets[row] setDescription] description];
    return returnValue;
}
-(NSString *) titleForRow:(NSUInteger)row
{
    NSString *returnValue;
    returnValue = [[self.allPhotosets[row] title] description];
    return returnValue;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self refresh];
    [self.tableView setSeparatorColor:[UIColor colorWithRed:RED green:GREEN blue:BLUE alpha:1.0]];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Set";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    // Configure the cell...
    cell.textLabel.text = [self titleForRow:indexPath.row];
    cell.detailTextLabel.text = [self descriptionForRow:indexPath.row];
    
    return cell;
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"toPhotoSet"]) {
        if ([sender isKindOfClass:[PhotoSet class]]) {
            PhotoSet *photoSetSender = (PhotoSet *)sender;
            if (photoSetSender) {
                if([[segue destinationViewController] respondsToSelector:@selector(setPhotoSetID:)]) {
                    [[segue destinationViewController] performSelector:@selector(setPhotoSetID:) withObject:photoSetSender.setID];
                } else NSLog(@"Error: the destination view controller for toPhotoSet does not respond to setPhotoSetID:");
                if([[segue destinationViewController] respondsToSelector:@selector(setPhotoSetTitle:)]) {
                    [[segue destinationViewController] performSelector:@selector(setPhotoSetTitle:) withObject:photoSetSender.title];
                } else NSLog(@"Error: the destination view controller for toPhotoSet does not respond to setPhotoSetID:");
            } else NSLog(@"Error: the PhotoSet failed to initialize in prepareForSegue");
        } else NSLog(@"Error: the sender from FlickrCollectionTableView is not a PhotoSet");
    } else NSLog(@"Error: the segue identifier is not a toPhotoSet");
}



@end
