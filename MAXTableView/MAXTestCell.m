//
//  MAXTestCell.m
//  MAXTableView
//
//  Created by matrixs on 16/5/31.
//  Copyright © 2016年 matrixs. All rights reserved.
//

#import "MAXTestCell.h"
#import "UITableViewCell+MAXTableViewCell.h"
#import <Masonry.h>

@interface MAXTestCell()
{
    UILabel *content;
    UIImageView *imageView;
}
@end

@implementation MAXTestCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"test"]];
    [self.contentView addSubview:imageView];
    imageView.contentMode = UIViewContentModeTop;
    imageView.backgroundColor = [UIColor redColor];
    [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView.mas_left).offset(10);
        make.top.equalTo(self.contentView.mas_top).offset(10);
        make.width.height.equalTo(@(70));
//        make.bottom.equalTo(@(-20)).priority(100);//set contentView bottom padding
    }];
    content = [UILabel new];
    content.textColor = [UIColor blueColor];
    content.font = [UIFont systemFontOfSize:14];
    content.numberOfLines = 0;
    [self.contentView addSubview:content];
        [content mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView.mas_top).offset(10);
        make.left.equalTo(imageView.mas_right).offset(10);
        make.right.equalTo(self.contentView.mas_right).offset(-10);
//            make.bottom.equalTo(@(-120)).priority(100); //set contentView bottom padding
    }];
    return self;
}

-(void)fillData:(id)data {
    content.text = data[@"txt"];
    
}

@end
