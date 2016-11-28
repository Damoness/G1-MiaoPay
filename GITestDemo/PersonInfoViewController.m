//
//  PersonInfoViewController.m
//  GITestDemo
//
//  Created by 吴狄 on 15/5/12.
//  Copyright (c) 2015年 Kyson. All rights reserved.
//

#import "PersonInfoViewController.h"
#import "UIUtils.h"
#import "CanKaoViewController.h"
#import "MiniPosSDK.h"
#import "ConnectDeviceViewController.h"
@interface PersonInfoViewController ()
{
    UIButton *_lastPressedBtn;
    NSString *_imageDocPath;
    NSData *_data1;
    NSData *_data2;
    NSData *_data3;
    NSData *_data4;
    NSData *_data5;

}

#define kOFFSET_FOR_KEYBOARD 140
#define kOFFSET_FOR_KEYBOARD_PAD 140

@property (nonatomic, strong) UIDatePicker *datePicker;
@end

@implementation PersonInfoViewController



- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadHistory];
    
    [self initBLESDK];
    [self _initViews];

    
//    self.imagePath3 = [_imageDocPath stringByAppendingPathComponent:@"3.jpg"];
//    [[NSFileManager defaultManager] createFileAtPath:self.imagePath3 contents:data attributes:nil];
    
        //            self.imagePath10 = [_imageDocPath stringByAppendingPathComponent:@"10.jpg"];
    self.imagePath10 = [_imageDocPath stringByAppendingPathComponent:@"10.jpg"];
    UIImage *image = [UIImage imageNamed:@"拍照参考模板"];
    NSData *data = UIImageJPEGRepresentation(image, 0.4);
    [[NSFileManager defaultManager] createFileAtPath:self.imagePath10 contents:data attributes:nil];
    
    
    [self setUpDatePicker];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(closeKeBoard) name:UIKeyboardDidHideNotification object:nil];
}

- (void)closeKeBoard{
    
    [self setViewMovedUp:NO];
}

