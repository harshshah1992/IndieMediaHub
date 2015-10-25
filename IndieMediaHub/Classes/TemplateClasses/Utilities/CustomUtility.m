//
//  CustomUtility.m
//  Custom properties
//
//  Created by PC-27 on 04/06/14.
//  Copyright (c) 2014 Custom properties. All rights reserved.
//

#import "CustomUtility.h"
#import "CustomControls.h"
#import "Reachability.h"

static NSString *letters = @"abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789";
//TWTAPIManager *apiManager;


@implementation CustomUtility
+ (CustomUtility*)sharedInstance {
    static CustomUtility *utility = nil;
    if (utility == nil)
    {
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            utility = [[CustomUtility alloc] init];
        });
    }
    
    return utility;
}
#pragma mark - tabBar methods
+ (UIView *)getActionSheet:(id)parentController delegate:(id)pickerClass {
    UIView *tmpView = [[UIView alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    tmpView.frame = CGRectMake(0, tmpView.frame.size.height, tmpView.frame.size.width, tmpView.frame.size.height);
    tmpView.backgroundColor = [UIColor clearColor];
    UIView *transparentView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tmpView.frame.size.width, tmpView.frame.size.height)];
    transparentView.backgroundColor = [UIColor clearColor];
    transparentView.alpha = 0.4;
    [tmpView addSubview:transparentView];
    
    
    UITapGestureRecognizer *gesture=[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingleTap:)];
    [transparentView addGestureRecognizer:gesture];
    
    [[[UIApplication sharedApplication] keyWindow] addSubview:tmpView];
    return tmpView;
}
+ (void)handleSingleTap:(UITapGestureRecognizer *)recognizer {
    [[self sharedInstance] cancel_clicked:Nil];
}
- (void) removeActionSheetFromSuperView {
    [UIView animateWithDuration:0.2
                          delay:0.0
                        options: 0
                     animations:^{
                         [self.actionSheetview setFrame: CGRectMake(0, [[UIScreen mainScreen] bounds].size.height, self.actionSheetview.frame.size.width, self.actionSheetview.frame.size.height)];
                     }
                     completion:^(BOOL finished) {
                         [self.actionSheetview removeFromSuperview];
                     }];
}

+ (void)setNavigationBarSettings:(UINavigationController *)navigationController {
    
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    navigationController.navigationBar.translucent = NO;
    [[UINavigationBar appearance] setBackgroundImage:[UIImage imageNamed:@"top_bg2.png"] forBarMetrics:UIBarMetricsDefault];
    [[UINavigationBar appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor],NSFontAttributeName:[UIFont fontWithName:@"Lato-Regular" size:18]}];
    if([UINavigationBar instancesRespondToSelector:@selector(barTintColor)])
    {
        //iOS>=7
        //        [UINavigationBar appearance].barTintColor = [UIColor colorWithRed:173.0/255.0 green:4.0/255.0 blue:21.0/255.0 alpha:1];
    } else {
        //        [UINavigationBar appearance].tintColor = [UIColor colorWithRed:173.0/255.0 green:4.0/255.0 blue:21.0/255.0 alpha:1];
    }
    
}

+ (UIImage *)getTabBarImage:(NSString *)imageName {
    
    return [[UIImage imageNamed:imageName] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
}


+ (id)getViewController:(NSString *)viewController {
    return [[NSClassFromString(viewController) alloc] initWithNibName:viewController bundle:nil];
}
+ (UIImage *)imageWithColor:(UIColor *)color {
    CGRect rect = CGRectMake(0, 0, 1, 1);
    // Create a 1 by 1 pixel context
    UIGraphicsBeginImageContextWithOptions(rect.size, NO, 0);
    [color setFill];
    UIRectFill(rect);   // Fill it with your color
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}
+ (UIBarButtonItem *)getBarButton:(NSString *)image selectedImage:(NSString *)selectedImage action:(SEL)action target:(id)target {
    UIButton *btnBar = [UIButton buttonWithType:UIButtonTypeCustom];
    btnBar.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    UIImage *btnImage = [UIImage imageNamed:image];
    [btnBar setImage:btnImage forState:UIControlStateNormal];
    [btnBar setImage:[UIImage imageNamed:selectedImage] forState:UIControlStateHighlighted];
    [btnBar addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    btnBar.frame = CGRectMake(0, 0, btnImage.size.width, btnImage.size.height);
    return [[UIBarButtonItem alloc] initWithCustomView:btnBar];
}
+ (UIToolbar *)createToolBarWithTitle:(NSString *)title target:(id)target {
    UIToolbar *Toolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(0,0,[[UIApplication sharedApplication] keyWindow].bounds.size.width,44)];
    Toolbar.barStyle = UIBarStyleDefault;
    [Toolbar setBackgroundImage:[UIImage imageNamed:@"bg_top_bar"] forToolbarPosition:UIBarPositionAny barMetrics:UIBarMetricsDefault];
    Toolbar.opaque = NO;
    Toolbar.translucent = YES;
    [Toolbar setItems:[CustomUtility toolbarItemForPickerWithTarget:target] animated:YES];
    [Toolbar addSubview:[CustomUtility createTitleLabel:title]];
    return Toolbar;
}
+ (UIViewController *)getViewControllerFromNavigationController:(UINavigationController *)navController withNibName:(NSString *)nibName {
    NSArray *controllers = navController.viewControllers;
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"self.nibName = %@", nibName];
    controllers = [controllers filteredArrayUsingPredicate:predicate];
    if([controllers count] > 0) {
        return [controllers objectAtIndex:0];
    } else {
        return nil;
    }
}
+ (UIPickerView *)getPicker:(NSString *)title target:(id)target {
    UIToolbar *toolBar = [CustomUtility createToolBarWithTitle:title target:target];
    
    // UIActionSheet *actionSheet;
    UIPickerView *picker = [[UIPickerView alloc] init];
    picker.frame = CGRectMake(0, 44, [[UIApplication sharedApplication] keyWindow].bounds.size.width, 216);
    picker.delegate = target;
    picker.dataSource = target;
    picker.showsSelectionIndicator = YES;
    
    float origin;
    origin = [UIScreen mainScreen].bounds.size.height - 260;
    
    UIView *actionSheetView =[self getActionSheet:target delegate:target];
    [[CustomUtility sharedInstance] setActionSheetview:actionSheetView];
    UIView *objView =[[UIView alloc] init];
    objView.frame =CGRectMake(0, origin, actionSheetView.frame.size.width, actionSheetView.frame.size.height);
    [objView setBackgroundColor:[UIColor whiteColor]];
    [objView addSubview:toolBar];
    [objView addSubview:picker];
    [actionSheetView addSubview:objView ];
    [UIView animateWithDuration:0.1
                          delay:0.0
                        options: 0
                     animations:^{
                         [actionSheetView setFrame: CGRectMake(0, 0, actionSheetView.frame.size.width, actionSheetView.frame.size.height)];
                     }
                     completion:^(BOOL finished) {
                     }];
    return picker;
    
}

