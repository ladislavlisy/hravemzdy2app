//
// Created by lisy on 01.04.13.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import "PYGIncomeNettoConcept.h"
#import "PYGSymbolConcepts.h"
#import "PYGPayTagGateway.h"
#import "PYGPayrollPeriod.h"
#import "PYGPayrollResult.h"
#import "PYGSymbolTags.h"
#import "PYGTaxAdvanceFinalTag.h"
#import "PYGTaxWithholdTag.h"
#import "PYGTaxBonusChildTag.h"
#import "PYGInsuranceSocialTag.h"
#import "PYGInsuranceHealthTag.h"
#import "NSDictionary+Func.h"
#import "PYGTagRefer.h"
#import "PYGAmountResult.h"
#import "PYGXmlBuilder.h"


@implementation PYGIncomeNettoConcept {

}

- (id)initWithTagCode:(NSUInteger)tagCode andValues:(NSDictionary *)values {
    if (!(self=[super initWithCodeName:[PYGSymbolConcepts codeRef:CONCEPT_INCOME_NETTO] andTagCode:tagCode])) return nil;
    [self setupValues:values];
    return self;
}

+ (PYGIncomeNettoConcept *)conceptWithTagCode:(NSUInteger)tagCode andValues:(NSDictionary *)values {
    return [[self alloc] initWithTagCode:tagCode andValues:values];
}

- (id)copyWithZone:(NSZone*) zone {
    return self;
}

- (PYGIncomeNettoConcept*)newConceptWithCode:(NSUInteger)tagCode andValues:(NSDictionary *)values {
    PYGIncomeNettoConcept *concept = [PYGIncomeNettoConcept conceptWithTagCode:tagCode andValues:values];
    [concept  setPendingCodes:self.tagPendingCodes];
    return concept;
}

- (void)setupValues:(NSDictionary *)values {
    NSParameterAssert(values != nil);
}

+(PYGIncomeNettoConcept *)concept
{
    return [[self alloc] initWithTagCode:TAG_UNKNOWN andValues:EMPTY_VALUES];
}

- (NSArray *)pendingCodes {
    return @[
        TAG_NEW(PYGTaxAdvanceFinalTag),
        TAG_NEW(PYGTaxWithholdTag),
        TAG_NEW(PYGTaxBonusChildTag),
        TAG_NEW(PYGInsuranceSocialTag),
        TAG_NEW(PYGInsuranceHealthTag)
    ];
}

- (NSArray *)summaryCodes {
    return @[];
}

- (NSUInteger)calcCategory {
    return CALC_CATEGORY_FINAL;
}

- (NSUInteger)typeOfResult {
    return TYPE_RESULT_SUMMARY;
}

- (PYGPayrollResult*)evaluateForPeriod:(PYGPayrollPeriod *)period config:(PYGPayTagGateway *)config results:(NSDictionary *)results {
    PYGPayTagGateway * tagConfig = config;
    NSDictionary * tagResults = results;

    NSDecimalNumber * resultIncome = [tagResults injectForDecimal:(DECIMAL_ZERO) with:^NSDecimalNumber * (NSDecimalNumber *agr, id key, id obj) {
        PYGTagRefer * termKey = (PYGTagRefer *)key;
        PYGPayrollResult * termResult = (PYGPayrollResult *)obj;
        return [agr decimalNumberByAdding:[self sumTermWithConfig:tagConfig andTagCode:self.tagCode forKey:termKey andItem:termResult]];
    }];

    NSDictionary * resultValues = D_MAKE_HASH(@"amount", resultIncome);

    return [PYGAmountResult newWithConcept:self andValues:resultValues];
}

- (NSDecimalNumber *)sumTermWithConfig:(PYGPayTagGateway *)tagConfig andTagCode:(NSUInteger)tagCode forKey:(PYGTagRefer *)resultKey andItem:(PYGPayrollResult *)resultItem {
    //TODO: test refactoring - no PYGCodeNameRefer here in resultKey
    PYGPayrollTag * tagConfigItem = [tagConfig findTag:resultKey.code];
    if ([resultItem isSummaryFor:tagCode]) {
        if ([tagConfigItem isIncomeNetto]==YES) {
            return resultItem.getPayment;
        }
        else if ([tagConfigItem isDeductionNetto]==YES)
        {
            return DECIMAL_NEG([resultItem getDeduction]);
        }
    }
    return DECIMAL_ZERO;
}

@end