//
//  ThreadLockViewController.m
//  ThreadQueue
//
//  Created by peace on 23/11/2016.
//  Copyright © 2016 peace. All rights reserved.
//

#import "ThreadLockViewController.h"

#import "TQImageData.h"

#define ROW_COUNT 5
#define COLUMN_COUNT 3
#define ROW_HEIGHT 100
#define ROW_WIDTH ROW_HEIGHT
#define CELL_SPACING 10
#define IMAGE_COUNT 9

@interface ThreadLockViewController ()
{
    NSMutableArray *_imageViews;
    NSLock *_lock;
     dispatch_semaphore_t _semaphore;//定义一个信号量
//    NSMutableArray *_imageNames;
}

@property (atomic,strong) NSMutableArray *imageNames;

@end

@implementation ThreadLockViewController

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
    
    UIButton *button=[UIButton buttonWithType:UIButtonTypeRoundedRect];
    button.frame=CGRectMake(50, 500, 220, 25);
    [button setTitle:@"加载图片" forState:UIControlStateNormal];
    //添加方法
    [button addTarget:self action:@selector(loadImageWithMultiThread) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
    
    //初始化锁对象
    _lock=[[NSLock alloc]init];
    
    _semaphore=dispatch_semaphore_create(1);
}

#pragma mark 将图片显示到界面
-(void)updateImageWithData:(NSData *)data andIndex:(int )index{
    UIImage *image=[UIImage imageWithData:data];
    UIImageView *imageView= _imageViews[index];
    imageView.image=image;
}

#pragma mark 请求图片数据
-(NSData *)requestData:(int )index{
    
    
    NSData *data;
    NSString *name;
//    //加锁
//    @synchronized(self){
//        if (index%2 == 1) {
//            sleep(1);
//        }
//        
//        if (_imageNames.count>0) {
//            name=[_imageNames lastObject];
//            [_imageNames removeObject:name];
//        }
//    }
    
    dispatch_semaphore_wait(_semaphore, DISPATCH_TIME_FOREVER);
    
    if (index%2 == 1) {
        sleep(1);
    }
    
    if (_imageNames.count>0) {
        name=[_imageNames lastObject];
        [_imageNames removeObject:name];
    }
    //信号通知
    dispatch_semaphore_signal(_semaphore);
    
    if(name){
        NSURL *url=[NSURL URLWithString:name];
        data=[NSData dataWithContentsOfURL:url];
    }
    return data;
}

#pragma mark 加载图片
-(void)loadImage:(NSNumber *)index{
    int i=(int)[index integerValue];
    //请求数据
    NSData *data= [self requestData:i];
    //更新UI界面,此处调用了GCD主线程队列的方法
    dispatch_queue_t mainQueue= dispatch_get_main_queue();
    dispatch_sync(mainQueue, ^{
        [self updateImageWithData:data andIndex:i];
    });
}

#pragma mark 多线程下载图片
-(void)loadImageWithMultiThread{
    //创建图片链接
    _imageNames=[NSMutableArray array];
    for (int i=0; i<IMAGE_COUNT; i++) {
        [_imageNames addObject:[NSString stringWithFormat:@"http://images.cnblogs.com/cnblogs_com/kenshincui/613474/o_%i.jpg",i]];
    }
    
    
    int count=ROW_COUNT*COLUMN_COUNT;
    
    dispatch_queue_t globalQueue=dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    //创建多个线程用于填充图片
    for (int i=0; i<count; ++i) {
        //异步执行队列任务
        dispatch_async(globalQueue, ^{
            [self loadImage:[NSNumber numberWithInt:i]];
        });
    }
    
}

@end
