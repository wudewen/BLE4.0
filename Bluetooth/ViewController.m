//
//  ViewController.m
//  Bluetooth
//
//  Created by 吴德文 on 16/10/12.
//  Copyright © 2016年 XiangYuKeJi. All rights reserved.
//

#import "ViewController.h"
#import "TableViewCell.h"
#import "PeripheralViewController.h"

#define ScanTimeInterval 1.0

@interface ViewController ()
{
    TableViewCell *cell;
}

@property (nonatomic,strong) NSMutableArray *devicesArray;
@property (nonatomic,strong) CBCentralManager *centralManager;
@property (nonatomic,strong) CBPeripheral *selectedPeripheral;
@property (nonatomic,strong) NSTimer *scanTimer;

@end

@implementation ViewController

- (void)dealloc
{
    _devicesArray = nil;
    _centralManager = nil;
    _selectedPeripheral = nil;
    _scanTimer = nil;
}

-(void)viewDidLoad
{
    self.edgesForExtendedLayout = 0;
    
    [self setUI];
}

#pragma mark - 搭建UI界面
-(void)setUI
{
    _devicesArray = [[NSMutableArray alloc] initWithCapacity:1];
    
    [self initWithTableView];
    [self initWithCBCentralManager];
    
    self.title = @"蓝牙音响";
    
    //space空格buttonItem
    UIBarButtonItem *negativeSpacer = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    negativeSpacer.width = -30;
    
    // 扫描设备
    UIButton *btn1 = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn1 setTitle:@"扫描设备" forState:UIControlStateNormal];
    [btn1 addTarget:self action:@selector(searchDeviceClick) forControlEvents:UIControlEventTouchUpInside];
    [btn1 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    btn1.frame = CGRectMake(0.0, 0.0, SCREEN_WIDTH/3, 40.0);
    [self.view addSubview:btn1];
//    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithCustomView:btn1];
//    self.navigationItem.leftBarButtonItems = @[negativeSpacer, leftItem];
    
    // 停止扫描
    UIButton *btn2 = [[UIButton alloc] init];
    [btn2 setTitle:@"停止扫描" forState:UIControlStateNormal];
    [btn2 addTarget:self action:@selector(disconnectClick) forControlEvents:UIControlEventTouchUpInside];
    [btn2 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    btn2.frame = CGRectMake(SCREEN_WIDTH*2/3, 0.0, SCREEN_WIDTH/3, 40.0);
    [self.view addSubview:btn2];
//    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithCustomView:btn2];
//    self.navigationItem.rightBarButtonItems = @[negativeSpacer,rightItem];
}

#pragma mark - 扫描设备方法
-(void)searchDeviceClick
{
    if (!_scanTimer) {
        _scanTimer = [NSTimer timerWithTimeInterval:ScanTimeInterval target:self selector:@selector(scanForPeripherals) userInfo:nil repeats:YES];
        [[NSRunLoop mainRunLoop] addTimer:_scanTimer forMode:NSDefaultRunLoopMode];
    }
    if (_scanTimer && !_scanTimer.valid) {
        [_scanTimer fire];
    }
}

- (void)scanForPeripherals
{
    if (_centralManager.state == CBCentralManagerStateUnsupported) {//设备不支持蓝牙
        
    }else {//设备支持蓝牙连接
        if (_centralManager.state == CBCentralManagerStatePoweredOn) {//蓝牙开启状态
            //[_centralManager stopScan];
            [_centralManager scanForPeripheralsWithServices:nil options:@{CBCentralManagerScanOptionAllowDuplicatesKey:[NSNumber numberWithBool:NO]}];
        }
    }
}

#pragma mark - 停止扫描设备方法
-(void)disconnectClick
{
    if (_scanTimer && _scanTimer.valid) {
        [_scanTimer invalidate];
        _scanTimer = nil;
    }
    [_centralManager stopScan];
}

#pragma mark - CBCentralManager
- (void)initWithCBCentralManager
{
    if (!_centralManager) {
        dispatch_queue_t queue = dispatch_get_main_queue();
        _centralManager = [[CBCentralManager alloc] initWithDelegate:self queue:queue options:@{CBCentralManagerOptionShowPowerAlertKey:@YES}];
        [_centralManager setDelegate:self];
    }
}

#pragma mark - tableView
- (void)initWithTableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 50, SCREEN_WIDTH, SCREEN_HEIGHT-50*2-44) style:UITableViewStylePlain];
        [_tableView setDelegate:self];
        [_tableView setDataSource:self];
        [_tableView setBackgroundColor:[UIColor clearColor]];
        [_tableView setSeparatorStyle:UITableViewCellSeparatorStyleSingleLine];
        [_tableView setTranslatesAutoresizingMaskIntoConstraints:NO];
    }
    if (_tableView && _tableView.superview != self.view) {
        [self.view addSubview:_tableView];
        
//        NSArray *h = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|[_tableView]|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_tableView)];
//        NSArray *v = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|[_tableView]|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_tableView)];
//        [self.view addConstraints:h];
//        [self.view addConstraints:v];
    }
}

#pragma mark - UITableView Datasource && Delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _devicesArray.count;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return @"附近的蓝牙设备";
    }else {
        return nil;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50.0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellID = @"cellID";
    cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell)
    {
        cell = [[TableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellID];
    }
    NearbyPeripheralInfo *info = [_devicesArray objectAtIndex:indexPath.row];
    [cell setPeripheral:info];
    NSLog(@"%@,%s, line = %d",info.peripheral.name,__FUNCTION__, __LINE__);
    //cell.IsConnectLabel.text = @"未连接";
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (_centralManager.state == CBCentralManagerStateUnsupported) {//设备不支持蓝牙
        
    }else {//设备支持蓝牙连接
        if (_centralManager.state == CBCentralManagerStatePoweredOn) {//蓝牙开启状态
            //连接设备
            NearbyPeripheralInfo *info = [_devicesArray objectAtIndex:indexPath.row];
            [_centralManager connectPeripheral:info.peripheral options:@{CBConnectPeripheralOptionNotifyOnConnectionKey:@YES,CBConnectPeripheralOptionNotifyOnNotificationKey:@YES,CBConnectPeripheralOptionNotifyOnDisconnectionKey:@YES}];
        }
    }
}

