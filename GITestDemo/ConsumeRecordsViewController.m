//
//  ConsumeRecordsViewController.m
//  GITestDemo
//
//  Created by 吴狄 on 15/6/30.
//  Copyright (c) 2015年 Kyson. All rights reserved.
//

#import "ConsumeRecordsViewController.h"
#import "AppDelegate.h"
#import "AFNetworking.h"
#import "Jiaoyijilu.h"
#import "MJExtension.h"
#import "JiaoyijiluCell.h"
#import "MiniPosSDK.h"
#import "ConnectDeviceViewController.h"

@interface ConsumeRecordsViewController ()<UITableViewDelegate,UITableViewDataSource,UIAlertViewDelegate>


@end

@implementation ConsumeRecordsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    

}
- (IBAction)bodakefudianhua:(id)sender {
    
        NSString *number = @"4008226228";
        
        NSString *num = [[NSString alloc] initWithFormat:@"telprompt://%@",number];
        
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:num]]; //拨号
        
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)back:(UIBarButtonItem *)sender {
    
    
    [self.navigationController popViewControllerAnimated:YES];
}
- (IBAction)backTo:(UIButton *)sender {
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)openOrCloseLeftList:(id)sender
{
    AppDelegate *tempAppDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    if (tempAppDelegate.LeftSlideVC.closed)
    {
        [tempAppDelegate.LeftSlideVC openLeftView];
    }
    else
    {
        [tempAppDelegate.LeftSlideVC closeLeftView];
    }
    
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
