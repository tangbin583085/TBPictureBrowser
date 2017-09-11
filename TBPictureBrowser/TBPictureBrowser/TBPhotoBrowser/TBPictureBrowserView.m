//
//  TBPictureBrowserView.m
//  com.pintu.aaaaaa
//
//  Created by hanchuangkeji on 2017/9/11.
//  Copyright © 2017年 hanchuangkeji. All rights reserved.
//

#import "TBPictureBrowserView.h"
#import "UIView+FOFExtension.h"
#import "TBConfig.h"
#import "ACActionSheet.h"
#import "TBImageView.h"
#import "UIImageView+WebCache.h"


@interface TBPictureBrowserView ()<UIScrollViewDelegate, TBImageViewDelegate>

@property (nonatomic,  weak)UIScrollView *contentSC;
@property (nonatomic,  weak)UIPageControl *pageControl;

@property (nonatomic,  assign)BOOL addedLaunchAnimation;

@end



@implementation TBPictureBrowserView

{
    UIActivityIndicatorView *_indicatorView;

}


- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        // 全屏显示
        self.frame = [UIScreen mainScreen].bounds;
        self.backgroundColor = tbBackgroundColor;
        [self prepare];
    }
    return self;
}


- (void)prepare {
    // 添加UISrollView
    UIScrollView *contentSC = [[UIScrollView alloc] init];
    contentSC.backgroundColor = tbBackgroundColor;
    contentSC.pagingEnabled = YES;
    contentSC.showsVerticalScrollIndicator = NO;
    contentSC.showsHorizontalScrollIndicator = NO;
    contentSC.delegate = self;
    [self addSubview:contentSC];
    self.contentSC = contentSC;
    
    // 添加pageControl
    UIPageControl *pageControl = [[UIPageControl alloc] init];
    pageControl.pageIndicatorTintColor = tbPageIndicatorTintColor;
    pageControl.currentPageIndicatorTintColor = tbCurrentPageIndicatorTintColor;
    [self addSubview:pageControl];
    self.pageControl = pageControl;
    
    // 添加长按的手势
    [self addGestureRecognizer:[[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longGesture:)]];
}

- (void)saveImage {
    NSInteger index = self.contentSC.contentOffset.x / self.contentSC.width;
    UIImageView *imageView = self.contentSC.subviews[index];
    UIImageWriteToSavedPhotosAlbum(imageView.image, self, @selector(image:didFinishSavingWithError:contextInfo:), NULL);
    
    // 添加活动指示器
    UIActivityIndicatorView *indicator = [[UIActivityIndicatorView alloc] init];
    indicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyleWhiteLarge;
    indicator.center = self.center;
    _indicatorView = indicator;
    [[UIApplication sharedApplication].keyWindow addSubview:indicator];
    [indicator startAnimating];
    
}

- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo;
{
    [_indicatorView removeFromSuperview];
    
    UILabel *label = [[UILabel alloc] init];
    label.textColor = [UIColor whiteColor];
    label.backgroundColor = [UIColor colorWithRed:0.1f green:0.1f blue:0.1f alpha:0.90f];
    label.layer.cornerRadius = 5;
    label.clipsToBounds = YES;
    label.bounds = CGRectMake(0, 0, 150, 30);
    label.center = self.center;
    label.textAlignment = NSTextAlignmentCenter;
    label.font = [UIFont boldSystemFontOfSize:17];
    [[UIApplication sharedApplication].keyWindow addSubview:label];
    [[UIApplication sharedApplication].keyWindow bringSubviewToFront:label];
    if (error) {
        label.text = TBSaveImageFailText;
    }   else {
        label.text = TBSaveImageSuccessText;
    }
    [label performSelector:@selector(removeFromSuperview) withObject:nil afterDelay:1.0];
}

- (void)tapGesture{
    
    // 主控件
    [UIView animateWithDuration:0.25 animations:^{
        self.alpha = 0.0;
    } completion:nil];
    
    // 结束图片
    CGRect tempRect = [[UIApplication sharedApplication].keyWindow convertRect:self.containerView.subviews[self.currentPage].frame fromView:self.containerView];
    TBImageView *imageViewTemp = [[TBImageView alloc] init];
    imageViewTemp.frame = self.bounds;
    imageViewTemp.contentMode = UIViewContentModeScaleAspectFit;
    imageViewTemp.image = [self.delegate placeHolderImage:self index:self.currentPage];
    [[UIApplication sharedApplication].keyWindow addSubview:imageViewTemp];
    imageViewTemp.alpha = 1.0;
    [UIView animateWithDuration:tbDuration animations:^{
        imageViewTemp.frame = tempRect;
        imageViewTemp.alpha = 0.0;
    } completion:^(BOOL finished) {
        [imageViewTemp removeFromSuperview];
        [self removeFromSuperview];
    }];
}

-(void)doubleTap {
    NSLog(@"%s", __func__);
}



