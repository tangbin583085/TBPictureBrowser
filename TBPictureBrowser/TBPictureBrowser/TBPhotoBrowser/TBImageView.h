//
//  TBImageView.h
//  com.pintu.aaaaaa
//
//  Created by hanchuangkeji on 2017/9/11.
//  Copyright © 2017年 hanchuangkeji. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol TBImageViewDelegate <NSObject>

@optional
- (void)imageViewTap;

@end



@interface TBImageView : UIImageView

@property (nonatomic, weak)id<TBImageViewDelegate> delegate;

- (void)setupHightQualityPic:(NSString *)url;

@end
