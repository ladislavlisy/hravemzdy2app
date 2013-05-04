//
// Created by lisy on 01.04.13.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import "PYGTaxEmployersSocialTag.h"
#import "PYGSymbolTags.h"
#import "PYGSymbolConcepts.h"


@implementation PYGTaxEmployersSocialTag {

}
- (id)init {
    if (!(self=[super initWithCodeName:[PYGSymbolTags codeRef:TAG_TAX_EMPLOYERS_SOCIAL]
                            andConcept:[PYGSymbolConcepts codeRef:CONCEPT_TAX_EMPLOYERS_SOCIAL]])) return nil;
    return self;
}

- (id)copyWithZone:(NSZone*) zone {
    return self;
}

+ (PYGTaxEmployersSocialTag *)tag {
    return [[self alloc] init];
}

@end