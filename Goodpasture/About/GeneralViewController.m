//
//  GeneralViewController.m
//  Goodpasture
//
//  Created by Phillip Trent on 11/23/13.
//  Copyright (c) 2013 Phillip Trent Coding. All rights reserved.
//

#import "GeneralViewController.h"

@interface GeneralViewController () <UIWebViewDelegate>
@property (strong, nonatomic) IBOutlet UIWebView *webView;
@end

@implementation GeneralViewController
-(UIWebView *)webView
{
    if (!_webView) {
        _webView = [[UIWebView alloc] init];
    }
    return _webView;
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    NSString *htmlFile = @"";
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        htmlFile = [[NSBundle mainBundle] pathForResource:@"/GeneraliPad" ofType:@"html"];
    } else {
        htmlFile = [[NSBundle mainBundle] pathForResource:@"/GeneraliPhone" ofType:@"html"];
    }
    NSString* htmlString = [NSString stringWithContentsOfFile:htmlFile encoding:NSUTF8StringEncoding error:nil];
    self.webView.scrollView.contentInset = UIEdgeInsetsZero;
    [self.webView loadHTMLString:htmlString baseURL:nil];
}

@end
