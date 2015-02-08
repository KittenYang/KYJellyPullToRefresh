//
//  KYJellyTableViewController.m
//  KYJellyPullToRefresh
//
//  Created by Kitten Yang on 2/7/15.
//  Copyright (c) 2015 Kitten Yang. All rights reserved.
//




#define jellyHeaderHeight 300
#import "KYJellyTableViewController.h"

@interface KYJellyTableViewController ()

@property (nonatomic,strong) CADisplayLink *displayLink;



@end

@implementation KYJellyTableViewController{

}


- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor blackColor];
    self.title  = @"弹性小球下拉刷新";
    self.tableView.allowsSelection = YES;
    self.tableView.delegate  =self;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{

    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return 8;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
//    UITableViewCell *cell = [tableView UITableViewCellStyleDefault reuseIdentifier:@"JellyCell"];
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"JellyCell" forIndexPath:indexPath];
    NSString *imgName = [NSString stringWithFormat:@"cellImg%ld",indexPath.row + 1];
//    self.cellImgView.image = [UIImage imageNamed:imgName];
    UIImageView *cellImgView = (UIImageView *)[cell.contentView viewWithTag:101];
    cellImgView.image = [UIImage imageNamed:imgName];
    
    return cell;


}




//判断滚动方向向上还是向下
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    
    if (self.displayLink == nil && (-scrollView.contentOffset.y - 64.5) > 0) {
        self.jellyView = [[JellyView alloc]initWithFrame:CGRectMake(0, -jellyHeaderHeight , [UIScreen mainScreen].bounds.size.width, jellyHeaderHeight)];
        self.jellyView.backgroundColor = [UIColor clearColor];
        [self.view insertSubview:self.jellyView aboveSubview:self.tableView];
        
        
        self.displayLink = [CADisplayLink displayLinkWithTarget:self selector:@selector(displayLinkAction:)];
        [self.displayLink addToRunLoop:[NSRunLoop mainRunLoop] forMode:NSRunLoopCommonModes];
    }

}


//松手的时候
-(void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{

    CGFloat offset = -scrollView.contentOffset.y - 64.5;
    if (offset >= 130) {
        
        self.jellyView.isLoading = YES;
        
        
        [UIView animateWithDuration:0.3 delay:0.0f usingSpringWithDamping:0.4f initialSpringVelocity:0.0f options:UIViewAnimationOptionCurveEaseInOut animations:^{
            
            self.jellyView.controlPoint.center = CGPointMake(self.jellyView.userFrame.size.width / 2, jellyHeaderHeight);
            NSLog(@"self.jellyView.controlPoint.center:%@",NSStringFromCGPoint(self.jellyView.controlPoint.center));
            
            self.tableView.contentInset = UIEdgeInsetsMake(130+64.5, 0, 0, 0);
        } completion:^(BOOL finished) {
            [self performSelector:@selector(backToTop) withObject:nil afterDelay:2.0f];
        }];
    }
    
}

//动画结束，删除一切
-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{

    if (self.jellyView.isLoading == NO) {
        [self.jellyView removeFromSuperview];
        self.jellyView = nil;
        [self.displayLink invalidate];
        self.displayLink = nil;
    }

}

//跳到顶部复原的方法
-(void)backToTop{

    [UIView animateWithDuration:0.3 delay:0.0f usingSpringWithDamping:0.4f initialSpringVelocity:0.0f options:UIViewAnimationOptionCurveEaseInOut animations:^{
        self.tableView.contentInset = UIEdgeInsetsMake(64.5, 0, 0, 0);
    } completion:^(BOOL finished) {
        self.jellyView.isLoading = NO;
        [self.jellyView removeFromSuperview];
        self.jellyView = nil;
        [self.displayLink invalidate];
        self.displayLink = nil;
    }];
}

//持续刷新屏幕的计时器
-(void)displayLinkAction:(CADisplayLink *)dis{

    CALayer *layer = (CALayer *)[self.jellyView.controlPoint.layer presentationLayer];
//    NSLog(@"presentationLayer:%@",NSStringFromCGRect(layer.frame));
    
    self.jellyView.controlPointOffset = (self.jellyView.isLoading == NO)? (-self.tableView.contentOffset.y - 64.5) : (self.jellyView.controlPoint.layer.position.y - self.jellyView.userFrame.size.height);


    [self.jellyView setNeedsDisplay];
//    NSLog(@"contentOffset.y:%f",self.tableView.contentOffset.y);
}

@end
