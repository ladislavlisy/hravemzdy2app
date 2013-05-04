//
// Created by lisy on 01.04.13.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import <Foundation/Foundation.h>
#import "PYGPayrollConcept.h"


@interface PYGTaxEmployersSocialConcept : PYGPayrollConcept <NSCopying>

@property(nonatomic, readonly) NSUInteger interestCode;

-(id)initWithTagCode:(NSUInteger) tagCode andValues:(NSDictionary *)values;
-(PYGTaxEmployersSocialConcept *)newConceptWithCode:(NSUInteger)tagCode andValues:(NSDictionary *)values;
+(PYGTaxEmployersSocialConcept *)concept;

-(PYGPayrollResult*)evaluateForPeriod:(PYGPayrollPeriod *)period config:(PYGPayTagGateway *)config results:(NSDictionary *)results;

@end