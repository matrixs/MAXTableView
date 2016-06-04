//
//  MAXTableViewImpl.m
//  MAXTableView
//
//  Created by matrixs on 16/5/31.
//  Copyright © 2016年 matrixs. All rights reserved.
//

#import "MAXTableViewImpl.h"
#import "UITableViewCell+MAXTableViewCell.h"
#import <objc/runtime.h>

NSString *MAXIdentifier = @"MAXCELL";
const char BottomKey, BottomMarginKey;

@interface MAXTableViewImpl()
{
    UITableViewCell *_cell;
    BOOL _constraintsCached;
    NSString *_cellIdentifier;
}
@end

@implementation MAXTableViewImpl

-(void)registerClass:(Class)cellClass bindDataSource:(NSArray *)dataSource delegate:(id)delegate {
    if (!_cellIdentifier) {
        _cellIdentifier = MAXIdentifier;
    }
    [self bindDataSource:dataSource delegate:delegate];
    [self.tableView registerClass:cellClass forCellReuseIdentifier:_cellIdentifier];
    self.cellClass = cellClass;
}

-(void)registerClass:(Class)cellClass bindDataSource:(NSArray *)dataSource delegate:(id)delegate identifier:(NSString *)identifier {
    _cellIdentifier = identifier;
    [self registerClass:cellClass bindDataSource:dataSource delegate:delegate];
}

-(void)registerNib:(UINib *)nib bindDataSource:(NSArray *)dataSource delegate:(id)delegate identifier:(NSString *)identifier {
    _cellIdentifier = identifier;
    [self bindDataSource:dataSource delegate:delegate];
    [self.tableView registerNib:nib forCellReuseIdentifier:_cellIdentifier];
}

-(void)bindDataSource:(NSArray *)dataSource delegate:(id)delegate {
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.forward = delegate;
    self.data = dataSource;
    self.heightArray = [[NSMutableArray alloc] initWithCapacity:self.data.count];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if ([self.forward respondsToSelector:@selector(numberOfSectionsInTableView:)]) {
        return [self.forward numberOfSectionsInTableView:tableView];
    }
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if ([self.forward respondsToSelector:@selector(tableView:numberOfRowsInSection:)]) {
        return [self.forward tableView:tableView numberOfRowsInSection:section];
    }
    return self.data.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell;
    if ([self.forward respondsToSelector:@selector(tableView:cellForRowAtIndexPath:)]) {
        cell = [self.forward tableView:tableView cellForRowAtIndexPath:indexPath];
    }
    NSString *cellIdentifier = _cellIdentifier;
    if (self.multiCellType) {
        cellIdentifier = [self identifierForRowAtIndexPath:indexPath];
    }
    if (!cell) {
        cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    }
    if (!cell) {
        if ([self.forward respondsToSelector:@selector(cellClassForRowAtIndexPath:)]) {
            cell = [[[self.forward cellClassForRowAtIndexPath:indexPath] alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        }
        if (self.cellClass) {
            cell = [[self.cellClass alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        } else {
            cell = [[[self cellClassForRowAtIndexPath:indexPath] alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        }
    }
    [cell fillData:self.data[indexPath.row]];
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([self.forward respondsToSelector:@selector(tableView:heightForRowAtIndexPath:)]) {
        return [self.forward tableView:tableView heightForRowAtIndexPath:indexPath];
    }
    if (indexPath.row < self.heightArray.count && self.heightArray[indexPath.row] > 0) {
        return [self.heightArray[indexPath.row] floatValue];
    }
    return 0;
}

-(Class)cellClassForRowAtIndexPath:(NSIndexPath*)indexPath {
    return [UITableViewCell class];
}

-(NSString*)identifierForRowAtIndexPath:(NSIndexPath*)indexPath {
    return [NSString stringWithFormat:@"%@%ld", _cellIdentifier, (long)indexPath.row];
}

-(void)calculateCellHeight:(UITableViewCell*)cell withData:(id)data{
    [cell fillData:data];
    [self updateLayout:cell];
    CGFloat height = [self maxMarginBottomInSubviews:cell.contentView];
    height += 1;
    [self.heightArray addObject:@(height)];
    _constraintsCached = YES;
}

-(CGFloat)maxMarginBottomInSubviews:(UIView*)view {
    CGFloat maxMarginBottom = 0;
    if (view.subviews.count > 0) {
        for (UIView *subview in view.subviews) {
            CGFloat height = [self maxMarginBottomInSubviews:subview];
            if (_constraintsCached) {
                id bottomValue = objc_getAssociatedObject(subview, &BottomKey);
                if (bottomValue) {
                    height += [bottomValue floatValue];
                }
                id bottomMarginValue = objc_getAssociatedObject(subview, &BottomMarginKey);
                if (bottomMarginValue) {
                    height += [bottomMarginValue floatValue];
                }
            } else {
                NSArray *array = view.constraints;
                for (NSLayoutConstraint *constraint in array) {
                    if (subview == constraint.firstItem) {
                        NSLayoutAttribute firstAttribute = constraint.firstAttribute;
                        if(firstAttribute == NSLayoutAttributeBottom) {
                            CGFloat bottom = fabs(constraint.constant);
                            height += bottom;
                            objc_setAssociatedObject(subview, &BottomKey, @(bottom), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
                        }
                        if (firstAttribute == NSLayoutAttributeBottomMargin) {
                            CGFloat bottomMargin = fabs(constraint.constant);
                            height += bottomMargin;
                            objc_setAssociatedObject(subview, &BottomMarginKey, @(bottomMargin), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
                        }
                    }
                }
            }
            if (height > maxMarginBottom) {
                maxMarginBottom = height;
            }
        }
    } else {
        return view.frame.origin.y + view.bounds.size.height;
    }
    return maxMarginBottom;
}

-(void)updateLayout:(UITableViewCell*)cell {
    cell.bounds = CGRectMake(0, 0, CGRectGetWidth(self.tableView.bounds), CGRectGetHeight(cell.bounds));
    [cell layoutIfNeeded];
}

-(void)calcCellHeight {
    if (!_cell) {
        if (self.cellClass) {
            _cell = [[self.cellClass alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:_cellIdentifier];
        } else {
            _cell = [self.tableView dequeueReusableCellWithIdentifier:_cellIdentifier];
        }
    }
    for (id obj in self.data) {
        [self calculateCellHeight:_cell withData:obj];
    }
}



@end
