//
//  PersonInfoViewController.h
//  GITestDemo
//
//  Created by 吴狄 on 15/5/12.
//  Copyright (c) 2015年 Kyson. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RootViewController.h"
#import "BaseViewController.h"
@interface PersonInfoViewController : BaseViewController <UIImagePickerControllerDelegate,UINavigationControllerDelegate,UIActionSheetDelegate,UITextFieldDelegate>

@property (strong, nonatomic) IBOutlet UITextField *password; //登录密码
@property (weak, nonatomic) IBOutlet UITextField *yonghuxingming;//用户姓名
@property (weak, nonatomic) IBOutlet UITextField *shoujihao;//手机号
@property (strong, nonatomic) IBOutlet UITextField *ID; //身份证
@property (strong, nonatomic) IBOutlet UITextField *certExpdate; //身份证有效期


@property (strong, nonatomic) IBOutlet UIButton *IDPhotoFront; //身份证正面
@property (strong, nonatomic) IBOutlet UIButton *IDPhotoBack;  //身份证背面
@property (strong, nonatomic) IBOutlet UIButton *IDPhotoAndPerson; //法人手持正面
//@property (strong, nonatomic) IBOutlet UIButton *XianChangZhaoPian; //现场照片
@property (weak, nonatomic) IBOutlet UIButton *yinhangkaFront;
@property (weak, nonatomic) IBOutlet UIButton *yinghangkaBack;
//@property (weak, nonatomic) IBOutlet UIButton *G1Sn;


//@property (weak, nonatomic) IBOutlet UITextField *G1SNTextField;
//@property (weak, nonatomic) IBOutlet UILabel *G1SNLabel;
//@property (weak, nonatomic) IBOutlet UIButton *G1SNButton;

@property (weak, nonatomic) IBOutlet UILabel *G1SNLabel;
@property (weak, nonatomic) IBOutlet UITextField *G1SNTextField;
@property (weak, nonatomic) IBOutlet UIButton *G1SNButton;

@property (strong,nonatomic) UIActionSheet *actionSheet;

@property (strong,nonatomic) NSString *imagePath1; //身份证正面路径
@property (strong,nonatomic) NSString *imagePath2; //身份证背面路径
@property (strong,nonatomic) NSString *imagePath3; //法人手持正面路径
@property (nonatomic, copy) NSString *CardFrontPath;//银行卡正面路径
@property (nonatomic, copy) NSString *CardBackPath;//银行卡背面路径
@property (strong,nonatomic) NSString *imagePath10; //现场照片
@end
