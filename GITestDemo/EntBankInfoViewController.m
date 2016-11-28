//
//  EntBankInfoViewController.m
//  GITestDemo
//
//  Created by 吴狄 on 15/6/9.
//  Copyright (c) 2015年 Kyson. All rights reserved.
//

#import "EntBankInfoViewController.h"
#import "QRadioButton.h"
#import "AFNetworking.h"
#import "EntPersonInfoViewController.h"
#import "EntMerchantInfoViewController.h"
#import "LoginViewController.h"
#import "SIAlertView.h"
@interface EntBankInfoViewController ()<WDPickViewDelegate>{
    NSString *_imageDocPath;
}

@end

#define kOFFSET_FOR_KEYBOARD 140
#define kOFFSET_FOR_KEYBOARD_PAD 140

@implementation EntBankInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadHistory];
    // Do any additional setup after loading the view.
    //获取Documents文件夹目录
    NSArray *path = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentPath = [path objectAtIndex:0];
    //指定新建文件夹路径
    _imageDocPath = [documentPath stringByAppendingPathComponent:@"ImageFile_q"];
    //创建ImageFile文件夹
    [[NSFileManager defaultManager] createDirectoryAtPath:_imageDocPath withIntermediateDirectories:YES attributes:nil error:nil];
//    self.imagePath4 = @"";
    [self _initViews];
    
    
    
    WDPickView *pickView = [[WDPickView alloc]initPickViewWithPlistName:@"Address"];
    pickView.delegate = self;
    self.diqubianma.inputView = pickView;
}

- (void)loadHistory{
    
    self.diqubianma.text = [KUserDefault objectForKey:qiyeDiqubianma];
    self.province.text = [KUserDefault objectForKey:qiyeprovince];
    self.city.text = [KUserDefault objectForKey:qiyecity];
    self.bankName.text = [KUserDefault objectForKey:qiyebankName];
    self.settleBank.text = [KUserDefault objectForKey:qiyesettleBank];
    self.bankBranch.text = [KUserDefault objectForKey:qiyebankBranch];
    self.settleAccno.text = [KUserDefault objectForKey:qiyesettleAccno];
    self.accName.text = [KUserDefault objectForKey:qiyeaccName];
   
    
}

- (void)_initViews{
    
    
//    UIView *titleView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 180, 44)];
//    UILabel *label1 = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 60, 44)];
//    UILabel *label2 = [[UILabel alloc]initWithFrame:CGRectMake(60, 0, 60, 44)];
//    UILabel *label3 = [[UILabel alloc]initWithFrame:CGRectMake(120, 0, 60, 44)];
//    [label1 setText:@"个人信息"];
//    [label2 setText:@"商户信息"];
//    [label3 setText:@"银行卡信息"];
//    [label1 setFont:[UIFont systemFontOfSize:14]];
//    [label2 setFont:[UIFont systemFontOfSize:14]];
//    [label3 setFont:[UIFont systemFontOfSize:14]];
//    [titleView addSubview:label1];
//    [titleView addSubview:label2];
//    [titleView addSubview:label3];
//    
//    label1.textColor = [UIColor grayColor];
//    label2.textColor = [UIColor grayColor];
//    label3.textColor = [UIColor blackColor];
//    self.navigationItem.titleView = titleView;
    self.navigationItem.title = @"银行卡信息";
    
    
 
    self.diqubianma.delegate = self;
    self.diqubianma.tag = 1;
    
    self.province.delegate = self;
    self.province.tag = 2;
    
    self.city.delegate = self;
    self.city.tag = 3;
    
    self.settleBank.delegate = self;
    self.settleBank.tag = 4;
    
    self.bankName.delegate = self;
    self.bankName.tag = 5;
    
    self.bankBranch.delegate = self;
    self.bankBranch.tag = 6;
    
    self.settleAccno.delegate = self;
    self.settleAccno.tag = 7;
    
    self.accName.delegate = self;
    self.accName.tag = 8;
    
    
    QRadioButton *accountType_radio1 = [[QRadioButton alloc] initWithDelegate:self groupId:@"accountType"];
    accountType_radio1.frame = CGRectMake(150, 153, 100, 40);
    accountType_radio1.tag = 1;
    [accountType_radio1 setTitle:@"借记卡" forState:UIControlStateNormal];
    [self.view addSubview:accountType_radio1];
    [accountType_radio1 setChecked:YES];
    QRadioButton *accountType_radio2 = [[QRadioButton alloc] initWithDelegate:self groupId:@"accountType"];
    accountType_radio2.frame = CGRectMake(220, 153, 100, 40);
    accountType_radio2.tag = 2;
    [accountType_radio2 setTitle:@"贷记卡" forState:UIControlStateNormal];
    [self.view addSubview:accountType_radio2];
    
    QRadioButton *isPrivate_radio1 = [[QRadioButton alloc] initWithDelegate:self groupId:@"isPrivate"];
    isPrivate_radio1.frame = CGRectMake(150, 127, 100, 40);
    isPrivate_radio1.tag = 1;
    [isPrivate_radio1 setTitle:@"对私" forState:UIControlStateNormal];
    [self.view addSubview:isPrivate_radio1];
    [isPrivate_radio1 setChecked:YES];
    QRadioButton *isPrivate_radio2 = [[QRadioButton alloc] initWithDelegate:self groupId:@"isPrivate"];
    isPrivate_radio2.frame = CGRectMake(220, 127, 100, 40);
    isPrivate_radio2.tag = 0;
    [isPrivate_radio2 setTitle:@"对公" forState:UIControlStateNormal];
    [self.view addSubview:isPrivate_radio2];
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(closeKeBoard) name:UIKeyboardDidHideNotification object:nil];
    
}

