//
//  PowerSchoolViewController.m
//  Goodpasture Application
//
//  Created by Phillip Trent on 7/6/13.
//  Copyright (c) 2013 Phillip Trent Coding. All rights reserved.
//

#import "PowerSchoolViewController.h"
#import "HomeViewController.h"
#import "NSObject_UniversalHeader.h"
#define RED 1.0
#define GREEN 0.0
#define BLUE 0.0

@interface PowerSchoolViewController () <UIWebViewDelegate>
@property (strong, nonatomic) IBOutlet UIWebView *webView;
@property (strong, nonatomic) IBOutlet UIActivityIndicatorView *spinner;
@property (strong, nonatomic) IBOutlet UILabel *loadingLabel;
@property (strong, nonatomic) NSTimer *timer;
@end

@implementation PowerSchoolViewController

//---------------------------------------
//Buttons:
//---------------------------------------
- (IBAction)BackButton:(UIBarButtonItem *)sender
{
    [self.webView goBack];
}
- (IBAction)ForwardButton:(UIBarButtonItem *)sender
{
    [self.webView goForward];
}
//---------------------------------------



//---------------------------------------
//Display Messages:
//---------------------------------------
-(void) networkErrorMessage
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"It is taking longer than usual to connect to PowerSchool. Please check your internet connection." delegate:nil cancelButtonTitle:@"Dismiss" otherButtonTitles:nil];
    [alert show];
}
//---------------------------------------



//---------------------------------------
//Making the UI Pretty:
//---------------------------------------
- (void)fadeInLabelAndSpinner
{
    if (!self.spinner.isAnimating) [self.spinner startAnimating];
    [UIView beginAnimations:@"fade in" context:nil];
    [UIView setAnimationDuration:0.5];
    self.loadingLabel.alpha = 1.0;
    self.spinner.alpha = 1.0;
    [UIView commitAnimations];
    
}
- (void)fadeOutLabelAndSpinner
{
    [UIView beginAnimations:@"fade in" context:nil];
    [UIView setAnimationDuration:0.5];
    self.loadingLabel.alpha = 0.0;
    self.spinner.alpha = 0.0;
    [UIView commitAnimations];
    
}
//---------------------------------------



//---------------------------------------
//Get Content:
//---------------------------------------
-(void) getWebViewContent
{
    dispatch_queue_t powerSchoolQueue = dispatch_queue_create("grades", NULL);
    dispatch_async(powerSchoolQueue, ^{
        //Start the Network Activity Indicator
        [UIApplication sharedApplication].networkActivityIndicatorVisible = true;
        
        [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:POWERSCHOOL_DESTINATION_URL]]];
        
        //Stop the Network Activity Indicator
        [UIApplication sharedApplication].networkActivityIndicatorVisible = false;
    });
}
//---------------------------------------

//---------------------------------------
//Delegate Methods:
//---------------------------------------
-(void) webViewDidStartLoad:(UIWebView *)webView
{
    if (webView == self.webView) {
        NSLog(@"Did start load");
        [self.spinner startAnimating];
        [self fadeInLabelAndSpinner];
        if (self.timer.isValid) {
            [self.timer invalidate];
            self.timer = nil;
        }
        self.timer = [NSTimer scheduledTimerWithTimeInterval:10
                                                      target:self
                                                    selector:@selector(networkErrorMessage)
                                                    userInfo:nil
                                                     repeats:NO];
    }
}

-(void) webViewDidFinishLoad:(UIWebView *)webView
{
    if (webView == self.webView) {
        NSLog(@"Webview did finish loading");
        [self fadeOutLabelAndSpinner];
        do {
            [self.timer invalidate];
            NSLog(@"Timer Invalidated");
        } while (self.timer.isValid);
        
    }
}
-(void) webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    if (webView == self.webView) {
        NSLog(@"WebView ERROR---%@", error.description);
    }
}
//---------------------------------------



//---------------------------------------
//Setup:
//---------------------------------------
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //setup the navigation controller
    if (self.navigationController.navigationBarHidden) {
        [self.navigationController setNavigationBarHidden:NO animated:YES];
    }
    self.navigationController.title = @"Grades";
    self.title = @"Grades";
    [self.navigationController.toolbar setHidden:NO];
    [self.navigationController.navigationBar setTintColor:[UIColor colorWithRed:RED green:GREEN blue:BLUE alpha:1.0]];
    [self.view setTintColor:[UIColor colorWithRed:RED green:GREEN blue:BLUE alpha:1.0]];
    
    //setup and get content for webview
    self.webView.scalesPageToFit = YES;
    [self getWebViewContent];
    self.webView.scrollView.showsHorizontalScrollIndicator = NO;
    self.loadingLabel.hidden = NO;
    self.loadingLabel.alpha = 0.0;
    
    self.spinner.hidden = NO;
    self.spinner.alpha = 0.0;
}
-(void) viewDidDisappear:(BOOL)animated
{
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO; //BAD
    if(self.timer.isValid) [self.timer invalidate];
}
-(UIView *) viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    return self.webView;
}
//---------------------------------------



@end