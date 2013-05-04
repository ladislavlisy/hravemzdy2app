//
// Created by lisy on 01.04.13.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import <Foundation/Foundation.h>
#import "PYGPayrollTag.h"


@interface PYGInsuranceSocialTag : PYGPayrollTag <NSCopying>
-(id)init;
+(PYGInsuranceSocialTag*)tag;

-(BOOL)isDeductionNetto;

@end