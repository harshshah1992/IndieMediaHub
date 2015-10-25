//
//  HBImagePicker.m
//  HBImagePicker
//
//  Created by Manikanta.Chintapalli on 3/12/15.
//  Copyright (c) 2015 Hidden Brains. All rights reserved.
//

#import "HBImagePicker.h"
#import <MobileCoreServices/MobileCoreServices.h>
@interface HBImagePicker () <UIImagePickerControllerDelegate, UINavigationControllerDelegate,UIActionSheetDelegate>
@property (strong , nonatomic) ImagePickerCompletionHandler completionHandler;
@property (readwrite) CFStringRef media;

@end
@implementation HBImagePicker
+(HBImagePicker*) sharedInstance{
    static dispatch_once_t once;
    static HBImagePicker * sharedInstance;
    dispatch_once(&once, ^{
                sharedInstance = [[self alloc] init];
    });
    return sharedInstance;
}

- (void)openImagePickerWithMediaType:(enum mediaType)media actionSheetTitle:(NSString *)title cancelButtonTitle:(NSString *)cancelTitle cameraButtonTitle:(NSString *)cameraTitle  galleryButtonTitle:(NSString *)galleryTitle withCompletion:(ImagePickerCompletionHandler)completionHandler{
    if (media == MediaTypeImage) {
        self.media = kUTTypeImage;
    }else {
       self.media = kUTTypeMovie;
    }
    self.completionHandler = [completionHandler copy];
    UIActionSheet *popup = [[UIActionSheet alloc] initWithTitle:title delegate:self cancelButtonTitle:cancelTitle destructiveButtonTitle:nil otherButtonTitles:
                           cameraTitle,galleryTitle,nil];
    popup.tag = 1;
    [popup showInView:[UIApplication sharedApplication].keyWindow];

}

- (void)actionSheet:(UIActionSheet *)popup clickedButtonAtIndex:(NSInteger)buttonIndex {
    switch (buttonIndex) {
        case 0:
            [self openCamera];
            break;
        case 1:
            [self openGallery];
            break;
        default:
            break;
    }
}

- (void)openGallery {
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    picker.allowsEditing = YES;
    picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    picker.mediaTypes = [[NSArray alloc] initWithObjects:(__bridge NSString *)_media, nil];

    UIViewController *controller = [[UIApplication sharedApplication].delegate window].rootViewController;
    [controller presentViewController:picker animated:YES completion:nil];

}

- (void)openCamera {
    if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        self.completionHandler(NO, nil );
        self.completionHandler = nil;
        UIAlertView *myAlertView = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Device has no camera" delegate:nil
                                                    cancelButtonTitle:@"OK" otherButtonTitles: nil];
        [myAlertView show];
    } else {
        UIImagePickerController *picker = [[UIImagePickerController alloc] init];
        picker.delegate = self;
        picker.allowsEditing = YES;
        picker.sourceType = UIImagePickerControllerSourceTypeCamera;
        NSArray *mediaTypes = [[NSArray alloc]initWithObjects:(__bridge NSString *)_media, nil];
        picker.mediaTypes = mediaTypes;
        UIViewController *controller = [[UIApplication sharedApplication].delegate window].rootViewController;
        [controller presentViewController:picker animated:YES completion:nil];
    }
}

#pragma image picker delegate methods

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    NSString *mediaType = [info objectForKey: UIImagePickerControllerMediaType];
     NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    //Handle picture
    if (CFStringCompare ((CFStringRef) mediaType, kUTTypeImage, 0) == kCFCompareEqualTo) {
        [dict setObject:info[UIImagePickerControllerEditedImage] forKey:@"image"];
    }
    // Handle a movie capture
    if (CFStringCompare ((CFStringRef) mediaType, kUTTypeMovie, 0) == kCFCompareEqualTo) {
        [dict setObject:[[info objectForKey:
                          UIImagePickerControllerMediaURL] path] forKey:@"video"];
    }
    [picker dismissViewControllerAnimated:YES completion:^{
        self.completionHandler(YES, dict);
        self.completionHandler = nil;
    }];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [picker dismissViewControllerAnimated:YES completion:^{
        self.completionHandler(NO, nil);
        self.completionHandler = nil;
    }];
}

@end
