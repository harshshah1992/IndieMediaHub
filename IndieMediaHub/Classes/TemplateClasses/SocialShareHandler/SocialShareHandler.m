//
//  SocialShareHandler.m
//  Templete1
//
//  Created by Venkatesh on 5/15/15.
//  Copyright (c) 2015 com.CompanyName. All rights reserved.
//

#import "SocialShareHandler.h"
#import <Social/Social.h>
#import <GoogleOpenSource/GoogleOpenSource.h>




@interface SocialShareHandler(){
//    GPlusShareCompletionHandler _GPlusShareCompletionHandler;
//    GPlusDetailsCompletionHandler _GPlusDetailsCompletionHandler;
}

@property (strong , nonatomic) GPlusShareCompletionHandler gPlusShareCompletionHandler;
@property (strong , nonatomic) GPlusDetailsCompletionHandler gPlusDetailsCompletionHandler;



@end

@implementation SocialShareHandler

bool isGplusDetails =NO;

+ (SocialShareHandler*)sharedInstance {
    static SocialShareHandler *utility = nil;
    if (utility == nil)
    {
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            utility = [[SocialShareHandler alloc] init];
        });
    }
    
    return utility;
}


- (void )getDetailsFromFacebookLogin:(void (^)(id arrayResult ,id accessToken))block {
    ACAccountStore *accountStoreDetailes=[[ACAccountStore alloc] init];
    ACAccountType *facebookTypeAccount = [accountStoreDetailes accountTypeWithAccountTypeIdentifier:ACAccountTypeIdentifierFacebook];
    NSMutableDictionary *options = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                    FB_APPLICATION_ID, ACFacebookAppIdKey,
                                    [NSArray arrayWithObjects:@"email", nil], ACFacebookPermissionsKey,ACFacebookAudienceFriends,ACFacebookAudienceKey, nil];
    //,read_stream,read_friendlist
    [accountStoreDetailes requestAccessToAccountsWithType:facebookTypeAccount options:options completion:
     ^(BOOL granted, NSError *e) {
         
         if (granted) {
             NSArray *accounts = [accountStoreDetailes accountsWithAccountType:facebookTypeAccount];
             NSDictionary *permsDict = nil;
             permsDict = [[NSDictionary alloc] initWithObjectsAndKeys:@"id,name,first_name,middle_name,last_name,gender,languages,link,age_range,bio,birthday,cover,currency,education,email,hometown,interested_in,location,favorite_athletes,favorite_teams,picture,quotes,relationship_status,religion,security_settings,significant_other,video_upload_limits,website,work",@"fields", nil];
             
             NSURL *requestURL = [NSURL URLWithString:@"https://graph.facebook.com/v2.0/me"];
             SLRequest *request = [SLRequest requestForServiceType:SLServiceTypeFacebook
                                                     requestMethod:SLRequestMethodGET
                                                               URL:requestURL
                                                        parameters:permsDict];
             request.account = [accounts lastObject];
             [request performRequestWithHandler:^(NSData *data,
                                                  NSHTTPURLResponse *response,
                                                  NSError *error) {
                 NSDictionary *dict_facebookdata=[NSJSONSerialization JSONObjectWithData:data  options:kNilOptions error:&error];
                 NSLog(@"%@",dict_facebookdata);
                 NSLog(@"Acess Token is  %@",request.account.credential.oauthToken);
                 
                 block(dict_facebookdata,request.account.credential.oauthToken);
                 
             }];
         } else {
             block(nil,nil);
             dispatch_sync(dispatch_get_main_queue(), ^{
                 UIAlertView *objAlertView=[[UIAlertView alloc] initWithTitle:nil message:@"Facebook access failed,Please check if the facebook account is logged in or not and also check if the app permissions are enabled."delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
                 [objAlertView showWithCompletion:^(UIAlertView *alertView, NSInteger buttonIndex) {
                     
                 }];
             });
             
         }
     }];
    
    
}

