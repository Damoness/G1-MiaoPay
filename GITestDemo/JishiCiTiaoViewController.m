//
//  JishiCiTiaoViewController.m
//  GITestDemo
//
//  Created by lcc on 15/9/11.
//  Copyright (c) 2015年 Kyson. All rights reserved.
//

#import "JishiCiTiaoViewController.h"
#import "SwipingCardViewController.h"

@interface JishiCiTiaoViewController ()<UITextFieldDelegate,UITableViewDelegate,UITableViewDataSource>{
    
    NSString *payType;
    BOOL _isConnectHistoryConnect;
}
@property (weak, nonatomic) IBOutlet UITextField *xingming;
@property (weak, nonatomic) IBOutlet UITextField *shenfenzhenghao;
@property (weak, nonatomic) IBOutlet UITextField *shoujihao;
@property (weak, nonatomic) IBOutlet UITextField *anquanma;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tableHeight;

//@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *allHistoryArr;
@property (weak, nonatomic) IBOutlet UITableView *tableView;



@end

@implementation JishiCiTiaoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
//    self.shoujihao.delegate = self;
    self.shenfenzhenghao.delegate = self;
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.hidden = YES;
    self.tableView.tableFooterView = [[UIView alloc] init];
    
    self.shenfenzhenghao.delegate = self;
    self.shenfenzhenghao.tag = 4;
    self.shoujihao.delegate = self;
    self.shoujihao.tag = 5;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(connectSuccess) name:KconnectDeivesSuccess object:nil];
}

- (void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    
    [self loadHistoryInfo];
}





- (void)loadHistoryInfo{
    
    
    
    
    NSString *shenfenzhenghao = [KUserDefault objectForKey:Kcitiaoshenfenzhenghao];
    NSMutableDictionary *dict = [KUserDefault objectForKey:KcitiaoInfo];

    NSLog(@"###%@",dict);
    NSArray *arr = [dict objectForKey:shenfenzhenghao];
    
    self.shoujihao.text = arr[1];;
    self.xingming.text = arr[0];
    self.shenfenzhenghao.text = shenfenzhenghao;
    
    [self.allHistoryArr removeAllObjects];
    for (NSString *key in dict) {
        [self.allHistoryArr addObject:key];
    }
    self.tableHeight.constant = 44 * self.allHistoryArr.count;
    [self.tableView reloadData];
    
}

- (void)connectSuccess{
    
    
    if ([payType isEqualToString:@"磁条卡"]) {
        [self queren:nil];
    }
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)queren:(id)sender {
    if (!self.xingming.text.length) {
        
        [self showAlertViewWithMessage:@"姓名不能为空"];
    }else if (!self.shenfenzhenghao.text.length){
        
        [self showAlertViewWithMessage:@"身份证号不能为空"];
    }else if (!self.shoujihao.text.length){
        
        [self showAlertViewWithMessage:@"手机号不能为空"];
    }else {
        
        payType = @"磁条卡";
        
        [self saveCiTiaoInfo];
        
        
        
        
        if(MiniPosSDKDeviceState()<0){
                //[self showTipView:@"设备未连接"];
            _isConnectHistoryConnect = NO;
            [self connectHistoryDevice];
            
            return;
        }else{
            
            [self requestXiaoFei];
            
            
            
            
        }
        
    }
    
}

- (void)requestXiaoFei{
    
    [self verifyParamsSuccess:^{
        
        if (MiniPosSDKGetCurrentSessionType()== SESSION_POS_UNKNOWN) {
            
            int amount  = [self.count doubleValue]*100;
            
            if (amount > 0) {
                
                char buf[20];
                
                sprintf(buf,"%012d",amount);
                
                NSLog(@"amount: %s",buf);
                
                
                _type = 1;
                NSString *suijiStr = [NSString stringWithFormat:@"%d",(arc4random() % 89999999) + 10000000];
                
                [[NSUserDefaults standardUserDefaults] setObject:suijiStr forKey:Kcitiaosuijishu];
                [[NSUserDefaults standardUserDefaults] synchronize];
                
                NSString *str = [NSString stringWithFormat:@"0\x1C%@",suijiStr];
                
                
                _quanjuQianDaoType = 1;
                
                MiniPosSDKSaleTradeCMD(buf, NULL,str.UTF8String);
                
                UIStoryboard *mainStory = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
                SwipingCardViewController *scvc = [mainStory instantiateViewControllerWithIdentifier:@"SC"];
                [self.navigationController pushViewController:scvc animated:YES];
                [scvc setValue:@"即时收款" forKey:@"type"];
                
                
                
                
            } else {
                
                [self showTipView:@"请确定交易金额！"];
                
                
            }
            
        }else{
            [self showTipView:@"设备繁忙，稍后再试"];
        }
        
    }];

}

