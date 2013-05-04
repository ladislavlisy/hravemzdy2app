//
// Created by lisy on 01.04.13.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import <Foundation/Foundation.h>
#import "PYGPayrollConcept.h"

@class PYGPayrollPeriod;


@interface PYGTaxAdvanceBaseConcept : PYGPayrollConcept <NSCopying>

-(id)initWithTagCode:(NSUInteger) tagCode andValues:(NSDictionary *)values;
-(PYGTaxAdvanceBaseConcept*)newConceptWithCode:(NSUInteger)tagCode andValues:(NSDictionary *)values;
+(PYGTaxAdvanceBaseConcept *)concept;

-(PYGPayrollResult*)evaluateForPeriod:(PYGPayrollPeriod *)period config:(PYGPayTagGateway *)config results:(NSDictionary *)results;
-(NSDecimalNumber *)taxRoundedBase:(PYGPayrollPeriod *)period withDecl:(BOOL)taxDecl income:(NSDecimalNumber *)taxIncome base:(NSDecimalNumber *)taxBase;
-(NSDecimalNumber *)advanceRoundedBase:(PYGPayrollPeriod *)period withDecl:(BOOL)taxDecl base:(NSDecimalNumber *)taxBase;

@end