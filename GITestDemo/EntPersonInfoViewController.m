//
//  EntPersonInfoViewController.m
//  GITestDemo
//
//  Created by 吴狄 on 15/6/8.
//  Copyright (c) 2015年 Kyson. All rights reserved.
//


#import "EntPersonInfoViewController.h"
#import "UIUtils.h"
#import "CanKaoViewController.h"
#import "MiniPosSDK.h"
#import "ConnectDeviceViewController.h"

#define kOFFSET_FOR_KEYBOARD 140
#define kOFFSET_FOR_KEYBOARD_PAD 140


@interface EntPersonInfoViewController ()
{
    UIButton *_lastPressedBtn;
    NSString *_imageDocPath;
    NSData *_data1;
    NSData *_data2;
    
}
@property (nonatomic, strong) UIDatePicker *datePicker;
@end

@implementation EntPersonInfoViewController



- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self loadHistory];
    
    [self initBLESDK];
    [self _initViews];
    [self setUpDatePicker];
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(closeKeBoard) name:UIKeyboardDidHideNotification object:nil];
}

- (void)closeKeBoard{
    
    [self setViewMovedUp:NO];
}

- (void)dealloc{
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardDidHideNotification object:nil];
}

- (void)loadHistory{

    
    self.password.text = [KUserDefault objectForKey:qiyeMima];
    self.fadingdaibiaoren.text = [KUserDefault objectForKey:qiyeFadingdaibiaoren];
    self.shoujihao.text = [KUserDefault objectForKey:qiyeShoujihao];
    self.lianxiren.text = [KUserDefault objectForKey:qiyeLianxiren];
    self.lianxirendianhua.text = [KUserDefault objectForKey:qiyeLianxirenDianhua];
    self.ID.text = [KUserDefault objectForKey:qiyeID];
    self.certExpdate.text = [KUserDefault objectForKey:qiyeCertExpdate];
    
    _data1 = [KUserDefault objectForKey:qiyeImage1];
    [self.IDPhotoFront setBackgroundImage:[UIImage imageWithData:_data1] forState:UIControlStateNormal];
    
    _data2 = [KUserDefault objectForKey:qiyeImage2];
    [self.IDPhotoBack setBackgroundImage:[UIImage imageWithData:_data2] forState:UIControlStateNormal];
    
}

