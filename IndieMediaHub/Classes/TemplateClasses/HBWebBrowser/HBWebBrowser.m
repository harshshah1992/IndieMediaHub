//
//  HBWebBrowser.m
//  Templete1
//
//  Created by Manikanta on 3/17/15.
//  Copyright (c) 2015 com.CompanyName. All rights reserved.
//

#import "HBWebBrowser.h"


@interface HBWebBrowser (){
 
}

@property (strong , nonatomic)  OpenBrowserCompletionHandler openBrowserCompletionHandler;
@property (strong , nonatomic)  UIWebView *webViewer;
@property (strong , nonatomic)  UIView *viewAdd;
@property (strong , nonatomic)  UIViewController *viewController;
@property (strong , nonatomic)  UIButton *btnForward;
@property (strong , nonatomic)  UIButton *btnBack;
@property (strong , nonatomic)  UIButton *btnStop;
@property (strong , nonatomic)  UIButton *btnRefresh;
@property (strong , nonatomic)  UIActivityIndicatorView *activityIndicator;

@end
@implementation HBWebBrowser

+(HBWebBrowser*) sharedInstance{
    static dispatch_once_t once;
    static HBWebBrowser * sharedInstance;
    dispatch_once(&once, ^{
        sharedInstance = [[self alloc] init];
    });
    return sharedInstance;
}

- (void) openBrowserWithType:(enum browserType)browserType withTitle:(NSString *)title withUrl:(NSString *)urlString withCompletion:(OpenBrowserCompletionHandler)completionHandler {
    self.openBrowserCompletionHandler = [completionHandler copy];
    self.viewController = [[[[UIApplication sharedApplication] delegate] window] rootViewController];
    self.viewAdd = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height)];
     self.webViewer = [[UIWebView alloc] initWithFrame:CGRectMake(0, 44, self.viewAdd.frame.size.width, self.viewAdd.frame.size.height-88)];
    [self.viewAdd addSubview:self.webViewer];
    [self.webViewer bringSubviewToFront:self.viewController.view];
    if (browserType == internal) {
        self.webViewer.delegate = self;
        NSURL *url = [NSURL URLWithString:urlString];
        NSURLRequest *request = [NSURLRequest requestWithURL:url];
        [self.webViewer loadRequest:request];
    } else if(browserType == external){
        NSURL *url = [NSURL URLWithString:urlString];
        [[UIApplication sharedApplication] openURL:url];
    }
    UIView *topView = [[UIView alloc] initWithFrame:CGRectMake(0, 0 , [UIScreen mainScreen].bounds.size.width, 44)];
    [topView setBackgroundColor:[UIColor blackColor]];
    UILabel *lbl = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 44)];
    lbl.text = title;
    [lbl setTextAlignment:NSTextAlignmentCenter];
    lbl.textColor = [UIColor whiteColor];
    [topView addSubview:lbl];
    [self.viewAdd addSubview:topView];
    
    UIView *bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, [UIScreen mainScreen].bounds.size.height-44 , [UIScreen mainScreen].bounds.size.width, 44)];
    [bottomView setBackgroundColor:[UIColor blackColor]];
    UIButton *btnClose = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 100, 44)];
    [btnClose setTitle:@"Close" forState:UIControlStateNormal];
    btnClose.titleLabel.textColor = [UIColor whiteColor];
    [btnClose addTarget:self action:@selector(dismissWebView) forControlEvents:UIControlEventTouchUpInside];
    [bottomView addSubview:btnClose];
    
    self.btnBack = [[UIButton alloc] initWithFrame:CGRectMake(bottomView.frame.size.width - 230, (bottomView.frame.size.height / 2) - self.btnBack.frame.size.height / 2, 14, 17)];
    [self.btnBack setImage:[UIImage imageNamed:@"back.png"] forState:UIControlStateNormal];
    self.btnBack.center = CGPointMake(bottomView.frame.size.width/2+10, bottomView.frame.size.height/2);
    self.btnBack.titleLabel.textColor = [UIColor whiteColor];
    [self.btnBack addTarget:self action:@selector(goBack) forControlEvents:UIControlEventTouchUpInside];
    [bottomView addSubview:self.btnBack];
    
    self.btnForward = [[UIButton alloc] initWithFrame:CGRectMake(250, 0, 14, 17)];
    self.btnForward.center = CGPointMake(bottomView.center.x+80, bottomView.frame.size.height/2);
    [self.btnForward setImage:[UIImage imageNamed:@"forward.png"] forState:UIControlStateNormal];
    [self.btnForward addTarget:self action:@selector(goForward) forControlEvents:UIControlEventTouchUpInside];
    [bottomView addSubview:self.btnForward];
    
    self.btnStop = [[UIButton alloc] initWithFrame:CGRectMake(250, 0, 100, 44)];
    [self.btnStop  setImage:[UIImage imageNamed:@"close-icon.png"] forState:UIControlStateNormal];
    self.btnStop.center = CGPointMake(bottomView.frame.size.width/3+20, bottomView.frame.size.height/2);
    [self.btnStop addTarget:self action:@selector(stopLoading) forControlEvents:UIControlEventTouchUpInside];
    [bottomView addSubview:self.btnStop];
    
    self.btnRefresh = [[UIButton alloc] initWithFrame:CGRectMake(250, 0, 100, 44)];
    self.btnRefresh.center = CGPointMake(bottomView.frame.size.width/3+20, bottomView.frame.size.height/2);
    [self.btnRefresh setImage:[UIImage imageNamed:@"Command-Refresh-01.png"] forState:UIControlStateNormal];
    [self.btnRefresh addTarget:self action:@selector(refreshWebView) forControlEvents:UIControlEventTouchUpInside];
    [self.btnRefresh setHidden:YES];
    [bottomView addSubview:self.btnRefresh];
    [self.viewAdd addSubview:bottomView];
    
    self.activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
    self.activityIndicator.center = CGPointMake(bottomView.frame.size.width-20, bottomView.frame.size.height/2);
    [self.activityIndicator startAnimating];
    [bottomView addSubview:self.activityIndicator];
    
    [self.viewController.view addSubview:self.viewAdd];
}

