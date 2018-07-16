//
//  MJPhoto.h
//
//  Created by mj on 13-3-4.
//  Copyright (c) 2013年 itcast. All rights reserved.

#import <Foundation/Foundation.h>

@interface MJPhoto : NSObject

@property (nonatomic, assign) int index; // 索引
@property (nonatomic, strong) NSURL *url;
@property (nonatomic, strong) UIImage * image;
@property (nonatomic, strong, readonly) UIImage *placeholder;

// 是否已经保存到相册
@property (nonatomic, assign) BOOL save;
@end
