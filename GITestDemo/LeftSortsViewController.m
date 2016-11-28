//
//  LeftSortsViewController.m
//  LGDeckViewController
//
//  Created by jamie on 15/3/31.
//  Copyright (c) 2015年 Jamie-Ling. All rights reserved.
//

#import "LeftSortsViewController.h"
#import "AppDelegate.h"
#import "CommonViewController.h"
#import "LodingViewController.h"
#import "GatheringViewController.h"
#import "AFNetworking.h"
#import "JiLuViewController.h"

@interface LeftSortsViewController () <UITableViewDelegate,UITableViewDataSource,UIAlertViewDelegate>

@property (nonatomic, strong) LodingViewController *loding;

@end

@implementation LeftSortsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    UIImageView *imageview = [[UIImageView alloc] initWithFrame:self.view.bounds];
    imageview.image = [UIImage imageNamed:@"leftbackiamge"];
    [self.view addSubview:imageview];

    UITableView *tableview = [[UITableView alloc] init];
    self.tableview = tableview;
    tableview.frame = self.view.bounds;
    tableview.dataSource = self;
    tableview.delegate  = self;
    tableview.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:tableview];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 5;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *Identifier = @"Identifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:Identifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:Identifier];
    }
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.textLabel.font = [UIFont systemFontOfSize:20.0f];
    cell.backgroundColor = [UIColor clearColor];
    cell.textLabel.textColor = [UIColor whiteColor];
    
    if (indexPath.row == 0) {
        cell.textLabel.text = @"支付界面";
        UIImage *icon = [UIImage imageNamed:@"功能"];
        CGSize itemSize = CGSizeMake(36, 36);
        UIGraphicsBeginImageContextWithOptions(itemSize, NO ,0.0);
        CGRect imageRect = CGRectMake(0.0, 0.0, itemSize.width, itemSize.height);
        [icon drawInRect:imageRect];
        
        cell.imageView.image = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        
    } else if (indexPath.row == 1) {
        cell.textLabel.text = @"交易记录";
        
        UIImage *icon = [UIImage imageNamed:@"邮件"];
        CGSize itemSize = CGSizeMake(36, 36);
        UIGraphicsBeginImageContextWithOptions(itemSize, NO ,0.0);
        CGRect imageRect = CGRectMake(0.0, 0.0, itemSize.width, itemSize.height);
        [icon drawInRect:imageRect];
        
        cell.imageView.image = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
    } else if (indexPath.row == 2) {
        cell.textLabel.text = @"通用";
        UIImage *icon = [UIImage imageNamed:@"通用"];
        CGSize itemSize = CGSizeMake(36, 36);
        UIGraphicsBeginImageContextWithOptions(itemSize, NO ,0.0);
        CGRect imageRect = CGRectMake(0.0, 0.0, itemSize.width, itemSize.height);
        [icon drawInRect:imageRect];
        
        cell.imageView.image = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
    } else if (indexPath.row == 3) {
        cell.textLabel.text = @"安全退出";
        UIImage *icon = [UIImage imageNamed:@"退出"];
        CGSize itemSize = CGSizeMake(36, 36);
        UIGraphicsBeginImageContextWithOptions(itemSize, NO ,0.0);
        CGRect imageRect = CGRectMake(0.0, 0.0, itemSize.width, itemSize.height);
        [icon drawInRect:imageRect];
        
        cell.imageView.image = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
    } else if (indexPath.row == 4) {
        cell.textLabel.text = @"绑定设备";
        UIImage *icon = [UIImage imageNamed:@"Locked"];
        CGSize itemSize = CGSizeMake(36, 36);
        UIGraphicsBeginImageContextWithOptions(itemSize, NO ,0.0);
        CGRect imageRect = CGRectMake(0.0, 0.0, itemSize.width, itemSize.height);
        [icon drawInRect:imageRect];
        
        cell.imageView.image = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    AppDelegate *tempAppDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    
    //[tempAppDelegate.mainNavigationController pushViewController:vc animated:NO];
    
    //otherViewController *vc = [[otherViewController alloc] init];
   // tempAppDelegate.i
    
    quanjubangding = @"0";
    
    switch (indexPath.row) {
        case 0://功能
        {
        
            UIViewController *vc = [tempAppDelegate.LeftSlideVC.presentingViewController.storyboard
                                    instantiateViewControllerWithIdentifier:@"MainVC"];
            [tempAppDelegate.LeftSlideVC replaceMainView:vc];
            
            [[NSNotificationCenter defaultCenter] removeObserver:self name:KconnectDeivesSuccess object:nil];
            break;
        }
//  
//        case 1:{ //客服电话
//            {
//                UIViewController *vc = [tempAppDelegate.LeftSlideVC.presentingViewController.storyboard
//                                        instantiateViewControllerWithIdentifier:@"JYJL"];
//                [tempAppDelegate.LeftSlideVC replaceMainView:vc];
//                
//                [[NSNotificationCenter defaultCenter] removeObserver:self name:KconnectDeivesSuccess object:nil];
//                break;
//            }
//        }
 
            break;
        case 1:{//交易记录
            {
                
                JiLuViewController *jiluVc = [[JiLuViewController alloc] init];
                UINavigationController *navVc = [[UINavigationController alloc] initWithRootViewController:jiluVc];
                [tempAppDelegate.LeftSlideVC replaceMainView:navVc];
                
                [[NSNotificationCenter defaultCenter] removeObserver:self name:KconnectDeivesSuccess object:nil];
                break;
            }
        }
            
            break;
        case 2://通用
        {
            UIViewController *vc = [tempAppDelegate.LeftSlideVC.presentingViewController.storyboard
                                     instantiateViewControllerWithIdentifier:@"TY"];
            UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:vc];
            [tempAppDelegate.LeftSlideVC replaceMainView:nav];
            
            [[NSNotificationCenter defaultCenter] removeObserver:self name:KconnectDeivesSuccess object:nil];
            break;
        }
        case 3: //退出
        {
//        MiniPosSDK *sdk;
//        MiniPosSDKDestroy(sdk);
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"是否确认退出" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        [alertView show];
        
        
        
            //            [KVNProgress showWithStatus:@"感谢您的使用"];
            //
            //            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            //                [KVNProgress dismiss];
            //            });
        
            //            [self showProgressWithStatus:@"感谢您的使用"];
            //
            //
            //            [self hideProgressAfterDelaysInSeconds:3.0];
        
        
        
            [[NSNotificationCenter defaultCenter] removeObserver:self name:KconnectDeivesSuccess object:nil];
        
        }
            
            break;
            
        case 4://绑定新设备
        
//            if(MiniPosSDKDeviceState()<0){
//                //为连接设备
//                    //[self showTipView:@"设备未连接"];
////                GatheringViewController *vc = [tempAppDelegate.LeftSlideVC.presentingViewController.storyboard
////                                        instantiateViewControllerWithIdentifier:@"MainVC"];
////                vc.XinZeng = @"11";
////                [vc setXinZeng:@"11"];
//                
////                [tempAppDelegate.LeftSlideVC replaceMainView:vc];
//                [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(newDeviceAppend) name:KconnectDeivesSuccess object:nil];
//                
//                UIViewController *connectVc = [tempAppDelegate.LeftSlideVC.presentingViewController.storyboard
//                                        instantiateViewControllerWithIdentifier:@"CD"];
//                UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:connectVc];
//                quanjubangding = @"1";
//                [tempAppDelegate.LeftSlideVC replaceMainView:nav];
//                return;
//            }else{
//                //设备连接
//                
//                
//                [self newDeviceAppend];
//            }
        {
            
            //[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(newDeviceAppend) name:KconnectDeivesSuccess object:nil];
            
            UIViewController *connectVc = [tempAppDelegate.LeftSlideVC.presentingViewController.storyboard
                                           instantiateViewControllerWithIdentifier:@"CD"];
            UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:connectVc];
            connectVc.navigationItem.title  = @"绑定新设备";
            quanjubangding = @"1";
            [tempAppDelegate.LeftSlideVC replaceMainView:nav];
            return;
        }
            
        break;
        
            