#pragma mark - CBCentralManager Delegate
- (void)centralManagerDidUpdateState:(CBCentralManager *)central
{
    switch (central.state) {
        case CBCentralManagerStatePoweredOff:
            NSLog(@"CBCentralManagerStatePoweredOff");
            break;
        case CBCentralManagerStatePoweredOn:
            NSLog(@"CBCentralManagerStatePoweredOn");
            break;
        case CBCentralManagerStateResetting:
            NSLog(@"CBCentralManagerStateResetting");
            break;
        case CBCentralManagerStateUnauthorized:
            NSLog(@"CBCentralManagerStateUnauthorized");
            break;
        case CBCentralManagerStateUnknown:
            NSLog(@"CBCentralManagerStateUnknown");
            break;
        case CBCentralManagerStateUnsupported:
            NSLog(@"CBCentralManagerStateUnsupported");
            break;
            
        default:
            break;
    }
}
//发现蓝牙设备
- (void)centralManager:(CBCentralManager *)central didDiscoverPeripheral:(CBPeripheral *)peripheral advertisementData:(NSDictionary *)advertisementData RSSI:(NSNumber *)RSSI
{
    //    NSLog(@"\nperipheral is :\n%@\nadvertisementData is :\n%@\nRSSI is :%d",peripheral,advertisementData,[RSSI intValue]);
    
    BOOL isExist = NO;
    NearbyPeripheralInfo *info = [[NearbyPeripheralInfo alloc] init];
    info.peripheral = peripheral;
    info.advertisementData = advertisementData;
    info.RSSI = RSSI;
    
    if (_devicesArray.count == 0)
    {
        [_devicesArray addObject:info];
        NSIndexPath *path = [NSIndexPath indexPathForRow:0 inSection:0];
        [_tableView insertRowsAtIndexPaths:@[path] withRowAnimation:UITableViewRowAnimationFade];
    }else
    {
        for (int i = 0;i < _devicesArray.count;i++)
        {
            NearbyPeripheralInfo *originInfo = [_devicesArray objectAtIndex:i];
            CBPeripheral *per = originInfo.peripheral;
            if ([peripheral.identifier.UUIDString isEqualToString:per.identifier.UUIDString])
            {
                isExist = YES;
                [_devicesArray replaceObjectAtIndex:i withObject:info];
                [_tableView reloadData];
            }
        }
        if (!isExist) {
            [_devicesArray addObject:info];
            NSIndexPath *path = [NSIndexPath indexPathForRow:(_devicesArray.count - 1) inSection:0];
            [_tableView insertRowsAtIndexPaths:@[path] withRowAnimation:UITableViewRowAnimationFade];
        }
    }
}

//连接蓝牙设备成功
- (void)centralManager:(CBCentralManager *)central didConnectPeripheral:(CBPeripheral *)peripheral
{
    
    [self showTostInView:@"蓝牙设备已连接成功"];
    
    //cell.IsConnectLabel.text = @"已连接";
    
    NSLog(@"%s",__FUNCTION__);
    [self stopScan];
    
    _selectedPeripheral = peripheral;
    
//    PeripheralViewController *viewController = [[PeripheralViewController alloc] initWithNibName:nil bundle:nil];
//    viewController.currentPeripheral = _selectedPeripheral;
//    [self.navigationController pushViewController:viewController animated:YES];
}

- (void)stopScan
{
    if (_scanTimer && _scanTimer.valid) {
        [_scanTimer invalidate];
        _scanTimer = nil;
    }
    [_centralManager stopScan];
}

//连接蓝牙设备失败
- (void)centralManager:(CBCentralManager *)central didFailToConnectPeripheral:(CBPeripheral *)peripheral error:(NSError *)error
{
    [self showTostInView:@"蓝牙设备连接失败"];
    
    NSLog(@"%s",__FUNCTION__);
}

//断开连接
- (void)centralManager:(CBCentralManager *)central didDisconnectPeripheral:(CBPeripheral *)peripheral error:(NSError *)error
{
    [self showTostInView:@"蓝牙设备已断开连接"];
    //cell.IsConnectLabel.text = @"未连接";
    NSLog(@"%s",__FUNCTION__);
}

// 提示文字
- (void)showTostInView:(NSString *)tost
{
    [self.view makeToast:tost duration:1.5 position:@"center"];
}

// 断开连接
- (void)yf_dismissConentedWithPeripheral:(CBPeripheral *)peripheral
{
    [self showTostInView:@"已断开连接"];
    
    // 停止扫描
    [self.centralManager stopScan];
    // 断开连接
    [self.centralManager cancelPeripheralConnection:peripheral];
}

//设置可删除
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

//滑动删除
-(UITableViewCellEditingStyle) tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewCellEditingStyleDelete;
}

-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    //请求数据源提交的插入或删除指定行接收者。
    if (editingStyle ==UITableViewCellEditingStyleDelete) {//如果编辑样式为删除样式
        
        NSLog(@"%s, line = %d",__FUNCTION__, __LINE__);

        [self yf_dismissConentedWithPeripheral:self.selectedPeripheral];
    }
}

//修改左滑的按钮的字
-(NSString*)tableView:(UITableView*)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath*)indexpath
{
    return @"断开连接";
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