- (void)dealloc{
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardDidHideNotification object:nil];
}


- (IBAction)selectImage:(UIButton *)sender {
    
    UIActionSheet *actionSheet = [[UIActionSheet alloc]initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"从相册获取",@"拍照",nil];
    
    
    [actionSheet showInView:self.view];
    
}
//提交审核
- (IBAction)submit:(UIButton *)sender {
    
    //    if (DEBUG) {
    //        //[self.navigationController popToViewController:self.navigationController.viewControllers[1] animated:YES];
    //        [self dismissViewControllerAnimated:YES completion:nil];
    //        return;
    //    }
    
    //校验信息
    
    if ([UIUtils isEmptyString:self.bankName.text]||[self.bankName.text length] > 20) {
        [self showTipView:@"请输入正确的开户行全称"];
        return;
    }else if ([UIUtils isEmptyString:self.province.text]||[self.province.text length] > 10) {
        [self showTipView:@"请选择地区编码"];
        return;
    }else if([UIUtils isEmptyString:self.city.text]||[self.city.text length] > 10){
        [self showTipView:@"请选择地区编码"];
        return;
    }else if([UIUtils isEmptyString:self.bankBranch.text]||[self.bankBranch.text length] > 20){
        [self showTipView:@"请输入正确的支行名称"];
        return;
    }else if(![UIUtils isCorrectBankCardNumber:self.settleAccno.text]){
        [self showTipView:@"请输入开户行账户"];
        return;
    }else if([UIUtils isEmptyString:self.accName.text]||[self.accName.text length] > 10){
        [self showTipView:@"请输入商户姓名"];
        return;
    }else if([UIUtils isEmptyString:self.settleBank.text]||[self.settleBank.text length] > 12){
        [self showTipView:@"请输入正确的银行联行号"];
        return;
    }
//    else if([UIUtils isEmptyString:self.imagePath4]){
//        [self showTipView:@"请选择银行卡正面照"];
//        return;
//    }
    
    
    
    EntPersonInfoViewController *pivc = self.navigationController.viewControllers[4];
    EntMerchantInfoViewController *mivc = self.navigationController.viewControllers[5];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    NSString *phoneNo = [[NSUserDefaults standardUserDefaults]objectForKey:kSignUpPhoneNo];
    //phoneNo = @"13202264038";
    
//    NSLog(@" pivc.password.text:%@", pivc.password.text);
////    NSLog(@" mivc.area.text:%@", mivc.area.text);
//    NSLog(@" pivc.name.text:%@", pivc.lianxiren.text);
//    NSLog(@" phoneNo:%@", phoneNo);
//    NSLog(@" pivc.ID.text:%@", pivc.ID.text);
//    NSLog(@" mivc.address.text:%@",self.province.text);
//    NSLog(@" self.accountType.text:%@", self.accountType.text);
//    NSLog(@" self.isPrivate.text:%@", self.isPrivate.text);
//    NSLog(@" self.bankName.text:%@",self.bankName.text);
//    NSLog(@" self.province.text:%@", self.province.text);
//    NSLog(@" self.city.text:%@", self.city.text);
//    NSLog(@" self.bankBranch.text:%@", self.bankBranch.text);
//    NSLog(@" self.settleAccno.text:%@",self.settleAccno.text);
//    NSLog(@"self.accName.text:%@",self.accName.text);
    
    NSLog(@"%@,%@,%@,%@,%@,%@,%@,%@,%@,%@,%@,%@,%@,%@,%@,%@,%@,%@",pivc.password.text,self.diqubianma.text,pivc.lianxiren.text,phoneNo,pivc.lianxiren.text,pivc.ID.text,pivc.certExpdate.text,mivc.yingyedizhi.text,self.accountType,self.isPrivate,self.bankName.text,self.province.text,self.city.text,self.bankBranch.text,self.settleAccno.text,self.accName.text,mivc.sn.text,self.settleBank.text);
    
    NSString *deviceType = [[NSUserDefaults standardUserDefaults]stringForKey:kDeviceType];
    
    NSString *merType ;
    
    if ( [deviceType isEqualToString:@"H1"])
    {
        
        
        merType = @"11"; //H1 企业
        
    }else{
        
        merType = @"5"; //G1 企业
    }
    
    
    
    NSDictionary *parameters = @{@"merType": merType,@"passwd":pivc.password.text,@"areaCode":self.diqubianma.text,@"lawMan":pivc.lianxiren.text,@"phone":phoneNo,@"linkMan":pivc.lianxiren.text,@"linkPhone":phoneNo,@"certType":@"1",@"certNo":pivc.ID.text,@"certExpdate":pivc.certExpdate.text,@"mchAddr":mivc.yingyedizhi.text,@"accountType":self.accountType,@"isPrivate":self.isPrivate,@"bankName":self.bankName.text,@"province":self.province.text,@"city":self.city.text,@"bankBranch":self.bankBranch.text,@"settleAccno":self.settleAccno.text,@"accName":self.accName.text,@"sn":pivc.G1SNTextField.text,@"settleBank":self.settleBank.text};
    
    
    NSLog(@"parameters:%@",parameters);
    
//    
//    NSURL *filePath1 = [NSURL fileURLWithPath:pivc.imagePath1];
//    NSURL *filePath2 = [NSURL fileURLWithPath:pivc.imagePath2];
////    NSURL *filePath3 = [NSURL fileURLWithPath:pivc.imagePath3];
////    NSURL *filePath4 = [NSURL fileURLWithPath:pivc];
//    NSURL *filePath5 = [NSURL fileURLWithPath:mivc.KaiHuKeImagePath];
//    NSURL *filePath6 = [NSURL fileURLWithPath:mivc.imagePath6];
//    NSURL *filePath7 = [NSURL fileURLWithPath:mivc.imagePath7];
//    NSURL *filePath8 = [NSURL fileURLWithPath:mivc.imagePath8];
//    NSURL *filePath9 = [NSURL fileURLWithPath:mivc.imagePath9];
//    NSURL *filePath10 = [NSURL fileURLWithPath:mivc.xianchangzhaopianImagePath];
    
    NSData *data1 = [KUserDefault objectForKey:qiyeImage1];
    NSData *data2 = [KUserDefault objectForKey:qiyeImage2];
    NSData *data5 = [KUserDefault objectForKey:qiyeImage11];
    NSData *data6 = [KUserDefault objectForKey:qiyeImage6];
    NSData *data7 = [KUserDefault objectForKey:qiyeImage7];
    NSData *data8 = [KUserDefault objectForKey:qiyeImage8];
    NSData *data9 = [KUserDefault objectForKey:qiyeImage9];
    NSData *data10 = [KUserDefault objectForKey:qiyeImage10];
    
    
    NSString *imagePath1 =[_imageDocPath stringByAppendingPathComponent:@"1.jpg"];
    NSString *imagePath2 =[_imageDocPath stringByAppendingPathComponent:@"2.jpg"];
    NSString *imagePath5 =[_imageDocPath stringByAppendingPathComponent:@"5.jpg"];
    NSString *imagePath6 =[_imageDocPath stringByAppendingPathComponent:@"6.jpg"];
    NSString *imagePath7 =[_imageDocPath stringByAppendingPathComponent:@"7.jpg"];
    NSString *imagePath8 =[_imageDocPath stringByAppendingPathComponent:@"8.jpg"];
    NSString *imagePath9 =[_imageDocPath stringByAppendingPathComponent:@"9.jpg"];
    NSString *imagePath10 =[_imageDocPath stringByAppendingPathComponent:@"10.jpg"];
    
    [[NSFileManager defaultManager] createFileAtPath:imagePath1 contents:data1 attributes:nil];
    [[NSFileManager defaultManager] createFileAtPath:imagePath2 contents:data2 attributes:nil];
    [[NSFileManager defaultManager] createFileAtPath:imagePath5 contents:data5 attributes:nil];
    [[NSFileManager defaultManager] createFileAtPath:imagePath6 contents:data6 attributes:nil];
    [[NSFileManager defaultManager] createFileAtPath:imagePath7 contents:data7 attributes:nil];
    [[NSFileManager defaultManager] createFileAtPath:imagePath8 contents:data8 attributes:nil];
    [[NSFileManager defaultManager] createFileAtPath:imagePath9 contents:data9 attributes:nil];
    [[NSFileManager defaultManager] createFileAtPath:imagePath10 contents:data10 attributes:nil];
    
    
    NSURL *filePath1 = [NSURL fileURLWithPath:imagePath1];
    NSURL *filePath2 = [NSURL fileURLWithPath:imagePath2];
    NSURL *filePath5 = [NSURL fileURLWithPath:imagePath5];
    NSURL *filePath6 = [NSURL fileURLWithPath:imagePath6];
    NSURL *filePath7 = [NSURL fileURLWithPath:imagePath7];
    NSURL *filePath8 = [NSURL fileURLWithPath:imagePath8];
    NSURL *filePath9 = [NSURL fileURLWithPath:imagePath9];
    NSURL *filePath10 = [NSURL fileURLWithPath:imagePath10];

    
    
    [self showHUD:@"正在提交"];
    NSString *url = [NSString stringWithFormat:@"http://%@:%@/MposApp/registerMchInfo.action",kServerIP,kServerPort];
    [manager POST:url parameters:parameters constructingBodyWithBlock:^(id<AFMultipartFormData> formData){
        [formData appendPartWithFileURL:filePath1 name:@"file1" error:nil];
        [formData appendPartWithFileURL:filePath2 name:@"file2" error:nil];
//        [formData appendPartWithFileURL:filePath3 name:@"file3" error:nil];
//        [formData appendPartWithFileURL:filePath4 name:@"file4" error:nil];
        [formData appendPartWithFileURL:filePath5 name:@"file5" error:nil];
        [formData appendPartWithFileURL:filePath6 name:@"file6" error:nil];
        [formData appendPartWithFileURL:filePath7 name:@"file7" error:nil];
        [formData appendPartWithFileURL:filePath8 name:@"file8" error:nil];
        [formData appendPartWithFileURL:filePath9 name:@"file9" error:nil];
        [formData appendPartWithFileURL:filePath10 name:@"file10" error:nil];
        
    } success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"Success: %@", responseObject);
        
        
        int code = [responseObject[@"resultMap"][@"code"]intValue];
        
        [self hideHUD];
        
        [self showTipView:responseObject[@"resultMap"][@"msg"]];
        
        if(code ==0){
            
            SIAlertView *salertView = [[SIAlertView alloc] initWithTitle:@"提交成功" andMessage:NULL];
            [salertView addButtonWithTitle:@"确定"
                                      type:SIAlertViewButtonTypeDefault
                                   handler:^(SIAlertView *alertView) {
                                       
                                       [self dismissViewControllerAnimated:YES completion:nil];
                                   }];
            salertView.cornerRadius = 10;
            salertView.buttonFont = [UIFont boldSystemFontOfSize:15];
            salertView.transitionStyle = SIAlertViewTransitionStyleFade;
            [salertView show];
            
        }
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        [self hideHUD];
        [self showTipView:@"提交失败"];
    }];
    
    
}



