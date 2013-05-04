//
// Created by lisy on 31.03.13.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import <Foundation/Foundation.h>

#import "PYGPayrollResult.h"

@interface PYGTaxAdvanceResult : PYGPayrollResult

@property (nonatomic, readonly) NSDecimalNumber * payment;
@property (nonatomic, readonly) NSDecimalNumber * afterReliefA;
@property (nonatomic, readonly) NSDecimalNumber * afterReliefC;

-(id)initWithTagCode:(NSUInteger)tagCode andConceptCode:(NSUInteger)conceptCode andConcept:(PYGPayrollConcept *)concept andValues:(NSDictionary *)values;
+(id)newWithTagCode:(NSUInteger)tagCode andConceptCode:(NSUInteger)conceptCode andConcept:(PYGPayrollConcept *)concept andValues:(NSDictionary *)values;
+(id)newWithConcept:(PYGPayrollConcept *)concept andValues:(NSDictionary *)values;

-(NSDecimalNumber *)getDeduction;
-(NSDecimalNumber *)getPayment;

@end