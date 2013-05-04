//
// Created by lisy on 01.04.13.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import <Foundation/Foundation.h>
#import "PYGPayrollConcept.h"


@interface PYGScheduleWeeklyConcept : PYGPayrollConcept <NSCopying>

@property(nonatomic, readonly) NSInteger hoursWeekly;

-(id)initWithTagCode:(NSUInteger) tagCode andValues:(NSDictionary *)values;
-(PYGScheduleWeeklyConcept*)newConceptWithCode:(NSUInteger)tagCode andValues:(NSDictionary *)values;
+(PYGScheduleWeeklyConcept *)concept;

-(PYGPayrollResult*)evaluateForPeriod:(PYGPayrollPeriod *)period config:(PYGPayTagGateway *)config results:(NSDictionary *)results;

@end