//
//  KYJellyTableViewController.m
//  KYJellyPullToRefresh
//
//  Created by Kitten Yang on 2/7/15.
//  Copyright (c) 2015 Kitten Yang. All rights reserved.
//


#define jellyHeaderHeight [UIScreen mainScreen].bounds.size.height
#import "KYJellyTableViewController.h"

@interface KYJellyTableViewController ()

@property (nonatomic,strong) CADisplayLink *displayLink;

@end

@implementation KYJellyTableViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title  = @"果冻下拉刷新";
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

    return 20;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
//    UITableViewCell *cell = [tableView UITableViewCellStyleDefault reuseIdentifier:@"JellyCell"];
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"JellyCell" forIndexPath:indexPath];
    cell.textLabel.text = [NSString stringWithFormat:@"第 %ld行",indexPath.row];
    
    return cell;


}


-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    if (self.displayLink == nil) {
        self.jellyView = [[JellyView alloc]initWithFrame:CGRectMake(0, -jellyHeaderHeight , [UIScreen mainScreen].bounds.size.width, jellyHeaderHeight)];
        self.jellyView.backgroundColor = [UIColor clearColor];
        [self.view insertSubview:self.jellyView aboveSubview:self.tableView];
        
        self.displayLink = [CADisplayLink displayLinkWithTarget:self selector:@selector(displayLinkAction:)];
        [self.displayLink addToRunLoop:[NSRunLoop mainRunLoop] forMode:NSRunLoopCommonModes];
    }
    NSLog(@"scrollViewWillBeginDragging");
}

-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{

    
//    CGFloat offset = MAX(scrollView.contentOffset.y - 64.5, 0);
//    offset = MIN(offset, 60);
//    scrollView.contentInset = UIEdgeInsetsMake(offset, 0.0f, 0.0f, 0.0f);

    
    [self.jellyView removeFromSuperview];
    self.jellyView = nil;
    [self.displayLink invalidate];
    self.displayLink = nil;
    NSLog(@"scrollViewDidEndDecelerating");
}

-(void)displayLinkAction:(CADisplayLink *)dis{
    self.jellyView.controlPointOffset = -self.tableView.contentOffset.y - 64.5;
    [self.jellyView setNeedsDisplay];
    NSLog(@"contentOffset.y:%f",self.tableView.contentOffset.y);
}

@end
