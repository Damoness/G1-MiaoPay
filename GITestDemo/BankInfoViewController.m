//
//  BankInfoViewController.m
//  GITestDemo
//
//  Created by 吴狄 on 15/5/14.
//  Copyright (c) 2015年 Kyson. All rights reserved.
//

#import "BankInfoViewController.h"
#import "QRadioButton.h"
#import "AFNetworking.h"
#import "PersonInfoViewController.h"
//#import "MerchantInfoViewController.h"
#import "LoginViewController.h"
#import "SIAlertView.h"
#import "UIUtils.h"
#import "WDPickView.h"
@interface BankInfoViewController ()<WDPickViewDelegate>{
        NSString *_imageDocPath;
}

@end

#define kOFFSET_FOR_KEYBOARD 140
#define kOFFSET_FOR_KEYBOARD_PAD 140

@implementation BankInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    // Do any additional setup after loading the view.
    //获取Documents文件夹目录
    NSArray *path = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentPath = [path objectAtIndex:0];
    //指定新建文件夹路径
    _imageDocPath = [documentPath stringByAppendingPathComponent:@"ImageFile_g"];
    //创建ImageFile文件夹
    [[NSFileManager defaultManager] createDirectoryAtPath:_imageDocPath withIntermediateDirectories:YES attributes:nil error:nil];
//    self.imagePath4 = @"";
    [self _initViews];
    
    WDPickView *pickView = [[WDPickView alloc]initPickViewWithPlistName:@"Address"];
    pickView.delegate = self;
    self.diqubianma.inputView = pickView;
}

- (void)viewWillAppear:(BOOL)animated{
    
    [self loadHistory];
}

- (void)loadHistory{
    
    

    self.diqubianma.text = [KUserDefault objectForKey:gerendiqubianma];
    self.province.text = [KUserDefault objectForKey:gerenprovince];
    self.city.text = [KUserDefault objectForKey:gerencity];
    self.settleBank.text = [KUserDefault objectForKey:gerensettleBank];
    self.bankName.text  =[KUserDefault objectForKey:gerenbankName];
    self.bankBranch.text = [KUserDefault objectForKey:gerenbankBranch];
    self.settleAccno.text = [KUserDefault objectForKey:gerensettleAccno];
    self.accName.text = [KUserDefault objectForKey:gerenaccName];
    self.shanghuyingyedizhi.text = [KUserDefault objectForKey:gerenshanghuyingyedizhi];
    
}



