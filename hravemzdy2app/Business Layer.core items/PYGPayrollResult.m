//
// Created by lisy on 31.03.13.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import "PYGPayrollResult.h"
#import "PYGPayrollConcept.h"
#import "NSArray+Func.h"
#import "PYGPayrollTag.h"
#import "PYGTagRefer.h"
#import "PYGPayrollName.h"
#import "PYGXmlBuilder.h"

#define EXP_TITLE @"title"
#define EXP_VALUE @"value"

@implementation PYGPayrollResult {

}
@synthesize tagCode = _tagCode;
@synthesize conceptCode = _conceptCode;
@synthesize concept = _concept;

- (id)initWithTagCode:(NSUInteger)tagCode andConceptCode:(NSUInteger)conceptCode andConcept:(PYGPayrollConcept *)concept {
    if (!(self=[super init])) return nil;
    _tagCode = tagCode;
    _conceptCode = conceptCode;
    _concept = [concept copy];
    return self;
}

- (BOOL) isSummaryFor:(NSUInteger) code {
    NSArray * summaryCodes = [[self.concept summaryCodes] map:^id(id obj) {
        return @([(PYGPayrollTag*)obj code]);
    }];
    return [summaryCodes containsObject:@(code)];
}

- (NSDecimalNumber *)getPayment {
    mustOverride();
    return nil;
}

- (NSDecimalNumber *)getDeduction {
    mustOverride();
    return nil;
}

- (NSString *)xmlValue {
    return @"";
}

- (NSString *)exportValueResult {
    return @"";
}

- (NSComparisonResult) compare:(PYGPayrollResult *) resultOther
{
    return [self compareUInt:[self tagCode] withUInt:[resultOther tagCode]];
}

- (NSDictionary *)exportTitleValueForTagRefer:(PYGTagRefer *)tagRefer andTagName:(PYGPayrollName*)tagName
                               andTagItem:(PYGPayrollTag *)tagItem andConcept:(PYGPayrollConcept *)tagConcept {
    return @{EXP_TITLE : tagName.title, EXP_VALUE : [self exportValueResult]};
}

- (NSComparisonResult)compareUInt:(NSUInteger) lhs withUInt:(NSUInteger) rhs {
    return lhs < rhs ? NSOrderedAscending : lhs > rhs ? NSOrderedDescending : NSOrderedSame;
}

- (BOOL)exportConceptXml:(PYGXmlBuilder*)xmlBuilder {
    return [self.concept exportXml:xmlBuilder];
}

- (BOOL)exportResultXml:(PYGXmlBuilder*)xmlBuilder {
    return YES;
}

- (BOOL)exportXml:(PYGXmlBuilder*)xmlBuilder forTagRefer:(PYGTagRefer *)tagResult {
    NSDictionary *attributes = @{
            @"period_base" : [@(tagResult.periodBase) stringValue],
            @"code" : [@(tagResult.code) stringValue],
            @"code_order" : [@(tagResult.codeOrder) stringValue]
    };
    BOOL done = [xmlBuilder writeXmlElement:@"reference" withAttributes:attributes];
    return done;
}

- (BOOL)exportXml:(PYGXmlBuilder*)xmlBuilder forTagName:(PYGPayrollName *)tagName
         withItem:(PYGPayrollTag *)tagItem andConcept:(PYGPayrollConcept *)tagConcept {
    NSDictionary *attributes = @{
            @"tag_name" : tagItem.name,
            @"category" : tagConcept.name
    };
    if ([xmlBuilder openXmlElement:@"item" withAttributes:attributes]) {
        [xmlBuilder writeXmlElement:@"title" withValue:tagName.title];
        [xmlBuilder writeXmlElement:@"description" withValue:tagName.description];
        [xmlBuilder writeXmlElement:@"group" withAttributes:[tagName getGroups]];
        [self exportConceptXml:xmlBuilder];
        [self exportResultXml:xmlBuilder];
        return [xmlBuilder closeXmlElement];
    }
    return NO;
}

- (BOOL)exportXml:(PYGXmlBuilder*)xmlBuilder forTag:(PYGTagRefer *)tagResult andName:(PYGPayrollName *)tagName
             withItem:(PYGPayrollTag *)tagItem andConcept:(PYGPayrollConcept *)tagConcept {
    if ([self exportXml:xmlBuilder forTagRefer:tagResult]) {
        return [self exportXml:xmlBuilder forTagName:tagName withItem:tagItem andConcept:tagConcept];
    }
    return NO;
}
@end