-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    switch (buttonIndex) {
        case 0:
            //从相册选择
            [self OpenLocalPhoto];
            break;
        case 1:
            //拍照
            [self takePhoto];
            break;
        default:
            break;
    }
}

-(void)takePhoto{
    
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        UIImagePickerController *picker = [[UIImagePickerController alloc]init];
        picker.delegate = self;
        picker.allowsEditing = YES;
        picker.sourceType = UIImagePickerControllerSourceTypeCamera;
        [self presentViewController:picker animated:YES completion:nil];
    }
}

-(void)OpenLocalPhoto{
    
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    //资源类型为图片库
    picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    picker.delegate = self;
    //设置选择后的图片可被编辑
    picker.allowsEditing = YES;
    [self presentViewController:picker animated:YES completion:nil];
    
}


- (void)didSelectedRadioButton:(QRadioButton *)radio groupId:(NSString *)groupId{
    
    if ([groupId isEqualToString:@"accountType"]){
        self.accountType = [NSString stringWithFormat:@"%d",radio.tag];
    }else if ([groupId isEqualToString:@"isPrivate"]){
        self.isPrivate = [NSString stringWithFormat:@"%d",radio.tag];
    }
}

#pragma mark UIImagePickerControllerDelegate

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    NSLog(@"imagePickerControllerDidCancel");
    
    [picker dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - wdpickview的代理方法
-(void)toolBarDoneBtnHaveClicked:(WDPickView *)pickView resultString:(NSString *)resultString shengfen:(NSString *)shengfen{
    
    
    self.city.text = [resultString substringToIndex:[resultString length] -5];
    self.diqubianma.text  = [resultString substringFromIndex:[resultString length] -4];
    self.province.text = shengfen;
    [KUserDefault setObject:self.province.text forKey:qiyeprovince];
    [KUserDefault setObject:self.city.text forKey:qiyecity];
    [KUserDefault setObject:self.diqubianma.text forKey:qiyeDiqubianma];
        //NSLog(@"self.area.tag:%d",self.area.tag);
    
        //为了解决跳转时，如果焦点停留在所在地区上，奔溃的bug
//    [self.view resignFirstResponder];
    [self.view endEditing:YES];
}

//- (void)imagePickerController:(UIImagePickerController *)picker
//        didFinishPickingImage:(UIImage *)image
//                  editingInfo:(NSDictionary *)editingInfo{
//    
//    NSLog(@"didFinishPickingImage");
//    
//    //当图片不为空时显示图片并保存图片
//    if (image != nil) {
//        //图片显示在按钮上
//        [self.CardPhotoFront setBackgroundImage:image forState:UIControlStateNormal];
//        
//        //把图片转成NSData类型的数据来保存文件
//        NSData *data;
//        
//        
//        data = UIImageJPEGRepresentation(image, 1.0);
//        
//        
//        //UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil);
//        
//        //保存
//        self.imagePath4 = [_imageDocPath stringByAppendingPathComponent:@"4.jpg"];
//        [[NSFileManager defaultManager] createFileAtPath:self.imagePath4 contents:data attributes:nil];
//        
//        
//        
//    }
//    
//    
//    [picker dismissViewControllerAnimated:YES completion:nil];
//    
//    
//    
//}

- (void)closeKeBoard{
    
    [self setViewMovedUp:NO];
}

-(void)setViewMovedUp:(BOOL)movedUp
{
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.3]; // if you want to slide up the view
    
    
    
    CGRect rect = self.view.frame;
    NSLog(@"%f",rect.size.height);
    if( (movedUp) )
    {
        // 1. move the view's origin up so that the text field that will be hidden come above the keyboard
        // 2. increase the size of the view so that the area behind the keyboard is covered up.
        if (rect.origin.y>=0)
        {
            if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
                rect.origin.y -= kOFFSET_FOR_KEYBOARD;
                rect.size.height += kOFFSET_FOR_KEYBOARD;
            }
            if ([[UIDevice currentDevice] userInterfaceIdiom] != UIUserInterfaceIdiomPhone) {
                rect.origin.y -= kOFFSET_FOR_KEYBOARD_PAD;
                rect.size.height += kOFFSET_FOR_KEYBOARD_PAD;
            }
        }
        
    }
    else
    {
        
        if   (rect.origin.y<0)
            // revert back to the normal state.
        {
            if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
                rect.origin.y += kOFFSET_FOR_KEYBOARD;
                rect.size.height -= kOFFSET_FOR_KEYBOARD;
            }
            if ([[UIDevice currentDevice] userInterfaceIdiom] != UIUserInterfaceIdiomPhone) {
                rect.origin.y += kOFFSET_FOR_KEYBOARD_PAD;
                rect.size.height -= kOFFSET_FOR_KEYBOARD_PAD;
            }
            
        }
    }
    self.view.frame = rect;
    
    [UIView commitAnimations];
}

