//
//  TBImageView.m
//  com.pintu.aaaaaa
//
//  Created by hanchuangkeji on 2017/9/11.
//  Copyright © 2017年 hanchuangkeji. All rights reserved.
//

#import "TBImageView.h"
#import "UIView+FOFExtension.h"
#import "TBPictureBrowserView.h"
#import "TBConfig.h"
#import "UIImageView+WebCache.h"


@interface TBImageView ()

@property (nonatomic, assign)CGFloat tbScale;
@property (nonatomic, weak)UIScrollView *scrollView;
@property (nonatomic, weak)UIPinchGestureRecognizer *pinchGesture;


@end

@implementation TBImageView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        
        self.userInteractionEnabled = YES;
        // 单击手势
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(oneTap)];
        [self addGestureRecognizer:tap];

        // 双击手势
        UITapGestureRecognizer *tap2 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(doubleTap)];
        tap2.numberOfTapsRequired = 2;
        [tap requireGestureRecognizerToFail:tap2];
        [self addGestureRecognizer:tap2];
        
        // 拉伸手势
        UIPinchGestureRecognizer *pinchGesture = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(pinchGesture:)];
        self.pinchGesture = pinchGesture;
        [self addGestureRecognizer:pinchGesture];
        
        // 监听变化
//        [self addObserver:self forKeyPath:@"tbScale" options:NSKeyValueObservingOptionNew context:nil];
        
        // 放大倍数
        self.tbScale = 1.0;
        
    }
    return self;
}




/**
 拉伸手势放大缩小

 @param gesture 手势对象
 */
- (void)pinchGesture:(UIPinchGestureRecognizer *)gesture {
    
    CGFloat temp = self.tbScale + (gesture.scale - 1);
    [self setImageViewScale:temp];
    gesture.scale = 1.0;
}

-(void)oneTap {
    
    if ([self.delegate respondsToSelector:@selector(imageViewTap)]) {
        [self.delegate imageViewTap];
    }
}

-(void)doubleTap {
    
    [self setImageViewScale:self.tbScale == 1? 1.5 : 1.0];
    
}

- (void)setupScrollView {
    if (self.scrollView == nil) {
        UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:self.bounds];
        scrollView.backgroundColor = tbBackgroundColor;
        scrollView.contentSize = scrollView.bounds.size;
        scrollView.showsVerticalScrollIndicator = NO;
        scrollView.showsHorizontalScrollIndicator = NO;
        [self addSubview:scrollView];
        self.scrollView = scrollView;
        
        // 生成临时占位符
        UIImageView *imageView = [[UIImageView alloc] init];
        imageView.contentMode = UIViewContentModeScaleAspectFit;
        imageView.frame = scrollView.bounds;
        imageView.image = self.image;
        [scrollView addSubview:imageView];
    }
}

- (void)setImageViewScale:(CGFloat)scale{
    
    self.tbScale = scale;
    
    // 不能极限比例
    if (maxScale <= self.tbScale || self.tbScale <= minScale) return;
    
    [self setupScrollView];
    
    self.scrollView.contentSize = CGSizeMake(self.scrollView.bounds.size.width * scale, self.scrollView.bounds.size.height * scale);
    UIImageView *tempImageView = self.scrollView.subviews.firstObject;
    tempImageView.size = self.scrollView.contentSize;
    tempImageView.center = CGPointMake(self.scrollView.contentSize.width * 0.5, self.scrollView.contentSize.height * 0.5);
    
    CGFloat Y = 0.5 * (self.scrollView.contentSize.height - self.scrollView.height);
    CGFloat X = 0.5 * (self.scrollView.contentSize.width - self.scrollView.width);
    
    [self.scrollView setContentOffset:CGPointMake(X, Y)];
}


/**
 * 重写
 */
- (void)setupHightQualityPic:(NSString *)url {
    
    // 添加加载等待图片
    UIActivityIndicatorView *activityView = [[UIActivityIndicatorView alloc] init];
    activityView.activityIndicatorViewStyle = UIActivityIndicatorViewStyleWhiteLarge;
    activityView.center = CGPointMake([UIScreen mainScreen].bounds.size.width * 0.5, [UIScreen mainScreen].bounds.size.height * 0.5);
    [[UIApplication sharedApplication].keyWindow addSubview:activityView];
    [activityView startAnimating];
    
    // 加载高清图
    [self sd_setImageWithURL:[NSURL URLWithString:url] placeholderImage:self.image completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        [activityView removeFromSuperview];
    }];
    
}








@end
