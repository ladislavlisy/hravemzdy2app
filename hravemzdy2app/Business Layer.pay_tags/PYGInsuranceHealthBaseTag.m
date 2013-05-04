//
// Created by lisy on 01.04.13.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import "PYGInsuranceHealthBaseTag.h"
#import "PYGSymbolTags.h"
#import "PYGSymbolConcepts.h"


@implementation PYGInsuranceHealthBaseTag {

}
- (id)init {
    if (!(self=[super initWithCodeName:[PYGSymbolTags codeRef:TAG_INSURANCE_HEALTH_BASE]
                            andConcept:[PYGSymbolConcepts codeRef:CONCEPT_INSURANCE_HEALTH_BASE]])) return nil;
    return self;
}

- (id)copyWithZone:(NSZone*) zone {
    return self;
}

+ (PYGInsuranceHealthBaseTag *)tag {
    return [[self alloc] init];
}

@end