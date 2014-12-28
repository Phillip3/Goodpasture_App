//
//  AboutViewController.m
//  Goodpasture Application
//
//  Created by Phillip Trent on 8/19/13.
//  Copyright (c) 2013 Phillip Trent Coding. All rights reserved.
//

#import "AboutViewController.h"
#define RED 0.116
#define GREEN 0.388
#define BLUE 0.96
@interface AboutViewController ()

@end

@implementation AboutViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    if (self.navigationController.navigationBarHidden) {
        [self.navigationController setNavigationBarHidden:NO animated:YES];
    }
    self.navigationController.title = @"About";
    self.title = @"About";
    [self.navigationController.navigationBar setTintColor:[UIColor colorWithRed:RED green:GREEN blue:BLUE alpha:1.0]];
    [self.tabBar setTintColor:[UIColor colorWithRed:RED green:GREEN blue:BLUE alpha:1.0]];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
