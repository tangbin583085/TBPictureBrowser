//
//  TBPictureBrowserView.h
//  com.pintu.aaaaaa
//
//  Created by hanchuangkeji on 2017/9/11.
//  Copyright © 2017年 hanchuangkeji. All rights reserved.
//

#import <UIKit/UIKit.h>
@class TBPictureBrowserView;
@protocol TBPictureBrowserViewDelegate <NSObject>

@required
/**
 * 小图，站位图
 */
- (UIImage *)placeHolderImage:(TBPictureBrowserView *)browser index:(NSInteger)index;

@optional
/**
 * 高清图的url
 */
- (NSString *)hightQualityImageUrl:(TBPictureBrowserView *)browser index:(NSInteger)index;

@end


@interface TBPictureBrowserView : UIView


/**
 当前页
 */
@property (nonatomic, assign)NSInteger currentPage;

/**
 总共的页数
 */
@property (nonatomic, assign)NSInteger totalPage;


/**
 父类的控件
 */
@property (nonatomic, weak)UIView *containerView;

@property (nonatomic, weak)id<TBPictureBrowserViewDelegate> delegate;


- (void)show;

@end
