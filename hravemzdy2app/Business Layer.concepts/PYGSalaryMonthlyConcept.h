//
// Created by lisy on 01.04.13.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import <Foundation/Foundation.h>
#import "PYGPayrollConcept.h"


@interface PYGSalaryMonthlyConcept : PYGPayrollConcept <NSCopying>

@property(nonatomic, readonly) NSDecimalNumber * amountMonthly;

-(id)initWithTagCode:(NSUInteger) tagCode andValues:(NSDictionary *)values;
-(PYGSalaryMonthlyConcept*)newConceptWithCode:(NSUInteger)tagCode andValues:(NSDictionary *)values;
+(PYGSalaryMonthlyConcept *)concept;

-(PYGPayrollResult*)evaluateForPeriod:(PYGPayrollPeriod *)period config:(PYGPayTagGateway *)config results:(NSDictionary *)results;

@end