#pragma mark UITextFieldDelegate

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    [self setViewMovedUp:YES];
    return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField{
    
    
    /**
     *  @property (weak, nonatomic) IBOutlet UITextField *diqubianma;//地区编码
     @property (strong, nonatomic) IBOutlet UITextField *province;//所在省
     @property (strong, nonatomic) IBOutlet UITextField *city; //所在市
     @property (weak, nonatomic) IBOutlet UITextField *settleBank; //银行联行号
     @property (strong, nonatomic) IBOutlet UITextField *bankName;//开户行全称
     @property (strong, nonatomic) IBOutlet UITextField *bankBranch;//支行名称
     @property (strong, nonatomic) IBOutlet UITextField *settleAccno; //开户行账户
     @property (strong, nonatomic) IBOutlet UITextField *accName; //商户姓名
     */
    
    if (textField.tag == 1) {
        [KUserDefault setObject:textField.text forKey:qiyeDiqubianma];
    }else if (textField.tag == 2){
        [KUserDefault setObject:textField.text forKey:qiyeprovince];
    }else if (textField.tag == 3){
        [KUserDefault setObject:textField.text forKey:qiyecity];
    }else if (textField.tag == 4){
        [KUserDefault setObject:textField.text forKey:qiyesettleBank];
    }else if (textField.tag == 5){
        [KUserDefault setObject:textField.text forKey:qiyebankName];
    }else if (textField.tag == 6){
        [KUserDefault setObject:textField.text forKey:qiyebankBranch];
    }else if (textField.tag == 7){
        [KUserDefault setObject:textField.text forKey:qiyesettleAccno];
    }else if (textField.tag == 8){
        [KUserDefault setObject:textField.text forKey:qiyeaccName];
    }
    
    
    [KUserDefault synchronize];
}


- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    
    if (textField.tag == 4) {
        if (range.location >= 12) {
            return NO;
        }
    }
    if (textField.tag == 7) {
        if (range.location >= 20) {
            return NO;
        }
    }
    return YES;
}

//override
- (void)dismissAction{
    
    [self setViewMovedUp:false];
    [self.view endEditing:YES];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    
    [self dismissAction];
    
    return YES;
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
