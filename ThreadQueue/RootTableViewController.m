//
//  RootTableViewController.m
//  ThreadQueue
//
//  Created by peace on 23/11/2016.
//  Copyright © 2016 peace. All rights reserved.
//

#import "RootTableViewController.h"

#import "ThreadViewController.h"
#import "MultiThreadViewController.h"
#import "OperationViewController.h"
#import "GCDViewController.h"
#import "ThreadLockViewController.h"
#import "ConditionViewController.h"

static NSString *identifier = @"identifier";

@interface RootTableViewController ()
{
    NSArray *_items;
}
@end

@implementation RootTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:identifier];
    
    _items = @[@"NSThread",@"NSThread并发",@"Operation",@"GCD",@"线程锁",@"Condition"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _items.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier forIndexPath:indexPath];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:identifier];
    }
    NSString *string = [_items objectAtIndex:indexPath.row];
    cell.textLabel.text = string;
    
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.row == 0) {
        ThreadViewController *viewController = [[ThreadViewController alloc] init];
        [self.navigationController pushViewController:viewController animated:YES];
    }
    else if (indexPath.row == 1) {
        MultiThreadViewController *viewController = [[MultiThreadViewController alloc] init];
        [self.navigationController pushViewController:viewController animated:YES];
    }
    else if (indexPath.row == 2) {
        OperationViewController *viewController = [[OperationViewController alloc] init];
        [self.navigationController pushViewController:viewController animated:YES];
    }
    else if (indexPath.row == 3) {
        GCDViewController *viewController = [[GCDViewController alloc] init];
        [self.navigationController pushViewController:viewController animated:YES];
    }
    else if (indexPath.row == 4) {
        ThreadLockViewController *viewController = [[ThreadLockViewController alloc] init];
        [self.navigationController pushViewController:viewController animated:YES];
    }
    else if (indexPath.row == 5) {
        ConditionViewController *viewController = [[ConditionViewController alloc] init];
        [self.navigationController pushViewController:viewController animated:YES];
    }
}

@end