- (void)_initViews{
    
    
//    UIView *titleView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 180, 44)];
//    UILabel *label1 = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 60, 44)];
////    UILabel *label2 = [[UILabel alloc]initWithFrame:CGRectMake(60, 0, 60, 44)];
//    UILabel *label3 = [[UILabel alloc]initWithFrame:CGRectMake(120, 0, 60, 44)];
//    [label1 setText:@"个人信息"];
////    [label2 setText:@"商户信息"];
//    [label3 setText:@"银行卡信息"];
//    [label1 setFont:[UIFont systemFontOfSize:14]];
////    [label2 setFont:[UIFont systemFontOfSize:14]];
//    [label3 setFont:[UIFont systemFontOfSize:14]];
//    [titleView addSubview:label1];
////    [titleView addSubview:label2];
//    [titleView addSubview:label3];
//    
//    label1.textColor = [UIColor grayColor];
////    label2.textColor = [UIColor grayColor];
//    label3.textColor = [UIColor blackColor];
//    self.navigationItem.titleView = titleView;

    /**
     *  @property (weak, nonatomic) IBOutlet UITextField *diqubianma;//地区编码
     @property (strong, nonatomic) IBOutlet UITextField *province;//所在省
     @property (strong, nonatomic) IBOutlet UITextField *city; //所在市
     @property (weak, nonatomic) IBOutlet UITextField *settleBank; //银行联行号
     @property (strong, nonatomic) IBOutlet UITextField *bankName;//开户行全称
     @property (strong, nonatomic) IBOutlet UITextField *bankBranch;//支行名称
     @property (strong, nonatomic) IBOutlet UITextField *settleAccno; //开户账号
     @property (strong, nonatomic) IBOutlet UITextField *accName; //商户姓名
     @property (weak, nonatomic) IBOutlet UITextField *shanghuyingyedizhi;//商户营业地址
     */
    
    
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
    
    self.shanghuyingyedizhi.delegate = self;
    self.shanghuyingyedizhi.tag = 9;
    

    QRadioButton *accountType_radio1 = [[QRadioButton alloc] initWithDelegate:self groupId:@"accountType"];
    accountType_radio1.frame = CGRectMake(150, 156, 100, 40);
    accountType_radio1.tag = 1;
    [accountType_radio1 setTitle:@"借记卡" forState:UIControlStateNormal];
    [self.view addSubview:accountType_radio1];
    [accountType_radio1 setChecked:YES];
    QRadioButton *accountType_radio2 = [[QRadioButton alloc] initWithDelegate:self groupId:@"accountType"];
    accountType_radio2.frame = CGRectMake(220, 156, 100, 40);
    accountType_radio2.tag = 2;
    [accountType_radio2 setTitle:@"贷记卡" forState:UIControlStateNormal];
    [self.view addSubview:accountType_radio2];
    
    QRadioButton *isPrivate_radio1 = [[QRadioButton alloc] initWithDelegate:self groupId:@"isPrivate"];
    isPrivate_radio1.frame = CGRectMake(150, 130, 100, 40);
    isPrivate_radio1.tag = 1;
    [isPrivate_radio1 setTitle:@"对私" forState:UIControlStateNormal];
    [self.view addSubview:isPrivate_radio1];
    [isPrivate_radio1 setChecked:YES];
    QRadioButton *isPrivate_radio2 = [[QRadioButton alloc] initWithDelegate:self groupId:@"isPrivate"];
    isPrivate_radio2.frame = CGRectMake(220, 130, 100, 40);
    isPrivate_radio2.tag = 0;
    [isPrivate_radio2 setTitle:@"对公" forState:UIControlStateNormal];
    [self.view addSubview:isPrivate_radio2];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(closeKeBoard) name:UIKeyboardDidHideNotification object:nil];
    
}
- (IBAction)selectImage:(UIButton *)sender {
    
    UIActionSheet *actionSheet = [[UIActionSheet alloc]initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"从相册获取",@"拍照",nil];
    
    
    [actionSheet showInView:self.view];
    
}

- (void)dealloc{
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardDidHideNotification object:nil];
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
            //![UIUtils isCorrectBankCardNumber:self.settleAccno.text]
        [self showTipView:@"请输入正确的开户账号"];
        return;
    }else if([UIUtils isEmptyString:self.accName.text]||[self.accName.text length] > 10){
        [self showTipView:@"商户姓名不能为空"];
        return;
    }else if([self.settleBank.text length] != 12){
        [self showTipView:@"请输入12位联行号"];
        return;
    }else if([UIUtils isEmptyString:self.shanghuyingyedizhi.text]){
        [self showTipView:@"请输入商户营业地址"];
        return;
    }
    
    
    
    PersonInfoViewController *pivc = self.navigationController.viewControllers[4];
//    MerchantInfoViewController *mivc = self.navigationController.viewControllers[4];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    NSString *phoneNo = [[NSUserDefaults standardUserDefaults]objectForKey:kSignUpPhoneNo];
    //phoneNo = @"13202264038";
   
    NSLog(@" pivc.password.text:%@", pivc.password.text);
//    NSLog(@" mivc.area.text:%@", mivc.area.text);
//    NSLog(@" pivc.name.text:%@", pivc.name.text);
    NSLog(@" phoneNo:%@", phoneNo);
    NSLog(@" pivc.ID.text:%@", pivc.ID.text);
//    NSLog(@" mivc.address.text:%@", mivc.address.text);
    NSLog(@" self.accountType.text:%@", self.accountType);
    NSLog(@" self.isPrivate.text:%@", self.isPrivate);
    NSLog(@" self.bankName.text:%@",self.bankName.text);
    NSLog(@" self.province.text:%@", self.province.text);
    NSLog(@" self.city.text:%@", self.city.text);
    NSLog(@" self.bankBranch.text:%@", self.bankBranch.text);
    NSLog(@" self.settleAccno.text:%@",self.settleAccno.text);
    NSLog(@"self.accName.text:%@",self.accName.text);
    
    
    NSString *deviceType = [[NSUserDefaults standardUserDefaults]stringForKey:kDeviceType];
    
    NSString *merType ;
    
    if ( [deviceType isEqualToString:@"H1"])
    {
        
        
        merType = @"12"; //H1 个人
        
    }else{
        
        merType = @"6"; //G1 个人
    }
    
    
    NSDictionary *parameters = @{@"merType":merType,@"passwd":pivc.password.text,@"areaCode":self.diqubianma.text,@"lawMan":pivc.yonghuxingming.text,@"phone":phoneNo,@"certType":@"1",@"certNo":pivc.ID.text,@"certExpdate":pivc.certExpdate.text,@"mchAddr":self.shanghuyingyedizhi.text,@"accountType":self.accountType,@"isPrivate":self.isPrivate,@"bankName":self.bankName.text,@"province":self.province.text,@"city":self.city.text,@"bankBranch":self.bankBranch.text,@"settleAccno":self.settleAccno.text,@"accName":self.accName.text,@"sn":pivc.G1SNTextField.text,@"settleBank":self.settleBank.text};
    
    
    NSLog(@"parameters:%@",parameters);
    
    
