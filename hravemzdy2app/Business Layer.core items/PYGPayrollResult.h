//
// Created by lisy on 31.03.13.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import <Foundation/Foundation.h>

@class PYGPayrollConcept;
@class PYGPayrollName;
@class PYGTagRefer;
@class PYGPayrollTag;

@interface PYGPayrollResult : NSObject
@property(nonatomic, readonly) NSUInteger tagCode;
@property(nonatomic, readonly) NSUInteger conceptCode;
@property(nonatomic, readonly) PYGPayrollConcept* concept;

-(id)initWithTagCode:(NSUInteger)tagCode andConceptCode:(NSUInteger)conceptCode andConcept:(PYGPayrollConcept *)concept;

-(NSDecimalNumber *)getPayment;
-(NSDecimalNumber *)getDeduction;
-(BOOL) isSummaryFor:(NSUInteger)code;

-(NSString *)xmlValue;
-(NSString *)exportValueResult;

-(NSDictionary *)exportTitleValueForTagRefer:(PYGTagRefer *)tagRefer andTagName:(PYGPayrollName*)tagName
                                  andTagItem:(PYGPayrollTag *)tagItem andConcept:(PYGPayrollConcept *)tagConcept;
@end