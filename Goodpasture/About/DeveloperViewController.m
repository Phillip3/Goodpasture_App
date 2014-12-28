//
//  DeveloperViewController.m
//  Goodpasture
//
//  Created by Phillip Trent on 11/23/13.
//  Copyright (c) 2013 Phillip Trent Coding. All rights reserved.
//

#import "DeveloperViewController.h"

@interface DeveloperViewController ()
@property (strong, nonatomic) IBOutlet UIWebView *webView;
@end

@implementation DeveloperViewController
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
        htmlFile = [[NSBundle mainBundle] pathForResource:@"/DeveloperiPad" ofType:@"html"];
    } else {
        htmlFile = [[NSBundle mainBundle] pathForResource:@"/DeveloperiPhone" ofType:@"html"];
    }    NSString* htmlString = [NSString stringWithContentsOfFile:htmlFile encoding:NSUTF8StringEncoding error:nil];
    [self.webView loadHTMLString:htmlString baseURL:nil];
}

@end
