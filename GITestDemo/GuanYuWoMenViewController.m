//
//  GuanYuWoMenViewController.m
//  GITestDemo
//
//  Created by lcc on 15/10/26.
//  Copyright © 2015年 Kyson. All rights reserved.
//

#import "GuanYuWoMenViewController.h"


@interface GuanYuWoMenViewController ()
@property (weak, nonatomic) IBOutlet UILabel *banbenhaoLabel;

@end

@implementation GuanYuWoMenViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    NSString *version = [[[NSBundle mainBundle] infoDictionary] objectForKey:(NSString *)kCFBundleVersionKey];
    self.banbenhaoLabel.text = [NSString stringWithFormat:@"软件版本号：%@",version];
    
    self.navigationController.navigationBar.hidden = NO;
    self.navigationItem.title = @"关于我们";
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
