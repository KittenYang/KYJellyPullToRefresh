//
//  JellyView.m
//  KYJellyPullToRefresh
//
//  Created by Kitten Yang on 2/7/15.
//  Copyright (c) 2015 Kitten Yang. All rights reserved.
//



#import "JellyView.h"

@implementation JellyView{
    UIColor *fillColor;
    CGRect userFrame;
    CGRect jellyFrame;
}


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.


- (id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        userFrame = frame;
        jellyFrame = CGRectMake(frame.origin.x, frame.origin.y, frame.size.width, frame.size.height + [UIScreen mainScreen].bounds.size.height);
        fillColor = [UIColor colorWithRed:0 green:0.722 blue:1 alpha:1];
        self.frame = jellyFrame;
    }
    return self;
}


- (void)drawRect:(CGRect)rect {
    NSLog(@"%@",NSStringFromCGRect(rect));
    
    UIBezierPath *path = [UIBezierPath bezierPath];
    [path moveToPoint:CGPointMake(0,userFrame.size.height)];
    [path addQuadCurveToPoint:CGPointMake(userFrame.size.width,userFrame.size.height) controlPoint:CGPointMake(userFrame.size.width / 2.0, userFrame.size.height + self.controlPointOffset)];
    [path addLineToPoint:CGPointMake(userFrame.size.width, 0)];
    [path addLineToPoint:CGPointMake(0, 0)];
    [path closePath];
    
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextAddPath(context, path.CGPath);
    [fillColor set];
    CGContextFillPath(context);
}


@end