- (void)longGesture:(UITapGestureRecognizer *)gesture{
    NSLog(@"%s", __func__);
    
    if (gesture.state != UIGestureRecognizerStateBegan) return;
    
    __weak typeof (self) weakSelf = self;
    ACActionSheet *sheet = [[ACActionSheet alloc] initWithTitle:nil cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@[@"保存"] actionSheetBlock:^(NSInteger buttonIndex) {
        NSLog(@"%ld", buttonIndex);
        if (buttonIndex == 0) {
            [weakSelf saveImage];
        }
    }];
    [sheet show];
}

- (void)didMoveToSuperview {
    [super didMoveToSuperview];
    
    // 设置contentSize
    self.contentSC.contentSize = CGSizeMake(self.width * self.totalPage, self.height);
    for (NSInteger i = 0; i < self.totalPage; i++) {
        TBImageView *imageView = [[TBImageView alloc] init];
        imageView.frame = CGRectMake(i * self.width, 0, self.width, self.height);
        [self.contentSC addSubview:imageView];
        imageView.contentMode = UIViewContentModeScaleAspectFit;
        imageView.delegate = self;
        // 设置占位符
        if ([self.delegate respondsToSelector:@selector(placeHolderImage:index:)]) {
            imageView.image = [self.delegate placeHolderImage:self index:i];
        }
    }
}

- (void)launchAnimation {
    
    // 主控件
    self.alpha = 0.0;
    [UIView animateWithDuration:0.25 animations:^{
        self.alpha = 1.0;
    } completion:nil];
    
    // 启动图片
    CGRect tempRect = [[UIApplication sharedApplication].keyWindow convertRect:self.containerView.subviews[self.currentPage].frame fromView:self.containerView];
    TBImageView *imageViewTemp = [[TBImageView alloc] init];
    imageViewTemp.frame = tempRect;
    imageViewTemp.contentMode = UIViewContentModeScaleAspectFit;
    imageViewTemp.image = [self.delegate placeHolderImage:self index:self.currentPage];
    [[UIApplication sharedApplication].keyWindow addSubview:imageViewTemp];
    imageViewTemp.alpha = 0.0;
    self.contentSC.hidden = YES;
    [UIView animateWithDuration:tbDuration animations:^{
        imageViewTemp.frame = self.bounds;
        imageViewTemp.alpha = 1.0;
    } completion:^(BOOL finished) {
        self.contentSC.hidden = NO;
        [imageViewTemp removeFromSuperview];
    }];
}

- (void)layoutSubviews {
    
    if (!_addedLaunchAnimation) {
        // 启动动画
        _addedLaunchAnimation = YES;
        [self launchAnimation];
    }
    
    NSLog(@"%s", __func__);
    self.contentSC.frame = self.bounds;
    self.pageControl.center = CGPointMake(self.width * 0.5f, self.height - 20);
    
    // 设置pageContrl
    self.pageControl.numberOfPages = self.totalPage;
    self.pageControl.currentPage = self.currentPage;
    
    // 获取占位符
    [self indexContentImage:self.currentPage scrollView:YES];
    
}



- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    NSInteger indexImageTemp = scrollView.contentOffset.x / (scrollView.width * 1.0) ;
    
    // 获取占位符
    if (self.currentPage != indexImageTemp) {
        self.currentPage = indexImageTemp;
        [self indexContentImage:self.currentPage scrollView:NO];
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    // 移除 左右2边 缩放的控件
    if (self.currentPage + 1 < self.totalPage) {
        TBImageView *imageView = (TBImageView *)self.contentSC.subviews[self.currentPage + 1];
        [imageView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    }
    if (self.currentPage - 1 > 0) {
        TBImageView *imageView = (TBImageView *)self.contentSC.subviews[self.currentPage - 1];
        [imageView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    }
}

- (void)indexContentImage:(NSInteger )index scrollView:(BOOL)contentOffset {
    
    // 设置占位符
    TBImageView *imageView = self.contentSC.subviews[index];
    if ([self.delegate respondsToSelector:@selector(placeHolderImage:index:)]) {
        imageView.image = [self.delegate placeHolderImage:self index:index];
    }
    
    if ([self.delegate respondsToSelector:@selector(hightQualityImageUrl:index:)]) {
        NSString *urlString = [self.delegate hightQualityImageUrl:self index:self.currentPage];
        [imageView setupHightQualityPic:urlString];
    }
    
    // 设置contentOffset
    if (contentOffset) {
        [self.contentSC setContentOffset:CGPointMake(self.contentSC.width * index, 0)];

    }

    self.pageControl.currentPage = self.currentPage;
    
}


#pragma makr TBImageViewDelegate
- (void)imageViewTap {
    [self tapGesture];
}

- (void)show {
    // 隐藏状态栏，控制
    [UIApplication sharedApplication].statusBarHidden = YES;
    [[UIApplication sharedApplication].keyWindow addSubview:self];
}

- (void)dealloc {
    // 显示状态栏
    [UIApplication sharedApplication].statusBarHidden = NO;
    
    NSLog(@"%s", __func__);
}

@end
