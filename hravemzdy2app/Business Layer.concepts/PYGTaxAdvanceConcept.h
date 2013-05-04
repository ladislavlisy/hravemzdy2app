//
// Created by lisy on 01.04.13.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import <Foundation/Foundation.h>
#import "PYGPayrollConcept.h"

@class PYGPayrollPeriod;


@interface PYGTaxAdvanceConcept : PYGPayrollConcept <NSCopying>

-(id)initWithTagCode:(NSUInteger) tagCode andValues:(NSDictionary *)values;
-(PYGTaxAdvanceConcept*)newConceptWithCode:(NSUInteger)tagCode andValues:(NSDictionary *)values;
+(PYGTaxAdvanceConcept *)concept;

-(PYGPayrollResult*)evaluateForPeriod:(PYGPayrollPeriod *)period config:(PYGPayTagGateway *)config results:(NSDictionary *)results;
-(NSInteger)taxAdvCalculate:(PYGPayrollPeriod *)period withIncome:(NSDecimalNumber *)taxIncome base:(NSDecimalNumber *)taxBase;
-(NSInteger)taxAdvCalculateMonth:(PYGPayrollPeriod *)period withIncome:(NSDecimalNumber *)taxIncome base:(NSDecimalNumber *)taxBase;

@end