//    NSURL *filePath1 = [NSURL fileURLWithPath:pivc.imagePath1];
//    NSURL *filePath2 = [NSURL fileURLWithPath:pivc.imagePath2];
//    NSURL *filePath3 = [NSURL fileURLWithPath:pivc.imagePath3];
//    NSURL *filePath4 = [NSURL fileURLWithPath:pivc.CardFrontPath];
//    NSURL *filePath5 = [NSURL fileURLWithPath:pivc.CardBackPath];
//    NSURL *filePath10 = [NSURL fileURLWithPath:pivc.imagePath10];
    NSData *data1 = [KUserDefault objectForKey:gerenImage1];
    NSData *data2 = [KUserDefault objectForKey:gerenImage2];
    NSData *data3 = [KUserDefault objectForKey:gerenImage3];
    NSData *data4 = [KUserDefault objectForKey:gerenImage4];
    NSData *data5 = [KUserDefault objectForKey:gerenImage5];
    NSData *data10 = data1;
    
    
    NSString *imagePath1 =[_imageDocPath stringByAppendingPathComponent:@"1.jpg"];
    NSString *imagePath2 =[_imageDocPath stringByAppendingPathComponent:@"2.jpg"];
    NSString *imagePath3 =[_imageDocPath stringByAppendingPathComponent:@"3.jpg"];
    NSString *imagePath4 =[_imageDocPath stringByAppendingPathComponent:@"4.jpg"];
    NSString *imagePath5 =[_imageDocPath stringByAppendingPathComponent:@"5.jpg"];
    NSString *imagePath10 =[_imageDocPath stringByAppendingPathComponent:@"10.jpg"];
    
    [[NSFileManager defaultManager] createFileAtPath:imagePath1 contents:data1 attributes:nil];
    [[NSFileManager defaultManager] createFileAtPath:imagePath2 contents:data2 attributes:nil];
    [[NSFileManager defaultManager] createFileAtPath:imagePath3 contents:data3 attributes:nil];
    [[NSFileManager defaultManager] createFileAtPath:imagePath4 contents:data4 attributes:nil];
    [[NSFileManager defaultManager] createFileAtPath:imagePath5 contents:data5 attributes:nil];
    [[NSFileManager defaultManager] createFileAtPath:imagePath10 contents:data10 attributes:nil];
    
    
    NSURL *filePath1 = [NSURL fileURLWithPath:imagePath1];
    NSURL *filePath2 = [NSURL fileURLWithPath:imagePath2];
    NSURL *filePath3 = [NSURL fileURLWithPath:imagePath3];
    NSURL *filePath4 = [NSURL fileURLWithPath:imagePath4];
    NSURL *filePath5 = [NSURL fileURLWithPath:imagePath5];
    NSURL *filePath10 = [NSURL fileURLWithPath:imagePath10];

//    NSLog(@"%@,%@,%@,%@,%@,%@",filePath1.absoluteString,filePath2.absoluteString,filePath3.absoluteString,filePath4.absoluteString,filePath5.absoluteString,filePath10.absoluteString);

    [self showHUD:@"正在提交"];
    NSString *url = [NSString stringWithFormat:@"http://%@:%@/MposApp/registerMchInfo.action",kServerIP,kServerPort];
    [manager POST:url parameters:parameters constructingBodyWithBlock:^(id<AFMultipartFormData> formData){
        [formData appendPartWithFileURL:filePath1 name:@"file1" error:nil];
        [formData appendPartWithFileURL:filePath2 name:@"file2" error:nil];
        [formData appendPartWithFileURL:filePath3 name:@"file3" error:nil];
        [formData appendPartWithFileURL:filePath4 name:@"file4" error:nil];
        [formData appendPartWithFileURL:filePath5 name:@"file5" error:nil];
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
    
    NSString *tag = [NSString stringWithFormat:@"%d",radio.tag];
    if ([groupId isEqualToString:@"accountType"]){

        self.accountType = tag;

    }else if ([groupId isEqualToString:@"isPrivate"]){
        self.isPrivate = tag;

    }
    
    
}

#pragma mark UIImagePickerControllerDelegate

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    NSLog(@"imagePickerControllerDidCancel");
    
    [picker dismissViewControllerAnimated:YES completion:nil];
}