+ (UIDatePicker *)getDatePicker:(NSString *)title target:(id)target {
    
    
    if([CustomUtility sharedInstance].actionSheetview){
        
        [[CustomUtility sharedInstance].actionSheetview removeFromSuperview];
    }
    
    UIToolbar *toolBar = [CustomUtility createToolBarWithTitle:title target:target];
    
    // UIActionSheet *actionSheet;
    UIDatePicker *picker = [[UIDatePicker alloc] init];
    picker.datePickerMode = UIDatePickerModeDate;
    [picker addTarget:target action:@selector(dateChanged:) forControlEvents:UIControlEventValueChanged];
    picker.frame = CGRectMake(0, 44, [[UIApplication sharedApplication] keyWindow].bounds.size.width, 216);
    
    float origin;
    origin = [UIScreen mainScreen].bounds.size.height - 260;
    
    UIView *actionSheetView =[self getActionSheet:target delegate:target];
    [[CustomUtility sharedInstance] setActionSheetview:actionSheetView];
    UIView *objView =[[UIView alloc] init];
    objView.frame =CGRectMake(0, origin, actionSheetView.frame.size.width, actionSheetView.frame.size.height);
    [objView setBackgroundColor:[UIColor whiteColor]];
    [objView addSubview:toolBar];
    [objView addSubview:picker];
    [actionSheetView addSubview:objView ];
    [UIView animateWithDuration:0.1
                          delay:0.0
                        options: 0
                     animations:^{
                         [actionSheetView setFrame: CGRectMake(0, 0, actionSheetView.frame.size.width, actionSheetView.frame.size.height)];
                     }
                     completion:^(BOOL finished) {
                     }];
    return picker;
    
}

+ (UIDatePicker *)getDatePicker:(NSString *)title target:(id)target mode:(UIDatePickerMode)pickerMode {
    
    
    if([CustomUtility sharedInstance].actionSheetview){
        
        [[CustomUtility sharedInstance].actionSheetview removeFromSuperview];
    }
    
    
    UIToolbar *toolBar = [CustomUtility createToolBarWithTitle:title target:target];
    NSLocale *locale = [NSLocale localeWithLocaleIdentifier:@"NL"]; /* for 24hr format */
    //  NSLocale *locale = [NSLocale localeWithLocaleIdentifier:@"en_US"];
    // UIActionSheet *actionSheet;
    UIDatePicker *picker = [[UIDatePicker alloc] init];
    picker.locale = locale;
    picker.datePickerMode = pickerMode;
    [picker addTarget:target action:@selector(timeChanged:) forControlEvents:UIControlEventValueChanged];
    picker.frame = CGRectMake(0, 44, [[UIApplication sharedApplication] keyWindow].bounds.size.width, 216);
    
    float origin;
    origin = [UIScreen mainScreen].bounds.size.height - 260;
    
    UIView *actionSheetView =[self getActionSheet:target delegate:target];
    [[CustomUtility sharedInstance] setActionSheetview:actionSheetView];
    UIView *objView =[[UIView alloc] init];
    objView.frame =CGRectMake(0, origin, actionSheetView.frame.size.width, actionSheetView.frame.size.height);
    [objView setBackgroundColor:[UIColor whiteColor]];
    [objView addSubview:toolBar];
    [objView addSubview:picker];
    [actionSheetView addSubview:objView ];
    [UIView animateWithDuration:0.1
                          delay:0.0
                        options: 0
                     animations:^{
                         [actionSheetView setFrame: CGRectMake(0, 0, actionSheetView.frame.size.width, actionSheetView.frame.size.height)];
                     }
                     completion:^(BOOL finished) {
                     }];
    return picker;
    
}



