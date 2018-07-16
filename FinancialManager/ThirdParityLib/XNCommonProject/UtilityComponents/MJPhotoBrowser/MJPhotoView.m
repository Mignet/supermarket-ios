//
//  MJZoomingScrollView.m
//
//  Created by mj on 13-3-4.
//  Copyright (c) 2013年 itcast. All rights reserved.
//

#import "MJPhotoView.h"
#import "MJPhoto.h"
#import "MJPhotoLoadingView.h"

#import "UIImageView+WebCache.h"
#import <QuartzCore/QuartzCore.h>

@interface MJPhotoView ()

@property (nonatomic, assign) BOOL   doubleTap;
@property (nonatomic, strong) UIImageView * imageView;
@property (nonatomic, strong) MJPhotoLoadingView * photoLoadingView;
@end

@implementation MJPhotoView

- (id)initWithFrame:(CGRect)frame
{
    if ((self = [super initWithFrame:frame])) {

//        if (@available(iOS 11.0, *)){
//        }else
//        {
//            [self setContentInset:UIEdgeInsetsMake(-20, 0, 0, 0)];
//        }
        
        self.backgroundColor = [UIColor clearColor];
        self.delegate = self;
        self.showsHorizontalScrollIndicator = NO;
        self.showsVerticalScrollIndicator = NO;
        self.decelerationRate = UIScrollViewDecelerationRateFast;
        self.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    
        self.photoLoadingView = [[MJPhotoLoadingView alloc] init];
        
		self.imageView = [[UIImageView alloc] init];
		self.imageView.contentMode = UIViewContentModeScaleAspectFit;
		[self addSubview:_imageView];
        
        UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingleTap:)];
        singleTap.delaysTouchesBegan = YES;
        singleTap.numberOfTapsRequired = 1;
        [self addGestureRecognizer:singleTap];
        
        UITapGestureRecognizer *doubleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleDoubleTap:)];
        doubleTap.numberOfTapsRequired = 2;
        [self addGestureRecognizer:doubleTap];
    }
    return self;
}

//设置photo源
- (void)setPhoto:(MJPhoto *)photo {
    _photo = photo;
    
    [self photoStartLoad];
}

- (void)dealloc
{
    // 取消请求
    [self.imageView setImageWithURL:[NSURL URLWithString:@"file:///abc"]];
}

//////////////
#pragma mark - 自定义方法
////////////////////////////////////

//开始加载图片
- (void)photoStartLoad
{
    self.scrollEnabled = NO;
    [self.photoLoadingView removeFromSuperview];
    
    // 直接显示进度条
    [self addSubview:self.photoLoadingView];
    [self.photoLoadingView showLoading];
    
    __weak MJPhotoView * photoView = self;
    [self.imageView sd_setImageWithURL:self.photo.url placeholderImage:self.photo.placeholder options:SDWebImageRetryFailed|SDWebImageRefreshCached progress:nil completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        
        photoView.photo.image = image;
        [photoView photoDidFinishLoadWithImage:image];
    }];
}

//加载完毕
- (void)photoDidFinishLoadWithImage:(UIImage *)image
{
    if (image) {
      
        self.scrollEnabled = YES;
        [self.photoLoadingView removeFromSuperview];
        
        if ([self.photoViewDelegate respondsToSelector:@selector(photoViewImageFinishLoad:)]) {
            [self.photoViewDelegate photoViewImageFinishLoad:self];
        }
    } else {
        [self.photoLoadingView showFailure];
    }
    
    // 设置缩放比例
    [self adjustFrame];
}

//调整frame
- (void)adjustFrame
{
	if (self.imageView.image == nil) return;
    
    // 基本尺寸参数
    CGSize boundsSize = self.bounds.size;
    CGFloat boundsWidth = boundsSize.width;
    CGFloat boundsHeight = boundsSize.height;
    
    CGSize imageSize = self.imageView.image.size;
    CGFloat imageWidth = imageSize.width;
    CGFloat imageHeight = imageSize.height;
	
	// 设置伸缩比例
    CGFloat minScale = boundsWidth / imageWidth;
	if (minScale > 1) {
		minScale = 1.0;
	}
	CGFloat maxScale = 2.0; 
	if ([UIScreen instancesRespondToSelector:@selector(scale)]) {
		maxScale = maxScale / [[UIScreen mainScreen] scale];
	}
	self.maximumZoomScale = maxScale;
	self.minimumZoomScale = minScale;
	self.zoomScale = minScale;
    
    CGRect imageFrame = CGRectMake(0, 0, boundsWidth, imageHeight * boundsWidth / imageWidth);
    // 内容尺寸
    self.contentSize = CGSizeMake(0, imageFrame.size.height);
    
    // y值
    if (imageFrame.size.height < boundsHeight) {
        imageFrame.origin.y = floorf((boundsHeight - imageFrame.size.height) / 2.0);
	} else {
        imageFrame.origin.y = 0;
	}
    
    
    self.imageView.frame = imageFrame;
}

//手势处理
- (void)handleSingleTap:(UITapGestureRecognizer *)tap {
    
    self.doubleTap = NO;
    [self performSelector:@selector(hide) withObject:nil afterDelay:0.2];
}

//双击
- (void)handleDoubleTap:(UITapGestureRecognizer *)tap {
    self.doubleTap = YES;
    
    CGPoint touchPoint = [tap locationInView:self];
    if (self.zoomScale == self.maximumZoomScale) {
        [self setZoomScale:self.minimumZoomScale animated:YES];
    } else {
        [self zoomToRect:CGRectMake(touchPoint.x, touchPoint.y, 1, 1) animated:YES];
    }
}

//隐藏
- (void)hide
{
    if (self.doubleTap) return;
    
    // 移除进度条
    [self.photoLoadingView removeFromSuperview];
    self.contentOffset = CGPointZero;
    
    CGFloat duration = 0.3;
    
    [UIView animateWithDuration:duration animations:^{
        
        // gif图片仅显示第0张
        if (self.imageView.image.images) {
            self.imageView.image = self.imageView.image.images[0];
        }
        
        // 通知代理
        if ([self.photoViewDelegate respondsToSelector:@selector(photoViewSingleTap:)]) {
            [self.photoViewDelegate photoViewSingleTap:self];
        }
        
        self.alpha = 0.0;
        
    } completion:^(BOOL finished) {
        
        // 通知代理
        if ([self.photoViewDelegate respondsToSelector:@selector(photoViewDidEndZoom:)]) {
            [self.photoViewDelegate photoViewDidEndZoom:self];
        }
    }];
}

///////////////////
#pragma mark - 组件回调
/////////////////////////////////////

//UIScrollViewDelegate
- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView {
	return self.imageView;
}

@end
