//
// Created by lisy on 01.04.13.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import <Foundation/Foundation.h>
#import "PYGPayrollConcept.h"


@interface PYGUnknownConcept : PYGPayrollConcept <NSCopying>

-(id)initWithTagCode:(NSUInteger) tagCode;
-(PYGUnknownConcept*)newConceptWithCode:(NSUInteger)tagCode;
+(PYGUnknownConcept *)concept;

@end