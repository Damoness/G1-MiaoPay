//
//  Jiaoyijilu.h
//  GITestDemo
//
//  Created by lcc on 15/7/30.
//  Copyright (c) 2015年 Kyson. All rights reserved.
/*

"id":"000001",
"txnDate":"20150628",
"txnTime":"195720",
"pan":"6225********5555",
"accType":"1",
"txnAmt":"100",
"txnId":"200022",
"tranStatus":"1",
"sNumber":"000105"
*/

#import <Foundation/Foundation.h>

@interface Jiaoyijilu : NSObject

@property (nonatomic, copy) NSString *id;
@property (nonatomic, copy) NSString *txnDate;
@property (nonatomic, copy) NSString *txnTime;
@property (nonatomic, copy) NSString *pan;
@property (nonatomic, copy) NSString *accType;
@property (nonatomic, copy) NSString *txnAmt;
@property (nonatomic, copy) NSString *txnId;
@property (nonatomic, copy) NSString *tranStatus;
@property (nonatomic, copy) NSString *sNumber;
@property (nonatomic, copy) NSString *statusName;
@property (nonatomic, copy) NSString *txnName;
@end
