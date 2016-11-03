//
//  TableViewCell.m
//  MyBluetoothDemo
//
//  Created by LaughingZhong on 15/6/10.
//  Copyright (c) 2015年 Laughing. All rights reserved.
//

#import "TableViewCell.h"

@interface NearbyPeripheralInfo()

@end

@implementation NearbyPeripheralInfo
@synthesize peripheral,advertisementData,RSSI;

@end

@interface TableViewCell()

@property (nonatomic,strong) UILabel *nameLabel;
@property (nonatomic,strong) UILabel *RSSILabel;
@end

@implementation TableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self customUI];
    }
    return self;
}

- (void)awakeFromNib {
    // Initialization code
    [self customUI];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

#pragma mark - UI
- (void)customUI
{
    [self initWithNameLabel];
    [self initWithRSSILabel];
    //[self initWithConnectLabel];
    
    _IsConnectLabel = [[UILabel alloc] initWithFrame:CGRectMake(_nameLabel.frame.size.width, 0, 120, 50)];
    _IsConnectLabel.textAlignment = NSTextAlignmentCenter;
    _IsConnectLabel.textColor = [UIColor blackColor];
    [self.contentView addSubview:_IsConnectLabel];
    
//    [_IsConnectLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.equalTo(_nameLabel.mas_right).with.offset(20);
//        make.top.equalTo(self).with.offset(5);
//        make.size.mas_equalTo(CGSizeMake(150, 50));
//    }];
}

- (void)initWithNameLabel
{
    if (!_nameLabel) {
        _nameLabel = [self customLabelWithFrame:CGRectMake(0.0, 0.0, 100.0, 50.0)];
        [_nameLabel setTranslatesAutoresizingMaskIntoConstraints:NO];
    }
    if (_nameLabel && _nameLabel.superview != self.contentView) {
        [self.contentView addSubview:_nameLabel];
        
        NSArray *h = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-10-[_nameLabel]" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_nameLabel)];
        NSArray *v = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|[_nameLabel]|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_nameLabel)];
        [self.contentView addConstraints:h];
        [self.contentView addConstraints:v];
    }
}

- (void)initWithRSSILabel
{
    if (!_RSSILabel) {
        _RSSILabel = [self customLabelWithFrame:CGRectMake(0.0, 0.0, 100.0, 50.0)];
        [_RSSILabel setTranslatesAutoresizingMaskIntoConstraints:NO];
    }
    if (_RSSILabel && _RSSILabel.superview != self.contentView) {
        [self.contentView addSubview:_RSSILabel];
        
        NSArray *h = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-10-[_nameLabel]-10-[_RSSILabel(==80)]-10-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_nameLabel,_RSSILabel)];
        NSArray *v = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|[_RSSILabel]|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_RSSILabel)];
        [self.contentView addConstraints:h];
        [self.contentView addConstraints:v];
    }
}

- (UILabel *)customLabelWithFrame:(CGRect)frame
{
    UILabel *label = [[UILabel alloc] initWithFrame:frame];
    [label setBackgroundColor:[UIColor clearColor]];
    [label setTextAlignment:NSTextAlignmentLeft];
    [label setFont:[UIFont systemFontOfSize:15.0]];
    return label;
}

#pragma mark - Public Method
- (void)setPeripheral:(NearbyPeripheralInfo *)info
{
    if (info) {
        CBPeripheral *per = info.peripheral;
        
        [_nameLabel setText:per.name];
        [_RSSILabel setText:[NSString stringWithFormat:@"RSSI:%d",[info.RSSI intValue]]];
    }
}

@end