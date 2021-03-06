//
//  ScanBLEViewController.m
//  ESPMeshLibraryDemo
//
//  Created by zhaobing on 2018/6/20.
//  Copyright © 2018年 zhaobing. All rights reserved.
//

#import "ScanBLEViewController.h"
#import "ESPMeshManager.h"
#import "PairResultViewController.h"
@interface ScanBLEViewController ()<UITableViewDelegate,UITableViewDataSource>

@end

@implementation ScanBLEViewController{
    NSMutableDictionary* deviceArr;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.delegate=self;
    self.tableView.dataSource=self;
    
    self.tableView.rowHeight = 80;
    deviceArr=[[NSMutableDictionary alloc] initWithCapacity:0];
    
    // app从后台进入前台都会调用这个方法
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationBecomeActive) name:UIApplicationWillEnterForegroundNotification object:nil];
    self.wifiName.text=ESPMeshManager.share.getCurrentWiFiSsid;
}
-(void)applicationBecomeActive{
    self.wifiName.text=ESPMeshManager.share.getCurrentWiFiSsid;
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.wifiName.text=ESPMeshManager.share.getCurrentWiFiSsid;
    [[ESPMeshManager share] starScanBLE:^(EspDevice *device) {
        self->deviceArr[device.uuidBle]=device;
    } failblock:^(int code) {
        
    }];
    [NSTimer scheduledTimerWithTimeInterval:3 repeats:true block:^(NSTimer * _Nonnull timer) {
        [self.tableView reloadData];
    }].fire;
}
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [[ESPMeshManager share] cancelScanBLE];
}
-(void)dealloc{
    [[ESPMeshManager share] cancelScanBLE];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return deviceArr.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"cell"];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.textLabel.numberOfLines=0;
    }
    EspDevice* device=[deviceArr objectForKey:deviceArr.allKeys[indexPath.row]];
    cell.textLabel.text = device.uuidBle;
    //信号和服务
    cell.detailTextLabel.text = device.descriptionStr;
    
    
    return cell;
}


/*
 // Override to support conditional editing of the table view.
 - (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
 // Return NO if you do not want the specified item to be editable.
 return YES;
 }
 */

/*
 // Override to support editing the table view.
 - (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
 if (editingStyle == UITableViewCellEditingStyleDelete) {
 // Delete the row from the data source
 [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
 } else if (editingStyle == UITableViewCellEditingStyleInsert) {
 // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
 }
 }
 */

/*
 // Override to support rearranging the table view.
 - (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
 }
 */

/*
 // Override to support conditional rearranging of the table view.
 - (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
 // Return NO if you do not want the item to be re-orderable.
 return YES;
 }
 */

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    //@"nextstep"
    if ([segue.identifier isEqualToString:@"nextstep"]) {
        PairResultViewController* vc=[segue destinationViewController];
        vc.ssid=_wifiName.text;
        vc.password=_password.text;
        vc.deviceDic=deviceArr;
    }
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    
    
}


@end

