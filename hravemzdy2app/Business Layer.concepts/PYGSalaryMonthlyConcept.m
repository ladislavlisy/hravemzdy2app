//
// Created by lisy on 01.04.13.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import "PYGSalaryMonthlyConcept.h"
#import "PYGSymbolConcepts.h"
#import "PYGHoursWorkingTag.h"
#import "PYGHoursAbsenceTag.h"
#import "PYGPayTagGateway.h"
#import "PYGPayrollPeriod.h"
#import "PYGPayrollResult.h"
#import "PYGSymbolTags.h"
#import "PYGIncomeGrossTag.h"
#import "PYGIncomeNettoTag.h"
#import "PYGInsuranceSocialBaseTag.h"
#import "PYGInsuranceHealthBaseTag.h"
#import "PYGTaxIncomeBaseTag.h"
#import "PYGTimesheetResult.h"
#import "PYGTermHoursResult.h"
#import "PYGPaymentResult.h"


@implementation PYGSalaryMonthlyConcept {

}
@synthesize amountMonthly = _amountMonthly;

- (id)initWithTagCode:(NSUInteger)tagCode andValues:(NSDictionary *)values {
    if (!(self=[super initWithCodeName:[PYGSymbolConcepts codeRef:CONCEPT_SALARY_MONTHLY] andTagCode:tagCode])) return nil;
    [self setupValues:values];
    return self;
}

+ (PYGSalaryMonthlyConcept *)conceptWithTagCode:(NSUInteger)tagCode andValues:(NSDictionary *)values {
    return [[self alloc] initWithTagCode:tagCode andValues:values];
}

- (id)copyWithZone:(NSZone*) zone {
    return self;
}

- (PYGSalaryMonthlyConcept*)newConceptWithCode:(NSUInteger)tagCode andValues:(NSDictionary *)values {
    PYGSalaryMonthlyConcept * concept = [PYGSalaryMonthlyConcept conceptWithTagCode:tagCode andValues:values];
    [concept  setPendingCodes:self.tagPendingCodes];
    return concept;
}

- (void)setupValues:(NSDictionary *)values {
    NSParameterAssert(values != nil);
    _amountMonthly = D_SAFE_VALUES(@"amount_monthly");
}

+(PYGSalaryMonthlyConcept *)concept
{
    return [[self alloc] initWithTagCode:TAG_UNKNOWN andValues:EMPTY_VALUES];
}

- (NSArray *)pendingCodes {
    return @[
        TAG_NEW(PYGHoursWorkingTag),
        TAG_NEW(PYGHoursAbsenceTag)
    ];
}

- (NSArray *)summaryCodes {
    return @[
        TAG_NEW(PYGIncomeGrossTag),
        TAG_NEW(PYGIncomeNettoTag),
        TAG_NEW(PYGInsuranceSocialBaseTag),
        TAG_NEW(PYGInsuranceHealthBaseTag),
        TAG_NEW(PYGTaxIncomeBaseTag)
    ];
}

- (NSUInteger)calcCategory {
    return CALC_CATEGORY_AMOUNT;
}

- (PYGPayrollResult*)evaluateForPeriod:(PYGPayrollPeriod *)period config:(PYGPayTagGateway *)config results:(NSDictionary *)results {
    NSDictionary * evaluateResults =  results;
    PYGTimesheetResult * resultTimesheet = (PYGTimesheetResult *)[self getResult:evaluateResults byTagCode:TAG_TIMESHEET_PERIOD];
    PYGTermHoursResult * resultWorking = (PYGTermHoursResult *)[self getResult:evaluateResults byTagCode:TAG_HOURS_WORKING];
    PYGTermHoursResult * resultAbsence = (PYGTermHoursResult *)[self getResult:evaluateResults byTagCode:TAG_HOURS_ABSENCE];

    NSDecimalNumber * scheduleFactor = DECIMAL_NUMB(@(1.0));

    NSInteger timesheetHours = resultTimesheet.hours;
    NSInteger workingHours = resultWorking.hours;
    NSInteger absenceHours = resultAbsence.hours;

    NSDecimalNumber * amountFactor = [self factorizeAmount:self.amountMonthly by:scheduleFactor];

    NSDecimalNumber * paymentValue = [self paymentFromAmount:amountFactor
                                                 periodHours:timesheetHours working:workingHours absence:absenceHours];

    NSDictionary * resultValues = D_MAKE_HASH(@"payment", paymentValue);

    return [PYGPaymentResult newWithConcept:self andValues:resultValues];
}

- (NSDecimalNumber*)factorizeAmount:(NSDecimalNumber *)amount by:(NSDecimalNumber *)scheduleFactor {
    NSDecimalNumber * amountFactor = [self bigDecimal:amount multiBy:scheduleFactor];
    return amountFactor;
}

- (NSDecimalNumber*)paymentFromAmount:(NSDecimalNumber *)bigAmount periodHours:(NSInteger)timesheetHours
                              working:(NSInteger)workingHours absence:(NSInteger)absenceHours {
    NSInteger salariedHours = MAX(0, workingHours-absenceHours);
    NSDecimalNumber * paymentValue = [self bigDecimal:@(salariedHours) multiBy:bigAmount divBy:@(timesheetHours)];
    return paymentValue;
}

@end