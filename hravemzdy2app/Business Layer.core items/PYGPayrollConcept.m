//
// Created by lisy on 31.03.13.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import "PYGPayrollConcept.h"
#import "PYGTagRefer.h"
#import "PYGPayrollResult.h"
#import "PYGPayrollPeriod.h"
#import "PYGPayTagGateway.h"
#import "NSDictionary+Func.h"
#import "PYGXmlBuilder.h"

@interface PYGPayrollConcept ()
@property(nonatomic, readwrite) NSArray * tagPendingCodes;
@end

@implementation PYGPayrollConcept {
}

@synthesize tagCode = _tagCode;
@synthesize tagPendingCodes = _tagPendingCodes;


- (id)initWithCodeName:(PYGCodeNameRefer *)codeName andTagCode:(NSUInteger)tagCode {
    if (!(self=[super initWithCode:codeName.code andName:codeName.name]))  return nil;
    _tagCode = tagCode;
    _tagPendingCodes = nil;
    return self;
}

- (id)copyWithZone:(NSZone*) zone {
    id copiedConcept = [[[self class] allocWithZone:zone] initWithCode:[self code] andName:[self name]];
    return copiedConcept;
}

- (id)newConceptWithCode:(NSUInteger)tagCode andValues:(NSDictionary *)values {
    return nil;
}

- (PYGPayrollResult*)evaluateForPeriod:(PYGPayrollPeriod *)period config:(PYGPayTagGateway *)config results:(NSDictionary *)results {
    return nil;
}

//TODO: rename init_pending_codes to setPendingCodes
- (NSArray *)setPendingCodes:(NSArray *)pendingCodes {
    if (pendingCodes == nil) {
        self.tagPendingCodes = @[];
    }
    else
    {
        self.tagPendingCodes = [pendingCodes copy];
    }
    return self.tagPendingCodes;
}

- (NSArray *)pendingCodes {
    return @[];
}

- (NSArray *)summaryCodes {
    return @[];
}

- (NSUInteger)calcCategory {
    return CALC_CATEGORY_START;
}

- (NSUInteger)typeOfResult {
    return TYPE_RESULT_NULL;
}

- (BOOL)exportXml:(PYGXmlBuilder*)xmlBuilder {
    return YES;
}

- (NSComparisonResult) compare:(PYGPayrollConcept *) conceptOther
{
    NSUInteger countSelfPending = [self countPendingCodes:self.tagPendingCodes forCode:conceptOther.tagCode];
    if (countSelfPending!=0) {
#ifdef LOG_COMPARE_CONSOLE
        NSLog(@"%@ - %@ ASC Pending", conceptOther.name, self.name);
#endif
        return NSOrderedDescending;
    }
    NSUInteger countOtherPending = [self countPendingCodes:conceptOther.tagPendingCodes forCode:self.tagCode];
    if (countOtherPending!=0) {
#ifdef LOG_COMPARE_CONSOLE
        NSLog(@"%@ - %@ ASC Pending", self.name, conceptOther.name);
#endif
        return NSOrderedAscending;
    }
    NSUInteger countSelfSummary = [self countSummaryCodes:[self summaryCodes] forCode:conceptOther.tagCode];
    if (countSelfSummary!=0) {
#ifdef LOG_COMPARE_CONSOLE
        NSLog(@"%@ - %@ ASC Summary", self.name, conceptOther.name);
#endif
        return NSOrderedAscending;
    }
    NSUInteger countOtherSummary = [self countSummaryCodes:[conceptOther summaryCodes] forCode:self.tagCode];
    if (countOtherSummary!=0)  {
#ifdef LOG_COMPARE_CONSOLE
        NSLog(@"%@ - %@ ASC Summary", conceptOther.name, self.name);
#endif
        return NSOrderedDescending;
    }
    if ([self calcCategory] == [conceptOther calcCategory]) {
        NSComparisonResult codeResult = [self compareUInt:self.tagCode withUInt:conceptOther.tagCode];
#ifdef LOG_COMPARE_CONSOLE
        if (codeResult == NSOrderedAscending) {
            NSLog(@"%@ - %@ ASC code", self.name, conceptOther.name);
        }
        else if (codeResult == NSOrderedDescending)
        {
            NSLog(@"%@ - %@ ASC code", conceptOther.name, self.name);
        }
        else
        {
            NSLog(@"%@ - %@ SAME code", self.name, conceptOther.name);
        }
#endif
        return codeResult;
    }
    else
    {
        NSComparisonResult categoryResult = [self compareUInt:[self calcCategory] withUInt:[conceptOther calcCategory]];
#ifdef LOG_COMPARE_CONSOLE
        if (categoryResult == NSOrderedAscending) {
            NSLog(@"%@ - %@ ASC category", self.name, conceptOther.name);
        }
        else if (categoryResult == NSOrderedDescending)
        {
            NSLog(@"%@ - %@ ASC category", conceptOther.name, self.name);
        }
        else
        {
            NSLog(@"%@ - %@ SAME category", conceptOther.name, self.name);
        }
#endif
        return categoryResult;
    }
}

