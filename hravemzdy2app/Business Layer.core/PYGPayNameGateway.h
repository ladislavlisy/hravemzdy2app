//
// Created by lisy on 01.04.13.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import <Foundation/Foundation.h>

@class PYGCodeNameRefer;
@class PYGPayrollName;

@interface PYGPayNameGateway : NSObject
{
    NSMutableDictionary * models;
}
-(id) init;
-(PYGPayrollName*)nameFromModels:(PYGCodeNameRefer *)termName;
-(PYGPayrollName*)findName:(NSUInteger)tagCode;

@end