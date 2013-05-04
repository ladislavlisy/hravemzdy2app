//
// Created by lisy on 01.04.13.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import "PYGInsuranceSocialBaseTag.h"
#import "PYGSymbolTags.h"
#import "PYGSymbolConcepts.h"


@implementation PYGInsuranceSocialBaseTag {

}
- (id)init {
    if (!(self=[super initWithCodeName:[PYGSymbolTags codeRef:TAG_INSURANCE_SOCIAL_BASE]
                            andConcept:[PYGSymbolConcepts codeRef:CONCEPT_INSURANCE_SOCIAL_BASE]])) return nil;
    return self;
}

- (id)copyWithZone:(NSZone*) zone {
    return self;
}

+ (PYGInsuranceSocialBaseTag *)tag {
    return [[self alloc] init];
}

@end