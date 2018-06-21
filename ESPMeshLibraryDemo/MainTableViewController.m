//
//  MainTableViewController.m
//  ESPMeshLibraryDemo
//
//  Created by zhaobing on 2018/6/20.
//  Copyright © 2018年 zhaobing. All rights reserved.
//

#import "MainTableViewController.h"
#import "ESPMeshManager.h"

@interface MainTableViewController (){
    NSMutableDictionary* rootDic;
}

@end

@implementation MainTableViewController
- (IBAction)OTAClick:(id)sender {
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.rowHeight = 40;
    rootDic=[[NSMutableDictionary alloc] initWithCapacity:0];
    [[ESPMeshManager share] starScanRootUDP:^(NSString *mac, NSString *host, NSString *port, NSString *type) {
        self->rootDic[mac]=@{@"mac":mac,@"host":host,@"port":port,@"type":type};
        id tmp=[[ESPMeshManager share] getMeshInfoFromHost:host protocol:type port:port Parameters:nil];
        NSLog(@"%@", tmp);
    } failblock:^(int code) {
        
    }];
    [NSTimer scheduledTimerWithTimeInterval:3 repeats:true block:^(NSTimer * _Nonnull timer) {
        [self.tableView reloadData];
    }].fire;
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
        cell.textLabel.numberOfLines=0;
    }
    NSDictionary* item=[rootDic objectForKey:rootDic.allKeys[indexPath.row]];
    cell.textLabel.text = item[@"mac"];
    //信号和服务
    cell.detailTextLabel.text = [NSString stringWithFormat:@"host:%@,port:%@,type:%@",item[@"host"],item[@"port"],item[@"type"]];
    
    
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
