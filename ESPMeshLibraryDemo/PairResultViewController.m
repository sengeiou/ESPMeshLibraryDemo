//
//  PairResultViewController.m
//  ESPMeshLibraryDemo
//
//  Created by zhaobing on 2018/6/20.
//  Copyright © 2018年 zhaobing. All rights reserved.
//

#import "PairResultViewController.h"
#import "ESPMeshManager.h"

@interface PairResultViewController ()
@property (weak, nonatomic) IBOutlet UITextView *logTF;

@end

@implementation PairResultViewController
- (IBAction)okClick:(id)sender {
    self.logTF.text=@"";
    if (_deviceDic.count>0) {
        EspDevice* device=_deviceDic.allValues[0];
        [[ESPMeshManager share] starBLEPair:device ssid:_ssid password:_password callBackBlock:^(NSString *msg) {
            dispatch_async(dispatch_get_main_queue(), ^(){
                self.logTF.text=[NSString stringWithFormat:@"%@\n%@",msg,self.logTF.text];
                if ([msg isEqualToString:@"success pair"]) {
                    [self.navigationController popToRootViewControllerAnimated:true];
                }
            });
        }];
    }
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    if (_deviceDic.count>0) {
        EspDevice* device=_deviceDic.allValues[0];
        [[ESPMeshManager share] starBLEPair:device ssid:_ssid password:_password callBackBlock:^(NSString *msg) {
            dispatch_async(dispatch_get_main_queue(), ^(){
                self.logTF.text=[NSString stringWithFormat:@"%@\n%@",msg,self.logTF.text];
                if ([msg isEqualToString:@"success pair"]) {
                    [self.navigationController popToRootViewControllerAnimated:true];
                }
            });
        }];
    }
    
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
