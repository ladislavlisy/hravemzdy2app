//
// Created by lisy on 01.04.13.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import <Foundation/Foundation.h>

@class PYGPayrollConcept;
@class PYGCodeNameRefer;
@class PYGPayrollTag;


@interface PYGPayConceptGateway : NSObject
{
    NSMutableDictionary * models;
}
-(id) init;
-(PYGPayrollConcept *)conceptFromModels:(PYGPayrollTag *)termTag;
-(NSArray *)collectPendingCodesFor:(NSDictionary *)terms;

- (PYGPayrollConcept *)findConcept:(NSUInteger)conceptCode;

@end