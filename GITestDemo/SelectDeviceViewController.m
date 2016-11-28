//
//  SelectDeviceViewController.m
//  GITestDemo
//
//  Created by wd on 16/5/25.
//  Copyright © 2016年 Kyson. All rights reserved.
//

#import "SelectDeviceViewController.h"

@interface SelectDeviceViewController ()

@end

@implementation SelectDeviceViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self setBackIcon];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)G1ButtonAction:(UIButton *)sender {

    
  NSUserDefaults *preferences =   [NSUserDefaults standardUserDefaults];
    
    [preferences setObject:@"G1" forKey:kDeviceType];
    
    [preferences synchronize];
    
    
    
    
}

- (IBAction)H1ButtonAction:(UIButton *)sender {


    NSUserDefaults *preferences =   [NSUserDefaults standardUserDefaults];
    
    [preferences setObject:@"H1" forKey:kDeviceType];
    
    [preferences synchronize];
    
    
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