- (void)saveCiTiaoInfo{
    
    NSMutableDictionary *citiaoInfoDict = [NSMutableDictionary dictionaryWithDictionary:[KUserDefault objectForKey:KcitiaoInfo]];
//    NSLog(@"&&&&&&&&&&&&&&%@",citiaoInfoDict);
    
    
    
    for (NSString *key in citiaoInfoDict.allKeys) {

        if ([self.shoujihao.text isEqualToString:key]) {
            
//            NSLog(@"^^^%@^^^^^%@",key,self.shoujihao.text);
            
            [citiaoInfoDict removeObjectForKey:self.shoujihao.text];
        }
    }
    NSArray *newArr = @[self.xingming.text,self.shoujihao.text];
    
    
    [citiaoInfoDict setValue:newArr forKey:self.shenfenzhenghao.text];
    
//     NSLog(@"!~~~~~#####%@",citiaoInfoDict);
    [KUserDefault setObject:citiaoInfoDict forKey:KcitiaoInfo];
    [KUserDefault setObject:self.shenfenzhenghao.text forKey:Kcitiaoshenfenzhenghao];
    [KUserDefault synchronize];
    
    
    
    [[NSUserDefaults standardUserDefaults] setObject:self.shoujihao.text forKey:Kcitiaoyuliushoujihao];
    //        [[NSUserDefaults standardUserDefaults] setObject:self.xingming.text forKey:Kcitiaoxingming];
    //        [[NSUserDefaults standardUserDefaults] setObject:self.shenfenzhenghao.text forKey:Kcitiaoshenfenzhenghao];
    
    
//    NSArray *arr = @[self.xingming.text,self.shenfenzhenghao.text];
//    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithObjectsAndKeys:arr,self.shoujihao.text, nil];
//    [KUserDefault setObject:dict forKey:KcitiaoInfo];
    
    
    [[NSUserDefaults standardUserDefaults] synchronize];
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

int StrToHex(unsigned char* hex, unsigned char* str)
{
    int i;
    int j;
    unsigned char tmp;
    int len = strlen((char*)str);
    
    for(i = 0, j = 0; i < len; i++){
        tmp = 0xFF;
        
        if(str[i] >= '0' && str[i] <= '9'){
            tmp = str[i] - '0';
        }
        else if(str[i] >= 'A' && str[i] <= 'F'){
            tmp = str[i] - 'A' + 0x0A;
        }
        else if(str[i] >= 'a' && str[i] <= 'f'){
            tmp = str[i] - 'a' + 0x0A;
        }
        
        if(tmp < 0x10){
            if(j % 2 == 0){
                hex[j / 2] = tmp << 4;
            }
            else{
                hex[j / 2] &= 0xF0;
                hex[j / 2] |= (tmp & 0x0F);
            }
            j++;
        }
    }
    
    return j;
}

- (void)showAlertViewWithMessage:(NSString *)message{
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:message delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
    [alert show];
}


- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    
    [self.view endEditing:YES];
    self.tableView.hidden = YES;
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
        [self queren:nil];
//        [self requestXiaoFei];
        
        
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



#pragma mark - textField的代理方法

- (void)textFieldDidBeginEditing:(UITextField *)textField{
    
     //身份证
    if (textField.tag ==4) {
        
        self.tableView.hidden = NO;
    }

    
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string;   {
    
    //身份证
    if (textField.tag ==4) {
    
        if(textField.text.length >=18 && ![string isEqualToString:@""]){
            
            return NO;
        }
    }
    
    //手机号
    if (textField.tag ==5) {
        if(textField.text.length >=11 && ![string isEqualToString:@""]){
            
            return NO;
        }
    }
    
    
    return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField{
    
    self.tableView.hidden = YES;
}

#pragma mark - tableView的代理和数据源方法

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.allHistoryArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *ID = @"MenuCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
    }
//    cell.backgroundColor = [UIColor redColor];
//    cell.text = self.allHistoryArr[indexPath.row];
    cell.textLabel.font = [UIFont systemFontOfSize:14];
    cell.textLabel.text = self.allHistoryArr[indexPath.row];
    
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [self.shoujihao endEditing:YES];
    NSString *key = self.allHistoryArr[indexPath.row];
    NSDictionary *dict = [KUserDefault objectForKey:KcitiaoInfo];
    NSArray *arr = [dict objectForKey:key];
    self.shenfenzhenghao.text = key;
    self.xingming.text = arr[0];
    self.shoujihao.text = arr[1];
    self.tableView.hidden = YES;
}

#pragma mark - 懒加载
- (NSMutableArray *)allHistoryArr{
    
    if (_allHistoryArr == nil) {
        _allHistoryArr = [NSMutableArray array];
    }
    return _allHistoryArr;
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
