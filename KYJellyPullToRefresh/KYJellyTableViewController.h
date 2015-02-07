//
//  KYJellyTableViewController.h
//  KYJellyPullToRefresh
//
//  Created by Kitten Yang on 2/7/15.
//  Copyright (c) 2015 Kitten Yang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JellyView.h"

@interface KYJellyTableViewController : UITableViewController<UIScrollViewDelegate>

@property(nonatomic,strong)JellyView *jellyView;

@end
