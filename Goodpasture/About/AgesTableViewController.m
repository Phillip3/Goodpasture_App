//
//  AgesTableViewController.m
//  Goodpasture
//
//  Created by Phillip Trent on 11/23/13.
//  Copyright (c) 2013 Phillip Trent Coding. All rights reserved.
//

#import "AgesTableViewController.h"
#import "NSObject_UniversalHeader.h"

@interface AgesTableViewController ()
@property (strong, nonatomic) NSArray *agesNames;
@property (strong, nonatomic) NSArray *agesSubtitles;
@end

@implementation AgesTableViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    if (self.navigationController.navigationBarHidden) {
        [self.navigationController setNavigationBarHidden:NO animated:YES];
    }
    //[self.tableView setBackgroundColor:[UIColor colorWithRed:0.116 green:0.388 blue:0.96 alpha:1.0]];
    self.agesNames = AGES_NAMES;
    self.agesSubtitles = AGES_SUBTITLES;
}
-(void)viewDidLayoutSubviews
{
    [self.view layoutIfNeeded];
}
#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.agesNames.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Age";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    cell.textLabel.text = [self.agesNames[indexPath.row] description];
    cell.detailTextLabel.text = [self.agesSubtitles[indexPath.row] description];
    
    return cell;
}
-(void) viewDidAppear:(BOOL)animated
{
    [self.view layoutSubviews];
}
#pragma mark - Navigation

// In a story board-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([sender isKindOfClass:[UITableViewCell class]]) {
        UITableViewCell *cell = (UITableViewCell*)sender;
        if ([segue.destinationViewController respondsToSelector:@selector(setName:)]) {
            NSUInteger index = [self.agesNames indexOfObject:cell.textLabel.text];
            [segue.destinationViewController performSelector:@selector(setName:) withObject:[[self.agesNames objectAtIndex:index] description]];
        } else NSLog(@"Destination doesn't respond to setName:");
    } else NSLog(@"Sender isn't kind of class UITableViewCell");
}
@end
