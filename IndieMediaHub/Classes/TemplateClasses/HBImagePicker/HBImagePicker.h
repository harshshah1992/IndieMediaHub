//
//  HBImagePicker.h
//  HBImagePicker
//
//  Created by Manikanta.Chintapalli on 3/12/15.
//  Copyright (c) 2015 Hidden Brains. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^ImagePickerCompletionHandler)(BOOL success, NSMutableDictionary *mediaDict);
 enum mediaType {
    MediaTypeImage,
    MediaTypeVideo
};
@interface HBImagePicker : NSObject

+ (HBImagePicker*) sharedInstance;

// This method can call to Handle entire UIImagePickerController fuctionality with media types images and movies(videos). Developer can simply give media type, action sheet title , all button titles and can fetch the media from mediaDict dictionary. If he use media type image, Key name should be 'image' and if he use media type video, Key name should be 'video'.

- (void)openImagePickerWithMediaType:(enum mediaType)media actionSheetTitle:(NSString *)title cancelButtonTitle:(NSString *)cancelTitle cameraButtonTitle:(NSString *)cameraTitle  galleryButtonTitle:(NSString *)galleryTitle withCompletion:(ImagePickerCompletionHandler)completionHandler;

@end
