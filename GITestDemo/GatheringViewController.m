//
//  GatheringViewController.m
//  GITestDemo
//
//  Created by 吴狄 on 15/6/27.
//  Copyright (c) 2015年 Kyson. All rights reserved.
//

#import "GatheringViewController.h"
#import "WDCalculator.h"
#import "SwipingCardViewController.h"
#import "AFNetworking.h"
#import "CustomAlertView.h"
#import "ConnectDeviceViewController.h"
#import "AppDelegate.h"
#import "JishiChooseController.h"


@interface GatheringViewController ()<WDCalculatorDelegate>
{
    NSString *web_kernel;
    NSString *web_task;
    NSString *pos_kernel;
    NSString *pos_task;
    NSMutableArray *updateFiles;
    CustomAlertView *cav;
    
    BOOL isFirstGetVersionInfo;
    BOOL isGetDeviceMsgAction;
    NSString *payType;
    
    //判断是否在历史设备里已经连接了设备
    BOOL _isConnectHistoryConnect;
}

@property (nonatomic, strong) JishiChooseController *jishiVC;
@property (nonatomic, strong) MBProgressHUD *myHUD;



@end

@implementation GatheringViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.num.text =@"￥ 0.00";
    self.totalNum.text = @"0.00";
    
    isFirstGetVersionInfo = true;
    [self setUpNavgationLeftBtn];
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(connectSuccess) name:KconnectDeivesSuccess object:nil];
    
    
}

- (void)connectSuccess{
    
    
    
    if (isFirstGetVersionInfo) {
//        MiniPosSDKInit();
//        MiniPosSDKGetDeviceInfoCMD();
        //isFirstGetVersionInfo = false;
        [self viewWillAppear:YES];
        
    }else{
        
        if ([payType isEqualToString:@"常规消费"]) {
            [self normalConsume:nil];
        }
    }
    
    
}

- (void)setUpNavgationLeftBtn{
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setImage:[UIImage imageNamed:@"更多"] forState:UIControlStateNormal];
    [btn sizeToFit];
    [btn addTarget:self action:@selector(openOrCloseLeftList:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:btn];
    self.navigationItem.leftBarButtonItem = item;
}

- (void)openOrCloseLeftList:(id)sender
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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewDidAppear:(BOOL)animated{
    
    [super viewDidAppear:animated];
    
    
    
    WDCalculator *calculator = [[WDCalculator alloc]initWithFrame:self.calculatorView.frame];
    calculator.delegate = self;
    [self.view addSubview:calculator];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.tabBarController.navigationItem.title = @"支付页面";
    
    MiniPosSDKInit();
    
    if (isFirstGetVersionInfo) {
        MiniPosSDKGetDeviceInfoCMD();
        //isFirstGetVersionInfo = false;
    }
}

- (void)getDeviceInfo{
    
    if (isFirstGetVersionInfo) {
        
        NSString *task = [KUserDefault objectForKey:Kpos_task];
        
        NSString *kernel = [KUserDefault objectForKey:Kpos_kernel];
//        if (task.length == 0 || kernel.length == 0) {
//            MiniPosSDKGetDeviceInfoCMD();
//        }else{
//            
//            pos_task = task;
//            pos_kernel = kernel;
//            [self downloadWebVersionFile];
//        }
        
    }
}

//从服务器下载版本文件
- (void)downloadWebVersionFile{
    
//    if(isFirstGetVersionInfo==false){
//        [self showHUD:@"正在从服务器获取版本信息"];
//    }
    
    // 1       http://120.24.213.123/app/magtest/
    NSString *baseURLString = @"http://120.24.213.123/app/version.json";
//    NSString *baseURLString = @"http://120.24.213.123/app/magtest/version.json";
    NSURL *url = [NSURL URLWithString:baseURLString];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    
    // 2
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    
    //operation.responseSerializer = [AFJSONResponseSerializer serializer];
    
    NSString *str = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/version.json"];
    
    operation.inputStream = [NSInputStream inputStreamWithURL:url];
    operation.outputStream = [NSOutputStream outputStreamToFileAtPath:str append:NO];
    
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        [self hideHUD];
        
        
        NSDictionary *dictionary = [NSJSONSerialization JSONObjectWithData:[[NSData alloc]initWithContentsOfFile:str] options:kNilOptions error:NULL];
        
        NSLog(@"%@",dictionary);
        
        NSDictionary *g1 = dictionary[@"G1"];
        
        web_kernel = g1[@"kernel"];
        web_task = g1[@"task"];
        
        NSString *message = [NSString stringWithFormat:@"web_kernel:%@\nweb_task:%@",web_kernel,web_task];
        
        NSLog(@"message:%@",message);
        
        
        //成功就获取本地版本号
        [self getPosVersionInfo];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"failure");
        [self hideHUD];
        [self showTipView:@"获取失败,请检查网络"];
        
    }];
    
    // 5
    [operation start];
    
    
}

