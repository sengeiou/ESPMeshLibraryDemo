//
//  MainTableViewController.m
//  ESPMeshLibraryDemo
//
//  Created by zhaobing on 2018/6/20.
//  Copyright © 2018年 zhaobing. All rights reserved.
//

#import "MainTableViewController.h"
#import "ESPMeshManager.h"
#import "EspDeviceCommonViewController.h"


@interface MainTableViewController (){
    NSMutableDictionary* rootDic;
}

@end

@implementation MainTableViewController
- (IBAction)OTAClick:(id)sender {
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.rowHeight = 80;
    rootDic=[[NSMutableDictionary alloc] initWithCapacity:0];
    
}


- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [[ESPMeshManager share] starScanRootUDP:^(EspDevice *device) {
        
        NSMutableArray* tmpDeviceArr = [[ESPMeshManager share] getMeshInfoFromHost:device];
        
        for (int i=0; i<tmpDeviceArr.count; i++) {
            EspDevice* device=[tmpDeviceArr objectAtIndex:i];
            self->rootDic[device.mac]=device;
        }
    } failblock:^(int code) {
        
    }];
    [NSTimer scheduledTimerWithTimeInterval:3 repeats:true block:^(NSTimer * _Nonnull timer) {
        [self.tableView reloadData];
    }].fire;
}
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [[ESPMeshManager share] cancelScanRootUDP];
}
-(void)dealloc{
    [[ESPMeshManager share] cancelScanRootUDP];
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

    return rootDic.allKeys.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"cell"];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.detailTextLabel.numberOfLines=0;
    }
    EspDevice* device=[rootDic objectForKey:rootDic.allKeys[indexPath.row]];
    cell.textLabel.text = device.mac;
    
    cell.detailTextLabel.text = device.descriptionStr;
    
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [self performSegueWithIdentifier:@"ShowSelectedDevice" sender:indexPath];
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
    if ([segue.identifier isEqualToString:@"ShowSelectedDevice"]) {
        EspDeviceCommonViewController *deviceVC = segue.destinationViewController;
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        NSInteger selectedIndex = indexPath.row;
        
        EspDevice *device = [rootDic.allValues objectAtIndex:selectedIndex];
        deviceVC.device = device;
        deviceVC.title = device.name;
    }
}


@end
