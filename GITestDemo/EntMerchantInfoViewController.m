//
//  EntMerchantInfoViewController.m
//  GITestDemo
//
//  Created by 吴狄 on 15/6/8.
//  Copyright (c) 2015年 Kyson. All rights reserved.
//

#import "EntMerchantInfoViewController.h"
#import "ConnectDeviceViewController.h"
@interface EntMerchantInfoViewController (){
    UIButton *_lastPressedBtn;
    NSString *_imageDocPath;
    NSData *_data6;
    NSData *_data7;
    NSData *_data8;
    NSData *_data9;
    NSData *_data10;
    NSData *_data11;
}

@end

@implementation EntMerchantInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self loadHistory];
    
    [self initBLESDK];
    [self initViews];
}

- (void)loadHistory{
    
    
    self.yingyedizhi.text = [KUserDefault objectForKey:qiyeShanghuyingyedizhi];

    _data6 = [KUserDefault objectForKey:qiyeImage6];
    [self.ZuZhiJiGouDaiMaZheng setBackgroundImage:[UIImage imageWithData:_data6] forState:UIControlStateNormal];
    
    _data7 = [KUserDefault objectForKey:qiyeImage7];
    [self.FangWuZuLinHeTongZheng setBackgroundImage:[UIImage imageWithData:_data7] forState:UIControlStateNormal];
    
    _data8 = [KUserDefault objectForKey:qiyeImage8];
    [self.ShuiWuDengJiZheng setBackgroundImage:[UIImage imageWithData:_data8] forState:UIControlStateNormal];
    
    _data9 = [KUserDefault objectForKey:qiyeImage9];
    [self.YingYeZhiZhaoZheng setBackgroundImage:[UIImage imageWithData:_data9] forState:UIControlStateNormal];
    
    _data10 = [KUserDefault objectForKey:qiyeImage10];
    [self.xianchangzhaopian setBackgroundImage:[UIImage imageWithData:_data10] forState:UIControlStateNormal];
    
    _data11 = [KUserDefault objectForKey:qiyeImage11];
    [self.kaihuxukezheng setBackgroundImage:[UIImage imageWithData:_data11] forState:UIControlStateNormal];
    
}



- (IBAction)viewChick:(id)sender {
    [self.view endEditing:YES];
}

-(void)initViews{
    
    
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
//    label2.textColor = [UIColor blackColor];
//    label3.textColor = [UIColor grayColor];
//    
//    self.navigationItem.titleView = titleView;
    self.navigationItem.title = @"商户信息";
//    self.area.delegate = self;
//    self.address.delegate = self;
    
    WDPickView *pickView = [[WDPickView alloc]initPickViewWithPlistName:@"Address"];
    pickView.delegate = self;
//    self.area.inputView = pickView;
    self.yingyedizhi.delegate = self;
    
    //获取Documents文件夹目录
    NSArray *path = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentPath = [path objectAtIndex:0];
    //指定新建文件夹路径
    _imageDocPath = [documentPath stringByAppendingPathComponent:@"ImageFile_q"];
    //创建ImageFile文件夹
    [[NSFileManager defaultManager] createDirectoryAtPath:_imageDocPath withIntermediateDirectories:YES attributes:nil error:nil];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)next:(UIButton *)sender
{
    if (DEBUG) {
        [self performSegueWithIdentifier:@"NEXT" sender:nil];
        return;
    }
    
    //校验信息
    
    if ([UIUtils isEmptyString:self.yingyedizhi.text]||[self.yingyedizhi.text length] > 30) {
        [self showTipView:@"请输入正确的经营地址"];
        return;
    }else if(!_data6){
        [self showTipView:@"请选择组织机构代码证照"];
        return;
    }else if(!_data7){
        [self showTipView:@"请选择房屋租赁合同照"];
        return;
    }else if(!_data8){
        [self showTipView:@"请选择税务登记证照"];
        return;
    }else if(!_data9){
        [self showTipView:@"请选择营业执照"];
        return;
    }else if(!_data10){
        [self showTipView:@"请选择现场照片"];
        return;
    }else if(!_data11){
        [self showTipView:@"请选择开户许可证"];
        return;
    }
    
    
    //跳转
    [self performSegueWithIdentifier:@"NEXT" sender:nil];
    
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

//- (IBAction)getSN:(id)sender {
//    
//    
//    [self.view endEditing:YES];
//    if(MiniPosSDKDeviceState()<0){
//        
//        
//        UIAlertView *alert1 = [[UIAlertView alloc]initWithTitle:@"设备未连接" message:@"点击跳转设备连接界面" delegate:self cancelButtonTitle:@"确认" otherButtonTitles:nil, nil];
//        
//        [alert1 show];
//        
//        return;
//    }
//    
//    MiniPosSDKGetDeviceInfoCMD();
//}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    if (buttonIndex == 0) {
        ConnectDeviceViewController *cdvc = [self.storyboard instantiateViewControllerWithIdentifier:@"CD"];
        [self.navigationController pushViewController:cdvc animated:YES];
        
    }
}
//- (void)recvMiniPosSDKStatus{
//    [super recvMiniPosSDKStatus];
//    
//    if ([self.statusStr isEqualToString:@"获取设备信息成功"]) {
//        
//        
//        
//        NSString *sn = [NSString stringWithFormat:@"%s",MiniPosSDKGetDeviceID()];
//        self.sn.text = sn;
//        
//        [[NSUserDefaults standardUserDefaults] setObject:sn forKey:kMposG1SN];
//        [[NSUserDefaults standardUserDefaults]synchronize];
//    }
//}

