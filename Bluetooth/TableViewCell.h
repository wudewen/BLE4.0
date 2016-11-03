//
//  TableViewCell.h
//  MyBluetoothDemo
//
//  Created by LaughingZhong on 15/6/10.
//  Copyright (c) 2015年 Laughing. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreBluetooth/CoreBluetooth.h>

@interface NearbyPeripheralInfo : NSObject

@property (nonatomic,strong) CBPeripheral *peripheral;
@property (nonatomic,strong) NSDictionary *advertisementData;
@property (nonatomic,strong) NSNumber *RSSI;
@end

@interface TableViewCell : UITableViewCell<CBPeripheralDelegate>

@property (nonatomic,strong) UILabel *IsConnectLabel;

- (void)setPeripheral:(NearbyPeripheralInfo *)info;

@end