//从POS机获取版本信息
- (void)getPosVersionInfo{
    
    if(pos_kernel && pos_task){
        [self compareVersionInfo];
    }
}

//比较版本信息
- (void)compareVersionInfo{
    
    updateFiles = [[NSMutableArray alloc]init];
    
    
    if ([pos_kernel compare:web_kernel options:NSNumericSearch] == NSOrderedAscending) {
        [updateFiles addObject:@"kernel"];
    }
    
    if ([pos_task compare:web_task options:NSNumericSearch] == NSOrderedAscending)
    {
        [updateFiles addObject:@"task"];
    }
    
    
    if([updateFiles count]>0){
        
        NSString *info = [NSString stringWithFormat:@"有%lu个文件需要更新，预计耗时%lu分钟",(unsigned long)[updateFiles count],[updateFiles count]*5];
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NULL message:info delegate:self cancelButtonTitle:@"确定更新" otherButtonTitles:nil, nil];
        
        [alert show];
        
        
//    }else if(isFirstGetVersionInfo==false){
        }else{
        
//        NSString *info = [NSString stringWithFormat:@"您的软件是最新版本"];
//        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NULL message:info delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
//        
//        [alert show];
        
        if ([payType isEqualToString:@"常规消费"]) {
            [self normalConsume:nil];
        }
    }
    
    isFirstGetVersionInfo = false;
    
    
}

//
- (void)downloadFromWebAndTransmitToPos{
    
    
    
    if ([updateFiles count]>0) {
        
        cav = [[CustomAlertView alloc]init];
        
        //[self.view addSubview:cav];
        [cav show];
        
        [self download:updateFiles[0] CompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
            //NSLog(@"download %@ success",updateFiles[0]);
            if ([updateFiles count] >1) {
                [self download:updateFiles[1] CompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
                    
                    MiniPosSDKDownPro();
                    
                    [ [ UIApplication sharedApplication] setIdleTimerDisabled:YES ] ;
                    
                    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
                        DownThread((__bridge void*)cav,updateFiles);
                        
                        [ [ UIApplication sharedApplication] setIdleTimerDisabled:NO ] ;
                        
                        
                        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                            [cav dismiss];
                        });
                        
                    });
                    
                    
                    
                }];
            }else{
                
                MiniPosSDKDownPro();
                
                [ [ UIApplication sharedApplication] setIdleTimerDisabled:YES ] ;
                
                dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
                    DownThread((__bridge void*)cav,updateFiles);
                    
                    [ [ UIApplication sharedApplication] setIdleTimerDisabled:NO ] ;
                    
                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                        [cav dismiss];
                    });
                    
                });
                
                
            }
            
        }];
    }else{
        
        //[self showTipView:@"您的软件是最新版本"];
    }
    
}

- (void)download:(NSString *)fileName CompletionBlockWithSuccess:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success{
    
    if (fileName ==nil) {
        return;
    }
    
    NSString *baseURLString = [NSString stringWithFormat:@"http://120.24.213.123/app/%@",fileName];
//    NSString *baseURLString = [NSString stringWithFormat:@"http://120.24.213.123/app/magtest/%@",fileName];
    NSURL *baseURL = [NSURL URLWithString:baseURLString];
    
    NSURLRequest *request = [NSURLRequest requestWithURL:baseURL cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:10];
    
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc]initWithRequest:request];
    
    NSString *str = [NSHomeDirectory() stringByAppendingPathComponent:[NSString stringWithFormat:@"Documents/%@",fileName]];
    NSLog(@"%@",baseURLString);
    NSLog(@"%@",str);
    
    operation.inputStream = [NSInputStream inputStreamWithURL:baseURL];
    operation.outputStream = [NSOutputStream outputStreamToFileAtPath:str append:NO];
    
    
    
    [operation setDownloadProgressBlock:^(NSUInteger bytesRead, long long totalBytesRead, long long totalBytesExpectedToRead) {
        NSLog(@"%@ is download：%f",fileName, (float)totalBytesRead/totalBytesExpectedToRead);
        //self.progressView set
        float progress = (float)totalBytesRead/totalBytesExpectedToRead;
        
        
        [cav updateProgress:progress];
        [cav updateTitle:[NSString stringWithFormat:@"正在下载%@",fileName]];
        
        
    }];
    
    //NSString *filePath = [NSString alloc]in
    
    [operation setCompletionBlockWithSuccess:success failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"failure");
    }];
    
    [operation start];
    
    
    NSLog(@"download,%@",fileName);
    
    
}

