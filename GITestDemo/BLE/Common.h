//
//  Common.h
//  GITest
//
//  Created by Femto03 on 14/11/17.
//  Copyright (c) 2014年 Kyson. All rights reserved.
//

#ifndef GITest_Common_h
#define GITest_Common_h

#define kScreenHeight [UIScreen mainScreen].bounds.size.height
#define kScreenWidth [UIScreen mainScreen].bounds.size.width
#define isIPhone5 [UIScreen mainScreen].bounds.size.height > 480 ? YES:NO
#define isIOS_5 (([[[UIDevice currentDevice] systemVersion] floatValue] <= 6.0)? (YES):(NO))
#define isIOS_7 (([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0)? (YES):(NO))
#define isIOS_8 (([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0)? (YES):(NO))

//通过三色值获取颜色对象
#define rgb(r,g,b,a) [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:a]


//新界面的主颜色
#define KMyBlueColor [UIColor colorWithRed:25/255.0 green:99/255.0 blue:189/255.0 alpha:1]


#import "BleManager.h"

#define KUUIDService @"49535343-FE7D-4AE5-8FA9-9FAFD205E455"
#define kUUIDRead @"49535343-1E4D-4BD9-BA61-23C647249616"
#define kUUIDWrite @"49535343-8841-43F4-A8D4-ECBE34729BB3"

#define KUUIDService1 @"FFFF"
#define kUUIDRead1 @"FF01"
#define kUUIDWrite1 @"FF02"

#define kDidDiscoverDevice @"didDiscoverDevice"
#define kDidConnectDevice @"didConnectDevice"

#define kLastConnectedDevice @"lastConnectedDevice"

#define KLastPingZhengHao @"lastPingZhengHao"
#define KLastJiaoYiJinE @"lastJiaoYiJinE"

//保存本地版本信息不用每次都获取
#define Kpos_kernel @"pos_kernel"
#define Kpos_task @"pos_task"

#define kShangHuName @"shanghuName"  
#define kShangHuEditor @"shangHuEditor"
#define kZhongDuanEditor @"zhongDuanEditor"
#define kCaoZhuoYuanEditor @"caoZhuoYuanEditor"
#define kHostEditor @"hostEditor"
#define kPortEditor @"portEditor"
#define kRememberPassword @"RememberPassword" //是否记住密码
#define kSignUpPhoneNo @"SignUpPhoneNo" //注册时验证通过的手机号码
#define kLoginPhoneNo @"LoginPhoneNo" //登录成功的手机号码
#define KPassword @"Password" //登录成功的密码
#define kHasSignedIn @"HasSignedIn" //用户登录成功后是否签到

#define kLastLoginPhoneNo @"LastLoginPhoneNo" //上一次登录成功的手机号码
BOOL  isOldUser;      //是否老的登录用户

#define KdengLuInfo @"dengluxinxi"//登陆的时候保存的密码和账号一一对应

#define kMposG1SN @"SnNo"  //mposSN号
#define kkSN @"kksn"  //保存一个账号对应sn号码的字典
#define kkSNzhongduan @"kksnzhongduan"  //保存各个sn号码对应的终端号TerminalNo
#define kMposG1TerminalNo @"TerminalNo" //mpos终端号
#define kMposG1MerchantNo @"MerchantNo" //mpos商户号
#define kMposG1MainKey  @"MainKey"  //mpos主密钥

#define kUserSNDict @"kUserSNDict"  //用户对应连接设备的字典

#define kDeviceType @"kDeviceType" //设备类型(G1 H1)


//秒到正式
#define kServerIP @"mpos.qimiaolife.com" //注册登录的ip
#define kServerPort @"18080" //注册登录的端口
#define kPosPort @"8899"
#define kPosIP @"122.112.28.20"
#define kDecryptKey "01CCA5D0712519DE01CCA5D0712519DE"


#define kPgyerAppID @"d6592e45411274c0b321c22018494519"



////腾氏测试
//#define kServerIP @"122.112.12.25" //注册登录的ip
//#define kServerPort @"18081" //注册登录的端口
//#define kPosIP @"122.112.12.25"
//#define kPosPort @"25679"
//#define kDecryptKey "22222222222222222222222222222222"

//腾氏生产
//#define kServerIP @"122.112.12.29" //注册登录的ip
//#define kServerPort @"8081" //注册登录的端口
//#define kPosIP @"122.112.12.24"
//#define kPosPort @"5679"
//#define kDecryptKey "00000003000011650000000300001165"

