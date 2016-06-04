//
//  UITableView+MAXTableView.m
//  MAXTableView
//
//  Created by matrixs on 16/5/31.
//  Copyright © 2016年 matrixs. All rights reserved.
//

#import "UITableView+MAXTableView.h"
#import <objc/runtime.h>

const char MAXTableViewImplKey;

@implementation UITableView(MAXTableView)

+(void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        [self max_swizzleMethod];
        
    });
}

+ (void)max_swizzleMethod
{
    //PART 1
    Class thisClass = [self class];
    
    //layoutSubviews selector, method, implementation
    SEL reloadDataSEL = @selector(reloadData);
    Method reloadDataMethod = class_getInstanceMethod(thisClass, reloadDataSEL);
    IMP reloadDataIMP = method_getImplementation(reloadDataMethod);
    
    //mg_layoutSubviews selector, method, implementation
    SEL max_reloadDataSEL = @selector(max_reloadData);
    Method max_reloadDataMethod = class_getInstanceMethod(thisClass, max_reloadDataSEL);
    IMP max_reloadDataIMP = method_getImplementation(max_reloadDataMethod);
    
    //PART 2
    //Try to add the method layoutSubviews with the new implementation (if already exists it'll return NO)
    BOOL wasMethodAdded = class_addMethod(thisClass, reloadDataSEL, max_reloadDataIMP, method_getTypeEncoding(max_reloadDataMethod));
    
    if (wasMethodAdded) {
        //Just set the new selector points to the original layoutSubviews method
        class_replaceMethod(thisClass, max_reloadDataSEL, reloadDataIMP, method_getTypeEncoding(reloadDataMethod));
    } else {
        method_exchangeImplementations(reloadDataMethod, max_reloadDataMethod);
    }
}

-(MAXTableViewImpl *)tableViewImpl {
    MAXTableViewImpl *tableViewImpl = objc_getAssociatedObject(self, &MAXTableViewImplKey);
    if (!tableViewImpl) {
        tableViewImpl = [[MAXTableViewImpl alloc] init];
        objc_setAssociatedObject(self, &MAXTableViewImplKey, tableViewImpl, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    return tableViewImpl;
}

-(void)registerClass:(Class)cellClass bindDataSource:(NSArray *)dataSource delegate:(id)delegate {
    self.tableViewImpl.tableView = self;
    self.tableFooterView = [UIView new];
    [self.tableViewImpl registerClass:cellClass bindDataSource:dataSource delegate:delegate];
}

-(void)registerClass:(Class)cellClass bindDataSource:(NSArray *)dataSource delegate:(id)delegate identifier:(NSString *)identifier {
    self.tableViewImpl.tableView = self;
    self.tableFooterView = [UIView new];
    [self.tableViewImpl registerClass:cellClass bindDataSource:dataSource delegate:delegate identifier:identifier];
}

-(void)registerNib:(UINib *)nib bindDataSource:(NSArray *)dataSource delegate:(id)delegate identifier:(NSString *)identifier {
    self.tableViewImpl.tableView = self;
    self.tableFooterView = [UIView new];
    [self.tableViewImpl registerNib:nib bindDataSource:dataSource delegate:delegate identifier:identifier];
}

-(void)bindDataSource:(NSArray *)dataSource delegate:(id)delegate {
    self.tableViewImpl.tableView = self;
    self.tableFooterView = [UIView new];
    [self.tableViewImpl bindDataSource:dataSource delegate:delegate];
}

-(void)max_reloadData {
    if (![self.tableViewImpl.forward respondsToSelector:@selector(tableView:heightForRowAtIndexPath:)]) {
        [self.tableViewImpl calcCellHeight];
    }
    [self max_reloadData];
}

@end