//-(void)toolBarDoneBtnHaveClicked:(WDPickView *)pickView resultString:(NSString *)resultString shengfen:(NSString *)shengfen{
//    
//    
//    self.area.text = [resultString substringToIndex:[resultString length] -5];
//    self.areaCode  = [resultString substringFromIndex:[resultString length] -4];
//    
//    //NSLog(@"self.area.tag:%d",self.area.tag);
//    
//    //为了解决跳转时，如果焦点停留在所在地区上，奔溃的bug
//    [self.area resignFirstResponder];
//}

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
        if (_lastPressedBtn == self.ZuZhiJiGouDaiMaZheng) {
//            self.imagePath6 = [_imageDocPath stringByAppendingPathComponent:@"6.jpg"];
//            [[NSFileManager defaultManager] createFileAtPath:self.imagePath6 contents:data attributes:nil];
            _data6  =data;
            [KUserDefault setObject:data forKey:qiyeImage6];
        }else if (_lastPressedBtn == self.FangWuZuLinHeTongZheng){
//            self.imagePath7 = [_imageDocPath stringByAppendingPathComponent:@"7.jpg"];
//            [[NSFileManager defaultManager] createFileAtPath:self.imagePath7 contents:data attributes:nil];
            _data7 = data;
            [KUserDefault setObject:data forKey:qiyeImage7];
        }else if (_lastPressedBtn == self.ShuiWuDengJiZheng){
//            self.imagePath8 = [_imageDocPath stringByAppendingPathComponent:@"8.jpg"];
//            [[NSFileManager defaultManager] createFileAtPath:self.imagePath8 contents:data attributes:nil];
            _data8 = data;
            [KUserDefault setObject:data forKey:qiyeImage8];
        }else if (_lastPressedBtn == self.YingYeZhiZhaoZheng){
//            self.imagePath9 = [_imageDocPath stringByAppendingPathComponent:@"9.jpg"];
//            [[NSFileManager defaultManager] createFileAtPath:self.imagePath9 contents:data attributes:nil];
            _data9 = data;
            [KUserDefault setObject:data forKey:qiyeImage9];
        }else if (_lastPressedBtn == self.xianchangzhaopian){
//            self.xianchangzhaopianImagePath = [_imageDocPath stringByAppendingPathComponent:@"10.jpg"];
//            [[NSFileManager defaultManager] createFileAtPath:self.imagePath9 contents:data attributes:nil];
            _data10 = data;
            [KUserDefault setObject:data forKey:qiyeImage10];
        }else if (_lastPressedBtn == self.kaihuxukezheng){
//            self.KaiHuKeImagePath = [_imageDocPath stringByAppendingPathComponent:@"11.jpg"];
//            [[NSFileManager defaultManager] createFileAtPath:self.imagePath9 contents:data attributes:nil];
            _data11 = data;
            [KUserDefault setObject:data forKey:qiyeImage11];
        }
        
        [KUserDefault synchronize];
    }
    
    
    [picker dismissViewControllerAnimated:YES completion:nil];
    
    
    
}

#pragma mark -- UITextFieldDelegate

-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    
    [textField resignFirstResponder];
    return YES;
}


- (void)textFieldDidEndEditing:(UITextField *)textField{
    

    [KUserDefault setObject:textField.text forKey:qiyeShanghuyingyedizhi];
   
    
    [KUserDefault synchronize];
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
