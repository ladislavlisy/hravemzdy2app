//
// Created by lisy on 01.04.13.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import <Foundation/Foundation.h>
#import "PYGPayrollConcept.h"


@interface PYGTaxEmployersHealthConcept : PYGPayrollConcept <NSCopying>

@property(nonatomic, readonly) NSUInteger interestCode;

-(id)initWithTagCode:(NSUInteger) tagCode andValues:(NSDictionary *)values;
-(PYGTaxEmployersHealthConcept *)newConceptWithCode:(NSUInteger)tagCode andValues:(NSDictionary *)values;
+(PYGTaxEmployersHealthConcept *)concept;

-(PYGPayrollResult*)evaluateForPeriod:(PYGPayrollPeriod *)period config:(PYGPayTagGateway *)config results:(NSDictionary *)results;

@end