+ (NSMutableArray *)toolbarItemForPickerWithTarget:(id)target {
    NSMutableArray *barItems = [[NSMutableArray alloc] init];
    NSString *cancelTitle = @"Cancel";
    NSString *doneTitle = @"Done";
    UIBarButtonItem *cancelBtn = [[UIBarButtonItem alloc] initWithTitle:cancelTitle style:UIBarButtonItemStylePlain target:target action:@selector(cancel_clicked:)];
    [barItems addObject:cancelBtn];
    UIBarButtonItem *flexSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    [barItems addObject:flexSpace];
    UIBarButtonItem *doneBtn = [[UIBarButtonItem alloc] initWithTitle:doneTitle style:UIBarButtonItemStylePlain target:target action:@selector(done_clicked:)];
    [barItems addObject:doneBtn];
    return barItems;
}
- (void)dateChanged:(id)sender {
    
}
- (void)cancel_clicked:(id)sender {
    
    [self removeActionSheetFromSuperView];
}
- (void)done_clicked:(id)sender {
    [self removeActionSheetFromSuperView];
}
+ (UILabel *)createTitleLabel:(NSString *)title {
    CGFloat lWidth,lheight;
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        lWidth = 4;
        lheight = 36;
    } else {
        if ([UIApplication sharedApplication].statusBarOrientation == UIInterfaceOrientationPortrait || [UIApplication sharedApplication].statusBarOrientation == UIInterfaceOrientationPortraitUpsideDown) {
            lheight = 36;
            lWidth = 4;
        } else {
            lWidth = 2;
            lheight = 28;
        }
    }
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0,lWidth,[[UIScreen mainScreen] bounds].size.width,lheight)];
    label.backgroundColor = [UIColor clearColor];
    label.font = [UIFont fontWithName:@"PT Sans" size:15];
    label.text = title;
    label.textColor = [UIColor redColor];
    label.textAlignment = NSTextAlignmentCenter;
    return label;
}
+ (NSMutableArray *)getArrayBetween:(int)start andEnd:(int)end step:(int)step {
    NSMutableArray *arrBounds = [NSMutableArray array];
    for (int i = start; i <= end; i = i + step) {
        [arrBounds addObject:[NSString stringWithFormat:@"%i", i]];
    }
    return arrBounds;
}
+ (NSString *)getStringFromDate:(NSDate *)date withFormat:(NSString *)format {
    NSDateFormatter *formatter=[[NSDateFormatter alloc]init];
    [formatter setTimeZone:[NSTimeZone systemTimeZone]];
    [formatter setLocale:[NSLocale currentLocale]];
    [formatter setDateFormat:format];
    NSString *dateString = [formatter stringFromDate:date];
    return dateString;
}
+ (NSDate *)getDateFromString:(NSString *)dateString withFormat:(NSString *)format {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setTimeZone:[NSTimeZone systemTimeZone]];
    [formatter setLocale:[NSLocale currentLocale]];
    [formatter setDateFormat:format];
    NSDate* sourceDate = [formatter dateFromString:dateString];
    return sourceDate;
}
+ (NSArray *)getPerPickerDataSource {
    return [NSArray arrayWithObjects:@"Day",@"Week",@"Month", nil];
}

//Custom properties
+ (void) showAlertWithTitle:(NSString *)title andMessage:(NSString *)message {
    [CustomUtility showAlertWithTitle:title andMessage:message withCancelButtonTitle:NSLocalizedString(@"OK", nil) otherButtonTitles:nil];
}
+ (void) showAlertWithTitle:(NSString *)title andMessage:(NSString *)message withCancelButtonTitle:(NSString *)cancelTitle otherButtonTitles:(NSString *)otherButtonsTitles {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title message:message delegate:self cancelButtonTitle:cancelTitle otherButtonTitles:otherButtonsTitles, nil];
    [alert show];
}

+ (id)getSessionValue:(NSString *)key {
    return [[NSUserDefaults standardUserDefaults] valueForKey:key];
}
+ (void)saveSessionValue:(id)value withKey:(NSString *)key {
    [[NSUserDefaults standardUserDefaults] setValue:value forKey:key];
    [[NSUserDefaults standardUserDefaults] synchronize];
}
+ (void)removeSessionValue:(NSString *)key {
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:key];
    [[NSUserDefaults standardUserDefaults] synchronize];
}


+(BOOL)isValidUrl:(NSString *)url {
    NSURL *candidateURL = [NSURL URLWithString:url];
    if (candidateURL && candidateURL.scheme && candidateURL.host) {
        return YES;
    }
    return NO;
}
+(BOOL)isDocumentFolderUrl:(NSString *)url {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    if([url rangeOfString:documentsDirectory].location != NSNotFound) {
        return YES;
    }
    return NO;
}
+(NSMutableDictionary *)removeNullFromDict:(NSDictionary *)dictionary {
    NSMutableDictionary *filteredDictionary = [dictionary mutableCopy];
    NSSet *keysToRemove = [dictionary keysOfEntriesPassingTest:^BOOL(id key, id obj, BOOL *stop) {
        if (obj == [NSNull null]) {
            return YES;
        } else {
            return NO;
        }
    }];
    [filteredDictionary removeObjectsForKeys:[keysToRemove allObjects]];
    return filteredDictionary;
}
+(NSString *)getDocumentFolderPathByAppendingPathComponent:(NSString *)fileName {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    return  [documentsDirectory stringByAppendingPathComponent:fileName];
}

+(NSString *)prepareFileNameWithExtension:(NSString *)extension{
    //Create unique filename
    //	CFUUIDRef newUniqueId = CFUUIDCreate(kCFAllocatorDefault);
    //	CFStringRef newUniqueIdString = CFUUIDCreateString(kCFAllocatorDefault, newUniqueId);
    //    NSString *tempName = (__bridge NSString *)newUniqueIdString;
    //	NSString *fileName = [tempName stringByAppendingPathExtension: extension];
    //	CFRelease(newUniqueId);
    //	CFRelease(newUniqueIdString);
    //    return fileName;
    NSMutableString *randomString = [NSMutableString stringWithCapacity: 8];
    for (int i=0; i<8; i++) {
        [randomString appendFormat: @"%C", [letters characterAtIndex: arc4random() % [letters length]]];
    }
    return [[[randomString stringByAppendingString:[NSString stringWithFormat:@"%f",[[NSDate date] timeIntervalSince1970]]] stringByReplacingOccurrencesOfString:@"." withString:@""] stringByAppendingPathExtension: extension];
    
}
+ (NSString *)getRandomFilePathWithExtensionInDocumentFolder:(NSString *)extension withPrefix:(NSString *)prefix{
    NSString *fileName = [NSString stringWithFormat:@"%@%@",prefix,[CustomUtility prepareFileNameWithExtension:extension]];
    return [CustomUtility getDocumentFolderPathByAppendingPathComponent:fileName];
}

+ (BOOL)saveFileInDocumentFolderAtPath:(NSString *)path andFileData:(NSData *)fileData {
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if([fileManager fileExistsAtPath:path]) {
        NSError *error;
        if ([fileManager removeItemAtPath:path error:&error] == NO) {
            NSLog(@"removeItemAtPath %@ error:%@", path, error);
        }
    }
    NSError *error;
    [fileData writeToFile:path options:NSDataWritingAtomic error:&error];
    if(error == nil) {
        return YES;
    } else {
        NSLog(@"Unable write fileat path: %@ with error:%@", path, error);
        return NO;
    }
}


