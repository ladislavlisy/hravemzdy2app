//
// Created by lisy on 01.04.13.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import <Foundation/Foundation.h>
#import "PYGPayrollConcept.h"


@interface PYGTimesheetWorkConcept : PYGPayrollConcept <NSCopying>

-(id)initWithTagCode:(NSUInteger) tagCode andValues:(NSDictionary *)values;
-(PYGTimesheetWorkConcept*)newConceptWithCode:(NSUInteger)tagCode andValues:(NSDictionary *)values;
+(PYGTimesheetWorkConcept *)concept;

-(PYGPayrollResult*)evaluateForPeriod:(PYGPayrollPeriod *)period config:(PYGPayTagGateway *)config results:(NSDictionary *)results;

@end