//
//  JiaoyijiluCell.m
//  GITestDemo
//
//  Created by lcc on 15/7/30.
//  Copyright (c) 2015年 Kyson. All rights reserved.
//

#import "JiaoyijiluCell.h"

@interface JiaoyijiluCell ()

@property (weak, nonatomic) IBOutlet UILabel *xuhao;

@property (weak, nonatomic) IBOutlet UILabel *jiaoyiliushuihao;

@property (weak, nonatomic) IBOutlet UILabel *yinhangkahao;

@property (weak, nonatomic) IBOutlet UILabel *kapianleixing;
@property (weak, nonatomic) IBOutlet UILabel *jiaoyiriqi;
@property (weak, nonatomic) IBOutlet UILabel *jiaoyizhuangtai;
@property (weak, nonatomic) IBOutlet UILabel *jiaoyishijian;
@property (weak, nonatomic) IBOutlet UILabel *jiaoyijine;
@property (weak, nonatomic) IBOutlet UILabel *jiaoyimingcheng;

@end



@implementation JiaoyijiluCell

- (void)awakeFromNib {
    // Initialization code

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


- (void)setJilu:(Jiaoyijilu *)jilu{
    
    _jilu = jilu;
    self.xuhao.text = jilu.id;
    self.yinhangkahao.text = jilu.pan;
    self.kapianleixing.text = jilu.accType;
    self.jiaoyijine.text = [NSString stringWithFormat:@"%.2f",jilu.txnAmt.floatValue/100];
    self.jiaoyiriqi.text = jilu.txnDate;
    self.jiaoyimingcheng.text = jilu.txnName;
    self.jiaoyishijian.text = jilu.txnTime;
    self.jiaoyizhuangtai.text = jilu.statusName;
    self.jiaoyiliushuihao.text = jilu.sNumber;
}

@end
