//
// Created by lisy on 01.04.13.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import "PYGInsuranceHealthBaseConcept.h"
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


@implementation PYGInsuranceHealthBaseConcept {

}
@synthesize interestCode = _interestCode;
@synthesize minimumAsses = _minimumAsses;

- (id)initWithTagCode:(NSUInteger)tagCode andValues:(NSDictionary *)values {
    if (!(self=[super initWithCodeName:[PYGSymbolConcepts codeRef:CONCEPT_INSURANCE_HEALTH_BASE] andTagCode:tagCode])) return nil;
    [self setupValues:values];
    return self;
}

+ (PYGInsuranceHealthBaseConcept *)conceptWithTagCode:(NSUInteger)tagCode andValues:(NSDictionary *)values {
    return [[self alloc] initWithTagCode:tagCode andValues:values];
}

- (id)copyWithZone:(NSZone*) zone {
    return self;
}

- (PYGInsuranceHealthBaseConcept*)newConceptWithCode:(NSUInteger)tagCode andValues:(NSDictionary *)values {
    PYGInsuranceHealthBaseConcept *concept = [PYGInsuranceHealthBaseConcept conceptWithTagCode:tagCode andValues:values];
    [concept  setPendingCodes:self.tagPendingCodes];
    return concept;
}

- (void)setupValues:(NSDictionary *)values {
    NSParameterAssert(values != nil);
    _interestCode = U_SAFE_VALUES(@"interest_code");
    _minimumAsses = U_SAFE_VALUES(@"minimum_asses");
}

+(PYGInsuranceHealthBaseConcept *)concept
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

    NSDecimalNumber * employeeBase = [self minMaxAssessmentBase:period forBase:resultIncome];
    NSDecimalNumber * employerBase = [self maxAssessmentBase:period forBase:resultIncome];

    NSDictionary * resultValues = @{
        D_MAKE_PAIR(@"income_base",   resultIncome),
        D_MAKE_PAIR(@"employee_base", employeeBase),
        D_MAKE_PAIR(@"employer_base", employerBase),
        U_MAKE_PAIR(@"interest_code", self.interestCode),
        U_MAKE_PAIR(@"mimimum_asses", self.minimumAsses),
   };

    return [PYGIncomeBaseResult newWithConcept:self andValues:resultValues];
}

- (NSDecimalNumber *)sumTermWithConfig:(PYGPayTagGateway *)tagConfig andTagCode:(NSUInteger)tagCode forKey:(PYGTagRefer *)resultKey andItem:(PYGPayrollResult *)resultItem {
    //TODO: test refactoring - no PYGCodeNameRefer here in resultKey
    PYGPayrollTag * tagConfigItem = [tagConfig findTag:resultKey.code];
    if ([resultItem isSummaryFor:tagCode]) {
        if ([tagConfigItem isInsuranceHealth]==YES) {
            return resultItem.getPayment;
        }
    }
    return DECIMAL_ZERO;
}

- (BOOL)isInterest {
    return (self.interestCode!=0);
}

- (BOOL)isMinimumAssessment {
    return (self.minimumAsses!=0);
}

- (NSDecimalNumber *) minMaxAssessmentBase:(PYGPayrollPeriod *)period forBase:(NSDecimalNumber *)insBase {
    NSDecimalNumber * minBase = [self minAssessmentBase:period forBase:insBase];

    NSDecimalNumber * maxBase = [self maxAssessmentBase:period forBase:minBase];
    return maxBase;
}

- (NSDecimalNumber *) maxAssessmentBase:(PYGPayrollPeriod *)period forBase:(NSDecimalNumber *)incomeBase {
    NSUInteger maximumBaseInt = [self healthMaxAssessmentForYear:period.year];
    NSDecimalNumber * maximumBase = DECIMAL_NUMB(@(maximumBaseInt));
    if (maximumBaseInt == 0) {
        return incomeBase;
    }
    else
    {
        return [self minToBig:incomeBase andDecimal:maximumBase];
    }
}

- (NSDecimalNumber *) minAssessmentBase:(PYGPayrollPeriod *)period forBase:(NSDecimalNumber *)incomeBase {
    if (self.isMinimumAssessment == NO) {
        return incomeBase;
    }
    else
    {
        NSUInteger minimumBaseInt = [self healthMinAssessmentForYear:period.year month:period.month];
        NSDecimalNumber * minimumBase = DECIMAL_NUMB(@(minimumBaseInt));
        if ([self isGreater:minimumBase thenDecimal:incomeBase])
        {
            return minimumBase;
        }
        else
        {
            return incomeBase;
        }
    }
}

- (NSUInteger)healthMaxAssessmentForYear:(NSUInteger)year
{
    if (year>=2013)
    {
        return 0; //1863648L
    }
    else if (year==2012)
    {
        return 1809864;
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

- (NSUInteger) healthMinAssessmentForYear:(NSUInteger)year month:(NSUInteger)month {
    if (year>=2007)
    {
        return 8000;
    }
    else if (year==2006 && month>=7)
    {
        return 7955;
    }
    else if (year==2006)
    {
        return 7570;
    }
    else if (year==2005)
    {
        return 7185;
    }
    else if (year==2004)
    {
        return 6700;
    }
    else if (year==2003)
    {
        return 6200;
    }
    else if (year==2002)
    {
        return 5700;
    }
    else if (year==2001)
    {
        return 5000;
    }
    else if (year==2000 && month>=7)
    {
        return 4500;
    }
    else if (year==2000)
    {
        return 4000;
    }
    else if (year==1999 && month>=7)
    {
        return 3600;
    }
    else
    {
        return 3250;
    }
}

- (BOOL)exportXml:(PYGXmlBuilder*)xmlBuilder {
    NSDictionary *attributes = @{
            @"interest_code" : [@(self.interestCode) stringValue],
            @"minimum_asses" : [@(self.minimumAsses) stringValue]
    };
    BOOL done = [xmlBuilder writeXmlElement:@"spec_value" withAttributes:attributes];
    return done;
}

@end