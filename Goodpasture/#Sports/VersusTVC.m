//
//  Header.h
//  Goodpasture
//
//  Created by Phillip Trent on 12/26/14.
//  Copyright (c) 2014 Phillip Trent. All rights reserved.
//
#import "VersusTVC.h"
#import "NSObject_UniversalHeader.h"
#define RED 1.0
#define GREEN 0.672
#define BLUE 0.0

@interface VersusTVC ()
@property (strong, nonatomic) NSArray *hashTags;
@end

@implementation VersusTVC
//---------------------------------------
//TableView Data Source:
//---------------------------------------
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.hashTags.count;
}
-(NSString *) titleForRow: (NSUInteger)row
{
    return [self.hashTags objectAtIndex:row];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Hash Tag";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    // Configure the cell...
    cell.textLabel.text = [self titleForRow:indexPath.row];
    NSString *imageName = [NSString stringWithFormat:@"%@.png", cell.textLabel.text];
    NSLog(@"%@", imageName);
    UIImage *image =[UIImage imageNamed:imageName];
    if (!image) NSLog(@"No Image");
    [cell.imageView setImage:image];
    cell.imageView.hidden = NO;
    [cell.accessoryView setBackgroundColor:[UIColor colorWithRed:RED green:GREEN blue:BLUE alpha:1.0]];
    
    return cell;
}
//---------------------------------------



//---------------------------------------
//Lifecycle:
//---------------------------------------
- (void)viewDidLoad
{
    [super viewDidLoad];
    if (self.navigationController.navigationBarHidden) {
        [self.navigationController setNavigationBarHidden:NO animated:YES];
    }
    [self.navigationController.navigationBar setTintColor:[UIColor colorWithRed:RED green:GREEN blue:BLUE alpha:1.0]];
    
    self.navigationController.title = @"Sports";
    self.title = @"Sports";
    self.hashTags = HASH_TAGS;
    
}
-(void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([sender isKindOfClass:[UITableViewCell class]]) {
        
        NSIndexPath *indexPath = [self.tableView indexPathForCell:sender];
        
        if (indexPath) {
            
            if ([segue.identifier isEqualToString:@"toTwitterFeed"]) {
                
                if ([segue.destinationViewController respondsToSelector:@selector(setTitle:)]) {
                    
                    [segue.destinationViewController setTitle:[self titleForRow:indexPath.row]];
                    
                    if ([segue.destinationViewController respondsToSelector:@selector(setTweetStorage:)]) {
                        
                        [segue.destinationViewController setTweetStorage:self.tweetStorage];
                    }
                }
            }
        }
    }
}
//---------------------------------------

@end
