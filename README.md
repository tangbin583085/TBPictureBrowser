# TBPictureBrowser
图片浏览器（高仿微信朋友圈图片浏览）

# 使用方法
        TBPictureBrowserView *photoBrowser = [[TBPictureBrowserView alloc] init];
        photoBrowser.delegate = self;
        photoBrowser.currentPage = gesture.view.tag;
        photoBrowser.totalPage = self.dataSource.count;
        photoBrowser.containerView = gesture.view.superview;
        photoBrowser show];


 ![image](https://github.com/tangbin583085/TBPictureBrowser/blob/master/TBPictureBrowser/TBPictureBrowser/TBPhotoBrowser/screenshot/2017-09-12%2014_43_36.gif)
