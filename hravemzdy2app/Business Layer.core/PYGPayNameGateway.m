//
// Created by lisy on 01.04.13.
//
// To change the template use AppCode | Preferences | File Templates.
//
 
#import "PYGPayNameGateway.h"
#import "PYGUnknownTag.h"
#import "PYGSymbolTags.h"
#import "NSString+RubyCocoaString.h"
#import "PYGPayrollName.h"
#import "PYGUnknownName.h"

#define PYGNameClassAssert(condition, className, codeName) NSCAssert((condition), @"Name Class not implemented: %s for: %s", className, codeName)

@implementation PYGPayNameGateway {
}

- (id)init {
    if (!(self=[super init])) return nil;
    models = [NSMutableDictionary dictionaryWithObjectsAndKeys:[PYGUnknownName name], @(TAG_UNKNOWN), nil];
    return self;
}

- (void)loadModels {
    PYGCodeNameRefer * REF_SCHEDULE_WORK          = [PYGSymbolTags codeRef:TAG_SCHEDULE_WORK];
    PYGCodeNameRefer * REF_SCHEDULE_TERM          = [PYGSymbolTags codeRef:TAG_SCHEDULE_TERM];
    PYGCodeNameRefer * REF_HOURS_ABSENCE          = [PYGSymbolTags codeRef:TAG_HOURS_ABSENCE];
    PYGCodeNameRefer * REF_TIMESHEET_PERIOD       = [PYGSymbolTags codeRef:TAG_TIMESHEET_PERIOD];
    PYGCodeNameRefer * REF_TIMESHEET_WORK         = [PYGSymbolTags codeRef:TAG_TIMESHEET_WORK];
    PYGCodeNameRefer * REF_HOURS_WORKING          = [PYGSymbolTags codeRef:TAG_HOURS_WORKING];
    PYGCodeNameRefer * REF_SALARY_BASE            = [PYGSymbolTags codeRef:TAG_SALARY_BASE];
    PYGCodeNameRefer * REF_TAX_INCOME_BASE        = [PYGSymbolTags codeRef:TAG_TAX_INCOME_BASE];
    PYGCodeNameRefer * REF_INSURANCE_HEALTH_BASE  = [PYGSymbolTags codeRef:TAG_INSURANCE_HEALTH_BASE];
    PYGCodeNameRefer * REF_INSURANCE_HEALTH       = [PYGSymbolTags codeRef:TAG_INSURANCE_HEALTH];
    PYGCodeNameRefer * REF_INSURANCE_SOCIAL_BASE  = [PYGSymbolTags codeRef:TAG_INSURANCE_SOCIAL_BASE];
    PYGCodeNameRefer * REF_INSURANCE_SOCIAL       = [PYGSymbolTags codeRef:TAG_INSURANCE_SOCIAL];
    PYGCodeNameRefer * REF_SAVINGS_PENSIONS       = [PYGSymbolTags codeRef:TAG_SAVINGS_PENSIONS];
    PYGCodeNameRefer * REF_TAX_CLAIM_PAYER        = [PYGSymbolTags codeRef:TAG_TAX_CLAIM_PAYER];
    PYGCodeNameRefer * REF_TAX_CLAIM_CHILD        = [PYGSymbolTags codeRef:TAG_TAX_CLAIM_CHILD];
    PYGCodeNameRefer * REF_TAX_CLAIM_DISABILITY   = [PYGSymbolTags codeRef:TAG_TAX_CLAIM_DISABILITY];
    PYGCodeNameRefer * REF_TAX_CLAIM_STUDYING     = [PYGSymbolTags codeRef:TAG_TAX_CLAIM_STUDYING];
    PYGCodeNameRefer * REF_TAX_EMPLOYERS_HEALTH   = [PYGSymbolTags codeRef:TAG_TAX_EMPLOYERS_HEALTH];
    PYGCodeNameRefer * REF_TAX_EMPLOYERS_SOCIAL   = [PYGSymbolTags codeRef:TAG_TAX_EMPLOYERS_SOCIAL];
    PYGCodeNameRefer * REF_TAX_ADVANCE_BASE       = [PYGSymbolTags codeRef:TAG_TAX_ADVANCE_BASE];
    PYGCodeNameRefer * REF_TAX_ADVANCE            = [PYGSymbolTags codeRef:TAG_TAX_ADVANCE];
    PYGCodeNameRefer * REF_TAX_WITHHOLD_BASE      = [PYGSymbolTags codeRef:TAG_TAX_WITHHOLD_BASE];
    PYGCodeNameRefer * REF_TAX_WITHHOLD           = [PYGSymbolTags codeRef:TAG_TAX_WITHHOLD];
    PYGCodeNameRefer * REF_TAX_RELIEF_PAYER       = [PYGSymbolTags codeRef:TAG_TAX_RELIEF_PAYER];
    PYGCodeNameRefer * REF_TAX_ADVANCE_FINAL      = [PYGSymbolTags codeRef:TAG_TAX_ADVANCE_FINAL];
    PYGCodeNameRefer * REF_TAX_RELIEF_CHILD       = [PYGSymbolTags codeRef:TAG_TAX_RELIEF_CHILD];
    PYGCodeNameRefer * REF_TAX_BONUS_CHILD        = [PYGSymbolTags codeRef:TAG_TAX_BONUS_CHILD];
    PYGCodeNameRefer * REF_INCOME_GROSS           = [PYGSymbolTags codeRef:TAG_INCOME_GROSS];
    PYGCodeNameRefer * REF_INCOME_NETTO           = [PYGSymbolTags codeRef:TAG_INCOME_NETTO];

    [self nameFromModels:REF_SCHEDULE_WORK];
    [self nameFromModels:REF_SCHEDULE_TERM];
    [self nameFromModels:REF_TIMESHEET_PERIOD];
    [self nameFromModels:REF_TIMESHEET_WORK];
    [self nameFromModels:REF_HOURS_WORKING];
    [self nameFromModels:REF_HOURS_ABSENCE];
    [self nameFromModels:REF_SALARY_BASE];
    [self nameFromModels:REF_TAX_INCOME_BASE];
    [self nameFromModels:REF_INSURANCE_HEALTH_BASE];
    [self nameFromModels:REF_INSURANCE_SOCIAL_BASE];
    [self nameFromModels:REF_INSURANCE_HEALTH];
    [self nameFromModels:REF_INSURANCE_SOCIAL];
    [self nameFromModels:REF_SAVINGS_PENSIONS];
    [self nameFromModels:REF_TAX_EMPLOYERS_HEALTH];
    [self nameFromModels:REF_TAX_EMPLOYERS_SOCIAL];
    [self nameFromModels:REF_TAX_CLAIM_PAYER];
    [self nameFromModels:REF_TAX_CLAIM_DISABILITY];
    [self nameFromModels:REF_TAX_CLAIM_STUDYING];
    [self nameFromModels:REF_TAX_CLAIM_CHILD];
    [self nameFromModels:REF_TAX_RELIEF_PAYER];
    [self nameFromModels:REF_TAX_RELIEF_CHILD];
    [self nameFromModels:REF_TAX_ADVANCE_BASE];
    [self nameFromModels:REF_TAX_ADVANCE];
    [self nameFromModels:REF_TAX_BONUS_CHILD];
    [self nameFromModels:REF_TAX_ADVANCE_FINAL];
    [self nameFromModels:REF_TAX_WITHHOLD_BASE];
    [self nameFromModels:REF_TAX_WITHHOLD];
    [self nameFromModels:REF_INCOME_GROSS];
    [self nameFromModels:REF_INCOME_NETTO];
}