- (NSComparisonResult)compareUInt:(NSUInteger) lhs withUInt:(NSUInteger) rhs {
    return lhs < rhs ? NSOrderedAscending : lhs > rhs ? NSOrderedDescending : NSOrderedSame;
}

- (NSUInteger)countPendingCodes:(NSArray *)conceptPending forCode:(NSUInteger)code {
    NSUInteger predicateCode = code;
    NSPredicate * equalTagPredicate = [NSPredicate predicateWithBlock:^BOOL (id obj, NSDictionary *bind) {
        PYGTagRefer * tagRefer = (PYGTagRefer *)obj;
        return (tagRefer.code==predicateCode);
    }];
    NSArray * _codes = [conceptPending filteredArrayUsingPredicate:equalTagPredicate];
    return _codes.count;
}

- (NSUInteger)countSummaryCodes:(NSArray *)conceptSummary forCode:(NSUInteger)code {
    NSUInteger predicateCode = code;
    NSPredicate * equalTagPredicate = [NSPredicate predicateWithBlock:^BOOL (id obj, NSDictionary *bind) {
        PYGTagRefer * tagRefer = (PYGTagRefer *)obj;
        return (tagRefer.code==predicateCode);
    }];
    NSArray * _codes = [conceptSummary filteredArrayUsingPredicate:equalTagPredicate];
    return _codes.count;

}

// get term from Results by key of tag
- (PYGPayrollResult *)getResult:(NSDictionary *)results byTagCode:(NSUInteger)selCode {
    NSDictionary * resultHash = [results selectWithBlock:^BOOL (id key, id obj) {
        PYGTagRefer * tagRef = (PYGTagRefer *)key;
        return tagRef.code == selCode;
    }];

    return [resultHash allValues][0];
}

- (NSDecimalNumber*)bigDecimal:(NSNumber*)op1 multiBy:(NSNumber *)op2 {
    NSDecimalNumber * big_op1 = [self bigDecimalWithNumber:(op1)];
    NSDecimalNumber * big_op2 = [self bigDecimalWithNumber:(op2)];
    return [big_op1 decimalNumberByMultiplyingBy:big_op2];
}

- (NSDecimalNumber*)bigDecimal:(NSNumber*)op1 divBy:(NSNumber *)op2 {
    NSDecimalNumber * big_op1 = [self bigDecimalWithNumber:(op1)];
    NSDecimalNumber * big_op2 = [self bigDecimalWithNumber:(op2)];
    //TODO: division by zero
    if ([big_op2 isEqual:DECIMAL_ZERO]) {
        return DECIMAL_ZERO;
    }
    return [big_op1 decimalNumberByDividingBy:big_op2];
}

- (NSDecimalNumber*)bigDecimal:(NSNumber*)op1 multiBy:(NSNumber *)op2 divBy:(NSNumber *)div {
    NSDecimalNumber * big_op1 = [self bigDecimalWithNumber:(op1)];
    NSDecimalNumber * big_op2 = [self bigDecimalWithNumber:(op2)];
    NSDecimalNumber * big_div = [self bigDecimalWithNumber:(div)];
    //TODO: division by zero
    if ([big_div isEqual:DECIMAL_ZERO]) {
        return DECIMAL_ZERO;
    }
    return [[big_op1 decimalNumberByMultiplyingBy:big_op2] decimalNumberByDividingBy:big_div];
}

- (NSDecimalNumber*)roundUpToBig:(NSNumber *) valueDec {
    NSUInteger roundedInt = (NSUInteger)(ceil(fabs(valueDec.doubleValue)));
    return [self bigDecimalWithNumber:(valueDec.integerValue < 0 ? @(-roundedInt) : @(roundedInt))];
}

- (NSUInteger)roundUpToFix:(NSNumber *) valueDec {
    NSUInteger roundedInt = (NSUInteger)(ceil(fabs(valueDec.doubleValue)));
    return (NSUInteger) (valueDec.integerValue < 0 ? (-roundedInt) : (roundedInt));
}

- (NSDecimalNumber*)roundDownToBig:(NSNumber *) valueDec {
    NSUInteger roundedInt = (NSUInteger)(floor(fabs(valueDec.doubleValue)));
    return [self bigDecimalWithNumber:(valueDec.integerValue < 0 ? @(-roundedInt) : @(roundedInt))];
}

- (NSUInteger)roundDownToFix:(NSNumber *) valueDec {
    NSUInteger roundedInt = (NSUInteger)(floor(fabs(valueDec.doubleValue)));
    return (NSUInteger) (valueDec.integerValue < 0 ? (-roundedInt) : (roundedInt));
}

- (NSDecimalNumber*)maxToBig:(NSDecimalNumber *) bigMax1 andNumber:(NSNumber *) max2 {
    NSDecimalNumber * bigMax2 = [NSDecimalNumber decimalNumberWithDecimal:[max2 decimalValue]];
    return ([bigMax1 compare:bigMax2] ==  NSOrderedDescending) ? bigMax2 : bigMax1;
}

- (NSDecimalNumber*)maxToZero:(NSDecimalNumber *) bigMax1 {
    return [self maxToBig:bigMax1 andDecimal:[NSDecimalNumber zero]];
}

