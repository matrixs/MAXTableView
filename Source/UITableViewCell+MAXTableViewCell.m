//
//  UITableViewCell+MAXTableViewCell.m
//  MAXTableView
//
//  Created by matrixs on 16/5/31.
//  Copyright © 2016年 matrixs. All rights reserved.
//

#import "UITableViewCell+MAXTableViewCell.h"
#import <objc/runtime.h>

@implementation UITableViewCell(MAXTableViewCell)

+(void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        [self max_extendsLayoutSubviews];
        
    });
}

+ (void)max_extendsLayoutSubviews
{
    //PART 1
    Class thisClass = [self class];
    
    //layoutSubviews selector, method, implementation
    SEL layoutSubviewsSEL = @selector(layoutSubviews);
    Method layoutSubviewsMethod = class_getInstanceMethod(thisClass, layoutSubviewsSEL);
    IMP layoutSubviewsIMP = method_getImplementation(layoutSubviewsMethod);
    
    //mg_layoutSubviews selector, method, implementation
    SEL max_layoutSubviewsSEL = @selector(max_layoutSubviews);
    Method max_layoutSubviewsMethod = class_getInstanceMethod(thisClass, max_layoutSubviewsSEL);
    IMP max_layoutSubviewsIMP = method_getImplementation(max_layoutSubviewsMethod);
    
    //PART 2
    //Try to add the method layoutSubviews with the new implementation (if already exists it'll return NO)
    BOOL wasMethodAdded = class_addMethod(thisClass, layoutSubviewsSEL, max_layoutSubviewsIMP, method_getTypeEncoding(max_layoutSubviewsMethod));
    
    if (wasMethodAdded) {
        //Just set the new selector points to the original layoutSubviews method
        class_replaceMethod(thisClass, max_layoutSubviewsSEL, layoutSubviewsIMP, method_getTypeEncoding(layoutSubviewsMethod));
    } else {
        method_exchangeImplementations(layoutSubviewsMethod, max_layoutSubviewsMethod);
    }
}

-(void)fillData:(id)data {
    [NSException raise:@"MAXTableViewException" format:@"you must implement your fillData methods in your custom UITableViewCell"];
}

-(void)max_layoutSubviews {
    [self max_layoutSubviews];
    if ([self isKindOfClass:[UITableViewCell class]]) {
        NSLayoutConstraint *constraint = [NSLayoutConstraint constraintWithItem:self.contentView attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeWidth multiplier:1 constant:self.bounds.size.width];
        [self.contentView addConstraint:constraint];
        [self setPreferredMaxWidthOfUILabelForView:((UITableViewCell*)self).contentView];
        [self.contentView removeConstraint:constraint];
    }
}

-(void)setPreferredMaxWidthOfUILabelForView:(UIView*)view {
    if (view.subviews.count > 0) {
        for (UIView *childView in view.subviews) {
            [self setPreferredMaxWidthOfUILabelForView:childView];
        }
    } else {
        if ([view isKindOfClass:[UILabel class]]) {
            UILabel *label = ((UILabel*)view);
            [label layoutIfNeeded];
            label.preferredMaxLayoutWidth = label.bounds.size.width;
        }
    }
}

@end
