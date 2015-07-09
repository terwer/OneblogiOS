//
//  ImageViewerController.m
//  iosapp
//
//  Created by Terwer Green on 11/12/14.
//  Copyright (c) 2014 Terwer Green. All rights reserved.
//


// 参考 https://github.com/bogardon/GGFullscreenImageViewController

#import "ImageViewerController.h"
#import "Utils.h"

#import <SDWebImageManager.h>
#import <UIImageView+WebCache.h>
#import <MBProgressHUD.h>

@interface ImageViewerController () <UIScrollViewDelegate, UIAlertViewDelegate>

@property (nonatomic, strong) NSURL *imageURL;
@property (nonatomic, strong) UIImage *image;

@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) UIButton *saveButton;
@property (nonatomic, assign) BOOL zoomOut;

@property (nonatomic, strong) MBProgressHUD *HUD;

@end

@implementation ImageViewerController

#pragma mark - init method

- (instancetype)initWithImageURL:(NSURL *)imageURL
{
    self = [super init];
    if (self) {
        self.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
        _imageURL = imageURL;
    }
    
    return self;
}

- (instancetype)initWithImage:(UIImage *)image
{
    self = [super init];
    if (self) {
        self.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
        _image = image;
    }
    
    return self;
}



#pragma mark - life cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor blackColor];
    
    _scrollView = [[UIScrollView alloc] initWithFrame:self.view.bounds];
    _scrollView.delegate = self;
    _scrollView.maximumZoomScale = 2;
    _scrollView.showsHorizontalScrollIndicator = NO;
    _scrollView.showsVerticalScrollIndicator = NO;
    [self.view addSubview:_scrollView];
    
    
    _imageView = [UIImageView new];
    _imageView.contentMode = UIViewContentModeScaleAspectFit;
    _imageView.userInteractionEnabled = YES;
    
    if (_image) {
        _imageView.image = _image;
    } else {
        if (![[SDWebImageManager sharedManager] cachedImageExistsForURL:_imageURL]) {
            _HUD = [Utils createHUD];
            _HUD.mode = MBProgressHUDModeAnnularDeterminate;
            [_HUD addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingleTap)]];
        }
        
        [_imageView sd_setImageWithURL:_imageURL
                      placeholderImage:nil
                               options:SDWebImageProgressiveDownload | SDWebImageContinueInBackground
                              progress:^(NSInteger receivedSize, NSInteger expectedSize) {
                                  _HUD.progress = (CGFloat)receivedSize / (CGFloat)expectedSize;
                              }
                             completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                                 [_HUD hide:YES];
                             }];
    }
    
    
    UITapGestureRecognizer *doubleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleDoubleTap:)];
    doubleTap.numberOfTapsRequired = 2;
    [_imageView addGestureRecognizer:doubleTap];
    
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingleTap)];
    [singleTap requireGestureRecognizerToFail:doubleTap];
    [_imageView addGestureRecognizer:singleTap];
    
    _scrollView.contentSize = _imageView.frame.size;
    [_scrollView addSubview:_imageView];
    
    UIView *backView = [[UIView alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height-50, self.view.frame.size.width, 50)];
    backView.backgroundColor = [UIColor clearColor];
    backView.alpha = 0.8;
    [self.view addSubview:backView];
    
    _saveButton = [UIButton new];
    CGFloat X = self.view.frame.size.width;
    CGFloat Y = self.view.frame.size.height;
    _saveButton.frame = CGRectMake(X-60, Y-45, 30, 30);
    [_saveButton setImage:[UIImage imageNamed:@"picture_download"] forState:UIControlStateNormal];
    [_saveButton addTarget:self action:@selector(downloadPicture) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_saveButton];
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:YES];
    
    _imageView.frame = _scrollView.bounds;
}


- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:YES];
}



#pragma mark - UIScrollViewDelegate

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    return self.imageView;
}

#pragma mark - handle gesture

- (void)handleSingleTap
{
    [_HUD hide:YES];
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)handleDoubleTap:(UIGestureRecognizer *)recognizer
{
    CGFloat power = _zoomOut ? 1/_scrollView.maximumZoomScale : _scrollView.maximumZoomScale;
    _zoomOut = !_zoomOut;
    
    CGPoint pointInView = [recognizer locationInView:self.imageView];
    
    CGFloat newZoomScale = _scrollView.zoomScale * power;
    
    CGSize scrollViewSize = _scrollView.bounds.size;
    
    CGFloat width = scrollViewSize.width / newZoomScale;
    CGFloat height = scrollViewSize.height / newZoomScale;
    CGFloat x = pointInView.x - (width / 2.0f);
    CGFloat y = _scrollView.center.y - (height / 2.0f);
    
    CGRect rectToZoomTo = CGRectMake(x, y, width, height);
    
    [_scrollView zoomToRect:rectToZoomTo animated:YES];
}

//下载保存图片
- (void)downloadPicture
{
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"下载图片至手机相册" message:@"" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    
    [alertView show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1) {
        UIImageWriteToSavedPhotosAlbum(self.imageView.image, self, @selector(imageSavedToPhotosAlbum:didFinishSavingWithError:contextInfo:), nil);
    }
}

- (void)imageSavedToPhotosAlbum:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo
{
    MBProgressHUD *HUD = [Utils createHUD];
    HUD.mode = MBProgressHUDModeCustomView;
    
    if (!error) {
        HUD.labelText = @"保存成功";
    } else {
        HUD.labelText = [NSString stringWithFormat:@"%@", [error description]];
    }
    
    [HUD hide:YES afterDelay:1];
}


@end
