//
// Created by lisy on 01.04.13.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import <Foundation/Foundation.h>

@class PYGCodeNameRefer;

static const NSUInteger TAG_UNKNOWN               = 0;
static const NSUInteger TAG_SCHEDULE_WORK         = 10001;
static const NSUInteger TAG_SCHEDULE_TERM         = 10002;
static const NSUInteger TAG_TIMESHEET_PERIOD      = 10003;
static const NSUInteger TAG_TIMESHEET_WORK        = 10004;
static const NSUInteger TAG_HOURS_WORKING         = 10005;
static const NSUInteger TAG_HOURS_ABSENCE         = 10006;
static const NSUInteger TAG_SALARY_BASE           = 10101;
static const NSUInteger TAG_TAX_INCOME_BASE       = 30001;
static const NSUInteger TAG_INSURANCE_HEALTH_BASE = 30002;
static const NSUInteger TAG_INSURANCE_SOCIAL_BASE = 30003;
static const NSUInteger TAG_INSURANCE_HEALTH      = 30005;
static const NSUInteger TAG_INSURANCE_SOCIAL      = 30006;
static const NSUInteger TAG_SAVINGS_PENSIONS      = 30007;
static const NSUInteger TAG_TAX_EMPLOYERS_HEALTH  = 30008;
static const NSUInteger TAG_TAX_EMPLOYERS_SOCIAL  = 30009;
static const NSUInteger TAG_TAX_CLAIM_PAYER       = 30010;
static const NSUInteger TAG_TAX_CLAIM_DISABILITY  = 30011;
static const NSUInteger TAG_TAX_CLAIM_STUDYING    = 30014;
static const NSUInteger TAG_TAX_CLAIM_CHILD       = 30019;
static const NSUInteger TAG_TAX_RELIEF_PAYER      = 30020;
static const NSUInteger TAG_TAX_RELIEF_CHILD      = 30029;
static const NSUInteger TAG_TAX_ADVANCE_BASE      = 30030;
static const NSUInteger TAG_TAX_ADVANCE           = 30031;
static const NSUInteger TAG_TAX_BONUS_CHILD       = 30033;
static const NSUInteger TAG_TAX_ADVANCE_FINAL     = 30034;
static const NSUInteger TAG_TAX_WITHHOLD_BASE     = 30035;
static const NSUInteger TAG_TAX_WITHHOLD          = 30036;
static const NSUInteger TAG_INCOME_GROSS          = 90001;
static const NSUInteger TAG_INCOME_NETTO          = 90002;


@interface PYGSymbolTags : NSObject

+(PYGCodeNameRefer *)codeRef:(NSUInteger)code NS_RETURNS_RETAINED;

@end