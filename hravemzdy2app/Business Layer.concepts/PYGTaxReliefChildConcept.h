//
// Created by lisy on 01.04.13.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import <Foundation/Foundation.h>
#import "PYGPayrollConcept.h"


@interface PYGTaxReliefChildConcept : PYGPayrollConcept <NSCopying>

-(id)initWithTagCode:(NSUInteger) tagCode andValues:(NSDictionary *)values;
-(PYGTaxReliefChildConcept*)newConceptWithCode:(NSUInteger)tagCode andValues:(NSDictionary *)values;
+(PYGTaxReliefChildConcept *)concept;

-(PYGPayrollResult*)evaluateForPeriod:(PYGPayrollPeriod *)period config:(PYGPayTagGateway *)config results:(NSDictionary *)results;

@end