//
//  TBSDVC.m
//  com.pintu.aaaaaa
//
//  Created by hanchuangkeji on 2017/9/8.
//  Copyright © 2017年 hanchuangkeji. All rights reserved.
//


#import "TBViewController.h"
#import "TBPictureBrowserView.h"

@interface TBViewController ()<TBPictureBrowserViewDelegate>
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UIImageView *imageView2;
@property (weak, nonatomic) IBOutlet UIImageView *imageView3;
@property (weak, nonatomic) IBOutlet UIImageView *imageView4;
@property (weak, nonatomic) IBOutlet UIButton *btn;

@property (strong, nonatomic) NSMutableArray *dataSource;

@property (strong, nonatomic) NSMutableArray *dataSourceHight;

@end

@implementation TBViewController

- (NSMutableArray *)dataSourceHight {
    if (!_dataSourceHight) {
        NSMutableArray *dataSource = [NSMutableArray array];
        for (int i = 1; i < 5; i++) {
            NSString *name = [NSString stringWithFormat:@"https://pic.shareweapp.com/14993307386424421_big_.jpg"];
            [dataSource addObject:name];
        }
        _dataSourceHight = dataSource;
    }
    return _dataSourceHight;
}

- (NSMutableArray *)dataSource {
    if (!_dataSource) {
        NSMutableArray *dataSource = [NSMutableArray array];
        for (int i = 1; i < 5; i++) {
            NSString *name = [NSString stringWithFormat:@"test%d", i];
            [dataSource addObject:[UIImage imageNamed:name]];
        }
        _dataSource = dataSource;
    }
    return _dataSource;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _imageView.userInteractionEnabled = YES;
    _imageView.tag = 0;
    [_imageView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapImage:)]];
    
    _imageView2.userInteractionEnabled = YES;
    _imageView2.tag = 1;
    [_imageView2 addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapImage:)]];
    
    _imageView3.userInteractionEnabled = YES;
    _imageView3.tag = 2;
    [_imageView3 addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapImage:)]];
    
    _imageView4.userInteractionEnabled = YES;
    _imageView4.tag = 3;
    [_imageView4 addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapImage:)]];
    
    
}

- (void)tapImage:(UIGestureRecognizer *)gesture {
    
    TBPictureBrowserView *photoBrowser = [[TBPictureBrowserView alloc] init];
    photoBrowser.delegate = self;
    photoBrowser.currentPage = gesture.view.tag;
    photoBrowser.totalPage = self.dataSource.count;
    photoBrowser.containerView = gesture.view.superview;
    [photoBrowser show];
}

- (UIImage *)placeHolderImage:(TBPictureBrowserView *)browser index:(NSInteger)index {
    return self.dataSource[index];
}

// 高清图实现方法代理
//- (NSString *)hightQualityImageUrl:(TBPictureBrowserView *)browser index:(NSInteger)index {
//    return self.dataSourceHight[index];
//}


- (IBAction)btnClick:(id)sender {
    
    
}
@end