+ (NSString *)getCustomFont:(NSString *)fontName {
    if ([UIFont fontWithName:fontName size:20.0] != nil) {
        return fontName;
    } else {
        NSLog(@"PLEASE ADD FONT FILE INTO PROJECT AND PLIST ALSO");
        return @"";
    }
}

+ (void)setBorderSettingsForController:(id)controller {
    CustomView *currentView = (CustomView *)controller;
    currentView.layer.borderColor = (currentView.borderColor)?[currentView.borderColor CGColor]:nil;
    currentView.layer.borderWidth = (currentView.borderWidth)?currentView.borderWidth :0;
    currentView.layer.cornerRadius = (currentView.borderRadius)? currentView.borderRadius :0;
    [currentView.layer setMasksToBounds:YES];
}

+(NSString *)getStringFromBool:(BOOL)boolValue {
    if(!boolValue) {
        return @"0";
    } else {
        return @"1";
    }
}
+(BOOL)getBoolFromString:(NSString *)stringValue {
    if([stringValue isKindOfClass:[NSString class]]) {
        if(stringValue == nil || [stringValue length] == 0 || [[stringValue uppercaseString] isEqualToString:@"NO"] || [[stringValue uppercaseString] isEqualToString:@"0"]) {
            return NO;
        } else {
            return YES;
        }
    } else {
        return (int)stringValue;
    }
    
}

+ (NSString *)replaceAllSpecialCharectrs:(NSString *)value {
    return [value stringByReplacingOccurrencesOfString:@"'" withString:@"|||"];
}

