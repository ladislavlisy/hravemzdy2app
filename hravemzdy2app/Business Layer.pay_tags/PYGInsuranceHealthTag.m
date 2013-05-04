//
// Created by lisy on 01.04.13.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import "PYGInsuranceHealthTag.h"
#import "PYGSymbolTags.h"
#import "PYGSymbolConcepts.h"


@implementation PYGInsuranceHealthTag {

}
- (id)init {
    if (!(self=[super initWithCodeName:[PYGSymbolTags codeRef:TAG_INSURANCE_HEALTH]
                            andConcept:[PYGSymbolConcepts codeRef:CONCEPT_INSURANCE_HEALTH]])) return nil;
    return self;
}

- (id)copyWithZone:(NSZone*) zone {
    return self;
}

+ (PYGInsuranceHealthTag *)tag {
    return [[self alloc] init];
}

-(BOOL)isDeductionNetto {
    return YES;
}

@end