//
//  GYCastView.h
//  PushBox
//
//  Created by Gabriel Yeah on 11-11-13.
//  Copyright (c) 2011年 同济大学. All rights reserved.
//

#import <UIKit/UIKit.h>

@class GYCastView;

@protocol GYCastViewDelegate
@required
-(UIView*)viewForItemAtIndex:(GYCastView*)scrollView index:(int)index;
-(int)itemCount:(GYCastView*)scrollView;
@end

@interface GYCastView : UIView<UIScrollViewDelegate> {
	UIScrollView *scrollView;	
	id <GYCastViewDelegate, NSObject> delegate;
	NSMutableArray *scrollViewPages;
	BOOL firstLayout;
	CGSize pageSize;
	BOOL dropShadow;
	NSInteger pageNum;
	NSInteger prePage;
}
@property (nonatomic, retain) UIScrollView *scrollView;
@property (nonatomic, assign) id<GYCastViewDelegate, NSObject> delegate;
@property (nonatomic, assign) CGSize pageSize;
@property (nonatomic, assign) BOOL dropShadow;
@property (nonatomic) NSInteger pageNum;

- (void)didReceiveMemoryWarning;
- (id)initWithFrameAndPageSize:(CGRect)frame pageSize:(CGSize)size;

@end