- (PYGPayrollName *)nameFor:(NSString *)tagCodeName {
    NSString * tagClass = [self classNameFor:tagCodeName];
    PYGPayrollName * tagInstance = [[NSClassFromString(tagClass) alloc] init];
    PYGNameClassAssert(tagInstance != nil, [tagClass UTF8String], [tagCodeName UTF8String]);
    return tagInstance;
}

- (NSString *)classNameFor:(NSString *)tagCodeName {
    NSRegularExpression * conceptRegex = [NSRegularExpression regularExpressionWithPattern:@"TAG_(.*)" options:0 error:NULL];
    NSTextCheckingResult * regexMatch = [conceptRegex firstMatchInString:tagCodeName options:0 range:NSMakeRange(0, [tagCodeName length])];
    NSString * tagClass = [tagCodeName substringWithRange:[regexMatch rangeAtIndex:1]];
    NSString * className = [[[tagClass underscore] camelize] concat:@"Name"];
    return [@"PYG" concat:className];
}

- (PYGPayrollName *)nameFromModels:(PYGCodeNameRefer *)termName {
    PYGPayrollName * baseTag = nil;
    if ((baseTag=[models objectForKey:@([termName code])])==nil)
    {
        baseTag = [self emptyNameFor:termName];
        [models setObject:baseTag forKey:@(termName.code)];
    }
    return baseTag;
}

- (PYGPayrollName *)findName:(NSUInteger)tagCode {
    PYGPayrollName * baseTag = nil;
    if ((baseTag=[models objectForKey:@(tagCode)])==nil)
    {
        baseTag = [models objectForKey:@(TAG_UNKNOWN)];
    }
    return baseTag;

}

- (PYGPayrollName *)emptyNameFor:(PYGCodeNameRefer *)termName {
    PYGPayrollName * emptyTag = [self nameFor:[termName name]];
    return emptyTag;
}

@end