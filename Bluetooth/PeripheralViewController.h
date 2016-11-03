//
//  PeripheralViewController.h
//  MyBluetoothDemo
//
//  Created by LaughingZhong on 15/6/10.
//  Copyright (c) 2015年 Laughing. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreBluetooth/CoreBluetooth.h>

@interface PeripheralViewController : UIViewController<CBPeripheralDelegate>

@property (nonatomic,strong) CBPeripheral *currentPeripheral;

@end
