//
//  SocialShareHandler.h
//  Templete1
//
//  Created by Venkatesh on 5/15/15.
//  Copyright (c) 2015 com.CompanyName. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <GooglePlus/GooglePlus.h>



typedef void (^GPlusShareCompletionHandler)(BOOL success);
typedef void (^GPlusDetailsCompletionHandler)(BOOL success, id arrayResult);

@interface SocialShareHandler : NSObject<GPPSignInDelegate,GPPShareDelegate>

@property (nonatomic, strong)NSMutableDictionary *gplusDict;


+ (SocialShareHandler *)sharedInstance;


// TWITTER

-(void)getDetailsFromTwitterLogin:(void (^)(id arrayResult,id accessToken))block;

- (void )postToTwitter:(NSString *)message withImage:(UIImage *)image  withImageURL:(NSString *)imageURL completion:(void (^)(bool result))completion;


// FACEBOOK

-(void )getDetailsFromFacebookLogin:(void (^)(id arrayResult ,id accessToken))block;

- (void )postToFacebook:(NSString *)message withImage:(UIImage *)image  withImageURL:(NSString *)imageURL completion:(void (^)(bool result))completion;


// GOOGLE PLUS

/*
 
 
1) Add URLScheme in info tab for URL Types.
 
2) define Macro in .pch file as below.
   #define GPLUS_CLIENT_ID @"xxxxxxxxxxxxxxxxxxxxxxxxxxxx";
 
3) use the same BundleIdentifier in your app.
 
4) Implement below Method in your AppDelegate.
 

 
 -(BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
 return [GPPURLHandler handleURL:url sourceApplication:sourceApplication annotation:annotation];
 }
 
 
 */


-(void)getDetailsFromGplusLogin:(GPlusDetailsCompletionHandler)completionHandler;


// This method cannot be
// called in combination with either |withImage:| or |withURLToShare| or |withLocalVideoURL|.

- (void )postToGplus:(NSString *)message withImage:(UIImage *)image  withURLToShare:(NSString *)urlToShare withLocalVideoURL:(NSString *)localVideoURL completion:(GPlusShareCompletionHandler)completionHandler;


@end
