//
//  JishiChooseController.m
//  GITestDemo
//
//  Created by lcc on 15/9/11.
//  Copyright (c) 2015年 Kyson. All rights reserved.
//

#import "JishiChooseController.h"
#import "SwipingCardViewController.h"
#import "JishiCiTiaoViewController.h"

@interface JishiChooseController (){
    
    NSString *payType;
    BOOL _isConnectHistoryConnect;
}
@property (weak, nonatomic) IBOutlet UIButton *cipian;
@property (weak, nonatomic) IBOutlet UIButton *citiao;

@end

@implementation JishiChooseController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(connectSuccess) name:KconnectDeivesSuccess object:nil];
}

- (void)connectSuccess{
    
    
    if ([payType isEqualToString:@"芯片卡"]) {
        [self xinpian:nil];
    }
    
}

- (IBAction)xinpian:(id)sender {
    
    
    
    if (self.count.floatValue < 100 || self.count.floatValue > 50000) {
        
        [self showTipView:@"芯片卡消费区间为100~50000"];
        return;
    }
    
    payType = @"芯片卡";
    if(MiniPosSDKDeviceState()<0){
            //[self showTipView:@"设备未连接"];
        _isConnectHistoryConnect = NO;

        [self connectHistoryDevice];
        return;
    }else{
        
        [self verifyParamsSuccess:^{
            _quanjuQianDaoType = 0;
            if (MiniPosSDKGetCurrentSessionType()== SESSION_POS_UNKNOWN) {
                
                int amount  = [self.count doubleValue]*100;
                
                if (amount > 0) {
                    
                    char buf[20];
                    
                    sprintf(buf,"%012d",amount);
                    
                    NSLog(@"amount: %s",buf);
                    
                    
                    _type = 1;
                    
                    NSString *str = [NSString stringWithFormat:@"0\x1C"];

                    MiniPosSDKSaleTradeCMD(buf, NULL,str.UTF8String);
                    
                    
                    
                    UIStoryboard *mainStory = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
                    SwipingCardViewController *scvc = [mainStory instantiateViewControllerWithIdentifier:@"SC"];
                    [self.navigationController pushViewController:scvc animated:YES];
                    [scvc setValue:@"芯片卡" forKey:@"type"];
                    
                    
                    
                } else {
                    
                    [self showTipView:@"请确定交易金额！"];
                }
                
            }else{
                [self showTipView:@"设备繁忙，稍后再试"];
            }
            
        }];
        
        
        
    }

}
- (IBAction)citiao:(id)sender {
    
    _quanjuQianDaoType = 0;
    
    if (self.count.floatValue <100 || self.count.floatValue > 20000) {
        
        [self showTipView:@"磁条卡消费区间为100~20000"];
        return;
    }
    
    JishiCiTiaoViewController *jishicitiaoVc = [[JishiCiTiaoViewController alloc] init];
    jishicitiaoVc.count = self.count;
    [self.navigationController pushViewController:jishicitiaoVc animated:YES];
    
    
}

/**
 *  搜索上一次连接的设备
 */
