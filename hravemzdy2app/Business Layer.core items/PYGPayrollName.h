//
// Created by lisy on 31.03.13.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import <Foundation/Foundation.h>
#import "PYGCodeNameRefer.h"

#define VPAYGRP_UNKNOWN    nil
#define HPAYGRP_UNKNOWN    nil
#define VPAYGRP_SCHEDULE   @"VPAYGRP_SCHEDULE"
#define VPAYGRP_PAYMENTS   @"VPAYGRP_PAYMENTS"
#define VPAYGRP_TAX_SOURCE @"VPAYGRP_TAX_SOURCE"
#define VPAYGRP_TAX_RESULT @"VPAYGRP_TAX_RESULT"
#define VPAYGRP_INS_RESULT @"VPAYGRP_INS_RESULT"
#define VPAYGRP_TAX_INCOME @"VPAYGRP_TAX_INCOME"
#define VPAYGRP_INS_INCOME @"VPAYGRP_INS_INCOME"
#define VPAYGRP_SUMMARY    @"VPAYGRP_SUMMARY"

@interface PYGPayrollName : PYGCodeNameRefer

@property(nonatomic, readonly) NSString* title;
@property(nonatomic, readonly) NSString* description;

-(id)initWithCodeRefer:(PYGCodeNameRefer*)tagRefer andTitle:(NSString*)title andDescription:(NSString*)description andVertGroup:(NSString*)vertGroup andHorizGroup:(NSString*)horizGroup;
-(bool)isMatchVGroup:(NSString *)group_code;
-(bool)isMatchHGroup:(NSString *)group_code;

@end