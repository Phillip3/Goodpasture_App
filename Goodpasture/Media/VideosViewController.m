//
//  VideosViewController.m
//  Goodpasture
//
//  Created by Phillip Trent on 6/27/14.
//  Copyright (c) 2014 Phillip Trent Coding. All rights reserved.
//

#import "VideosViewController.h"
#define RED 0.2
#define GREEN 0.8
#define BLUE 0
@interface VideosViewController () <UIWebViewDelegate>
@property (weak, nonatomic) IBOutlet UIWebView *webView;
@property (weak, nonatomic) IBOutlet UILabel *loadingLabel;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *spinner;
@end

@implementation VideosViewController
- (IBAction)backButton:(UIBarButtonItem *)sender {
    [self.webView goBack];
}
- (IBAction)forwardButton:(UIBarButtonItem *)sender {
    [self.webView goForward];
}
- (IBAction)videoButton:(UIBarButtonItem *)sender {
    [self.webView reload];
}
-(void)webViewDidFinishLoad:(UIWebView *)webView
{
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    [self fadeOutLabelAndSpinner];
}
-(void)webViewDidStartLoad:(UIWebView *)webView
{
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    [self fadeInLabelAndSpinner];
}
-(void)fadeInLabelAndSpinner
{
    [UIView animateWithDuration:0.25 animations:^{
        self.spinner.alpha = 1;
        self.loadingLabel.alpha = 1;
    }];
}
-(void)fadeOutLabelAndSpinner
{
    [UIView animateWithDuration:0.25 animations:^{
        self.spinner.alpha = 0;
        self.loadingLabel.alpha = 0;
    }];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.spinner.hidesWhenStopped = NO;
    [self.spinner startAnimating];
    self.loadingLabel.alpha = 0;
    self.spinner.alpha = 0;
    self.loadingLabel.hidden = NO;
    self.loadingLabel.hidden = NO;
    NSString *urlString = @"https://www.youtube.com/user/GoodpastureChristian/featured";
    NSURL *url = [NSURL URLWithString:urlString];
    NSURLRequest *request = [[NSURLRequest alloc] initWithURL:url];
    [self.webView loadRequest:request];
    [self.view setTintColor:[UIColor colorWithRed:RED green:GREEN blue:BLUE alpha:1]];
    [self.navigationController.toolbar setHidden:NO];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
