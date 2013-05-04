//
// Created by lisy on 01.04.13.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import <Foundation/Foundation.h>
#import "PYGPayrollConcept.h"


@interface PYGTaxClaimDisabilityConcept : PYGPayrollConcept <NSCopying>

@property(nonatomic, readonly) NSUInteger reliefCode1;
@property(nonatomic, readonly) NSUInteger reliefCode2;
@property(nonatomic, readonly) NSUInteger reliefCode3;

-(id)initWithTagCode:(NSUInteger) tagCode andValues:(NSDictionary *)values;
-(PYGTaxClaimDisabilityConcept*)newConceptWithCode:(NSUInteger)tagCode andValues:(NSDictionary *)values;
+(PYGTaxClaimDisabilityConcept *)concept;

-(PYGPayrollResult*)evaluateForPeriod:(PYGPayrollPeriod *)period config:(PYGPayTagGateway *)config results:(NSDictionary *)results;

@end