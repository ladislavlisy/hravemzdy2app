//
// Created by lisy on 01.04.13.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import <Foundation/Foundation.h>

static const NSUInteger PERIOD_NOW = 0;

@interface PYGPayrollPeriod : NSObject <NSCopying>

@property(nonatomic, readonly) NSUInteger code;
-(NSUInteger) year;
-(Byte) month;

-(id)initWithCode:(NSUInteger)code;
-(id)initWithYear:(NSUInteger)year andMonth:(Byte)month;
+(PYGPayrollPeriod*)payrollPeriodWithCode:(NSUInteger)code;
+(PYGPayrollPeriod*)payrollPeriodWithYear:(NSUInteger)year andMonth:(Byte)month;

@end