- (void)textFieldDidBeginEditing:(UITextField *)textField{
    
    if (textField.tag == 1 || textField.tag == 2 || textField.tag == 3 || textField.tag == 4) {
        
    }else{
        
        [self setViewMovedUp:YES];
    }
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

- (void)loadHistory{
    
 
    self.password.text = [KUserDefault objectForKey:gerenMima];
    self.yonghuxingming.text = [KUserDefault objectForKey:gerenName];
    self.shoujihao.text = [KUserDefault objectForKey:gerenShoujihao];
    self.ID.text = [KUserDefault objectForKey:gerenID];
    self.certExpdate.text = [KUserDefault objectForKey:gerenCertExpdate];

    _data1 = [KUserDefault objectForKey:gerenImage1];
    [self.IDPhotoFront setBackgroundImage:[UIImage imageWithData:_data1] forState:UIControlStateNormal];
    
    _data2 = [KUserDefault objectForKey:gerenImage2];
    [self.IDPhotoBack setBackgroundImage:[UIImage imageWithData:_data2] forState:UIControlStateNormal];
    
    _data3 = [KUserDefault objectForKey:gerenImage3];
    [self.IDPhotoAndPerson setBackgroundImage:[UIImage imageWithData:_data3] forState:UIControlStateNormal];
    
    _data4 = [KUserDefault objectForKey:gerenImage4];
    [self.yinhangkaFront setBackgroundImage:[UIImage imageWithData:_data4] forState:UIControlStateNormal];
    
    _data5 = [KUserDefault objectForKey:gerenImage5];
    [self.yinghangkaBack setBackgroundImage:[UIImage imageWithData:_data5] forState:UIControlStateNormal];
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

//    self.navigationItem.titleView = titleView;
    self.navigationItem.title = @"个人信息";
    
    
    
    self.password.delegate = self;
    self.password.tag = 1;
    
    self.yonghuxingming.delegate = self;
    self.yonghuxingming.tag = 2;
    
    self.shoujihao.delegate = self;
    self.shoujihao.tag = 3;
    
    self.ID.delegate = self;
    self.ID.tag = 4;
    
    self.certExpdate.delegate = self;
    self.certExpdate.tag = 5;
    
    self.G1SNTextField.delegate = self;
    self.G1SNTextField.tag = 6;
    
    //获取Documents文件夹目录
    NSArray *path = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentPath = [path objectAtIndex:0];
    //指定新建文件夹路径
    _imageDocPath = [documentPath stringByAppendingPathComponent:@"ImageFile_g"];
    //创建ImageFile文件夹
    [[NSFileManager defaultManager] createDirectoryAtPath:_imageDocPath withIntermediateDirectories:YES attributes:nil error:nil];

    
    self.imagePath1 = @"";
    self.imagePath2 = @"";
    self.imagePath3 = @"";
    self.imagePath10 = @"";
    self.CardBackPath = @"";
    self.CardFrontPath = @"";
    
    
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

- (IBAction)canzhaomuban:(id)sender {
    
    CanKaoViewController *cankao = [[CanKaoViewController alloc] init];
    [self.navigationController pushViewController:cankao animated:YES];
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
- (IBAction)huoquSN:(id)sender {
    
    
    [self.view endEditing:YES];
    if(MiniPosSDKDeviceState()<0){
        
        
        UIAlertView *alert1 = [[UIAlertView alloc]initWithTitle:@"设备未连接" message:@"点击跳转设备连接界面" delegate:self cancelButtonTitle:@"确认" otherButtonTitles:nil, nil];
        
        [alert1 show];
        
        return;
    }
    
    MiniPosSDKGetDeviceInfoCMD();
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    if (buttonIndex == 0) {
        ConnectDeviceViewController *cdvc = [self.storyboard instantiateViewControllerWithIdentifier:@"CD"];
        [self.navigationController pushViewController:cdvc animated:YES];
        
    }
}

- (IBAction)next:(id)sender {
    
    if (DEBUG) {
       [self performSegueWithIdentifier:@"NEXT" sender:nil];
        return;
    }
    
    //校验信息
    NSString *phoneNo = [[NSUserDefaults standardUserDefaults]objectForKey:kSignUpPhoneNo];
    
    
    if (![UIUtils isCorrectPassword:self.password.text]) {
        [self showTipView:@"请输入6-20位数字或字母为密码"];
        return;
    }else if ([UIUtils isEmptyString:self.yonghuxingming.text]||[self.yonghuxingming.text length] > 10) {
        [self showTipView:@"用户姓名不能为空"];
        return;
    }else if (![self.shoujihao.text isEqualToString:phoneNo]){
        
        [self showTipView:@"输入的手机号与注册时的手机号不一致"];
        return;
    }else if (![UIUtils isCorrectID:self.ID.text]) {
        [self showTipView:@"请输入正确的身份证号码"];
        return;
    }else if ([UIUtils isEmptyString:self.certExpdate.text]) {
        [self showTipView:@"请输入正确的身份证有效期"];
        return;
    }else if (!_data1){
        [self showTipView:@"请选择身份证正面照"];
        return;
    }else if (!_data2){
        [self showTipView:@"请选择身份证反面照"];
        return;
    }else if (!_data3){
        [self showTipView:@"请选择法人持身份证照"];
        return;
    }else if ([UIUtils isEmptyString:self.G1SNTextField.text]){
        [self showTipView:@"请填写SN号"];
        return;
    }else if (!_data4){
        
        [self showTipView:@"请选择银行卡正面照片"];
        return;
    }else if (!_data5){
        
        [self showTipView:@"请选择银行卡反面照片"];
        return;
    }
    
    
    [[NSUserDefaults standardUserDefaults] setObject:[NSString stringWithFormat:@"秒到支付企业%@（封顶）",self.yonghuxingming.text] forKey:kShangHuName];
    //跳转
    [self performSegueWithIdentifier:@"NEXT" sender:nil];
    
    
    
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
            
            _data1 = data;
            [KUserDefault setObject:data forKey:gerenImage1];
        }else if (_lastPressedBtn == self.IDPhotoBack){
            
          _data2 = data;
            [KUserDefault setObject:data forKey:gerenImage2];
        }else if (_lastPressedBtn == self.IDPhotoAndPerson){
            
            _data3 = data;
            [KUserDefault setObject:data forKey:gerenImage3];
        }else if (_lastPressedBtn == self.yinhangkaFront){
            
            _data4 = data;
            [KUserDefault setObject:data forKey:gerenImage4];
        }else if (_lastPressedBtn == self.yinghangkaBack){

            _data5 = data;
            [KUserDefault setObject:data forKey:gerenImage5];
        }
        
        [KUserDefault synchronize];
        
        
       
    }
    
    
    [picker dismissViewControllerAnimated:YES completion:nil];
    
    
    
}



- (void)recvMiniPosSDKStatus{
    [super recvMiniPosSDKStatus];
    
    if ([self.statusStr isEqualToString:@"获取设备信息成功"]) {
        
        
        
        NSString *sn = [NSString stringWithFormat:@"%s",MiniPosSDKGetDeviceID()];
//        [self.G1Sn setTitle:sn forState:UIControlStateNormal];

        self.G1SNTextField.text = sn;
        
        
        [[NSUserDefaults standardUserDefaults] setObject:sn forKey:kMposG1SN];
        [[NSUserDefaults standardUserDefaults]synchronize];
    }
}



#pragma mark UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    
    [textField resignFirstResponder];
    
    return YES;
}
- (void)textFieldDidEndEditing:(UITextField *)textField{
    

    
    if (textField.tag == 1) {
        [KUserDefault setObject:textField.text forKey:gerenMima];
    }else if (textField.tag == 2){
        
        [KUserDefault setObject:textField.text forKey:gerenName];
    }else if (textField.tag == 3){
        
        [KUserDefault setObject:textField.text forKey:gerenShoujihao];
    }else if (textField.tag == 4){
        
        [KUserDefault setObject:textField.text forKey:gerenID];
    }else if (textField.tag == 5){
        
        [KUserDefault setObject:textField.text forKey:gerenCertExpdate];
    }else if (textField.tag == 6){
        
        [KUserDefault setObject:textField.text forKey:kH1SN];
    }
    
    [KUserDefault synchronize];
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    
    if (textField.tag == 4) {
        if (range.location > 20) {
            return NO;
        }
    }
    return YES;
}


-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    
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
