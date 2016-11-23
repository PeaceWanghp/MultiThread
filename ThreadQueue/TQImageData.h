//
//  TQImageData.h
//  ThreadQueue
//
//  Created by peace on 23/11/2016.
//  Copyright © 2016 peace. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TQImageData : NSObject

#pragma mark 索引
@property (nonatomic,assign) int index;

#pragma mark 图片数据
@property (nonatomic,strong) NSData *data;

@end
