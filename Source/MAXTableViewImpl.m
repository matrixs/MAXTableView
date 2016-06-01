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

NSString *identifier = @"MAXCELL";

@interface MAXTableViewImpl()
{
    UITableViewCell *_cell;
    NSMutableArray *viewArray, *bottomArray;
}
@end

@implementation MAXTableViewImpl

-(void)registerClass:(Class)cellClass bindDataSource:(NSArray *)dataSource delegate:(id)delegate {
    [self bindDataSource:dataSource delegate:delegate];
    [self.tableView registerClass:cellClass forCellReuseIdentifier:identifier];
    self.cellClass = cellClass;
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
    NSString *cellIdentifier = identifier;
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
    return [NSString stringWithFormat:@"%@%ld", identifier, (long)indexPath.row];
}

-(void)calculateCellHeight:(UITableViewCell*)cell withData:(id)data{
    [cell fillData:data];
    [self updateLayout:cell];
//    CGFloat height = [cell.contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize].height;
    viewArray = [NSMutableArray new];
    bottomArray = [NSMutableArray new];
    for (NSLayoutConstraint *constraint in cell.contentView.constraints) {
        if (cell.contentView == constraint.firstItem) {
            NSLayoutAttribute firstAttribute = constraint.firstAttribute;
            if (firstAttribute == NSLayoutAttributeBottom || firstAttribute == NSLayoutAttributeBottomMargin) {
                if (constraint.secondItem) {
                    [viewArray addObject:constraint.secondItem];
                    [bottomArray addObject:@(fabs(constraint.constant))];
                }
            }
        }
    }
    CGFloat height = [self maxMarginBottomInSubviews:cell.contentView];
    height += 1;
    [self.heightArray addObject:@(height)];
}

-(CGFloat)maxMarginBottomInSubviews:(UIView*)view {
    CGFloat maxMarginBottom = 0;
    if (view.subviews.count > 0) {
        for (UIView *subview in view.subviews) {
            CGFloat height = [self maxMarginBottomInSubviews:subview];
            if (height > maxMarginBottom) {
                maxMarginBottom = height;
            }
        }
    } else {
        for (UIView *subview in view.superview.subviews) {
            CGFloat height = subview.frame.origin.y + subview.bounds.size.height;
            for (NSLayoutConstraint *constraint in view.superview.constraints) {
                if (subview == constraint.firstItem) {
                    NSLayoutAttribute firstAttribute = constraint.firstAttribute;
                    if(firstAttribute == NSLayoutAttributeBottom || firstAttribute == NSLayoutAttributeBottomMargin) {
                        height += fabs(constraint.constant);
                    }
                }
            }
            NSInteger index = [viewArray indexOfObject:subview];
            if (index >= 0 && index < bottomArray.count) {
                height += [bottomArray[index] floatValue];
            }
            if (height > maxMarginBottom) {
                maxMarginBottom = height;
            }
        }
    }
    return maxMarginBottom;
}

-(void)updateLayout:(UITableViewCell*)cell {
    [cell setNeedsUpdateConstraints];
    [cell updateConstraintsIfNeeded];
    cell.bounds = CGRectMake(0, 0, CGRectGetWidth(self.tableView.bounds), CGRectGetHeight(cell.bounds));
    [cell setNeedsLayout];
    [cell layoutIfNeeded];
}

-(void)calcCellHeight {
    if (!_cell) {
        _cell = [[self.cellClass alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    for (id obj in self.data) {
        [self calculateCellHeight:_cell withData:obj];
    }
}



@end
