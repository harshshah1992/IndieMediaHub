//
//  HBWebBrowser.h
//  Templete1
//
//  Created by Manikanta on 3/17/15.
//  Copyright (c) 2015 com.CompanyName. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^OpenBrowserCompletionHandler)(BOOL success);
enum browserType {
    internal,
    external
};

@interface HBWebBrowser : NSObject<UIWebViewDelegate>
+ (HBWebBrowser*) sharedInstance;
- (void) openBrowserWithType:(enum browserType)browserType withTitle:(NSString*)title withUrl:(NSString*)urlString withCompletion:(OpenBrowserCompletionHandler)completionHandler;
@end