- (void)imagePickerController:(UIImagePickerController *)picker
        didFinishPickingImage:(UIImage *)image
                  editingInfo:(NSDictionary *)editingInfo{
    
    NSLog(@"didFinishPickingImage");
    
    //当图片不为空时显示图片并保存图片
    if (image != nil) {
        //图片显示在按钮上
        [self.CardPhotoFront setBackgroundImage:image forState:UIControlStateNormal];
        
        //把图片转成NSData类型的数据来保存文件
        NSData *data;
        
        
        data = UIImageJPEGRepresentation(image, 1.0);
        
        
        //UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil);
        
        //保存
//        self.imagePath4 = [_imageDocPath stringByAppendingPathComponent:@"4.jpg"];
//        [[NSFileManager defaultManager] createFileAtPath:self.imagePath4 contents:data attributes:nil];

        
        
    }
    
    
    [picker dismissViewControllerAnimated:YES completion:nil];
    
    
    
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

#pragma mark - wdPickViewDelegate
-(void)toolBarDoneBtnHaveClicked:(WDPickView *)pickView resultString:(NSString *)resultString shengfen:(NSString *)shengfen{
    
    
    NSLog(@"+++++++++++++++%@",resultString);
    self.city.text = [resultString substringToIndex:[resultString length] -5];
    self.diqubianma.text  = [resultString substringFromIndex:[resultString length] -4];
    self.province.text = shengfen;
    
    

    [KUserDefault setObject:self.province.text forKey:gerenprovince];
    
    [KUserDefault setObject:self.city.text forKey:gerencity];
    
        //NSLog(@"self.area.tag:%d",self.area.tag);
    
        //为了解决跳转时，如果焦点停留在所在地区上，奔溃的bug
    [self.diqubianma endEditing:YES];
}


- (void)closeKeBoard{
    
    [self setViewMovedUp:NO];
}

#pragma mark UITextFieldDelegate

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    
    if (textField.tag == 1) {
            //        [KUserDefault setObject:textField.text forKey:qiyeKaihuhangquancheng];
    }else if (textField.tag == 2){
        
            //        [KUserDefault setObject:textField.text forKey:qiyeSuozaisheng];
    }else if (textField.tag == 3){
        
            //        [KUserDefault setObject:textField.text forKey:qiyeSuozaishi];
    }
        
            //        [KUserDefault setObject:textField.text forKey:qiyeLianhanghao];
        [self setViewMovedUp:YES];

    
        //    [KUserDefault synchronize];
    
    
    return YES;
}



- (void)textFieldDidEndEditing:(UITextField *)textField{
    
    /**
     *  self.diqubianma.delegate = self;
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
     
     self.shanghuyingyedizhi.delegate = self;
     self.shanghuyingyedizhi.tag = 9;
     */
    
    if (textField.tag == 1) {
        [KUserDefault setObject:textField.text forKey:gerendiqubianma];
    }else if (textField.tag == 4){
        
        [KUserDefault setObject:textField.text forKey:gerensettleBank];
    }else if (textField.tag == 5){
        
        [KUserDefault setObject:textField.text forKey:gerenbankName];
    }else if (textField.tag == 6){
        
        [KUserDefault setObject:textField.text forKey:gerenbankBranch];
    }else if (textField.tag == 7){
        
        [KUserDefault setObject:textField.text forKey:gerensettleAccno];
    }else if (textField.tag == 8){
        
        [KUserDefault setObject:textField.text forKey:gerenaccName];
    }else if (textField.tag == 9){
        
        [KUserDefault setObject:textField.text forKey:gerenshanghuyingyedizhi];
    }
    
    [KUserDefault synchronize];
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    
    if (textField.tag == 4) {
        if (range.location >= 12) {
            return NO;
        }
    }
    if (textField.tag == 8) {
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
