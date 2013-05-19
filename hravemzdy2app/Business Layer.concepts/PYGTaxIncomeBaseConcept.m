//
// Created by lisy on 01.04.13.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import "PYGTaxIncomeBaseConcept.h"
#import "PYGSymbolConcepts.h"
#import "PYGPayTagGateway.h"
#import "PYGPayrollPeriod.h"
#import "PYGPayrollResult.h"
#import "PYGSymbolTags.h"
#import "PYGTagRefer.h"
#import "NSDictionary+Func.h"
#import "PYGIncomeBaseResult.h"
#import "PYGPayrollTag.h"
#import "PYGXmlBuilder.h"


@implementation PYGTaxIncomeBaseConcept {

}
@synthesize interestCode = _interestCode;
@synthesize declareCode = _declareCode;

- (id)initWithTagCode:(NSUInteger)tagCode andValues:(NSDictionary *)values {
    if (!(self=[super initWithCodeName:[PYGSymbolConcepts codeRef:CONCEPT_TAX_INCOME_BASE] andTagCode:tagCode])) return nil;
    [self setupValues:values];
    return self;
}

+ (PYGTaxIncomeBaseConcept *)conceptWithTagCode:(NSUInteger)tagCode andValues:(NSDictionary *)values {
    return [[self alloc] initWithTagCode:tagCode andValues:values];
}

- (id)copyWithZone:(NSZone*) zone {
    return self;
}

- (PYGTaxIncomeBaseConcept*)newConceptWithCode:(NSUInteger)tagCode andValues:(NSDictionary *)values {
    PYGTaxIncomeBaseConcept *concept = [PYGTaxIncomeBaseConcept conceptWithTagCode:tagCode andValues:values];
    [concept  setPendingCodes:self.tagPendingCodes];
    return concept;
}

- (void)setupValues:(NSDictionary *)values {
    NSParameterAssert(values != nil);
    _interestCode = U_SAFE_VALUES(@"interest_code");
    _declareCode  = U_SAFE_VALUES(@"declare_code");
}

+(PYGTaxIncomeBaseConcept *)concept
{
    return [[self alloc] initWithTagCode:TAG_UNKNOWN andValues:EMPTY_VALUES];
}

- (NSUInteger)calcCategory {
    return CALC_CATEGORY_GROSS;
}

- (PYGPayrollResult*)evaluateForPeriod:(PYGPayrollPeriod *)period config:(PYGPayTagGateway *)config results:(NSDictionary *)results {
    PYGPayTagGateway * tagConfig = config;
    NSDictionary * tagResults = results;

    NSDecimalNumber * resultIncome = DECIMAL_ZERO;
    if (self.isInterest==NO) {
        resultIncome = DECIMAL_ZERO;
    }
    else
    {
        resultIncome = [tagResults injectForDecimal:(DECIMAL_ZERO) with:^NSDecimalNumber * (NSDecimalNumber *agr, id key, id obj) {
            PYGTagRefer * termKey = (PYGTagRefer *)key;
            PYGPayrollResult * termResult = (PYGPayrollResult *)obj;
            return [agr decimalNumberByAdding:[self sumTermWithConfig:tagConfig andTagCode:self.tagCode forKey:termKey andItem:termResult]];
        }];
    }
    NSDictionary * resultValues = @{
        D_MAKE_PAIR(@"income_base",   resultIncome),
        U_MAKE_PAIR(@"interest_code", self.interestCode),
        U_MAKE_PAIR(@"declare_code",  self.declareCode)
    };

    return [PYGIncomeBaseResult newWithConcept:self andValues:resultValues];

}

- (NSDecimalNumber *)sumTermWithConfig:(PYGPayTagGateway *)tagConfig andTagCode:(NSUInteger)tagCode forKey:(PYGTagRefer *)resultKey andItem:(PYGPayrollResult *)resultItem {
    //TODO: test refactoring - no PYGCodeNameRefer here in resultKey
    PYGPayrollTag * tagConfigItem = [tagConfig findTag:resultKey.code];
    if ([resultItem isSummaryFor:tagCode]) {
        if ([tagConfigItem isTaxAdvance]==YES) {
            return resultItem.getPayment;
        }
    }
    return DECIMAL_ZERO;
}

- (BOOL)isInterest
{
    return self.interestCode!=0;
}

- (BOOL) isDeclared
{
    return self.declareCode!=0;
}

- (BOOL)exportXml:(PYGXmlBuilder*)xmlBuilder {
    NSDictionary *attributes = @{
            @"interest_code" : [@(self.interestCode) stringValue],
            @"declare_code" : [@(self.declareCode) stringValue]
    };
    BOOL done = [xmlBuilder writeXmlElement:@"spec_value" withAttributes:attributes];
    return done;
}

@end