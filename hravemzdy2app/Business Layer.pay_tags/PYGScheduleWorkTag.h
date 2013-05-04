//
// Created by lisy on 01.04.13.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import <Foundation/Foundation.h>
#import "PYGPayrollTag.h"


@interface PYGScheduleWorkTag : PYGPayrollTag <NSCopying>
-(id)init;
+(PYGScheduleWorkTag*)tag;
@end