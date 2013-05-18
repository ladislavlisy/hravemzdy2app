//
// Created by lisy on 11.04.13.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import <Foundation/Foundation.h>

@class PYGPayrollPeriod;
@class PYGPayTagGateway;
@class PYGPayConceptGateway;
@class PYGCodeNameRefer;
@class PYGTagRefer;
@class PYGPayrollTag;
@class PYGPayrollConcept;


@interface PYGPayrollProcess : NSObject

@property(nonatomic, readonly) PYGPayrollPeriod * period;
@property(nonatomic, readonly) PYGPayTagGateway * tags;
@property(nonatomic, readonly) PYGPayConceptGateway * concepts;

-(id)initWithPeriodCode:(NSUInteger)code andTags:(PYGPayTagGateway *)payTags andConcepts:(PYGPayConceptGateway *) payConcepts;
-(id)initWithPeriodYear:(NSUInteger)year andMonth:(Byte)month andTags:(PYGPayTagGateway *)payTags andConcepts:(PYGPayConceptGateway *) payConcepts;

+(PYGPayrollProcess *)payrollProcessWithPeriodCode:(NSUInteger)code andTags:(PYGPayTagGateway *)payTags andConcepts:(PYGPayConceptGateway *) payConcepts;
+(PYGPayrollProcess *)payrollProcessWithPeriodYear:(NSUInteger)year andMonth:(Byte)month andTags:(PYGPayTagGateway *)payTags andConcepts:(PYGPayConceptGateway *) payConcepts;

-(PYGTagRefer*)insTermPeriodBase:(NSUInteger)periodBase tagRef:(PYGCodeNameRefer *)tagCodeRef tagOrder:(NSUInteger)tagCodeOrder andValues:(NSDictionary *)values;
-(PYGTagRefer*)addTermTagRef:(PYGCodeNameRefer *)tagCodeRef andValues:(NSDictionary *)values;
-(NSDictionary *)getTerm:(PYGTagRefer *)payTag;
-(NSDictionary *)getResult:(PYGTagRefer *)payTag;
-(NSDictionary *)evaluate:(PYGTagRefer *)payTag;

-(void)addTermTagRef:(PYGCodeNameRefer *)tagCodeRef andValues:(NSDictionary *)values asTimes:(NSUInteger)count;

-(PYGPayrollTag *)findTag:(NSUInteger)tagCode;
-(PYGPayrollConcept *)findConcept:(NSUInteger)conceptCode;
-(NSDictionary *)getResults;

@end