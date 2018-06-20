//
//  ScanBLEViewController.h
//  ESPMeshLibraryDemo
//
//  Created by zhaobing on 2018/6/20.
//  Copyright © 2018年 zhaobing. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ScanBLEViewController : UIViewController

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UILabel *wifiName;
@property (weak, nonatomic) IBOutlet UITextField *password;

@end
