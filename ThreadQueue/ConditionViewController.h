//
//  ConditionViewController.h
//  ThreadQueue
//
//  Created by peace on 23/11/2016.
//  Copyright © 2016 peace. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ConditionViewController : UIViewController

#pragma mark 图片资源存储容器
@property (atomic,strong) NSMutableArray *imageNames;

#pragma mark 当前加载的图片索引（图片链接地址连续）
@property (atomic,assign) int currentIndex;

@end
