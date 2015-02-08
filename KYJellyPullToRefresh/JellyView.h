//
//  JellyView.h
//  KYJellyPullToRefresh
//
//  Created by Kitten Yang on 2/7/15.
//  Copyright (c) 2015 Kitten Yang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JellyView : UIView


@property  CGFloat controlPointOffset;
@property  CGFloat yOffset;
@property (nonatomic,strong)UIView *controlPoint;
@property  CGRect userFrame;

@property BOOL isLoading;
@end