- (void)dismissWebView {
    [self.viewAdd removeFromSuperview];
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    self.webViewer.delegate = nil;
    self.openBrowserCompletionHandler = nil;
}
- (void)goBack {
    [self.webViewer goBack];
}
- (void)goForward {
    [self.webViewer goForward];
}

- (void)updateButtons
{
    self.btnForward.enabled = self.webViewer.canGoForward;
    self.btnBack.enabled = self.webViewer.canGoBack;
    self.btnStop.hidden = self.webViewer.isLoading;
    self.btnRefresh.hidden = !self.webViewer.isLoading;
}

// Delegate methods
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType{
    [self.activityIndicator startAnimating];
     self.btnStop.hidden = !webView.isLoading;
     self.btnRefresh.hidden = webView.isLoading;
    NSLog(@"Loading URL :%@",request.URL.absoluteString);
    [self updateButtons];
    //return FALSE; //to stop loading
    return YES;
}

- (void)webViewDidStartLoad:(UIWebView *)webView {
    NSLog(@"start");
    self.btnStop.hidden = !webView.isLoading;
    self.btnRefresh.hidden = webView.isLoading;
     [self.activityIndicator startAnimating];
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    
    NSLog(@"finish");
    [self.activityIndicator stopAnimating];
    self.btnStop.hidden = !webView.isLoading;
    self.btnRefresh.hidden = webView.isLoading;
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    self.openBrowserCompletionHandler(YES);
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
    self.btnStop.hidden = !webView.isLoading;
    self.btnRefresh.hidden = webView.isLoading;
    [self.activityIndicator stopAnimating];
    NSLog(@"Error for WEBVIEW: %@", [error description]);
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    self.openBrowserCompletionHandler(NO);
}

- (void)stopLoading{
    [self.webViewer stopLoading];
}

- (void)refreshWebView {
    [self.webViewer reload];
}


@end
