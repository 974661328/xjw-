//
//  NewsViewController.m
//  网易新闻
//
//  Created by mac on 16/10/1.
//  Copyright © 2016年 lancelot. All rights reserved.
//

#import "NewsViewController.h"
#import "TopLineViewController.h"
#import "HotViewController.h"
#import "SocietyViewController.h"
#import "VideoViewController.h"
#import "ReadViewController.h"
#import "ScienceViewController.h"

#define kScreenW     [UIScreen mainScreen].bounds.size.width
#define kScreenH     [UIScreen mainScreen].bounds.size.height


static  const int  labelW = 100;
@interface NewsViewController ()<UIScrollViewDelegate>
@property (weak, nonatomic) IBOutlet UIScrollView *titleScrollView;
@property (weak, nonatomic) IBOutlet UIScrollView *contentScrollView;
@property (nonatomic, strong)NSMutableArray *titleLabels;
@property (nonatomic, weak)UILabel *SelLabel;

@end

@implementation NewsViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self setUpAllChildViewController];
    [self setUpAllTitleLabel];
    [self setUpScrollView];
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    // Do any additional setup after loading the view.
}
- (NSMutableArray *)titleLabels{
    if (_titleLabels == nil) {
        self.titleLabels = [NSMutableArray array];
    }
    return _titleLabels;


}
- (void)setUpScrollView{

    NSUInteger count = self.childViewControllers.count;
    self.titleScrollView.showsHorizontalScrollIndicator = NO;
    self.contentScrollView.showsHorizontalScrollIndicator = NO;
    self.titleScrollView.contentSize = CGSizeMake(labelW * count, 0);
    self.contentScrollView.contentSize = CGSizeMake(count * kScreenW, 0);
    self.contentScrollView.bounces = NO;
    self.contentScrollView.delegate = self;
    self.contentScrollView.pagingEnabled = YES;
    
    
    



}
- (void)setUpAllChildViewController{
    
    TopLineViewController *topVc = [[TopLineViewController alloc]init];
    topVc.title = @"头条";
    [self addChildViewController:topVc];
   
    HotViewController *hotVc = [[HotViewController alloc]init];
    hotVc.title = @"热点";

    [self addChildViewController:hotVc];
    
    SocietyViewController *socVc = [[SocietyViewController alloc]init];
    socVc.title = @"社会";

    [self addChildViewController:socVc];
    
    VideoViewController *videoVc = [[VideoViewController alloc]init];
    videoVc.title = @"视频";

    [self addChildViewController:videoVc];
    
    ReadViewController *readVc = [[ReadViewController alloc]init];
    readVc.title = @"阅读";

    [self addChildViewController:readVc];
    
    ScienceViewController *scienceVc = [[ScienceViewController alloc]init];
    scienceVc.title = @"科学";

    [self addChildViewController:scienceVc];
    
}

- (void)setUpAllTitleLabel{
    
    NSUInteger count = self.childViewControllers.count;
    CGFloat labelX = 0;
    CGFloat labelY = 0;

    CGFloat labelH = 44;
    for (int i = 0; i<count; i++) {
        labelX = labelW * i;
        
        UIViewController *vc = self.childViewControllers[i];
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(labelX, labelY, labelW, labelH )];
        [self.titleLabels addObject:label];
        label.text = vc.title;
        label.tag = i;
        label.textAlignment = NSTextAlignmentCenter;

        label.highlightedTextColor = [UIColor redColor];
        label.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(titleClick:)];
        [label addGestureRecognizer:tap];
        
        
        if (i==0) {
            [self titleClick:tap];
        }
        
        
        [self.titleScrollView addSubview:label];
    }



}


- (void)titleClick:(UIGestureRecognizer *)tap{
    
//    NSLog(@"%s",__func__);
    
    UILabel *selLabel =(UILabel *) tap.view;

    [self selectLabel:selLabel];
    
    NSInteger index = selLabel.tag;
    CGFloat offSetX = index * kScreenW;
    

    [self showVc:index];
    self.contentScrollView.contentOffset = CGPointMake(offSetX, 0);
    
    

    
}


- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    
    NSInteger index = scrollView.contentOffset.x / scrollView.bounds.size.width;
    
//    UIViewController *vc = self.childViewControllers[index];
//    
//    vc.view.frame = CGRectMake(index * kScreenW, 0, kScreenW, self.contentScrollView.bounds.size.height);
//    
//    [self.contentScrollView addSubview:vc.view];
    [self showVc:index];
    
    UILabel *label = self.titleLabels[index];
    

    
    [self selectLabel:label];
    
    
    
    
    
}
//#pragma mark add
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    CGFloat curPage = scrollView.contentOffset.x / scrollView.bounds.size.width;
    
    NSInteger leftIndex = curPage;
    NSInteger rightIndex = curPage + 1;

    UILabel *leftLabel = self.titleLabels[leftIndex];
    UILabel *rightLabel;
    if (rightIndex <= self.titleLabels.count - 1) {
        
        rightLabel = self.titleLabels[rightIndex];
        
    }
    CGFloat RightScale = curPage - leftIndex;
    
    CGFloat leftScale =  1 - RightScale;
    
    leftLabel.transform = CGAffineTransformMakeScale(leftScale * 0.3+ 1, leftScale * 0.3 +1);

    rightLabel.transform  = CGAffineTransformMakeScale(RightScale * 0.3+ 1, RightScale * 0.3+1);
    
    
    
    


}
- (void)selectLabel:(UILabel *)label{

    _SelLabel.transform = CGAffineTransformIdentity;
    _SelLabel.highlighted = NO;
    
    label.highlighted = YES;
    
    label.transform = CGAffineTransformMakeScale(1.3, 1.3);
    
    _SelLabel = label;
    [self setUpTitleCenter:label];
    

    
    

}

- (void)showVc:(NSInteger)index{
    

    UIViewController *vc = self.childViewControllers[index];
    
    
    if (vc.isViewLoaded) {
        return;
    }
    vc.view.frame = CGRectMake(index * kScreenW, 0, kScreenW, self.contentScrollView.bounds.size.height);
    
    [self.contentScrollView addSubview:vc.view];

}
- (void)setUpTitleCenter:(UILabel *)label{
    
    
    CGFloat offSetx = label.center.x - kScreenW * 0.5;
    
    if (offSetx < 0) {
        offSetx = 0;
    }
    if (offSetx > self.titleScrollView.contentSize.width - kScreenW) {
        offSetx = self.titleScrollView.contentSize.width - kScreenW;
    }
    
    [self.titleScrollView setContentOffset:CGPointMake(offSetx, 0) animated:YES];
    



}
@end
