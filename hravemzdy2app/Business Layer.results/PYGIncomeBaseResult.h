//
// Created by lisy on 31.03.13.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import <Foundation/Foundation.h>

#import "PYGPayrollResult.h"

@interface PYGIncomeBaseResult : PYGPayrollResult

@property (nonatomic, readonly) NSDecimalNumber * incomeBase;
@property (nonatomic, readonly) NSDecimalNumber * employeeBase;
@property (nonatomic, readonly) NSDecimalNumber * employerBase;
@property (nonatomic, readonly) NSUInteger interestCode;
@property (nonatomic, readonly) NSUInteger declareCode;
@property (nonatomic, readonly) NSUInteger minimumAsses;

-(id)initWithTagCode:(NSUInteger)tagCode andConceptCode:(NSUInteger)conceptCode andConcept:(PYGPayrollConcept *)concept andValues:(NSDictionary *)values;
+(id)newWithTagCode:(NSUInteger)tagCode andConceptCode:(NSUInteger)conceptCode andConcept:(PYGPayrollConcept *)concept andValues:(NSDictionary *)values;
+(id)newWithConcept:(PYGPayrollConcept *)concept andValues:(NSDictionary *)values;

-(BOOL)isInterest;
-(BOOL)isDeclared;
-(BOOL)isMinimumAssessment;

@end