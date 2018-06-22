//
//  PairResultViewController.m
//  ESPMeshLibraryDemo
//
//  Created by zhaobing on 2018/6/20.
//  Copyright © 2018年 zhaobing. All rights reserved.
//

#import "PairResultViewController.h"
#import "ESPMeshManager.h"
#import "ESPBLEIO.h"
@interface PairResultViewController ()
@property (weak, nonatomic) IBOutlet UITextView *logTF;

@end

@implementation PairResultViewController
- (IBAction)okClick:(id)sender {
    EspDevice* device=_deviceDic.allValues[0];
    [[ESPBLEIO alloc] init:device.uuidBle ssid:_ssid password:_password statusBlock:^(int status) {
        
    } sensorBlock:^(NSData *data) {
        
    }];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