+ (NSDictionary *)readLocalJsonFileWithName:(NSString *)fileName {
    NSString *filePath = [[NSBundle mainBundle] pathForResource:fileName ofType:@"json"];
    NSString *jsonString = [[NSString alloc] initWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error: NULL];
    NSError *error;
    NSDictionary *jsonDataDict = [NSJSONSerialization JSONObjectWithData:[jsonString dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingMutableLeaves error:&error];
    if(error) {
        return nil;
    }
    return jsonDataDict;
}

-(CGSize)getSizeforText:(NSString *)message controller:(id)view
{
    UIFont *font;
    if ([view isKindOfClass:[UIButton class]] || [view isKindOfClass:[CustomButton class]]) {
        CustomButton *tempBtn = (CustomButton *)view;
        font = tempBtn.titleLabel.font;
    } else if ([view isKindOfClass:[UILabel class]] || [view isKindOfClass:[CustomLabel class]]) {
        CustomLabel *tempLbl = (CustomLabel *)view;
        font = tempLbl.font;
    } else {
        font = [UIFont fontWithName:PROJECT_FONT_NAME_NORMAL size:PROJECT_FONT_HEADER_SIZE];
    }
    CustomLabel *tempView = (CustomLabel *)view;
    NSStringDrawingContext *context = [[NSStringDrawingContext alloc] init];
    context.minimumScaleFactor = 0.8;
    
    if(floor(NSFoundationVersionNumber)<=NSFoundationVersionNumber_iOS_6_1) {
        CGSize maximumSize = CGSizeMake(tempView.frame.size.width, 2000);
        
        
        CGSize myStringSize = [message sizeWithFont:font
                                  constrainedToSize:maximumSize
                                      lineBreakMode:tempView.lineBreakMode];
        
        return myStringSize ;
    } else {
        return  [message boundingRectWithSize:CGSizeMake(tempView.frame.size.width, 2000)
                                      options:NSStringDrawingUsesLineFragmentOrigin
                                   attributes:@{ NSFontAttributeName : font}
                                      context:context].size;
    }
    
}

+(CustomButton *)prepareButtonWithText:(NSString *)text withNormalImageName:(NSString *)normImg withSelectedImage:(NSString *)selImg{
    
    CustomButton *button = [CustomButton buttonWithType:UIButtonTypeCustom];
    [button setImage:[UIImage imageNamed:normImg] forState:UIControlStateNormal];
    [button setTitle:text forState:UIControlStateNormal];
    [button setImage:[UIImage imageNamed:selImg] forState:UIControlStateSelected];
    button.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleLeftMargin;
    return button;
}

+ (UIBarButtonItem *)getBarButton:(NSString *)title action:(SEL)action target:(id)target {
    UIButton *btnBar = [UIButton buttonWithType:UIButtonTypeCustom];
    [btnBar setTitle:title forState:UIControlStateNormal];
    [btnBar setTitleColor:[UIColor colorWithRed:243.0/255.0 green:228.0/255.0 blue:246.0/255.0 alpha:1] forState:UIControlStateNormal];
    [btnBar addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    btnBar.frame = CGRectMake(0, 0, 65, 44);
    btnBar.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    btnBar.titleLabel.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:18];
    
    return [[UIBarButtonItem alloc] initWithCustomView:btnBar];
}
+ (UIImage *)imageWithMaskName:(NSString *)maskImage originalImageName:(NSString *)originalImage overlayImageName:(NSString *)overlayImage
{
    
    if([[CustomUtility sharedInstance].objImageCachingDict valueForKey:originalImage]) {
        return [[CustomUtility sharedInstance].objImageCachingDict objectForKey:originalImage];
    }else {
        UIImage *originalImageobj=[UIImage imageNamed:originalImage];
        UIImage *maskImageobj=[UIImage imageNamed:maskImage];
        UIImage *overlayImageobj=[UIImage imageNamed:overlayImage];
        //create drawing context
        UIGraphicsBeginImageContextWithOptions(originalImageobj.size, NO, 0.0f);
        CGContextRef context = UIGraphicsGetCurrentContext();
        
        //apply mask
        CGContextClipToMask(context, CGRectMake(0.0f, 0.0f, originalImageobj.size.width, originalImageobj.size.height), maskImageobj.CGImage);
        
        //draw image
        [originalImageobj drawAtPoint:CGPointZero];
        
        //capture resultant image
        UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        UIGraphicsBeginImageContextWithOptions(image.size, NO, 0.0f);
        [image drawInRect:CGRectMake(0, 0, image.size.width, image.size.height)];
        [overlayImageobj drawInRect:CGRectMake(0, image.size.height - image.size.height, image.size.width, image.size.height)];
        UIImage *resultImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        [[CustomUtility sharedInstance].objImageCachingDict setObject:resultImage forKey:originalImage];
    }
    
    return [[CustomUtility sharedInstance].objImageCachingDict objectForKey:originalImage];
    
}
+ (UIImage *)imageWithMask:(UIImage *)maskImage originalImage:(UIImage *)originalImage overlayImage:(UIImage *)overlayImage;
{
    
    //return originalImage;
    //create drawing context
    UIGraphicsBeginImageContextWithOptions(originalImage.size, NO, 0.0f);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    //apply mask
    CGContextClipToMask(context, CGRectMake(0.0f, 0.0f, originalImage.size.width, originalImage.size.height), maskImage.CGImage);
    
    //draw image
    [originalImage drawAtPoint:CGPointZero];
    
    //capture resultant image
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    UIGraphicsBeginImageContextWithOptions(image.size, NO, 0.0f);
    [image drawInRect:CGRectMake(0, 0, image.size.width, image.size.height)];
    [overlayImage drawInRect:CGRectMake(0, image.size.height - image.size.height, image.size.width, image.size.height)];
    UIImage *resultImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return resultImage;
    
}
+ (BOOL)validateEmail:(NSString *) emailString
{
    NSString *str = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", str];
    BOOL isValid = [emailTest evaluateWithObject:emailString];
    return isValid;
}
+ (BOOL) validatePassword:(NSString *) password {
    if ( [password length]<5 ) return NO;
    NSString *myRegex = @"[A-Z0-9a-z_]*";
    NSPredicate *myTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", myRegex];
    return [myTest evaluateWithObject:password];
}


+ (void )getDetailsFromFacebookLogin:(void (^)(id arrayResult ,id accessToken))block {
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

+(void)getDetailsFromtwitterLogin:(void (^)(id arrayResult,id accessToken))block {
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
                         //                         [apiManager performReverseAuthForAccount:twitterAccount withHandler:^(NSData *responseData, NSError *error) {
                         //                             if (responseData) {
                         //                                 NSString *responseStr = [[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding];
                         //                                 NSArray *parts = [responseStr componentsSeparatedByString:@"&"];
                         //                                 NSString *lined1 = [parts objectAtIndex:0];
                         //                                 NSString *lined2 = [parts objectAtIndex:1];
                         //
                         //                                 lined1 = [lined1 stringByReplacingOccurrencesOfString:@"oauth_token=" withString:@""];
                         //                                 lined2 = [lined2 stringByReplacingOccurrencesOfString:@"oauth_token_secret=" withString:@""];
                         //                                 NSString *lined = [NSString stringWithFormat:@"%@|%@",lined1,lined2];
                         //                                 NSLog(@"TOKEN lined--->%@",lined);
                         //                                 dispatch_async(dispatch_get_main_queue(), ^{
                         //                                     block(arrTwitterData,lined);
                         //
                         //                                     //                                         UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Success!" message:lined delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                         //                                     //                                         [alert show];
                         //                                 });
                         //                             }
                         //                             else {
                         //                                 block(arrTwitterData,@"sorry no access token");
                         //
                         //                             }
                         //                         }];
                         
                         
                         //  block(arrTwitterData,@"TwitterAcessToken");
                         
                         //                              NSString *strrs = [[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding];
                         //                             NSLog(@"Result %@",strrs);
                         //                             block(strrs);
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

+ (UIImage*)imageWithImage:(UIImage*)image scaledToSize:(CGSize)newSize
{
    UIGraphicsBeginImageContext(newSize);
    [image drawInRect:CGRectMake(0,0,newSize.width,newSize.height)];
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

- (void)addProgressHUD :(UIView *) objView {
    self.progressHUD  = [MBProgressHUD showHUDAddedTo:objView animated:YES];
    [self.progressHUD show:YES];
    self.progressHUD.removeFromSuperViewOnHide = YES;
    self.progressHUD.userInteractionEnabled = NO;
}
- (void)removeProgressHUB {
    if (self.progressHUD) {
        [self.progressHUD hide:YES];
        [self.progressHUD removeFromSuperview];
        self.progressHUD = nil;
    }
}
+ (UIActivityIndicatorView *)getActityIndicatorWithHeight:(int)height andWithWitdth:(int)width   {
    UIActivityIndicatorView *activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray] ;
    activityIndicator.center = CGPointMake(width / 2,height / 2);
    [activityIndicator startAnimating];
    [activityIndicator setHidesWhenStopped:YES];
    return activityIndicator;
}
+ (void)setTabBarimgInsets:(UITabBarController *)tabBarController {
    [tabBarController.tabBar setSelectionIndicatorImage:[[UIImage alloc] init]];
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        int insetBottom, insetTop,item3left,item3right;
        
        if(floor(NSFoundationVersionNumber)>NSFoundationVersionNumber_iOS_6_1) {
            insetBottom = -7;
            insetTop = 7;
            item3left = -6;
            item3right = 6;
        }else {
            insetBottom = 0;
            insetTop = 0;
            item3left = -3;
            item3right = 3;
        }
        
        
        
        for (UITabBarItem *item in tabBarController.tabBar.items) {
            if(item == [tabBarController.tabBar.items objectAtIndex:0]){
                item.imageInsets = UIEdgeInsetsMake(insetTop, -35, insetBottom, 35);
            }else if(item == [tabBarController.tabBar.items objectAtIndex:1] ) {
                item.imageInsets = UIEdgeInsetsMake(insetTop, 10, insetBottom, -10);
            }else if(item == [tabBarController.tabBar.items objectAtIndex:3] ) {
                item.imageInsets = UIEdgeInsetsMake(insetTop, item3left, insetBottom, item3right);
            }else if(item == [tabBarController.tabBar.items objectAtIndex:4]) {
                item.imageInsets = UIEdgeInsetsMake(insetTop, 30, insetBottom, -30);
            }else if(item == [tabBarController.tabBar.items objectAtIndex:2] ) {
                if(floor(NSFoundationVersionNumber)>NSFoundationVersionNumber_iOS_6_1)
                    item.imageInsets = UIEdgeInsetsMake(insetTop, 0, insetBottom, 0);
                else
                    item.imageInsets = UIEdgeInsetsMake(insetTop, 3	, insetBottom, -3);
                
            }
        }
        
    }else{
        
        for (UITabBarItem *item in tabBarController.tabBar.items) {
            if(item == [tabBarController.tabBar.items objectAtIndex:0]){
                item.imageInsets = UIEdgeInsetsMake(5, -5, -5, 5);
            }else if(item == [tabBarController.tabBar.items objectAtIndex:1]) {
                item.imageInsets = UIEdgeInsetsMake(5 ,10, -5, -10);
            }else if(item == [tabBarController.tabBar.items objectAtIndex:3]) {
                item.imageInsets = UIEdgeInsetsMake(5, -6, -5, 6);
            }else if(item == [tabBarController.tabBar.items objectAtIndex:4]) {
                item.imageInsets = UIEdgeInsetsMake(5, 5, -5, -5);
            }else {
                item.imageInsets = UIEdgeInsetsMake(5, 0, -5, 0);
            }
        }
    }
    
}
+(NSString*)uniqueIDForDevice
{
    NSString* uniqueIdentifier = nil;
    if(floor(NSFoundationVersionNumber)>NSFoundationVersionNumber_iOS_6_1 ) { // >=iOS 7
        uniqueIdentifier = [[[UIDevice currentDevice] identifierForVendor] UUIDString];
    } else { //<=iOS6, Use UDID of Device
        CFUUIDRef uuid = CFUUIDCreate(NULL);
        //uniqueIdentifier = ( NSString*)CFUUIDCreateString(NULL, uuid);- for non- ARC
        uniqueIdentifier = ( NSString*)CFBridgingRelease(CFUUIDCreateString(NULL, uuid));// for ARC
        CFRelease(uuid);
    }
    
    return uniqueIdentifier;
}

- (UIImage *)squareImageWithImage:(UIImage *)image scaledToSize:(CGSize)newSize {
    double ratio;
    double delta;
    CGPoint offset;
    
    //make a new square size, that is the resized imaged width
    CGSize sz = CGSizeMake(newSize.width, newSize.width);
    
    //figure out if the picture is landscape or portrait, then
    //calculate scale factor and offset
    if (image.size.width > image.size.height) {
        ratio = newSize.width / image.size.width;
        delta = (ratio*image.size.width - ratio*image.size.height);
        offset = CGPointMake(delta/2, 0);
    } else {
        ratio = newSize.width / image.size.height;
        delta = (ratio*image.size.height - ratio*image.size.width);
        offset = CGPointMake(0, delta/2);
    }
    
    //make the final clipping rect based on the calculated values
    CGRect clipRect = CGRectMake(-offset.x, -offset.y,
                                 (ratio * image.size.width) + delta,
                                 (ratio * image.size.height) + delta);
    
    
    //start a new context, with scale factor 0.0 so retina displays get
    //high quality image
    if ([[UIScreen mainScreen] respondsToSelector:@selector(scale)]) {
        UIGraphicsBeginImageContextWithOptions(sz, YES, 0.0);
    } else {
        UIGraphicsBeginImageContext(sz);
    }
    UIRectClip(clipRect);
    [image drawInRect:clipRect];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return newImage;
}

+ (void )underlineLabel:(UILabel*)lbl withInRange:(NSRange)range withColor:(UIColor*)color withStyle:(NSUnderlineStyle)style{
    if (![lbl respondsToSelector:@selector(setAttributedText:)]) {
        return;
    }
    NSMutableAttributedString *attributedText;
    if (!lbl.attributedText) {
        attributedText = [[NSMutableAttributedString alloc] initWithString:lbl.text];
    } else {
        attributedText = [[NSMutableAttributedString alloc] initWithAttributedString:lbl.attributedText];
    }
    
    [attributedText addAttribute:NSUnderlineColorAttributeName value:color range:range];
    [attributedText addAttribute:NSUnderlineStyleAttributeName value:[NSNumber numberWithInteger:style] range:range];
    lbl.attributedText = attributedText;
}


- (void)synchronizingUserData:(UIView *)addHUDView{
    
}




+ (UITabBarController*)getTabBarController {
    
    if ([CustomUtility sharedInstance].tabBarController) {
        [CustomUtility sharedInstance].tabBarController = nil;
    }
    
    
    [[UITabBarItem appearance] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
                                                       [UIFont fontWithName:@"HelveticaNeue-Medium" size:0.0f], NSFontAttributeName,
                                                       [UIColor clearColor], NSForegroundColorAttributeName,
                                                       nil] forState:UIControlStateNormal];
    
    [CustomUtility sharedInstance].tabBarController = [[UITabBarController alloc] init];
    
    
    [CustomUtility sharedInstance].tabBarController.moreNavigationController.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"More" image:[UIImage new] tag:0];
    
    id  searchByLocationVC = [CustomUtility getViewController:@"SearchByLocationVC"];
    UINavigationController *searchNavController = [[UINavigationController alloc] initWithRootViewController:searchByLocationVC];
    [CustomUtility setNavigationBarSettings:searchNavController];
    searchNavController.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"" image:[CustomUtility getTabBarImage:@""] selectedImage:[CustomUtility getTabBarImage:@""]];
    searchNavController.tabBarItem.imageInsets = UIEdgeInsetsMake(6, 0, -6, 0);
    searchNavController.navigationItem.hidesBackButton = YES;
    
    
    
    id  HomeVC = [CustomUtility getViewController:@"HomeVC"];
    UINavigationController *navForHome = [[UINavigationController alloc] initWithRootViewController:HomeVC];
    [CustomUtility setNavigationBarSettings:navForHome];
    navForHome.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"" image:[CustomUtility getTabBarImage:@""] selectedImage:[CustomUtility getTabBarImage:@""]];
    navForHome.tabBarItem.imageInsets = UIEdgeInsetsMake(6, 0, -6, 0);
    navForHome.navigationItem.hidesBackButton = YES;
    
    
    id  MainMapVC = [CustomUtility getViewController:@"MainMapVC"];
    UINavigationController *navForMainMap = [[UINavigationController alloc] initWithRootViewController:MainMapVC];
    [CustomUtility setNavigationBarSettings:navForMainMap];
    navForMainMap.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"" image:[CustomUtility getTabBarImage:@""] selectedImage:[CustomUtility getTabBarImage:@""]];
    navForMainMap.tabBarItem.imageInsets = UIEdgeInsetsMake(6, 0, -6, 0);
    navForMainMap.navigationItem.hidesBackButton = YES;
    
    
    id  favouriteVC = [CustomUtility getViewController:@"FavouriteVC"];
    UINavigationController *favouriteNavController = [[UINavigationController alloc] initWithRootViewController:favouriteVC];
    [CustomUtility setNavigationBarSettings:favouriteNavController];
    favouriteNavController.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"" image:[CustomUtility getTabBarImage:@""] selectedImage:[CustomUtility getTabBarImage:@""]];
    favouriteNavController.tabBarItem.imageInsets = UIEdgeInsetsMake(6, 0, -6, 0);
    favouriteNavController.navigationItem.hidesBackButton = YES;
    
    
    id  dealsVC = [CustomUtility getViewController:@"DealsVC"];
    UINavigationController *dealsNavController = [[UINavigationController alloc] initWithRootViewController:dealsVC];
    [CustomUtility setNavigationBarSettings:dealsNavController];
    dealsNavController.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"" image:[CustomUtility getTabBarImage:@""] selectedImage:[CustomUtility getTabBarImage:@""]];
    dealsNavController.tabBarItem.imageInsets = UIEdgeInsetsMake(6, 0, -6, 0);
    dealsNavController.navigationItem.hidesBackButton = YES;
    
    
    id  historyVC = [CustomUtility getViewController:@"HistoryVC"];
    UINavigationController *historyNavController = [[UINavigationController alloc] initWithRootViewController:historyVC];
    [CustomUtility setNavigationBarSettings:historyNavController];
    historyNavController.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"" image:[CustomUtility getTabBarImage:@""] selectedImage:[CustomUtility getTabBarImage:@""]];
    historyNavController.tabBarItem.imageInsets = UIEdgeInsetsMake(6, 0, -6, 0);
    historyNavController.navigationItem.hidesBackButton = YES;
    
        id  settingsVC = [CustomUtility getViewController:@"SettingsVC"];
        UINavigationController *settingsNavController = [[UINavigationController alloc] initWithRootViewController:settingsVC];
        [CustomUtility setNavigationBarSettings:settingsNavController];
        settingsNavController.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"" image:[CustomUtility getTabBarImage:@""] selectedImage:[CustomUtility getTabBarImage:@""]];
        settingsNavController.tabBarItem.imageInsets = UIEdgeInsetsMake(6, 0, -6, 0);
        settingsNavController.navigationItem.hidesBackButton = YES;
    
    
    

    
    //    for btnSearchLocation
    [CustomUtility sharedInstance].btnSearchLocation = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width/2, 50)];
    [CustomUtility sharedInstance].btnSearchLocation.tag = 100;
    [[CustomUtility sharedInstance].btnSearchLocation setImage:[UIImage imageNamed:@"tbbar_btn_srch_normal"] forState:UIControlStateNormal];
    [[CustomUtility sharedInstance].btnSearchLocation setImage:[UIImage imageNamed:@"tbbar_btn_srch_highlighted"] forState:UIControlStateHighlighted];
    [[CustomUtility sharedInstance].btnSearchLocation setImage:[UIImage imageNamed:@"tbbar_btn_srch_highlighted"] forState:UIControlStateSelected];
    [CustomUtility sharedInstance].btnSearchLocation.imageEdgeInsets = UIEdgeInsetsMake(0, -35, 0, 35);
    [[CustomUtility sharedInstance].btnSearchLocation addTarget:[CustomUtility sharedInstance] action:@selector(tabSidesClicked:) forControlEvents:UIControlEventTouchUpInside];
    [[CustomUtility sharedInstance].tabBarController.tabBar addSubview:[CustomUtility sharedInstance].btnSearchLocation];
    
    
    
    
    //   for btnFavourites
    [CustomUtility sharedInstance].btnFavourites = [[UIButton alloc] initWithFrame:CGRectMake([UIScreen mainScreen].bounds.size.width/2, 0, [UIScreen mainScreen].bounds.size.width/2, 50)];
    [CustomUtility sharedInstance].btnFavourites.tag = 103;
    [[CustomUtility sharedInstance].btnFavourites setImage:[UIImage imageNamed:@"tbbar_btn_wish_normal"] forState:UIControlStateNormal];
    [[CustomUtility sharedInstance].btnFavourites setImage:[UIImage imageNamed:@"tbbar_btn_wish_highlighted"] forState:UIControlStateHighlighted];
    [[CustomUtility sharedInstance].btnFavourites setImage:[UIImage imageNamed:@"tbbar_btn_wish_highlighted"] forState:UIControlStateSelected];
    [CustomUtility sharedInstance].btnFavourites.imageEdgeInsets = UIEdgeInsetsMake(0, 35, 0, -35);
    
    [[CustomUtility sharedInstance].btnFavourites addTarget:[CustomUtility sharedInstance] action:@selector(tabSidesClicked:) forControlEvents:UIControlEventTouchUpInside];
    [[CustomUtility sharedInstance].tabBarController.tabBar addSubview:[CustomUtility sharedInstance].btnFavourites];
    
    [[CustomUtility sharedInstance].tabBarController.tabBar setBackgroundColor:[UIColor clearColor]];
    
    
    [CustomUtility sharedInstance].tabBarController.viewControllers = [NSArray arrayWithObjects:searchNavController,navForMainMap,navForHome,favouriteNavController,dealsNavController,historyNavController,settingsNavController, nil];
    [CustomUtility sharedInstance].tabBarController.navigationItem.hidesBackButton = YES;
    [[CustomUtility sharedInstance].tabBarController.tabBar setShadowImage:[UIImage new]];
    [[CustomUtility sharedInstance].tabBarController.tabBar setBackgroundImage:[UIImage imageNamed:@"tbbar_bg.png"]];
    [CustomUtility sharedInstance].tabBarController.selectedIndex = 2;
    
    [[CustomUtility sharedInstance].tabBarController.tabBar bringSubviewToFront:[CustomUtility sharedInstance].btnSearchLocation];
    [[CustomUtility sharedInstance].tabBarController.tabBar bringSubviewToFront:[CustomUtility sharedInstance].btnFavourites];
    
    [CustomUtility sharedInstance].tabBarController.tabBar.translucent= NO;
    
    [[UITabBar appearance] setBarTintColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"tbbar_bg.png"]]];
    
    return [CustomUtility sharedInstance].tabBarController;
    
}

