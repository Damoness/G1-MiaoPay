//
//  JiaoYiGuiZeViewController.m
//  GITestDemo
//
//  Created by lcc on 15/10/26.
//  Copyright © 2015年 Kyson. All rights reserved.
//

#import "JiaoYiGuiZeViewController.h"

@interface JiaoYiGuiZeViewController ()
@property (weak, nonatomic) IBOutlet UILabel *xiaoyuandian1;
@property (weak, nonatomic) IBOutlet UILabel *xiaoyuandian2;
@property (weak, nonatomic) IBOutlet UILabel *xiaoyuandian3;

@property (weak, nonatomic) IBOutlet UILabel *xiaoyuandian;
@end

@implementation JiaoYiGuiZeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.xiaoyuandian.layer.cornerRadius = self.xiaoyuandian.width / 2;
    self.xiaoyuandian.layer.masksToBounds = YES;
    self.xiaoyuandian1.layer.cornerRadius = self.xiaoyuandian.width / 2;
    self.xiaoyuandian1.layer.masksToBounds = YES;
    self.xiaoyuandian2.layer.cornerRadius = self.xiaoyuandian.width / 2;
    self.xiaoyuandian2.layer.masksToBounds = YES;
    self.xiaoyuandian3.layer.cornerRadius = self.xiaoyuandian.width / 2;
    self.xiaoyuandian3.layer.masksToBounds = YES;
    
    
    
    self.navigationController.navigationBar.hidden = NO;
    self.navigationItem.title = @"交易规则";
    self.navigationController.navigationBar.barTintColor = KMyBlueColor;
    
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setImage:[UIImage imageNamed:@"233"] forState:UIControlStateNormal];
    [btn sizeToFit];
    [btn addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:btn];
    
}

- (void)back{
    
    [self.navigationController popViewControllerAnimated:YES];
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
