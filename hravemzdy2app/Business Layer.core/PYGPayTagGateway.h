//
// Created by lisy on 01.04.13.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import <Foundation/Foundation.h>

@class PYGCodeNameRefer;
@class PYGPayrollTag;


@interface PYGPayTagGateway : NSObject
{
    NSMutableDictionary * models;
}
-(id) init;
-(PYGPayrollTag*)tagFromModels:(PYGCodeNameRefer *)tagCodeRef;
-(PYGPayrollTag*)findTag:(NSUInteger)tagCode;

@end