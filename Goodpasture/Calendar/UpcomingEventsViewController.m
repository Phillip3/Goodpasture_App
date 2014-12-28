//
//  UpcomingEventsViewController.m
//  Goodpasture Application
//
//  Created by Phillip Trent on 9/22/13.
//  Copyright (c) 2013 Phillip Trent Coding. All rights reserved.
//

#import "UpcomingEventsViewController.h"
#import "HomeViewController.h"
#import "NSObject_UniversalHeader.h"
#define RED 0.93725490196
#define BLUE 0.71764705882
#define GREEN 0.30196078431

@interface UpcomingEventsViewController ()
@property (strong, nonatomic) IBOutlet UIWebView *webView;
@property (strong, nonatomic) IBOutlet UIActivityIndicatorView *spinner;
@property (strong, nonatomic) IBOutlet UILabel *loadingLabel;
@property (strong, nonatomic) NSTimer *timer;
@end

@implementation UpcomingEventsViewController

//---------------------------------------
//Buttons:
//---------------------------------------
- (IBAction)calendarButton:(UIBarButtonItem *)sender {
    [self getWebViewContent];
}
- (IBAction)backButton:(UIBarButtonItem *)sender {
    [self.webView goBack];
}
- (IBAction)forwardButton:(UIBarButtonItem *)sender {
    [self.webView goForward];
}
//---------------------------------------



//---------------------------------------
//Display Messages:
//---------------------------------------
-(void) networkErrorMessage
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"It is taking longer than usual to connect to the Calendar. Please check your internet connection." delegate:nil cancelButtonTitle:@"Dismiss" otherButtonTitles:nil];
    [alert show];
}
-(void) showTheAlert
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error!" message:@"Sorry! It seems that there was a problem accessing the internet. To refresh, hit the back button and tap on Upcoming Events. " delegate:Nil cancelButtonTitle:@"Okay. I forgive you." otherButtonTitles:nil];
    [alert show];
    if ([self.spinner isAnimating])[self.spinner stopAnimating];
    self.spinner.hidden = YES;
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
    dispatch_queue_t powerSchoolQueue = dispatch_queue_create("powerschool", NULL);
    dispatch_async(powerSchoolQueue, ^{
        [UIApplication sharedApplication].networkActivityIndicatorVisible = true;
        [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:UPCOMING_EVENTS_DESTINATION_URL]]];
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
    if (webView == self.webView)
    {
        [self.spinner stopAnimating];
        [self fadeOutLabelAndSpinner];
        [self.timer invalidate];
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
    if (self.navigationController.navigationBarHidden) {
        [self.navigationController setNavigationBarHidden:NO animated:YES];
    }
    [self.navigationController.navigationBar setTintColor:[UIColor colorWithRed:RED green:GREEN blue:BLUE alpha:1.0]];
    [self.view setTintColor:[UIColor colorWithRed:RED green:GREEN blue:BLUE alpha:1.0]];
    self.navigationController.title = @"Calendar";
    self.title = @"Calendar";
    [self getWebViewContent];
}
-(UIView *) viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    return self.webView.viewForBaselineLayout;
}
-(void)viewDidDisappear:(BOOL)animated
{
    if(self.timer.isValid) [self.timer invalidate];
    [UIApplication sharedApplication].networkActivityIndicatorVisible = false;
}
//---------------------------------------
@end