//        case 4://通用
//
//            if(MiniPosSDKDeviceState()<0){
//                    //[self showTipView:@"设备未连接"];
//                [self showConnectionAlert];
//                return;
//            }
//            
//            NSString *sn = [[NSUserDefaults standardUserDefaults] stringForKey:kMposG1SN];
//            NSString *merchantNo  = [[NSUserDefaults standardUserDefaults] stringForKey:kMposG1MerchantNo];
//            NSString *terminalNo  = [[NSUserDefaults standardUserDefaults]stringForKey:kMposG1TerminalNo];
//            NSString *phoneNo = [[NSUserDefaults standardUserDefaults] stringForKey:kLoginPhoneNo];
//
//            
//            
//            break;
            
            
        default:
            break;
    }
    
    [tempAppDelegate.LeftSlideVC closeLeftView];//关闭左侧抽屉
}




- (void)dismissLodingView{
    [_loding dismissViewControllerAnimated:YES completion:nil];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 180;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.tableview.bounds.size.width, 180)];
    view.backgroundColor = [UIColor clearColor];
    return view;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 60;
}

#pragma mark -  alertView的代理方法

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    if (buttonIndex == 1) {
        
        AppDelegate *tempAppDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
        [tempAppDelegate.LeftSlideVC dismissViewControllerAnimated:YES completion:nil];
        LodingViewController *loding = [[LodingViewController alloc] init];
        [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:loding animated:YES completion:nil];
        loding.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
        _loding = loding;
        [self performSelector:@selector(dismissLodingView) withObject:nil afterDelay:3.0];
        
        [[BleManager sharedManager].imBT disconnectPeripheral:[BleManager sharedManager].imBT.peripheral];
    }
}

