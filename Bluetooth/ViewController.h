//
//  ViewController.h
//  Bluetooth
//
//  Created by 吴德文 on 16/10/12.
//  Copyright © 2016年 XiangYuKeJi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreBluetooth/CoreBluetooth.h>

@interface ViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,CBCentralManagerDelegate,CBPeripheralDelegate>

@property(nonatomic,strong) UITableView *tableView;

/* 提示文字 */
- (void)showTostInView:(NSString *)tost;
@end