- (void)tabSidesClicked:(UIButton*)btn {
    if (btn.tag == 100) {
        [CustomUtility sharedInstance].tabBarController.selectedIndex = 0;
        
        [CustomUtility sharedInstance].isTabFavoutitesDoubleTapped = NO;
        [CustomUtility sharedInstance].isTabHomeDoubleTapped = NO;
        [CustomUtility sharedInstance].isTabMainMapDoubleTapped = NO;
        
        if ([CustomUtility sharedInstance].isTabSearchLocationDoubleTapped) {
            [[[[CustomUtility sharedInstance].tabBarController viewControllers] objectAtIndex:0] popToRootViewControllerAnimated:YES];
            [CustomUtility sharedInstance].isTabSearchLocationDoubleTapped = NO;
        }else {
            [CustomUtility sharedInstance].isTabSearchLocationDoubleTapped = YES;
        }
        [CustomUtility sharedInstance].btnSearchLocation.selected = YES;
        [CustomUtility sharedInstance].btnFavourites.selected = NO;
    }else if(btn.tag == 103) {
        [CustomUtility sharedInstance].tabBarController.selectedIndex = 3;
        
        [CustomUtility sharedInstance].isTabSearchLocationDoubleTapped = NO;
        [CustomUtility sharedInstance].isTabHomeDoubleTapped = NO;
        [CustomUtility sharedInstance].isTabMainMapDoubleTapped = NO;
        
        if ([CustomUtility sharedInstance].isTabFavoutitesDoubleTapped) {
            [[[[CustomUtility sharedInstance].tabBarController viewControllers] objectAtIndex:3] popToRootViewControllerAnimated:YES];
            [CustomUtility sharedInstance].tabBarController.selectedIndex = 3;
            [CustomUtility sharedInstance].isTabFavoutitesDoubleTapped = NO;
        }else {
            [CustomUtility sharedInstance].isTabFavoutitesDoubleTapped = YES;
        }
        [CustomUtility sharedInstance].btnSearchLocation.selected = NO;
        [CustomUtility sharedInstance].btnFavourites.selected = YES;
    }
    
}


