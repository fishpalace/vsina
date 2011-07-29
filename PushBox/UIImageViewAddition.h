//
//  UIImageViewAddition.h
//  PushBox
//
//  Created by Xie Hasky on 11-7-28.
//  Copyright 2011年 同济大学. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImageView (UIImageViewAddition)

- (void)loadImageFromURL:(NSString *)url completion:(void (^)())completion;

@end
