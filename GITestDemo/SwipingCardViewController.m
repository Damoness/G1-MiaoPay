//
//  SwipingCardViewController.m
//  GITestDemo
//
//  Created by Femto03 on 14/11/26.
//  Copyright (c) 2014年 Kyson. All rights reserved.
//

#import "SwipingCardViewController.h"
#import "PrintNoteViewController.h"


@interface SwipingCardViewController ()<UIAlertViewDelegate>
{
    NSString *sendValue;
}
@end

@implementation SwipingCardViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = self.type;
    
 
    
    NSData *gif;
    if ([self.type isEqualToString:@"芯片卡"]) {
        gif = [NSData dataWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"芯片卡" ofType:@"gif"]];
    }else{
        
        gif = [NSData dataWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"秒到磁条卡" ofType:@"gif"]];
        
    }
    
    
//    sendValue = @"消费交易";
//    [self performSelector:@selector(pushToPrint) withObject:nil afterDelay:1.0];
    
    //NSData *gif = [NSData dataWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"秒到刷卡页面" ofType:@"gif"]];
    
    self.webView.userInteractionEnabled = NO;//用户不可交互
    [self.webView loadData:gif MIMEType:@"image/gif" textEncodingName:nil baseURL:nil];
    
    self.webView.scalesPageToFit = true;
    
    self.navigationController.title = @"请插卡或刷卡消费";
    self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:17/255.0 green:131/255.0 blue:223/255.0 alpha:1];
    

}

- (void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(jishixiaofeiField) name:jishixiaofeiShibai object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(chongxinshuaka) name:jishixiaofeiChongxin object:nil];
}

- (void)chongxinshuaka{
    
    [self.navigationController popViewControllerAnimated:YES];
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"错误" message:@"请重新刷卡！" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
    [alertView show];
}

- (void)jishixiaofeiField{
    
    [self.navigationController popViewControllerAnimated:YES];
    
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"错误" message:@"身份验证失败，请核对您的信息！" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
    [alertView show];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)recvMiniPosSDKStatus
{
    if (!self.isViewLoaded) {
        return;
    }
    
    [super recvMiniPosSDKStatus];
    
    if ([self.statusStr isEqualToString:[NSString stringWithFormat:@"消费成功"]]) {
        sendValue = @"消费交易";
        [self pushToPrint];
    }
    
    if ([self.statusStr isEqualToString:[NSString stringWithFormat:@"查询余额成功"]]) {
        
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"查询余额成功！" message:@"余额信息请在设备终端查阅。" delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
        
        [alertView show];
        
//        [self pushToCheck];
    }
    
    
    if ([self.statusStr isEqualToString:[NSString stringWithFormat:@"查询余额失败"]]) {
        [self showTipView:self.statusStr];
        [self performSelector:@selector(popAction) withObject:nil afterDelay:2.0];
    }                                                                                                                                                                                                                                                                                                                                                     
    
    if ([self.statusStr isEqualToString:[NSString stringWithFormat:@"消费失败"]]) {
        [self showTipView:self.statusStr];
        [self performSelector:@selector(popAction) withObject:nil afterDelay:2.0];
    }
    
    
    if ([self.statusStr isEqualToString:@"设备响应超时"]) {
        [self showTipView:self.statusStr];
        [self performSelector:@selector(popAction) withObject:nil afterDelay:2.0];
    }
    
    if ([self.statusStr isEqualToString:@"查询余额响应超时"]) {
        [self showTipView:self.statusStr];
        [self performSelector:@selector(popAction) withObject:nil afterDelay:2.0];
    }
    
    self.statusStr = @"";
}


- (void)pushToPrint
{
    [self performSegueWithIdentifier:@"swipPushToPrint" sender:self];
}

- (void)pushToCheck
{
    [self performSegueWithIdentifier:@"swipPushToCheck" sender:self];
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
   
    UIViewController *send = segue.destinationViewController;
    if ([send respondsToSelector:@selector(setType:)]) {
        if (sendValue) {
            [send setValue:sendValue forKey:@"type"];
            
        }
    }
    
    if ([send respondsToSelector:@selector(setCount:)]) {
        [send setValue:[NSNumber numberWithFloat:self.count] forKey:@"count"];
    }
    
}

- (void)popAction
{
    [self.navigationController popToRootViewControllerAnimated:YES];
}

#pragma mark - 
#pragma mark - UIAlertView delegate 
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    [self popAction];
}

@end