- (void) wheelDidChangeValue:(NSString *)newValue {
    [CustomUtility sharedInstance].btnSearchLocation.selected = NO;
    [CustomUtility sharedInstance].btnFavourites.selected = NO;
    NSLog(@"%@",newValue);
    if ([newValue  isEqualToString: @"MainMapVC"]) {
        
        [CustomUtility sharedInstance].isMapFromTab = YES;
        
        [CustomUtility sharedInstance].tabBarController.selectedIndex = 1;
        [CustomUtility sharedInstance].isTabSearchLocationDoubleTapped = NO;
        [CustomUtility sharedInstance].isTabHomeDoubleTapped = NO;
        [CustomUtility sharedInstance].isTabFavoutitesDoubleTapped = NO;
        
        if ([CustomUtility sharedInstance].isTabMainMapDoubleTapped) {
            [[[[CustomUtility sharedInstance].tabBarController viewControllers] objectAtIndex:1] popToRootViewControllerAnimated:YES];
            [CustomUtility sharedInstance].isTabMainMapDoubleTapped = NO;
        }else {
            [CustomUtility sharedInstance].isTabMainMapDoubleTapped = YES;
        }
    }else if ([newValue isEqualToString:@"HomeVC"]) {
        
        [CustomUtility sharedInstance].tabBarController.selectedIndex = 2;
        [CustomUtility sharedInstance].isTabSearchLocationDoubleTapped = NO;
        [CustomUtility sharedInstance].isTabMainMapDoubleTapped = NO;
        [CustomUtility sharedInstance].isTabFavoutitesDoubleTapped = NO;
        
        if ([CustomUtility sharedInstance].isTabHomeDoubleTapped) {
            [[[[CustomUtility sharedInstance].tabBarController viewControllers] objectAtIndex:2] popToRootViewControllerAnimated:YES];
            [CustomUtility sharedInstance].isTabHomeDoubleTapped = NO;
        }else {
            [CustomUtility sharedInstance].isTabHomeDoubleTapped = YES;
        }
    }
}


+ (void)setPropertiesForToogleGambayButton:(UIButton*)btn {
    [btn setTitleColor:[UIColor colorWithRed:65.0/256.0 green:132.0/256.0 blue:172.0/256.0 alpha:1.0] forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
    [btn setBackgroundImage:[UIImage imageNamed:@"top_menu_bg_normal.png"] forState:UIControlStateNormal];
    [btn setBackgroundImage:[UIImage imageNamed:@"top_bg.png"] forState:UIControlStateHighlighted];
    [btn setBackgroundImage:[UIImage imageNamed:@"top_bg.png"] forState:UIControlStateSelected];
}

+ (void)resignKeyBoard:(UIView*)view {
    for (UIView *subView in view.subviews) {
        if (subView.isFirstResponder) {
            [subView resignFirstResponder];
            return;
        }else {
            [self resignKeyBoard:subView];
            
        }
    }
}



@end