#pragma mark - UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView
clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    //[super alertView:alertView clickedButtonAtIndex:buttonIndex];
    NSLog(@"Hooooooooooooooom");
    
    if (alertView.tag == 44) {
        if (buttonIndex == 0) {
            ConnectDeviceViewController *cdvc = [self.storyboard instantiateViewControllerWithIdentifier:@"CD"];
            [self.navigationController pushViewController:cdvc animated:YES];
            //[self presentViewController:cdvc animated:YES completion:nil];
        }
    }else{
        if (buttonIndex ==0) {
            [self downloadFromWebAndTransmitToPos ];
        }
    }
    
}

//常规消费
- (IBAction)normalConsume:(UIButton *)sender {
   
    if (self.totalNum.text.floatValue < 1 || self.totalNum.text.floatValue > 50000) {
        [self showTipView:@"常规消费区间是1~50000"];
        return;
    }
    payType = @"常规消费";
   
    
    if(MiniPosSDKDeviceState()<0){
        //[self showTipView:@"设备未连接"];
        
        _isConnectHistoryConnect = NO;
    
        [self connectHistoryDevice];
        

    }else{
         _quanjuQianDaoType = 0;
        [self verifyParamsSuccess:^{
            
            if (MiniPosSDKGetCurrentSessionType()== SESSION_POS_UNKNOWN) {
                
                int amount  = [self.totalNum.text doubleValue]*100;
                
                if (amount > 0) {
                    
                    char buf[20];
                    
                    sprintf(buf,"%012d",amount);
                    
                    NSLog(@"amount: %s",buf);
                    
                    
                    _type = 1;
                    MiniPosSDKSaleTradeCMD(buf, NULL,"1");
                    
                    self.num.text =@"￥ 0.00";
                    self.totalNum.text = @"0.00";
                    
                    SwipingCardViewController *scvc = [self.storyboard instantiateViewControllerWithIdentifier:@"SC"];
                    [self.navigationController pushViewController:scvc animated:YES];
                    [scvc setValue:@"请插卡或刷卡消费" forKey:@"type"];
                    
                    
                } else {
                    
                    [self showTipView:@"请确定交易金额！"];
                    
                    
                }
                
            }else{
                [self showTipView:@"设备繁忙，稍后再试"];
            }
            
        }];
        
        
        
    }
}

//即时收款
- (IBAction)immediatelyConsume:(UIButton *)sender {
    
        //return;
    
    if (self.totalNum.text.floatValue < 100) {
        [self showTipView:@"即时消费不能小于100"];
        return;
    }
    
    JishiChooseController *jishiVC = [[JishiChooseController alloc] init];
    self.jishiVC = jishiVC;
    jishiVC.count = self.totalNum.text;
    
    [self.navigationController pushViewController:jishiVC animated:YES];
    
    self.num.text =@"￥ 0.00";
    self.totalNum.text = @"0.00";
}


/**
 *  搜索上一次连接的设备
 */