- (void)setUpDatePicker{
    
    UIDatePicker *datepick = [[UIDatePicker alloc] init];
    _datePicker = datepick;
    [datepick setLocale:[NSLocale localeWithLocaleIdentifier:@"zh-CN"]];
    datepick.minimumDate = [NSDate date];
    
    datepick.datePickerMode=UIDatePickerModeDate;
    
    self.certExpdate.inputView = datepick;
    
    UIToolbar *toolbar=[[UIToolbar alloc]init];
    
    toolbar.barTintColor=[UIColor brownColor];
    
    toolbar.frame=CGRectMake(0, 0, 320, 44);
    
        //给工具条添加按钮
    UIBarButtonItem *item0=[[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    
    UIBarButtonItem *item1=[[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    
    UIBarButtonItem *item2=[[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    UIBarButtonItem *item3=[[UIBarButtonItem alloc]initWithTitle:@"完成" style:UIBarButtonItemStylePlain target:self action:@selector(DateClick)];
    
    toolbar.items = @[item0, item1, item2, item3];
        //    toolbar.items = @[item3];
        //设置文本输入框键盘的辅助视图
    self.certExpdate.inputAccessoryView=toolbar;
}

- (void)DateClick{
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyyMMdd"];
    NSString *str = [formatter stringFromDate:self.datePicker.date];
    self.certExpdate.text = str;
    [self.view endEditing:YES];
}

- (void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    
    NSString *deviceType = [[NSUserDefaults standardUserDefaults]stringForKey:kDeviceType];
    NSString *sn = [[NSUserDefaults standardUserDefaults] objectForKey:kMposG1SN];
    
    if ( [deviceType isEqualToString:@"H1"])
    {
        NSString *H1 = [[NSUserDefaults standardUserDefaults] objectForKey:kH1SN];
        
        self.G1SNTextField.text = H1;
        
    }else{
        
        self.G1SNTextField.text = sn;
    }
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
//    label1.textColor = [UIColor blackColor];
//    label2.textColor = [UIColor grayColor];
//    label3.textColor = [UIColor grayColor];
//    
//    self.navigationItem.titleView = titleView;
    self.navigationItem.title = @"企业信息";
    
//    self.password.delegate = self;
//    self.lianxiren.delegate = self;
//    self.ID.delegate = self;

    self.password.delegate = self;
    self.password.tag = 1;
    
    self.fadingdaibiaoren.delegate = self;
    self.fadingdaibiaoren.tag = 2;
    
    self.shoujihao.delegate = self;
    self.shoujihao.tag = 3;
    
    self.lianxiren.delegate = self;
    self.lianxiren.tag = 4;
    
    self.lianxirendianhua.delegate = self;
    self.lianxirendianhua.tag = 5;
    
    self.ID.delegate = self;
    self.ID.tag = 6;
    
    self.certExpdate.delegate = self;
    self.certExpdate.tag = 7;
    
    self.G1SNTextField.delegate = self;
    self.G1SNTextField.tag = 8;
    
    //获取Documents文件夹目录
    NSArray *path = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentPath = [path objectAtIndex:0];
    //指定新建文件夹路径
    _imageDocPath = [documentPath stringByAppendingPathComponent:@"ImageFile_q"];
    //创建ImageFile文件夹
    [[NSFileManager defaultManager] createDirectoryAtPath:_imageDocPath withIntermediateDirectories:YES attributes:nil error:nil];
    
    
    self.imagePath1 = @"";
    self.imagePath2 = @"";
//    self.imagePath3 = @"";
//    self.imagePath5 = @"";
//    self.imagePath10 = @"";
    
    NSString *deviceType = [[NSUserDefaults standardUserDefaults]stringForKey:kDeviceType];
    
    if ( [deviceType isEqualToString:@"H1"])
    {
        
        self.G1SNLabel.text = @" H1设备码";
        self.G1SNButton.hidden = YES;
        
    }
}


- (IBAction)back:(id)sender {
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)changeImage:(UIButton*)sender {
    
    _lastPressedBtn = sender;
    
    self.actionSheet = [[UIActionSheet alloc]initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"从相册获取",@"拍照",nil];
    
    
    [self.actionSheet showInView:self.view];
    
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
- (IBAction)getsn:(id)sender {
    
    
    [self.view endEditing:YES];
    if(MiniPosSDKDeviceState()<0){
        
        
        UIAlertView *alert1 = [[UIAlertView alloc]initWithTitle:@"设备未连接" message:@"点击跳转设备连接界面" delegate:self cancelButtonTitle:@"确认" otherButtonTitles:nil, nil];
        
        [alert1 show];
        
        return;
    }
    
    MiniPosSDKGetDeviceInfoCMD();
    
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

- (IBAction)next:(id)sender {
    
    if (DEBUG) {
        [self performSegueWithIdentifier:@"NEXT" sender:nil];
        return;
    }
    
    //校验信息
    NSString *phoneNo = [[NSUserDefaults standardUserDefaults]objectForKey:kSignUpPhoneNo];
    
    
    if (![UIUtils isCorrectPassword:self.password.text]) {
        [self showTipView:@"请输入正确的密码"];
        return;
    }else if ([UIUtils isEmptyString:self.fadingdaibiaoren.text]||[self.fadingdaibiaoren.text length] > 10) {
        [self showTipView:@"请输入法定代表人"];
        return;
    }else if (![self.shoujihao.text isEqualToString:phoneNo]){
        
        [self showTipView:@"输入的手机号与注册时的手机号不一致"];
        return;
    }else if ([UIUtils isEmptyString:self.lianxiren.text]||[self.lianxiren.text length] > 10) {
        [self showTipView:@"请输入联系人"];
        return;
    }else if (![UIUtils isMobileNumber:self.lianxirendianhua.text]) {

        [self showTipView:@"请输入联系人电话"];
        return;
    }else if (![UIUtils isCorrectID:self.ID.text]) {
        [self showTipView:@"请输入正确的身份证号码"];
        return;
    }else if ([UIUtils isEmptyString:self.certExpdate.text]) {
        [self showTipView:@"请输入正确的身份证有效期"];
        return;
    }else if ([UIUtils isEmptyString:self.G1SNTextField.text]) {
        [self showTipView:@"请填写SN号"];
        return;
    }
    else if (!_data1){
        [self showTipView:@"请选择身份证正面照"];
        return;
    }else if (!_data2){
        [self showTipView:@"请选择身份证反面照"];
        return;
    }
    [[NSUserDefaults standardUserDefaults] setObject:[NSString stringWithFormat:@"秒到支付个人%@（扣率）",self.lianxiren.text] forKey:kShangHuName];
    //跳转
    [self performSegueWithIdentifier:@"NEXT" sender:nil];
    
    
    
}

- (void)recvMiniPosSDKStatus{
    [super recvMiniPosSDKStatus];
    
    if ([self.statusStr isEqualToString:@"获取设备信息成功"]) {
        
        
        
        NSString *sn = [NSString stringWithFormat:@"%s",MiniPosSDKGetDeviceID()];
        //[self.G1SN setTitle:sn forState:UIControlStateNormal];
        self.G1SNTextField.text == sn;
        
        
        [[NSUserDefaults standardUserDefaults] setObject:sn forKey:kMposG1SN];
        [[NSUserDefaults standardUserDefaults]synchronize];
        
//
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
        [_lastPressedBtn setBackgroundImage:image forState:UIControlStateNormal];
        
        //把图片转成NSData类型的数据来保存文件
        NSData *data;
        //判断图片是不是png格式的文件
        
        data = UIImageJPEGRepresentation(image, 1.0);
        
        
        //UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil);
        
        
        //保存
        if (_lastPressedBtn == self.IDPhotoFront) {
//            self.imagePath1 = [_imageDocPath stringByAppendingPathComponent:@"1.jpg"];
//            [[NSFileManager defaultManager] createFileAtPath:self.imagePath1 contents:data attributes:nil];
            _data1 = data;
            
            [KUserDefault setObject:data forKey:qiyeImage1];
            
            
        }else if (_lastPressedBtn == self.IDPhotoBack){
//            self.imagePath2 = [_imageDocPath stringByAppendingPathComponent:@"2.jpg"];
//            [[NSFileManager defaultManager] createFileAtPath:self.imagePath2 contents:data attributes:nil];
            _data2 = data;
            [KUserDefault setObject:data forKey:qiyeImage2];
        }
        
        
        [KUserDefault synchronize];
        
        
    }
    
    
    [picker dismissViewControllerAnimated:YES completion:nil];
    
    
    
}
#pragma mark UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    
    [self dismissAction];
    
    return YES;
}
- (void)textFieldDidBeginEditing:(UITextField *)textField{
    
    if (textField.tag == 1 || textField.tag == 2 || textField.tag == 3 || textField.tag == 4) {
        
    }else{
        
        [self setViewMovedUp:YES];
    }
}

- (void)textFieldDidEndEditing:(UITextField *)textField{

    if (textField.tag == 1) {
        [KUserDefault setObject:textField.text forKey:qiyeMima];
    }else if (textField.tag == 2){
        
        [KUserDefault setObject:textField.text forKey:qiyeFadingdaibiaoren];
    }else if (textField.tag == 3){
        
        [KUserDefault setObject:textField.text forKey:qiyeShoujihao];
    }else if (textField.tag == 4){
        
        [KUserDefault setObject:textField.text forKey:qiyeLianxiren];
    }else if (textField.tag == 5){
        
        [KUserDefault setObject:textField.text forKey:qiyeLianxirenDianhua];
    }else if (textField.tag == 6){
        
        [KUserDefault setObject:textField.text forKey:qiyeID];
    }else if (textField.tag == 7){
        
        [KUserDefault setObject:textField.text forKey:qiyeCertExpdate];
    }else if (textField.tag == 8){
        
        [KUserDefault setObject:textField.text forKey:kH1SN];
    }
    
    [KUserDefault synchronize];
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    
    if (textField.tag == 6) {
        if (range.location > 20) {
            return NO;
        }
    }
    return YES;
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    if (buttonIndex == 0) {
        ConnectDeviceViewController *cdvc = [self.storyboard instantiateViewControllerWithIdentifier:@"CD"];
        [self.navigationController pushViewController:cdvc animated:YES];
        
    }
}



- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    
    [self.view endEditing:YES];
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

- (void)dismissAction{
    
    [self setViewMovedUp:false];
    [self.view endEditing:YES];
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
