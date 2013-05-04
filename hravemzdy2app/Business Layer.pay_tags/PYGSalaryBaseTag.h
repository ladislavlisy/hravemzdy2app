//
// Created by lisy on 01.04.13.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import <Foundation/Foundation.h>
#import "PYGPayrollTag.h"


@interface PYGSalaryBaseTag : PYGPayrollTag <NSCopying>
-(id)init;
+(PYGSalaryBaseTag*)tag;

-(BOOL)isInsuranceHealth;
-(BOOL)isInsuranceSocial;
-(BOOL)isTaxAdvance;
-(BOOL)isIncomeGross;
-(BOOL)isIncomeNetto;

@end