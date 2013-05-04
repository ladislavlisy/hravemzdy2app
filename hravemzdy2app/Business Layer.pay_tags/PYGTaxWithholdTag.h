//
// Created by lisy on 01.04.13.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import <Foundation/Foundation.h>
#import "PYGPayrollTag.h"


@interface PYGTaxWithholdTag : PYGPayrollTag <NSCopying>
-(id)init;
+(PYGTaxWithholdTag*)tag;

-(BOOL)isDeductionNetto;

@end