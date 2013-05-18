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

/*
  def export_xml_result(xml_element)
    attributes = {}
    attributes[:month_schedule] = @month_schedule
    xml_element.value(xml_value, attributes)
  end

  def xml_value
    sum_hours = month_schedule.inject (0) {|agr, item|  agr+item }
    "#{sum_hours} hours"
  end

---------------------------------------------------------------
  def export_xml_tag_refer(tag_refer, xml_builder)
    attributes = {}
    attributes[:period_base] = tag_refer.period_base
    attributes[:code]        = tag_refer.code
    attributes[:code_order]  = tag_refer.code_order
    xml_builder.reference(attributes)
  end

  def export_xml_concept(xml_builder)
    @concept.export_xml(xml_builder)
  end

  def export_xml_result(xml_builder)
  end

  def export_value_result
  end

  def export_xml_names(tag_name, tag_item, tag_concept, xml_element)
    attributes = {}
    attributes[:tag_name] = tag_item.name
    attributes[:category] = tag_concept.name

    xml_element.item(attributes) do |xml_item|
      xml_item.title tag_name.title
      xml_item.description tag_name.description
      xml_item.group(tag_name.get_groups)
      export_xml_concept(xml_item)
      export_xml_result(xml_item)
    end
  end

  def export_xml(tag_refer, tag_name, tag_item, tag_concept, xml_element)
    export_xml_tag_refer(tag_refer, xml_element)
    export_xml_names(tag_name, tag_item, tag_concept, xml_element)
  end
*/
@end