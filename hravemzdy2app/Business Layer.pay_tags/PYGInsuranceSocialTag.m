//
// Created by lisy on 01.04.13.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import "PYGInsuranceSocialTag.h"
#import "PYGSymbolTags.h"
#import "PYGSymbolConcepts.h"


@implementation PYGInsuranceSocialTag {

}
- (id)init {
    if (!(self=[super initWithCodeName:[PYGSymbolTags codeRef:TAG_INSURANCE_SOCIAL]
                            andConcept:[PYGSymbolConcepts codeRef:CONCEPT_INSURANCE_SOCIAL]])) return nil;
    return self;
}

- (id)copyWithZone:(NSZone*) zone {
    return self;
}

+ (PYGInsuranceSocialTag *)tag {
    return [[self alloc] init];
}

-(BOOL)isDeductionNetto {
    return YES;
}

@end