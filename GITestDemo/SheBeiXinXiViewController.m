//
//  SheBeiXinXiViewController.m
//  GITestDemo
//
//  Created by lcc on 15/10/26.
//  Copyright © 2015年 Kyson. All rights reserved.
//

#import "SheBeiXinXiViewController.h"

@interface SheBeiXinXiViewController ()
@property (weak, nonatomic) IBOutlet UILabel *yingyongbanbenLabel;
@property (weak, nonatomic) IBOutlet UILabel *jishenhaoLabel;
@property (weak, nonatomic) IBOutlet UILabel *neihebanbenLabel;
@property (weak, nonatomic) IBOutlet UILabel *appBanBenLabel;
@property (weak, nonatomic) IBOutlet UIButton *getInfoBtn;

@end

@implementation SheBeiXinXiViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self initBLESDK];
    
    self.navigationController.navigationBar.hidden = NO;
    self.navigationItem.title = @"设备信息";
    self.navigationController.navigationBar.barTintColor = KMyBlueColor;
    
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setImage:[UIImage imageNamed:@"233"] forState:UIControlStateNormal];
    [btn sizeToFit];
    [btn addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:btn];
    
    self.getInfoBtn.layer.borderColor = [[UIColor lightGrayColor] CGColor];
    self.getInfoBtn.layer.borderWidth = 1;

}

- (void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
   
    
    self.appBanBenLabel.text = [[[NSBundle mainBundle] infoDictionary] objectForKey:(NSString *)kCFBundleVersionKey];
    
    if(MiniPosSDKDeviceState()<0){
            //[self showTipView:@"设备未连接"];
        self.yingyongbanbenLabel.text = @"";
        self.jishenhaoLabel.text = @"";
        self.neihebanbenLabel.text = @"";

        
    }else{
        
        [self performSelector:@selector(getInfo:) withObject:nil afterDelay:1.0];
    }
    
    
    

    
}

- (void)back{
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)getInfo:(id)sender {
    
    self.appBanBenLabel.text = [[[NSBundle mainBundle] infoDictionary] objectForKey:(NSString *)kCFBundleVersionKey];
    
    if(MiniPosSDKDeviceState()<0){
            //[self showTipView:@"设备未连接"];
        self.yingyongbanbenLabel.text = @"";
        self.jishenhaoLabel.text = @"";
        self.neihebanbenLabel.text = @"";

        [self showConnectionAlert];
        return;
        
        
    }else{
        

        MiniPosSDKGetDeviceInfoCMD();
        
    }
}

-(void)recvMiniPosSDKStatus{
    [super recvMiniPosSDKStatus];
    
    if ([self.statusStr isEqualToString:@"获取设备信息成功"] ) {
        
        
        
            self.jishenhaoLabel.text = [KUserDefault objectForKey:kMposG1SN];
            self.neihebanbenLabel.text = [NSString stringWithCString:MiniPosSDKGetCoreVersion() encoding:NSASCIIStringEncoding];
            self.yingyongbanbenLabel.text = [NSString stringWithCString:MiniPosSDKGetAppVersion() encoding:NSASCIIStringEncoding];
        
    }
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
