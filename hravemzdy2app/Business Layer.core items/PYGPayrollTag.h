//
// Created by lisy on 31.03.13.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import <Foundation/Foundation.h>
#import "PYGCodeNameRefer.h"

@class PYGPayrollConcept;


@interface PYGPayrollTag : PYGCodeNameRefer <NSCopying>
@property(nonatomic, readonly) PYGCodeNameRefer* concept;

-(id)initWithCodeName:(PYGCodeNameRefer *)codeName andConcept:(PYGCodeNameRefer *)concept;
+(id)payrollTagWithCodeName:(PYGCodeNameRefer *)codeName andConcept:(PYGCodeNameRefer *)concept;

-(NSString *)title;
-(NSString *)description;
-(NSUInteger)conceptCode;
-(NSString *)conceptName;

-(BOOL)isInsuranceHealth;
-(BOOL)isInsuranceSocial;
-(BOOL)isTaxAdvance;
-(BOOL)isIncomeGross;
-(BOOL)isIncomeNetto;
-(BOOL)isDeductionNetto;

@end