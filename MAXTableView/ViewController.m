//
//  ViewController.m
//  MAXTableView
//
//  Created by matrixs on 16/5/31.
//  Copyright © 2016年 matrixs. All rights reserved.
//

#import "ViewController.h"
#import "UITableView+MAXTableView.h"
#import "MAXTestCell.h"

@interface ViewController ()
{
    NSMutableArray *_dataSource;
}

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _dataSource = [NSMutableArray new];
    UITableView *tableView =[[UITableView alloc] initWithFrame:self.view.frame style:UITableViewStylePlain];
    [self.view addSubview:tableView];
    [tableView registerClass:[MAXTestCell class] bindDataSource:_dataSource delegate:self];
    [_dataSource addObject:@{@"txt":@"ssssssss"}];
    [_dataSource addObject:@{@"txt":@"sssssssssssssssssssssssssssssssssssssssssssssss"}];
    [_dataSource addObject:@{@"txt":@"ssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssss"}];
    [_dataSource addObject:@{@"txt":@"ssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssss\nssssssss\nssssssss\nssssssss\nssssssss\ns\ns"}];
    [_dataSource addObject:@{@"txt":@"ssssssss\nssssssss\nssssssss\nssssssss\nssssssss\nssssssss\nssssssss\nssssssss\n\n\nssssssss\n\n\nssssssss\n\n\nssssssss"}];
    [_dataSource addObject:@{@"txt":@"ssssssssas\nssssssss\nsas\nssssssss\nas\n\nssssssss\n\nasdasd\nssssssss\nssssssssas\n\nasdas\n\n\nssssssss\nasd\nssssssss\n\nasdasd\nssssssss\nweqw\ne\nssssssss"}];
    [tableView reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
