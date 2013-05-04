//
// Created by lisy on 01.04.13.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import <Foundation/Foundation.h>
#import "PYGPayrollConcept.h"

@class PYGPayrollPeriod;


@interface PYGInsuranceSocialConcept : PYGPayrollConcept <NSCopying>

@property(nonatomic, readonly) NSUInteger interestCode;

-(id)initWithTagCode:(NSUInteger) tagCode andValues:(NSDictionary *)values;
-(PYGInsuranceSocialConcept*)newConceptWithCode:(NSUInteger)tagCode andValues:(NSDictionary *)values;
+(PYGInsuranceSocialConcept *)concept;

-(PYGPayrollResult*)evaluateForPeriod:(PYGPayrollPeriod *)period config:(PYGPayTagGateway *)config results:(NSDictionary *)results;
-(NSDecimalNumber*) insuranceContribution:(PYGPayrollPeriod *)period withIncome:(NSDecimalNumber *)incomeBase;

@end