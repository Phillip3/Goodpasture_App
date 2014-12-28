//
//  AboutAgesViewController.m
//  Goodpasture
//
//  Created by Phillip Trent on 11/8/13.
//  Copyright (c) 2013 Phillip Trent Coding. All rights reserved.
//

#import "AboutAgesViewController.h"
#import "NSObject_UniversalHeader.h"

@interface AboutAgesViewController ()
@property (strong, nonatomic) IBOutlet UIWebView *webView;
@end

@implementation AboutAgesViewController
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
        htmlFile = [[NSBundle mainBundle] pathForResource:@"/AgesiPad" ofType:@"html"];
    } else {
        htmlFile = [[NSBundle mainBundle] pathForResource:@"/AgesiPhone" ofType:@"html"];
    }    NSString* htmlString = [NSString stringWithContentsOfFile:htmlFile encoding:NSUTF8StringEncoding error:nil];
    [self.webView loadHTMLString:htmlString baseURL:nil];
}
@end
