//
//  MAXTableViewImpl.h
//  MAXTableView
//
//  Created by matrixs on 16/5/31.
//  Copyright © 2016年 matrixs. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MAXTableViewImpl : NSObject <UITableViewDelegate, UITableViewDataSource>

@property(nonatomic) NSInteger section;
@property(nonatomic) BOOL multiCellType;
@property(nonatomic) NSArray *data;
@property(nonatomic, weak) id forward;
@property(nonatomic) Class cellClass;
@property(nonatomic) NSMutableArray *heightArray;
@property(nonatomic, weak) UITableView *tableView;

-(void)registerClass:(Class)cellClass bindDataSource:(NSArray *)dataSource delegate:(id)delegate;
-(void)registerClass:(Class)cellClass bindDataSource:(NSArray *)dataSource delegate:(id)delegate identifier:(NSString *)identifier;
-(void)registerNib:(UINib *)nib bindDataSource:(NSArray *)dataSource delegate:(id)delegate identifier:(NSString *)identifier;
-(void)bindDataSource:(NSArray *)dataSource delegate:(id)delegate;
-(void)calcCellHeight;

@end
