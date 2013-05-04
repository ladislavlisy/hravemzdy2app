//
// Created by lisy on 31.03.13.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import <Foundation/Foundation.h>
#import "PYGCodeNameRefer.h"

@class PYGPayrollResult;
@class PYGPayrollPeriod;
@class PYGPayTagGateway;

typedef NS_ENUM(NSUInteger, CalcCategory)
{
    CALC_CATEGORY_START  = 0,
    CALC_CATEGORY_TIMES  = 0,
    CALC_CATEGORY_AMOUNT = 0,
    CALC_CATEGORY_GROSS  = 1,
    CALC_CATEGORY_NETTO  = 2,
    CALC_CATEGORY_FINAL  = 9
};

typedef NS_ENUM(NSUInteger, TermDayOrder)
{
    TERM_BEG_FINISHED  = 32,
    TERM_END_FINISHED  = 0
};


@interface PYGPayrollConcept : PYGCodeNameRefer <NSCopying>

@property(nonatomic, readonly) NSUInteger tagCode;
@property(nonatomic, readonly) NSArray * tagPendingCodes;

-(id)initWithCodeName:(PYGCodeNameRefer*)codeName andTagCode:(NSUInteger)tagCode;
-(id)newConceptWithCode:(NSUInteger)tagCode andValues:(NSDictionary *)values;

-(NSComparisonResult)compare:(PYGPayrollConcept *)conceptOther;

-(PYGPayrollResult*)evaluateForPeriod:(PYGPayrollPeriod *)period config:(PYGPayTagGateway *)config results:(NSDictionary *)results;
-(PYGPayrollResult*)getResult:(NSDictionary *)results byTagCode:(NSUInteger)selCode;

-(NSArray *)setPendingCodes:(NSArray *)pendingCodes;
-(NSArray *)pendingCodes;
-(NSArray *)summaryCodes;
-(NSUInteger)calcCategory;

- (NSDecimalNumber*)bigDecimal:(NSNumber*)op1 multiBy:(NSNumber *)op2;
- (NSDecimalNumber*)bigDecimal:(NSNumber*)op1 divBy:(NSNumber *)op2;
- (NSDecimalNumber*)bigDecimal:(NSNumber*)op1 multiBy:(NSNumber *)op2 divBy:(NSNumber *)div;
- (NSDecimalNumber*)roundUpToBig:(NSNumber *) valueDec;
- (NSUInteger)roundUpToFix:(NSNumber *) valueDec;
- (NSDecimalNumber*)roundDownToBig:(NSNumber *) valueDec;
- (NSUInteger)roundDownToFix:(NSNumber *) valueDec;
- (NSDecimalNumber*)bigDecimal:(NSNumber *) valueDec nearRoundUp:(NSNumber *) nearest/*=100*/;
- (NSDecimalNumber*)bigDecimal:(NSNumber *) valueDec nearRoundDown:(NSNumber *) nearest/*=100*/;
- (NSDecimalNumber*)bigInsuranceRoundUp:(NSNumber *) valueDec;
- (NSUInteger)fixInsuranceRoundUp:(NSNumber *) valueDec;
- (NSDecimalNumber*)bigTaxRoundUp:(NSNumber *) valueDec;
- (NSUInteger)fixTaxRoundUp:(NSNumber *) valueDec;
- (NSDecimalNumber*)bigTaxRoundDown:(NSNumber *) valueDec;
- (NSUInteger)fixTaxRoundDown:(NSNumber *) valueDec;
- (NSDecimalNumber*)maxToBig:(NSDecimalNumber *) bigMax1 andNumber:(NSNumber *) max2;
- (NSDecimalNumber*)maxToBig:(NSDecimalNumber *) bigMax1 andDecimal:(NSDecimalNumber *) bigMax2;
- (NSDecimalNumber*)maxToZero:(NSDecimalNumber *) bigMax1;
- (NSDecimalNumber*)minToBig:(NSDecimalNumber *) bigMax1 andNumber:(NSNumber *) max2;
- (NSDecimalNumber*)minToBig:(NSDecimalNumber *) bigMax1 andDecimal:(NSDecimalNumber *) bigMax2;
- (NSDecimalNumber*)minToZero:(NSDecimalNumber *) bigMax1;
- (BOOL)isLess:(NSDecimalNumber *) bigMax1 thenDecimal:(NSDecimalNumber *) bigMax2;
- (BOOL)isLessOrEq:(NSDecimalNumber *) bigMax1 thenDecimal:(NSDecimalNumber *) bigMax2;
- (BOOL)isLessThenZero:(NSDecimalNumber *) bigMax1;
- (BOOL)isLessOrEqZero:(NSDecimalNumber *) bigMax1;
- (BOOL)isGreater:(NSDecimalNumber *) bigMax1 thenDecimal:(NSDecimalNumber *) bigMax2;
- (BOOL)isGreaterOrEq:(NSDecimalNumber *) bigMax1 thenDecimal:(NSDecimalNumber *) bigMax2;
- (BOOL)isGreaterThenZero:(NSDecimalNumber *) bigMax1;
- (BOOL)isGreaterOrEqZero:(NSDecimalNumber *) bigMax1;
- (NSDecimalNumber*)bigDecimalWithNumber:(NSNumber *) valueDec;
@end