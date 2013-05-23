//
// Created by lisy on 01.04.13.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import "PYGInsuranceSocialBaseConcept.h"
#import "PYGSymbolConcepts.h"
#import "PYGPayTagGateway.h"
#import "PYGPayrollPeriod.h"
#import "PYGPayrollResult.h"
#import "PYGSymbolTags.h"
#import "PYGIncomeBaseResult.h"
#import "PYGTagRefer.h"
#import "NSDictionary+Func.h"
#import "PYGPayrollTag.h"
#import "PYGXmlBuilder.h"


@implementation PYGInsuranceSocialBaseConcept {

}
@synthesize interestCode = _interestCode;

- (id)initWithTagCode:(NSUInteger)tagCode andValues:(NSDictionary *)values {
    if (!(self=[super initWithCodeName:[PYGSymbolConcepts codeRef:CONCEPT_INSURANCE_SOCIAL_BASE] andTagCode:tagCode])) return nil;
    [self setupValues:values];
    return self;
}

+ (PYGInsuranceSocialBaseConcept *)conceptWithTagCode:(NSUInteger)tagCode andValues:(NSDictionary *)values {
    return [[self alloc] initWithTagCode:tagCode andValues:values];
}

- (id)copyWithZone:(NSZone*) zone {
    return self;
}

- (PYGInsuranceSocialBaseConcept*)newConceptWithCode:(NSUInteger)tagCode andValues:(NSDictionary *)values {
    PYGInsuranceSocialBaseConcept *concept = [PYGInsuranceSocialBaseConcept conceptWithTagCode:tagCode andValues:values];
    [concept  setPendingCodes:self.tagPendingCodes];
    return concept;
}

- (void)setupValues:(NSDictionary *)values {
    NSParameterAssert(values != nil);
    _interestCode = U_SAFE_VALUES(@"interest_code");
}

+(PYGInsuranceSocialBaseConcept *)concept
{
    return [[self alloc] initWithTagCode:TAG_UNKNOWN andValues:EMPTY_VALUES];
}

- (NSUInteger)calcCategory {
    return CALC_CATEGORY_GROSS;
}

- (NSUInteger)typeOfResult {
    return TYPE_RESULT_SUMMARY;
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

    NSDecimalNumber * employeeBase = [self minMaxAssessmentBase:period forBase:resultIncome];
    NSDecimalNumber * employerBase = [self maxAssessmentBase:period forBase:resultIncome];

    NSDictionary * resultValues = @{
            D_MAKE_PAIR(@"income_base",   resultIncome),
            D_MAKE_PAIR(@"employee_base", employeeBase),
            D_MAKE_PAIR(@"employer_base", employerBase),
            U_MAKE_PAIR(@"interest_code", self.interestCode)
    };

    return [PYGIncomeBaseResult newWithConcept:self andValues:resultValues];
}

- (NSDecimalNumber *)sumTermWithConfig:(PYGPayTagGateway *)tagConfig andTagCode:(NSUInteger)tagCode forKey:(PYGTagRefer *)resultKey andItem:(PYGPayrollResult *)resultItem {
    //TODO: test refactoring - no PYGCodeNameRefer here in resultKey
    PYGPayrollTag * tagConfigItem = [tagConfig findTag:resultKey.code];
    if ([resultItem isSummaryFor:tagCode]) {
        if ([tagConfigItem isInsuranceSocial]==YES) {
            return resultItem.getPayment;
        }
    }
    return DECIMAL_ZERO;
}

- (BOOL)isInterest {
    return (self.interestCode!=0);
}

- (NSDecimalNumber *) minMaxAssessmentBase:(PYGPayrollPeriod *)period forBase:(NSDecimalNumber *)insBase {
    NSDecimalNumber * minBase = [self minAssessmentBase:period forBase:insBase];

    NSDecimalNumber * maxBase = [self maxAssessmentBase:period forBase:minBase];
    return maxBase;
}

- (NSDecimalNumber *) maxAssessmentBase:(PYGPayrollPeriod *)period forBase:(NSDecimalNumber *)incomeBase {
    NSUInteger maximumBaseInt = [self socialMaxAssessmentForYear:period.year];
    NSDecimalNumber * maximumBase = DECIMAL_NUMB(@(maximumBaseInt));
    if (maximumBaseInt == 0) {
        return incomeBase;
    }
    else
    {
        return [self minToBig:incomeBase andDecimal:maximumBase];
    }
}

//TODO: minAssessmentBase
- (NSDecimalNumber *) minAssessmentBase:(PYGPayrollPeriod *)period forBase:(NSDecimalNumber *)incomeBase {
    return incomeBase;
}

- (NSUInteger)socialMaxAssessmentForYear:(NSUInteger)year
{
    if (year>=2013) {
        return 1242432;
    }
    else if (year==2012)
    {
        return 1206576;
    }
    else if (year==2011)
    {
        return 1781280;
    }
    else if (year==2010)
    {
        return 1707048;
    }
    else if (year==2009)
    {
        return 1130640;
    }
    else if (year==2008)
    {
        return 1034880;
    }
    else
    {
        return 0;
    }
}

- (BOOL)exportXml:(PYGXmlBuilder*)xmlBuilder {
    NSDictionary *attributes = @{
            @"interest_code" : [@(self.interestCode) stringValue]
    };
    BOOL done = [xmlBuilder writeXmlElement:@"spec_value" withAttributes:attributes];
    return done;
}

@end