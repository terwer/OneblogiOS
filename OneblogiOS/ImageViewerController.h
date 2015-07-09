//
//  ImageViewerController.h
//  iosapp
//
//  Created by Terwer Green on 11/12/14.
//  Copyright (c) 2014 Terwer Green. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ImageViewerController : UIViewController

- (instancetype)initWithImageURL:(NSURL *)imageURL;
- (instancetype)initWithImage:(UIImage *)image;

@end
