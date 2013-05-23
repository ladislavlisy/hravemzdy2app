//
// Created by lisy on 31.03.13.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import "PYGPayrollTag.h"


@implementation PYGPayrollTag {

}
@synthesize concept = _concept;

- (id)initWithCodeName:(PYGCodeNameRefer *)codeName andConcept:(PYGCodeNameRefer *)concept {
    if (!(self=[super initWithCode:codeName.code andName:codeName.name])) return nil;
    _concept = [concept copy];
    return self;
}

+ (id)payrollTagWithCodeName:(PYGCodeNameRefer *)codeName andConcept:(PYGCodeNameRefer *)concept {
    return [[self alloc] initWithCodeName:codeName andConcept:concept];
}

// Copying protocol returns self instance
- (id)copyWithZone:(NSZone*) zone {
    return self;
}

-(NSString *)title {
    return self.name;
}

-(NSString *)description {
    return self.name;
}

- (NSUInteger)typeOfResult {
    return TYPE_RESULT_NULL;
}

-(NSUInteger)conceptCode {
    return self.concept.code;
}

-(NSString *)conceptName{
    return self.concept.name;
}

-(BOOL)isInsuranceHealth {
    return NO;
}

-(BOOL)isInsuranceSocial {
    return NO;
}

-(BOOL)isTaxAdvance {
    return NO;
}

-(BOOL)isIncomeGross {
    return NO;
}

-(BOOL)isIncomeNetto {
    return NO;
}

-(BOOL)isDeductionNetto {
    return NO;
}

@end