- (void)connectHistoryDevice{
    
    NSMutableDictionary *userSNDict  =  [NSMutableDictionary dictionaryWithDictionary:[KUserDefault objectForKey:kUserSNDict]];
    NSString *phoneNo = [KUserDefault objectForKey:kLoginPhoneNo];
    NSString *HistoryDevName = [userSNDict objectForKey:phoneNo];
    if(HistoryDevName==nil) HistoryDevName =@"";
    //NSString *HistoryDevName = [KUserDefault objectForKey:kLastConnectedDevice];
    //NSDictionary *dic  = [NSd]
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
//            [KUserDefault setObject:pos_kernel forKey:Kpos_kernel];
//            [KUserDefault setObject:pos_task forKey:Kpos_task];
//            [KUserDefault synchronize];
//            
//            NSLog(@"message:%@",message);
//            
//            [self downloadWebVersionFile];
//            
//        }
//    }
    
    if ([self.statusStr isEqualToString:@"获取设备信息成功"] ) {
        
        
        if (isFirstGetVersionInfo){
            
            pos_kernel = [NSString stringWithCString:MiniPosSDKGetCoreVersion() encoding:NSASCIIStringEncoding];
            pos_task = [NSString stringWithCString:MiniPosSDKGetAppVersion() encoding:NSASCIIStringEncoding];
            
            NSString *message = [NSString stringWithFormat:@"pos_kernel:%@\npos_task:%@",pos_kernel,pos_task];
            
            
            NSLog(@"message:%@",message);
            
            [self downloadWebVersionFile];
            
        }
    }
    
    
    if([self.statusStr isEqualToString:@"设备已插入"]){
        NSLog(@"ConnectDevice:设备已经插入");
        _isConnect = YES;
        
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self getPosParams];
            
        });
        
        
    }
    
    if ([self.statusStr isEqualToString:@"设备已拔出"]) {

        _isConnect = NO;
    }
    
    if ([self.statusStr isEqualToString:@"获取参数成功"]) {
        
        NSString *SnNo = [NSString stringWithCString:MiniPosSDKGetParam("SnNo") encoding:NSUTF8StringEncoding];
        NSString *TerminalNo = [NSString stringWithCString:MiniPosSDKGetParam("TerminalNo") encoding:NSUTF8StringEncoding];
        NSString *MerchantNo = [NSString stringWithCString:MiniPosSDKGetParam("MerchantNo") encoding:NSUTF8StringEncoding];
        
        [[NSUserDefaults standardUserDefaults] setObject:SnNo forKey:kMposG1SN];
        [[NSUserDefaults standardUserDefaults] setObject:TerminalNo forKey:kMposG1TerminalNo];
        [[NSUserDefaults standardUserDefaults] setObject:MerchantNo forKey:kMposG1MerchantNo];
        
        [[NSUserDefaults standardUserDefaults]synchronize];
        
        NSLog(@"SnNo:%@,TerminalNo:%@,MerchantNo:%@",[[NSUserDefaults standardUserDefaults]stringForKey:kMposG1SN],[[NSUserDefaults standardUserDefaults]stringForKey:kMposG1TerminalNo],[[NSUserDefaults standardUserDefaults]stringForKey:kMposG1MerchantNo]);
        
        [self hideHUD];
        [self showTipView:@"连接成功"];
        _isConnectHistoryConnect = YES;
        
        if (isFirstGetVersionInfo) {

            [self performSelector:@selector(viewWillAppear:) withObject:nil afterDelay:1];
            //isFirstGetVersionInfo = false;
        }else{
            
            [self normalConsume:nil];
        }
        
        
//        [self getDeviceInfo];
        
        
        if ([quanjubangding isEqualToString:@"1"]) {
            [self verifyParamsSuccess:^{
                //                NSLog(@"45444444444444444");
                [self showTipView:@"签到成功"];
            }];
        }
        
        
    }
    

    
    self.statusStr = @"";
    
}


-(void)getPosParams{
    
    NSLog(@"didConnectDevice");
    
    char paramname[100];
    
    memset(paramname, 0x00, sizeof(paramname));
    strcat(paramname, "TerminalNo");
    strcat(paramname, "\x1C");
    strcat(paramname, "MerchantNo");
    strcat(paramname, "\x1C");
    strcat(paramname, "SnNo");
    
    MiniPosSDKGetParams("88888888", paramname);
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
#pragma mark - WDCalculatorDelegate
-(void)WDCalculatorDidClick:(WDCalculator *)WDCalculator{
    self.num.text  = [NSString stringWithFormat:@"￥ %.2f",WDCalculator.num];
    self.totalNum.text = [NSString stringWithFormat:@"%.2f",WDCalculator.totalNum];;
}

//- (void)setXinZeng:(NSString *)XinZeng{
//    
//    _XinZeng = XinZeng;
//    AppDelegate *tempAppDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
//    UIViewController *connectVc = [tempAppDelegate.LeftSlideVC.presentingViewController.storyboard
//                                   instantiateViewControllerWithIdentifier:@"CD"];
////    [vc.navigationController pushViewController:connectVc animated:YES];
//    [self.navigationController pushViewController:connectVc animated:YES];
//}
@end