#pragma mark - 新设备绑定

- (void)newDeviceAppend{
    
    NSString *sn = [KUserDefault objectForKey:kMposG1SN];
    NSString *loginPhone = [KUserDefault objectForKey:kLoginPhoneNo];
    NSString *mima = [KUserDefault objectForKey:KPassword];
    
    NSString *urlStr = [NSString stringWithFormat:@"http://%@:%@/MposApp/bindMpos.action?sn=%@&user=%@&passwd=%@&flag=0800464",kServerIP,kServerPort,sn,loginPhone,mima];
    NSLog(@"urlStr:%@",urlStr);
    AFHTTPRequestOperationManager *mgr = [AFHTTPRequestOperationManager manager];
    [mgr GET:urlStr parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
//        NSLog(@"##########%@",responseObject);
//        NSString *msg = [responseObject objectForKey:@"msg"];
//        [self showTipView:msg];
        NSLog(@"%@",responseObject);
        NSDictionary *dict = [responseObject objectForKey:@"resultMap"];
        if ([dict objectForKey:@"7"]) {
            
            [self showHUD:@"正在写入参数"];

            NSString *mainKey  = [dict objectForKey:@"tmk"];
            NSString *tid = [dict objectForKey:@"tid"];
            NSString *mid = [dict objectForKey:@"mid"];
            NSLog(@"mainKey:%@",mainKey);
            
            NSDictionary *dictionary = @{@"商户号":mid,@"终端号":tid,@"主密钥1":mainKey};
            __weak LeftSortsViewController *weakSelf = self;
            [self setPosWithParams:dictionary success:^{
                if(MiniPosSDKPosLogin()>=0)
                {
                    [weakSelf showHUD:@"正在签到"];
                }
            }];
            
        }else{
            
//            [self showTipView:[dict objectForKey:@"msg"]];
            [self showAlertViewWithMessage:[dict objectForKey:@"msg"]];
            if([[dict objectForKey:@"msg"] isEqualToString:@"新设备绑定失败，该MPOS机身码已提交注册或已绑定商户"]){
                [self showAlertViewWithMessage:@"新设备绑定失败，该MPOS已绑定其他商户，请重新选择"];
            }
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//        [self showTipView:@"绑定新设备失败"];
        [self showAlertViewWithMessage:@"绑定新设备失败"];
    }];
}

- (void)showAlertViewWithMessage:(NSString *)str{
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:str delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
    [alert show];
}
@end
