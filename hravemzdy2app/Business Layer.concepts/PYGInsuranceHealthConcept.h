//
// Created by lisy on 01.04.13.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import <Foundation/Foundation.h>
#import "PYGPayrollConcept.h"

@class PYGPayrollPeriod;


@interface PYGInsuranceHealthConcept : PYGPayrollConcept <NSCopying>

@property(nonatomic, readonly) NSUInteger interestCode;
@property(nonatomic, readonly) NSUInteger minimumAsses;

-(id)initWithTagCode:(NSUInteger) tagCode andValues:(NSDictionary *)values;
-(PYGInsuranceHealthConcept*)newConceptWithCode:(NSUInteger)tagCode andValues:(NSDictionary *)values;
+(PYGInsuranceHealthConcept *)concept;

-(PYGPayrollResult*)evaluateForPeriod:(PYGPayrollPeriod *)period config:(PYGPayTagGateway *)config results:(NSDictionary *)results;
-(NSDecimalNumber*) insuranceContribution:(PYGPayrollPeriod *)period withIncomeEmployer:(NSDecimalNumber *)employerIncome employee:(NSDecimalNumber *)employeeIncome;

@end