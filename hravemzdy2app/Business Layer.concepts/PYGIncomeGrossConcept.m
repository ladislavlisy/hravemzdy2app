//
// Created by lisy on 01.04.13.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import "PYGIncomeGrossConcept.h"
#import "PYGSymbolConcepts.h"
#import "PYGPayTagGateway.h"
#import "PYGPayrollPeriod.h"
#import "PYGPayrollResult.h"
#import "PYGSymbolTags.h"
#import "PYGAmountResult.h"
#import "PYGTagRefer.h"
#import "NSDictionary+Func.h"
#import "PYGPayrollTag.h"

@implementation PYGIncomeGrossConcept {

}

- (id)initWithTagCode:(NSUInteger)tagCode andValues:(NSDictionary *)values {
    if (!(self=[super initWithCodeName:[PYGSymbolConcepts codeRef:CONCEPT_INCOME_GROSS] andTagCode:tagCode])) return nil;
    [self setupValues:values];
    return self;
}

+ (PYGIncomeGrossConcept *)conceptWithTagCode:(NSUInteger)tagCode andValues:(NSDictionary *)values {
    return [[self alloc] initWithTagCode:tagCode andValues:values];
}

- (id)copyWithZone:(NSZone*) zone {
    return self;
}

- (PYGIncomeGrossConcept*)newConceptWithCode:(NSUInteger)tagCode andValues:(NSDictionary *)values {
    PYGIncomeGrossConcept *concept = [PYGIncomeGrossConcept conceptWithTagCode:tagCode andValues:values];
    [concept  setPendingCodes:self.tagPendingCodes];
    return concept;
}

- (void)setupValues:(NSDictionary *)values {
    NSParameterAssert(values != nil);
}

+(PYGIncomeGrossConcept *)concept
{
    return [[self alloc] initWithTagCode:TAG_UNKNOWN andValues:EMPTY_VALUES];
}

- (NSUInteger)calcCategory {
    return CALC_CATEGORY_FINAL;
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
        if ([tagConfigItem isIncomeGross]==YES) {
            return resultItem.getPayment;
        }
    }
    return DECIMAL_ZERO;
}

@end