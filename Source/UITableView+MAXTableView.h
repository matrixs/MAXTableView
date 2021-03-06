//
//  UITableView+MAXTableView.h
//  MAXTableView
//
//  Created by matrixs on 16/5/31.
//  Copyright © 2016年 matrixs. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MAXTableViewImpl.h"

@interface UITableView(MAXTableView)

@property(nonatomic, readonly)MAXTableViewImpl *tableViewImpl;

-(void)registerClass:(Class)cellClass bindDataSource:(NSArray *)dataSource delegate:(id)delegate;
-(void)registerClass:(Class)cellClass bindDataSource:(NSArray *)dataSource delegate:(id)delegate identifier:(NSString *)identifier;
-(void)registerNib:(UINib *)nib bindDataSource:(NSArray *)dataSource delegate:(id)delegate identifier:(NSString *)identifier;
-(void)bindDataSource:(NSArray *)dataSource delegate:(id)delegate;
-(void)setDataSource:(NSArray*)dataSource;

@end
