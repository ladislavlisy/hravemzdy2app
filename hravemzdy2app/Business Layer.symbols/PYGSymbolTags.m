//
// Created by lisy on 01.04.13.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import "PYGSymbolTags.h"
#import "PYGCodeNameRefer.h"


static NSDictionary * symbolsOfTags = nil;

@implementation PYGSymbolTags {

}
+ (PYGCodeNameRefer *)codeRef:(NSUInteger)code {
    [self loadSymbols];
    if (symbolsOfTags != nil)
    {
        return [symbolsOfTags objectForKey:[NSNumber numberWithUnsignedInt:code]];
    }
    return nil;
}
+ (void) loadSymbols {
    if (symbolsOfTags == nil)
    {
        symbolsOfTags = [NSDictionary dictionaryWithObjectsAndKeys:
            CODE_NAME_REF(TAG_UNKNOWN              , @"TAG_UNKNOWN"),
            CODE_NAME_REF(TAG_SCHEDULE_WORK        , @"TAG_SCHEDULE_WORK"),
            CODE_NAME_REF(TAG_SCHEDULE_TERM        , @"TAG_SCHEDULE_TERM"),
            CODE_NAME_REF(TAG_TIMESHEET_PERIOD     , @"TAG_TIMESHEET_PERIOD"),
            CODE_NAME_REF(TAG_TIMESHEET_WORK       , @"TAG_TIMESHEET_WORK"),
            CODE_NAME_REF(TAG_HOURS_WORKING        , @"TAG_HOURS_WORKING"),
            CODE_NAME_REF(TAG_HOURS_ABSENCE        , @"TAG_HOURS_ABSENCE"),
            CODE_NAME_REF(TAG_SALARY_BASE          , @"TAG_SALARY_BASE"),
            CODE_NAME_REF(TAG_TAX_INCOME_BASE      , @"TAG_TAX_INCOME_BASE"),
            CODE_NAME_REF(TAG_INSURANCE_HEALTH_BASE, @"TAG_INSURANCE_HEALTH_BASE"),
            CODE_NAME_REF(TAG_INSURANCE_SOCIAL_BASE, @"TAG_INSURANCE_SOCIAL_BASE"),
            CODE_NAME_REF(TAG_INSURANCE_HEALTH     , @"TAG_INSURANCE_HEALTH"),
            CODE_NAME_REF(TAG_INSURANCE_SOCIAL     , @"TAG_INSURANCE_SOCIAL"),
            CODE_NAME_REF(TAG_SAVINGS_PENSIONS     , @"TAG_SAVINGS_PENSIONS"),
            CODE_NAME_REF(TAG_TAX_EMPLOYERS_HEALTH , @"TAG_TAX_EMPLOYERS_HEALTH"),
            CODE_NAME_REF(TAG_TAX_EMPLOYERS_SOCIAL , @"TAG_TAX_EMPLOYERS_SOCIAL"),
            CODE_NAME_REF(TAG_TAX_CLAIM_PAYER      , @"TAG_TAX_CLAIM_PAYER"),
            CODE_NAME_REF(TAG_TAX_CLAIM_DISABILITY , @"TAG_TAX_CLAIM_DISABILITY"),
            CODE_NAME_REF(TAG_TAX_CLAIM_STUDYING   , @"TAG_TAX_CLAIM_STUDYING"),
            CODE_NAME_REF(TAG_TAX_CLAIM_CHILD      , @"TAG_TAX_CLAIM_CHILD"),
            CODE_NAME_REF(TAG_TAX_RELIEF_PAYER     , @"TAG_TAX_RELIEF_PAYER"),
            CODE_NAME_REF(TAG_TAX_RELIEF_CHILD     , @"TAG_TAX_RELIEF_CHILD"),
            CODE_NAME_REF(TAG_TAX_ADVANCE_BASE     , @"TAG_TAX_ADVANCE_BASE"),
            CODE_NAME_REF(TAG_TAX_ADVANCE          , @"TAG_TAX_ADVANCE"),
            CODE_NAME_REF(TAG_TAX_BONUS_CHILD      , @"TAG_TAX_BONUS_CHILD"),
            CODE_NAME_REF(TAG_TAX_ADVANCE_FINAL    , @"TAG_TAX_ADVANCE_FINAL"),
            CODE_NAME_REF(TAG_TAX_WITHHOLD_BASE    , @"TAG_TAX_WITHHOLD_BASE"),
            CODE_NAME_REF(TAG_TAX_WITHHOLD         , @"TAG_TAX_WITHHOLD"),
            CODE_NAME_REF(TAG_INCOME_GROSS         , @"TAG_INCOME_GROSS"),
            CODE_NAME_REF(TAG_INCOME_NETTO         , @"TAG_INCOME_NETTO"), nil];
    }
}
@end