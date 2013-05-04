//
// Created by lisy on 01.04.13.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import <Foundation/Foundation.h>

@class PYGCodeNameRefer;

static const NSUInteger CONCEPT_UNKNOWN               = 0;
static const NSUInteger CONCEPT_SALARY_MONTHLY        = 100;
static const NSUInteger CONCEPT_SCHEDULE_WEEKLY       = 200;
static const NSUInteger CONCEPT_SCHEDULE_TERM         = 201;
static const NSUInteger CONCEPT_TIMESHEET_PERIOD      = 202;
static const NSUInteger CONCEPT_TIMESHEET_WORK        = 203;
static const NSUInteger CONCEPT_HOURS_WORKING         = 204;
static const NSUInteger CONCEPT_HOURS_ABSENCE         = 205;
static const NSUInteger CONCEPT_TAX_INCOME_BASE       = 300;
static const NSUInteger CONCEPT_INSURANCE_HEALTH_BASE = 301;
static const NSUInteger CONCEPT_INSURANCE_SOCIAL_BASE = 302;
static const NSUInteger CONCEPT_INSURANCE_HEALTH      = 303;
static const NSUInteger CONCEPT_INSURANCE_SOCIAL      = 304;
static const NSUInteger CONCEPT_SAVINGS_PENSIONS      = 305;
static const NSUInteger CONCEPT_TAX_EMPLOYERS_HEALTH  = 306;
static const NSUInteger CONCEPT_TAX_EMPLOYERS_SOCIAL  = 307;
static const NSUInteger CONCEPT_TAX_CLAIM_PAYER       = 308;
static const NSUInteger CONCEPT_TAX_CLAIM_DISABILITY  = 309;
static const NSUInteger CONCEPT_TAX_CLAIM_STUDYING    = 312;
static const NSUInteger CONCEPT_TAX_CLAIM_CHILD       = 313;
static const NSUInteger CONCEPT_TAX_ADVANCE_BASE      = 314;
static const NSUInteger CONCEPT_TAX_ADVANCE           = 315;
static const NSUInteger CONCEPT_TAX_RELIEF_PAYER      = 316;
static const NSUInteger CONCEPT_TAX_RELIEF_DISABILITY = 317;
static const NSUInteger CONCEPT_TAX_RELIEF_STUDYING   = 318;
static const NSUInteger CONCEPT_TAX_RELIEF_CHILD      = 319;
static const NSUInteger CONCEPT_TAX_BONUS_CHILD       = 320;
static const NSUInteger CONCEPT_TAX_ADVANCE_FINAL     = 321;
static const NSUInteger CONCEPT_TAX_WITHHOLD_BASE     = 325;
static const NSUInteger CONCEPT_TAX_WITHHOLD          = 326;
static const NSUInteger CONCEPT_INCOME_GROSS          = 901;
static const NSUInteger CONCEPT_INCOME_NETTO          = 902;

@interface PYGSymbolConcepts : NSObject

+(PYGCodeNameRefer *)codeRef:(NSUInteger)code NS_RETURNS_RETAINED;

@end