- (void)connectHistoryDevice{
    
    NSMutableDictionary *userSNDict  =  [NSMutableDictionary dictionaryWithDictionary:[KUserDefault objectForKey:kUserSNDict]];
    NSString *phoneNo = [KUserDefault objectForKey:kLoginPhoneNo];
    NSString *HistoryDevName = [userSNDict objectForKey:phoneNo];
    if(HistoryDevName==nil) HistoryDevName =@"";
    
    if (searchDevices.count != 0) {
        for (CBPeripheral *per in searchDevices) {
            
            if ([HistoryDevName isEqualToString:per.name]) {
                
                [self showHUD:@"尝试连接历史设备"];
                //                [self showHUD:@"尝试连接历史设备" afterTime:8.0 failStr:@"连接历史设备失败，请主动连接设备"];
                
                
                [[BleManager sharedManager].imBT connect:per];
                
                
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(10.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    
                    if (MiniPosSDKDeviceState()<0) {
                        [self hideHUD];
                        [self showConnectionAlert];
                    }
                });
                
                return;
            }
        }
        _isConnectHistoryConnect = NO;
    }
    
    
    if (_isConnectHistoryConnect == NO) {
        [self showConnectionAlert];
        
        
        return;
    }
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)recvMiniPosSDKStatus
{
    [super recvMiniPosSDKStatus];
    
    if ([self.statusStr isEqualToString:[NSString stringWithFormat:@"签到成功"]]) {
        [self hideHUD];
        NSLog(@"LoginViewController ----签到成功");
        
        [self showTipView:self.statusStr];
    }
    
    
    if ([self.statusStr isEqualToString:[NSString stringWithFormat:@"签到失败"]]) {
        [self hideHUD];
        NSLog(@"LoginViewController ----签到失败");
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"签到失败！" message:self.displayString delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
        [alertView show];
        
    }
    
//    if ([self.statusStr isEqualToString:@"获取设备信息成功"] ) {
//        
//        
//        if (isFirstGetVersionInfo){
//            
//            pos_kernel = [NSString stringWithCString:MiniPosSDKGetCoreVersion() encoding:NSASCIIStringEncoding];
//            pos_task = [NSString stringWithCString:MiniPosSDKGetAppVersion() encoding:NSASCIIStringEncoding];
//            
//            NSString *message = [NSString stringWithFormat:@"pos_kernel:%@\npos_task:%@",pos_kernel,pos_task];
//            
//            
//            NSLog(@"message:%@",message);
//            
//            [self downloadWebVersionFile];
//            
//        }
//    }
    
    if([self.statusStr isEqualToString:@"设备已插入"]){
        NSLog(@"ConnectDevice:设备已经插入");
        _isConnect = YES;
        
        
//        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//            [self getPosParams];
//            
//        });
        [self hideHUD];
        [self showTipView:@"连接成功"];
        _isConnectHistoryConnect = YES;
        [self xinpian:nil];
        
        
    }
    
    if ([self.statusStr isEqualToString:@"设备已拔出"]) {
        
        _isConnect = NO;
    }
    
//    if ([self.statusStr isEqualToString:@"获取参数成功"]) {
//        
//        NSString *SnNo = [NSString stringWithCString:MiniPosSDKGetParam("SnNo") encoding:NSUTF8StringEncoding];
//        NSString *TerminalNo = [NSString stringWithCString:MiniPosSDKGetParam("TerminalNo") encoding:NSUTF8StringEncoding];
//        NSString *MerchantNo = [NSString stringWithCString:MiniPosSDKGetParam("MerchantNo") encoding:NSUTF8StringEncoding];
//        
//        [[NSUserDefaults standardUserDefaults] setObject:SnNo forKey:kMposG1SN];
//        [[NSUserDefaults standardUserDefaults] setObject:TerminalNo forKey:kMposG1TerminalNo];
//        [[NSUserDefaults standardUserDefaults] setObject:MerchantNo forKey:kMposG1MerchantNo];
//        
//        [[NSUserDefaults standardUserDefaults]synchronize];
//        
//        NSLog(@"SnNo:%@,TerminalNo:%@,MerchantNo:%@",[[NSUserDefaults standardUserDefaults]stringForKey:kMposG1SN],[[NSUserDefaults standardUserDefaults]stringForKey:kMposG1TerminalNo],[[NSUserDefaults standardUserDefaults]stringForKey:kMposG1MerchantNo]);
//        
//        [self hideHUD];
//        [self showTipView:@"连接成功"];
//        _isConnectHistoryConnect = YES;
//        [self xinpian:nil];
//        
//        if ([quanjubangding isEqualToString:@"1"]) {
//            [self verifyParamsSuccess:^{
//                //                NSLog(@"45444444444444444");
//                [self showTipView:@"签到成功"];
//            }];
//        }
//        
//        
//    }
    
    
    
    self.statusStr = @"";
    
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