- (NSDecimalNumber*)maxToBig:(NSDecimalNumber *) bigMax1 andDecimal:(NSDecimalNumber *) bigMax2 {
    return ([bigMax1 compare:bigMax2] ==  NSOrderedDescending) ? bigMax1 : bigMax2;
}

- (NSDecimalNumber*)minToZero:(NSDecimalNumber *) bigMax1 {
    return [self minToBig:bigMax1 andDecimal:[NSDecimalNumber zero]];
}

- (NSDecimalNumber*)minToBig:(NSDecimalNumber *) bigMax1 andDecimal:(NSDecimalNumber *) bigMax2 {
    return ([bigMax1 compare:bigMax2] ==  NSOrderedAscending) ? bigMax1 : bigMax2;
}

- (NSDecimalNumber*)minToBig:(NSDecimalNumber *) bigMax1 andNumber:(NSNumber *) max2 {
    NSDecimalNumber * bigMax2 = [NSDecimalNumber decimalNumberWithDecimal:[max2 decimalValue]];
    return ([bigMax1 compare:bigMax2] ==  NSOrderedAscending) ? bigMax2 : bigMax1;
}

- (BOOL)isLess:(NSDecimalNumber *) bigMax1 thenDecimal:(NSDecimalNumber *) bigMax2 {
    return ([bigMax1 compare:bigMax2] ==  NSOrderedAscending) ? YES : NO;
}

- (BOOL)isLessOrEq:(NSDecimalNumber *) bigMax1 thenDecimal:(NSDecimalNumber *) bigMax2 {
    NSComparisonResult comparisonResult = [bigMax1 compare:bigMax2];
    return (comparisonResult ==  NSOrderedAscending || comparisonResult ==  NSOrderedSame) ? YES : NO;
}

- (BOOL)isLessThenZero:(NSDecimalNumber *) bigMax1 {
    return ([bigMax1 compare:[NSDecimalNumber zero]] ==  NSOrderedAscending) ? YES : NO;
}

- (BOOL)isLessOrEqZero:(NSDecimalNumber *) bigMax1 {
    NSComparisonResult comparisonResult = [bigMax1 compare:[NSDecimalNumber zero]];
    return (comparisonResult ==  NSOrderedAscending || comparisonResult ==  NSOrderedSame) ? YES : NO;
}

- (BOOL)isGreater:(NSDecimalNumber *) bigMax1 thenDecimal:(NSDecimalNumber *) bigMax2 {
    return ([bigMax1 compare:bigMax2] ==  NSOrderedDescending) ? YES : NO;
}

- (BOOL)isGreaterOrEq:(NSDecimalNumber *) bigMax1 thenDecimal:(NSDecimalNumber *) bigMax2 {
    NSComparisonResult comparisonResult = [bigMax1 compare:bigMax2];
    return (comparisonResult ==  NSOrderedDescending || comparisonResult ==  NSOrderedSame) ? YES : NO;
}

- (BOOL)isGreaterThenZero:(NSDecimalNumber *) bigMax1 {
    return ([bigMax1 compare:[NSDecimalNumber zero]] ==  NSOrderedDescending) ? YES : NO;
}

- (BOOL)isGreaterOrEqZero:(NSDecimalNumber *) bigMax1 {
    NSComparisonResult comparisonResult = [bigMax1 compare:[NSDecimalNumber zero]];
    return (comparisonResult ==  NSOrderedDescending || comparisonResult ==  NSOrderedSame) ? YES : NO;
}

- (NSDecimalNumber*)bigDecimal:(NSNumber *) valueDec nearRoundUp:(NSNumber *) nearest/*=100*/ {
    return [self bigDecimal:[self roundUpToBig:[self bigDecimal:valueDec divBy:nearest]] multiBy:nearest];
}

- (NSDecimalNumber*)bigDecimal:(NSNumber *) valueDec nearRoundDown:(NSNumber *) nearest/*=100*/ {
    return [self bigDecimal:[self roundDownToBig:[self bigDecimal:valueDec divBy:nearest]] multiBy:nearest];
}

- (NSDecimalNumber*)bigInsuranceRoundUp:(NSNumber *) valueDec {
    return [self roundUpToBig:valueDec];
}

- (NSUInteger)fixInsuranceRoundUp:(NSNumber *) valueDec {
    return [self roundUpToFix:valueDec];
}

- (NSDecimalNumber*)bigTaxRoundUp:(NSNumber *) valueDec {
    return [self roundUpToBig:valueDec];
}

- (NSUInteger)fixTaxRoundUp:(NSNumber *) valueDec {
    return [self roundUpToFix:valueDec];
}

- (NSDecimalNumber*)bigTaxRoundDown:(NSNumber *) valueDec {
    return [self roundDownToBig:valueDec];
}

- (NSUInteger)fixTaxRoundDown:(NSNumber *) valueDec {
    return [self roundDownToFix:valueDec];
}

- (NSDecimalNumber*)bigDecimalWithNumber:(NSNumber *) valueDec {
    return [NSDecimalNumber decimalNumberWithDecimal:[valueDec decimalValue]];
}

@end