-(void)getDetailsFromTwitterLogin:(void (^)(id arrayResult,id accessToken))block {
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    ACAccountStore *accountStore = [[ACAccountStore alloc] init];
    // apiManager = [[TWTAPIManager alloc] init];
    
    // Create an account type that ensures Twitter accounts are retrieved.
    ACAccountType *accountType = [accountStore accountTypeWithAccountTypeIdentifier:ACAccountTypeIdentifierTwitter];
    
    // Request access from the user to use their Twitter accounts.
    [accountStore requestAccessToAccountsWithType:accountType options:nil completion:^(BOOL granted, NSError *error) {
        if(granted && error == nil) {
            // Get the list of Twitter accounts.
            NSArray *accountsArray = [accountStore accountsWithAccountType:accountType];
            
            // For the sake of brevity, we'll assume there is only one Twitter account present.
            // You would ideally ask the user which account they want to tweet from, if there is more than one Twitter account present.
            if ([accountsArray count] > 0) {
                // Grab the initial Twitter account to tweet from.
                
                
                ACAccount *twitterAccount = [accountsArray objectAtIndex:0];
                NSMutableDictionary *dicParam =[NSMutableDictionary dictionary];
                NSDictionary *tempDict = [twitterAccount dictionaryWithValuesForKeys:[NSArray arrayWithObject:@"properties"]];
                [dicParam setObject:[[tempDict objectForKey:@"properties"] objectForKey:@"user_id"] forKey:@"user_id"];
                
                //  Now we can create our request.  Note that we are performing a GET request.
                SLRequest *request ;
                NSURL *twitterUrl =[NSURL URLWithString:@"https://api.twitter.com/1.1/users/lookup.json"];
                request = [SLRequest requestForServiceType:SLServiceTypeTwitter
                                             requestMethod:SLRequestMethodGET
                                                       URL:twitterUrl
                                                parameters:dicParam];
                [request setAccount:twitterAccount];
                //  Perform our request
                [request performRequestWithHandler:
                 ^(NSData *responseData, NSHTTPURLResponse *urlResponse, NSError *error) {
                     
                     if (responseData && error == nil) {
                         [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
                         NSMutableArray *arrTwitterData=[NSJSONSerialization JSONObjectWithData:responseData  options:kNilOptions error:&error];
                         NSLog(@"Twitter responce %@",arrTwitterData);
                         block(arrTwitterData,nil);
                       
                     }
                     else
                     {
                         [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
                         block(nil,nil);
                         
                     }
                 }];
            }
            else
            {
                block(nil,nil);
                dispatch_sync(dispatch_get_main_queue(), ^{
                    UIAlertView *objAlertView=[[UIAlertView alloc] initWithTitle:nil message:@"Twitter access failed,Please check if the twitter account is logged in or not and also check if the app permissions are enabled." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
                    [objAlertView showWithCompletion:^(UIAlertView *alertView, NSInteger buttonIndex) {
                        
                    }];
                });
            }
        }
        else {
            block(nil,nil);
            dispatch_sync(dispatch_get_main_queue(), ^{
                UIAlertView *objAlertView=[[UIAlertView alloc] initWithTitle:nil message:@"Twitter access failed,Please check if the twitter account is logged in or not and also check if the app permissions are enabled." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
                [objAlertView showWithCompletion:^(UIAlertView *alertView, NSInteger buttonIndex) {
                    
                }];
            });
        }
        
        
    }];
}


-(void)getDetailsFromGplusLogin:(GPlusDetailsCompletionHandler)completionHandler{

    
    isGplusDetails=YES;
    self.gPlusDetailsCompletionHandler=[completionHandler copy];
    
    [self loginToGplus];
    
}


- (void )postToTwitter:(NSString *)message withImage:(UIImage *)image  withImageURL:(NSString *)imageURL completion:(void (^)(bool result))completion{
    
        SLComposeViewController *tweetSheet = [SLComposeViewController
                                               composeViewControllerForServiceType:SLServiceTypeTwitter];
        
        
        tweetSheet.completionHandler=^(SLComposeViewControllerResult result) {
            
            bool composed=NO;
            switch(result) {
                    //  This means the user cancelled without sending the Tweet
                case SLComposeViewControllerResultCancelled:
                    composed=NO;
                    break;
                    //  This means the user hit 'Send'
                case SLComposeViewControllerResultDone:
                    composed=YES;
                    break;
            }
            
                UIViewController *controller = [[UIApplication sharedApplication].delegate window].rootViewController;
                [controller dismissViewControllerAnimated:NO completion:^{
                    NSLog(@"Tweet Sheet has been dismissed.");
                     completion(result);
                }];
                        
        };
        
        if(message.length>0)
            [tweetSheet setInitialText:message];
        else
            [tweetSheet setInitialText:@""];
        
        if(image){
            [tweetSheet addImage:image];
        }
        if(imageURL.length>0){
            [tweetSheet addURL:[NSURL URLWithString:imageURL]];
        }
        
        
        UIViewController *controller = [[UIApplication sharedApplication].delegate window].rootViewController;
        [controller presentViewController:tweetSheet animated:YES completion:^{
            
        }];

}


- (void )postToFacebook:(NSString *)message withImage:(UIImage *)image  withImageURL:(NSString *)imageURL completion:(void (^)(bool result))completion{
    
        SLComposeViewController *fbSheet = [SLComposeViewController
                                               composeViewControllerForServiceType:SLServiceTypeFacebook];
        
        
        fbSheet.completionHandler=^(SLComposeViewControllerResult result) {
            
            bool composed=NO;
            switch(result) {
                    //  This means the user cancelled without sending the Tweet
                case SLComposeViewControllerResultCancelled:
                    composed=NO;
                    break;
                    //  This means the user hit 'Send'
                case SLComposeViewControllerResultDone:
                    composed=YES;
                    break;
            }
            
            UIViewController *controller = [[UIApplication sharedApplication].delegate window].rootViewController;
            [controller dismissViewControllerAnimated:NO completion:^{
                NSLog(@"FB Sheet has been dismissed.");
                completion(result);
            }];
            
        };
        
        if(message.length>0)
            [fbSheet setInitialText:message];
        else
            [fbSheet setInitialText:@""];
        
        if(image){
            [fbSheet addImage:image];
        }
        if(imageURL.length>0){
            [fbSheet addURL:[NSURL URLWithString:imageURL]];
        }
        
        
        UIViewController *controller = [[UIApplication sharedApplication].delegate window].rootViewController;
        [controller presentViewController:fbSheet animated:YES completion:^{
            
        }];

}



- (void)loginToGplus{
    
    GPPSignIn *signIn = [GPPSignIn sharedInstance];
    signIn.delegate = self;
    signIn.shouldFetchGooglePlusUser = YES;
    signIn.shouldFetchGoogleUserEmail = YES;  // Uncomment to get the user's email
    signIn.shouldFetchGoogleUserID = YES;
    signIn.attemptSSO=YES;
    
    // You previously set kClientId in the "Initialize the Google+ client" step
    signIn.clientID = GPLUS_CLIENT_ID;
    
   signIn.scopes = [NSArray arrayWithObjects:kGTLAuthScopePlusLogin,kGTLAuthScopePlusMe,kGTLAuthScopePlusUserinfoEmail,kGTLAuthScopePlusUserinfoProfile,nil];
    

    if ([signIn hasAuthInKeychain])
    {
        if (![signIn trySilentAuthentication])//because some time, it may expired
        {
            [signIn authenticate];
        }
    }
    else
    {
        [signIn authenticate];
    }
    
    
}
- (void)finishedWithAuth: (GTMOAuth2Authentication *)auth
                   error: (NSError *) error {
    NSLog(@"Gplus Received error %@ and auth object %@",error, auth);
    if(error==Nil){
        
        
        
        if(!isGplusDetails){
           [self postToGplus];
        }else{
            
            [self getGTLServicePlus:auth];
        
        }
        
        
    }
    else{

        UIAlertView *objAlertView=[[UIAlertView alloc] initWithTitle:nil message:@"GPlus access failed,Please check if the GPlus account is logged in or not and also check if the app permissions are enabled."delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        
        [objAlertView show];
    }
}



-(void)getGTLServicePlus:(GTMOAuth2Authentication *)auth{
    
    GTLQueryPlus *query = [GTLQueryPlus queryForPeopleGetWithUserId:@"me"];
    
    NSLog(@"email %@ ", [NSString stringWithFormat:@"Email: %@",[GPPSignIn sharedInstance].authentication.userEmail]);
    NSLog(@"Received and auth object %@", auth);
    
    // 1. Create a |GTLServicePlus| instance to send a request to Google+.
    GTLServicePlus* plusService = [[GTLServicePlus alloc] init] ;
    plusService.retryEnabled = YES;
    
    // 2. Set a valid |GTMOAuth2Authentication| object as the authorizer.
    [plusService setAuthorizer:[GPPSignIn sharedInstance].authentication];
    
    // 3. Use the "v1" version of the Google+ API.*
    plusService.apiVersion = @"v1";
    [plusService executeQuery:query
            completionHandler:^(GTLServiceTicket *ticket,
                                GTLPlusPerson *person,
                                NSError *error) {
                if (error) {
                    //Handle Error
                     self.gPlusDetailsCompletionHandler(NO,Nil);
                    
                    UIAlertView *objAlertView=[[UIAlertView alloc] initWithTitle:nil message:@"GPlus access failed,Please check if the GPlus account is logged in or not and also check if the app permissions are enabled."delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
                    
                    [objAlertView show];
                    
                    
                } else {
                    NSLog(@"Email= %@", [GPPSignIn sharedInstance].authentication.userEmail);
                    NSLog(@"GoogleID=%@", person.identifier);
                    NSLog(@"User Name=%@", [person.name.givenName stringByAppendingFormat:@" %@", person.name.familyName]);
                    NSLog(@"Gender=%@", person.gender);
                    
                    
                    NSMutableDictionary *dict=[[NSMutableDictionary alloc] init];
                    
                    
                     GPPSignIn *signIn = [GPPSignIn sharedInstance];
                    [dict setObject:signIn.clientID?signIn.clientID:@"" forKey:@"signInClientID"];
                    [dict setObject:signIn.userID?signIn.userID:@"" forKey:@"signInuserID"];
                    [dict setObject:signIn.idToken?signIn.idToken:@"" forKey:@"signInidToken"];
                    [dict setObject:signIn.keychainName?signIn.keychainName:@"" forKey:@"signInkeychainName"];
                    
                    [dict setObject:auth.parameters?auth.parameters:@"" forKey:@"authenticationParams"];
                    
                    [dict setObject:[GPPSignIn sharedInstance].authentication.userEmail forKey:@"userEmail"];
                    [dict setObject:person.aboutMe?person.aboutMe:@"" forKey:@"aboutMe"];
                    [dict setObject:person.ageRange.min?person.ageRange.min:@"" forKey:@"ageRangeMin"];
                    [dict setObject:person.ageRange.max?person.ageRange.max:@"" forKey:@"ageRangeMax"];
                    [dict setObject:person.birthday?person.birthday:@"" forKey:@"birthday"];
                    [dict setObject:person.braggingRights?person.braggingRights:@"" forKey:@"braggingRights"];
                    [dict setObject:person.circledByCount?person.circledByCount:@"" forKey:@"circledByCount"];
                    [dict setObject:person.cover.layout?person.cover.layout:@"" forKey:@"coverLayout"];
                    [dict setObject:person.cover.coverInfo.leftImageOffset?person.cover.coverInfo.leftImageOffset:@"" forKey:@"coverInfoleftImageOffset"];
                    [dict setObject:person.cover.coverInfo.topImageOffset?person.cover.coverInfo.topImageOffset:@"" forKey:@"coverInfotopImageOffset"];
                    [dict setObject:person.cover.coverPhoto.height?person.cover.coverPhoto.height:@"" forKey:@"coverPhotoheight"];
                    [dict setObject:person.cover.coverPhoto.width?person.cover.coverPhoto.width:@"" forKey:@"coverPhotowidth"];
                    [dict setObject:person.cover.coverPhoto.url?person.cover.coverPhoto.url:@"" forKey:@"coverPhotourl"];
                    [dict setObject:person.currentLocation?person.currentLocation:@"" forKey:@"currentLocation"];
                    [dict setObject:person.displayName?person.displayName:@"" forKey:@"displayName"];
                    [dict setObject:person.domain?person.domain:@"" forKey:@"domain"];
                    
                    NSMutableArray *eMailArr=[[NSMutableArray alloc] init];
                    if(person.emails.count>0){
                        for(int i=0;i<[person.emails count];i++)
                        {
                            NSMutableDictionary *eDict=[[NSMutableDictionary alloc] init];
                            GTLPlusPersonEmailsItem *item=[person.emails objectAtIndex:i];
                            [eDict setObject:item.value?item.value:@"" forKey:@"value"];
                            [eDict setObject:item.type?item.type:@"" forKey:@"type"];
                            [eMailArr addObject:eDict];
                        }
                        [dict setObject:eMailArr forKey:@"emails"];
                    }
                    
                    
                    [dict setObject:person.ETag?person.ETag:@"" forKey:@"ETag"];
                    [dict setObject:person.gender?person.gender:@"" forKey:@"gender"];
                    [dict setObject:person.identifier?person.identifier:@"" forKey:@"identifier"];
                    [dict setObject:person.image.url?person.image.url:@"" forKey:@"imageURL"];
                    [dict setObject:person.isPlusUser?person.isPlusUser:@"" forKey:@"isPlusUser"];
                    [dict setObject:person.kind?person.kind:@"" forKey:@"kind"];
                    [dict setObject:person.language?person.language:@"" forKey:@"language"];
                    [dict setObject:person.name.formatted?person.name.formatted:@"" forKey:@"fullName"];
                    [dict setObject:person.name.givenName?person.name.givenName:@"" forKey:@"firstName"];
                    [dict setObject:person.name.familyName?person.name.familyName:@"" forKey:@"lastName"];
                    [dict setObject:person.name.middleName?person.name.middleName:@"" forKey:@"middleName"];                    
                    [dict setObject:person.name.honorificPrefix?person.name.honorificPrefix:@"" forKey:@"prefixName"];
                    [dict setObject:person.name.honorificSuffix?person.name.honorificSuffix:@"" forKey:@"suffixName"];
                    [dict setObject:person.nickname?person.nickname:@"" forKey:@"nickname"];
                    [dict setObject:person.objectType?person.objectType:@"" forKey:@"personORpage"];
                    [dict setObject:person.occupation?person.occupation:@"" forKey:@"occupation"];
                    [dict setObject:person.plusOneCount?person.plusOneCount:@"" forKey:@"plusOneCount"];
                    
                    
                    
                    NSMutableArray *orgArr=[[NSMutableArray alloc] init];
                    if(person.organizations.count>0){
                        for(int i=0;i<[person.organizations count];i++)
                        {
                            NSMutableDictionary *oDict=[[NSMutableDictionary alloc] init];
                            GTLPlusPersonOrganizationsItem *item=[person.organizations objectAtIndex:i];
                            [oDict setObject:item.department?item.department:@"" forKey:@"organizationDepartment"];
                            [oDict setObject:item.descriptionProperty?item.descriptionProperty:@"" forKey:@"organizationDescriptionProperty"];
                            [oDict setObject:item.endDate?item.endDate:@"" forKey:@"organizationEndDate"];
                            [oDict setObject:item.location?item.location:@"" forKey:@"organizationLocation"];
                            [oDict setObject:item.name?item.name:@"" forKey:@"organizationName"];
                            [oDict setObject:item.primary?item.primary:@"" forKey:@"organizationPrimary"];
                            [oDict setObject:item.startDate?item.startDate:@"" forKey:@"organizationStartDate"];
                            [oDict setObject:item.title?item.title:@"" forKey:@"organizationTitle"];
                            [oDict setObject:item.type?item.type:@"" forKey:@"organizationType"];
                            
                            [orgArr addObject:oDict];
                        }
                        
                        [dict setObject:orgArr forKey:@"organizations"];
                    }
                    
                    
                    NSMutableArray *placesArr=[[NSMutableArray alloc] init];
                    if(person.placesLived.count>0){
                        for(int i=0;i<[person.placesLived count];i++)
                        {
                            NSMutableDictionary *plDict=[[NSMutableDictionary alloc] init];
                            GTLPlusPersonPlacesLivedItem *item=[person.placesLived objectAtIndex:i];
                            [plDict setObject:item.value?item.value:@"" forKey:@"value"];
                            [plDict setObject:item.primary?item.primary:@"" forKey:@"primary"];
                            [placesArr addObject:plDict];
                        }
                        [dict setObject:placesArr forKey:@"placesLived"];
                    }
                    
                    
                    
                    [dict setObject:person.relationshipStatus?person.relationshipStatus:@"" forKey:@"relationshipStatus"];
                    
                    [dict setObject:person.skills?person.skills:@"" forKey:@"skills"];
                    [dict setObject:person.tagline?person.tagline:@"" forKey:@"tagline"];
                    [dict setObject:person.url?person.url:@"" forKey:@"personProfileURL"];
                    [dict setObject:person.verified?person.verified:@"" forKey:@"gPlusPageVerified"];
                   
                    NSMutableArray *urlsArr=[[NSMutableArray alloc] init];
                    if(person.urls.count>0){
                        for(int i=0;i<[person.urls count];i++)
                        {
                            NSMutableDictionary *uDict=[[NSMutableDictionary alloc] init];
                            GTLPlusPersonUrlsItem *item=[person.urls objectAtIndex:i];
                            [uDict setObject:item.value?item.value:@"" forKey:@"value"];
                            [uDict setObject:item.label?item.label:@"" forKey:@"label"];
                            [uDict setObject:item.type?item.type:@"" forKey:@"type"];
                            [urlsArr addObject:uDict];
                        }
                        [dict setObject:urlsArr forKey:@"personURLs"];
                    }
                                                                                
                    self.gPlusDetailsCompletionHandler(YES,dict);
                    
                }
            }];

    
}

- (void )postToGplus:(NSString *)message withImage:(UIImage *)image  withURLToShare:(NSString *)urlToShare withLocalVideoURL:(NSString *)localVideoURL completion:(GPlusShareCompletionHandler)completionHandler{
   
    isGplusDetails=NO;


    _gplusDict=[[NSMutableDictionary alloc] init];
    
    if(message.length>0)
    {
        [_gplusDict setObject:message forKey:@"message"];
    }
    if(image)
    {
        [_gplusDict setObject:image forKey:@"image"];
    }
    if(urlToShare.length>0)
    {
        [_gplusDict setObject:urlToShare forKey:@"urlToShare"];
    }
    if(localVideoURL.length>0)
    {
        [_gplusDict setObject:localVideoURL forKey:@"localVideoURL"];
    }
    
    self.gPlusShareCompletionHandler =[completionHandler copy];


    
    [self loginToGplus];
    
   
    
    
}
-(void)postToGplus{
    
    [GPPShare sharedInstance].delegate = self;
    id<GPPNativeShareBuilder> shareBuilder = [[GPPShare sharedInstance] nativeShareDialog];
    

    
    if([_gplusDict objectForKey:@"message"])
    {
        [shareBuilder setPrefillText:[_gplusDict objectForKey:@"message"]];
    }
    
    
    
    if([_gplusDict objectForKey:@"image"])
    {
        [shareBuilder attachImage:[_gplusDict objectForKey:@"image"]];
    }else if([_gplusDict objectForKey:@"urlToShare"])
    {
        [shareBuilder setURLToShare:[NSURL URLWithString:[_gplusDict objectForKey:@"urlToShare"]]];
    }
    else if([_gplusDict objectForKey:@"localVideoURL"])
    {
        [shareBuilder attachVideoURL:[NSURL URLWithString:[_gplusDict objectForKey:@"localVideoURL"]]];
    }
    
    [shareBuilder open];
}
- (void)finishedSharingWithError:(NSError *)error {
    NSString *text;
    
    if (!error) {
        text = @"Success";
        
        self.gPlusShareCompletionHandler(YES);
    }else{
        
        
        if (error.code == kGPPErrorShareboxCanceled) {
            text = @"Canceled";
           
        } else {
            text = [NSString stringWithFormat:@"Error (%@)", [error localizedDescription]];
            
        }
        self.gPlusShareCompletionHandler(NO);
        
    }
    
     NSLog(@"Gplus Share Status: %@", text);
}


@end