//铜元
//#define kServerIP @"122.112.12.20" //注册登录的ip
//#define kServerPort @"25680" //注册登录的端口
//#define kPosPort @"6889"
//#define kDecryptKey "01CCA5D0712519DE01CCA5D0712519DE"
//#define kPosIP @"122.112.12.20"

//
//////广西开创
//#define kServerIP @"122.112.12.21" //注册登录的ip
//#define kServerPort @"19288" //注册登录的端口
//#define kPosIP @"122.112.12.21"
//#define kPosPort @"18899"
//#define kDecryptKey "EA4E8D2F609F2B4AEA4E8D2F609F2B4A"

#define DEBUG false
//#define DEBUG true



#endif

NSMutableArray *searchDevices;
//CBPeripheral

BOOL _isConnect;
BOOL _isNeedAutoConnect;

int _type; //1、消费 2、撤销

BOOL _isFirstInit;

NSString *quanjubangding;


#define KUserDefault [NSUserDefaults standardUserDefaults]


#define KconnectDeivesSuccess @"connectDeivesSuccess"
/**
 *  判断是交易状态还是签到状态
 */
int _quanjuQianDaoType;

/**
 *  即时消费失败发送通知
 */
#define jishixiaofeiShibai @"jishixianfofei"

#define jishixiaofeiChongxin @"jsihxiaofeng"


#define kH1SN @"kH1SN"

/**
 *  企业注册保存信息
 */


#define qiyeMima @"qiyemima"
#define qiyeFadingdaibiaoren @"qiyeFadingdaibiaoren"
#define qiyeShoujihao @"qiyeShoujihao"
#define qiyeLianxiren @"qiyeLianxiren"
#define qiyeLianxirenDianhua @"qiyeLianxirenDianhua"
#define qiyeID @"qiyeID"
#define qiyeCertExpdate @"qiyecertExpdate"

#define qiyeImage1 @"qiyeImage1"
#define qiyeImage2 @"qiyeImage2"
#define qiyeImage3 @"qiyeImage3"
#define qiyeImage5 @"qiyeImage5"
#define qiyeImage10 @"qiyeImage10"
#define qiyeImage6 @"qiyeImage6"
#define qiyeImage7 @"qiyeImage7"
#define qiyeImage8 @"qiyeImage8"
#define qiyeImage9 @"qiyeImage9"
#define qiyeImage4 @"qiyeimage4"
#define qiyeImage11 @"qiyeImage11"



#define qiyeShanghuyingyedizhi @"qiyeShanghuyingyedizhi"
#define qiyeDiqubianma @"qiyeDiqubianma"
#define qiyeprovince @"qiyeprovince"
#define qiyecity @"qiyecity"
#define qiyebankName @"qiyebankName"
#define qiyesettleBank @"qiyesettleBank"
#define qiyebankBranch @"qiyebankBranch"
#define qiyesettleAccno @"qiyesettleAccno"
#define qiyeaccName @"qiyeaccName"



/**
 *  个人注册保存信息
 */
#define gerenImage1 @"gerenimage1"
#define gerenImage2 @"gerenimage2"
#define gerenImage3 @"gerenimage3"
#define gerenImage10 @"gerenimage10"
#define gerenImage4 @"gerenimage4"
#define gerenImage5 @"gerenimage5"


#define gerenMima @"gerenmima"
#define gerenName @"gerenname"
#define gerenShoujihao @"gerenShoujihao"
#define gerenID @"gerenID"
#define gerenCertExpdate @"gerenCertExpdate"

#define gerendiqubianma @"gerendiqubianma"
#define gerenprovince @"gerenprovince"
#define gerencity @"gerencity"
#define gerensettleBank @"gerensettleBank"
#define gerenbankName @"gerenbankName"
#define gerenbankBranch @"gerenbankBranch"
#define gerensettleAccno @"gerensettleAccno"
#define gerenaccName @"gerenaccName"
#define gerenshanghuyingyedizhi @"gerenshanghuyingyedizhi"



/**
 *  磁条交易随机数
 */
#define Kcitiaosuijishu @"citiaojiaoyisuijishu"

/**
 *  磁条交易的保存信息
 */
#define KcitiaoInfo @"citiaoInfo"
/**
 *  词条交易预留手机号
 */
#define Kcitiaoyuliushoujihao @"citiaoyuliushoujihao"
///**
// *  磁条交易姓名
// */
//#define Kcitiaoxingming @"citiaoxingming"
/**
 *  磁条身份证号
 */
#define Kcitiaoshenfenzhenghao @"shenfenzheng"


