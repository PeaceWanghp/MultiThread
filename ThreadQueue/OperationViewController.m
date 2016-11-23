//
//  OperationViewController.m
//  ThreadQueue
//
//  Created by peace on 23/11/2016.
//  Copyright © 2016 peace. All rights reserved.
//

#import "OperationViewController.h"

#import "TQImageData.h"
#define ROW_COUNT 5
#define COLUMN_COUNT 3
#define ROW_HEIGHT 100
#define ROW_WIDTH ROW_HEIGHT
#define CELL_SPACING 10

@interface OperationViewController ()
{
    NSMutableArray *_imageViews;
    NSMutableArray *_imageNames;
}
@end

@implementation OperationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self layoutUI];
}

#pragma mark 界面布局
-(void)layoutUI{
    //创建多个图片控件用于显示图片
    _imageViews=[NSMutableArray array];
    for (int r=0; r<ROW_COUNT; r++) {
        for (int c=0; c<COLUMN_COUNT; c++) {
            UIImageView *imageView=[[UIImageView alloc]initWithFrame:CGRectMake(c*ROW_WIDTH+(c*CELL_SPACING), r*ROW_HEIGHT+(r*CELL_SPACING                           ), ROW_WIDTH, ROW_HEIGHT)];
            imageView.contentMode=UIViewContentModeScaleAspectFit;
            //            imageView.backgroundColor=[UIColor redColor];
            [self.view addSubview:imageView];
            [_imageViews addObject:imageView];
            
        }
    }
    
    //创建图片链接
    _imageNames=[NSMutableArray array];
    for (int i=0; i<_imageViews.count; i++) {
        [_imageNames addObject:[NSString stringWithFormat:@"http://images.cnblogs.com/cnblogs_com/kenshincui/613474/o_%i.jpg",i]];
    }
    
    UIButton *button=[UIButton buttonWithType:UIButtonTypeRoundedRect];
    button.frame=CGRectMake(50, 500, 220, 25);
    [button setTitle:@"加载图片" forState:UIControlStateNormal];
    //添加方法
    //[button addTarget:self action:@selector(loadImageWithMultiThread) forControlEvents:UIControlEventTouchUpInside];
    [button addTarget:self action:@selector(loadImageWithMultiThreadDependency) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
}

#pragma mark 将图片显示到界面
-(void)updateImageWithData:(NSData *)data andIndex:(int )index{
    UIImage *image=[UIImage imageWithData:data];
    UIImageView *imageView= _imageViews[index];
    imageView.image=image;
}

#pragma mark 请求图片数据
-(NSData *)requestData:(int )index{
    sleep(1);
    
    NSURL *url=[NSURL URLWithString:_imageNames[index]];
    NSData *data=[NSData dataWithContentsOfURL:url];
    
    return data;
}

#pragma mark 加载图片
-(void)loadImage:(NSNumber *)index{
    int i=(int)[index integerValue];
    
    //请求数据
    NSData *data= [self requestData:i];
    NSLog(@"%@",[NSThread currentThread]);
    //更新UI界面,此处调用了主线程队列的方法（mainQueue是UI主线程）
    [[NSOperationQueue mainQueue] addOperationWithBlock:^{
        [self updateImageWithData:data andIndex:i];
    }];
}

#pragma mark 多线程下载图片
-(void)loadImageWithMultiThread{
    int count=ROW_COUNT*COLUMN_COUNT;
    //创建操作队列
    NSOperationQueue *operationQueue=[[NSOperationQueue alloc]init];
    operationQueue.maxConcurrentOperationCount=5;//设置最大并发线程数
    //创建多个线程用于填充图片
    for (int i=0; i<count; ++i) {
        //方法1：创建操作块添加到队列
        //        //创建多线程操作
        //        NSBlockOperation *blockOperation=[NSBlockOperation blockOperationWithBlock:^{
        //            [self loadImage:[NSNumber numberWithInt:i]];
        //        }];
        //        //创建操作队列
        //
        //        [operationQueue addOperation:blockOperation];
        
        //方法2：直接使用操队列添加操作
        [operationQueue addOperationWithBlock:^{
            [self loadImage:[NSNumber numberWithInt:i]];
        }];
        
    }
}

//顺序依赖
-(void)loadImageWithMultiThreadDependency{
    int count=ROW_COUNT*COLUMN_COUNT;
    //创建操作队列
    NSOperationQueue *operationQueue=[[NSOperationQueue alloc]init];
//    operationQueue.maxConcurrentOperationCount=5;//设置最大并发线程数
    
    
    //创建多个线程用于填充图片
    NSBlockOperation *previousBlockOperation = nil;
    for (int i=0; i<count; ++i) {
        //方法1：创建操作块添加到队列
        //创建多线程操作
        NSBlockOperation *blockOperation=[NSBlockOperation blockOperationWithBlock:^{
            [self loadImage:[NSNumber numberWithInt:i]];
        }];
        //设置依赖操作为最后一张图片加载操作
        if (previousBlockOperation) {
            [blockOperation addDependency:previousBlockOperation];
        }
        
        [operationQueue addOperation:blockOperation];
        
        previousBlockOperation = blockOperation;
    }
}

@end
