//
// Created by lisy on 01.04.13.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import "PYGSalaryBaseTag.h"
#import "PYGSymbolConcepts.h"
#import "PYGSymbolTags.h"


@implementation PYGSalaryBaseTag {

}
- (id)init {
    if (!(self=[super initWithCodeName:[PYGSymbolTags codeRef:TAG_SALARY_BASE]
                            andConcept:[PYGSymbolConcepts codeRef:CONCEPT_SALARY_MONTHLY]])) return nil;
    return self;
}

- (id)copyWithZone:(NSZone*) zone {
    return self;
}

+ (PYGSalaryBaseTag *)tag {
    return [[self alloc] init];
}

-(BOOL)isInsuranceHealth {
    return YES;
}

-(BOOL)isInsuranceSocial {
    return YES;
}

-(BOOL)isTaxAdvance {
    return YES;
}

-(BOOL)isIncomeGross {
    return YES;
}

-(BOOL)isIncomeNetto {
    return YES;
}

@end