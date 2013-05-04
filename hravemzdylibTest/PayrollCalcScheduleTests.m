 //
// Created by lisy on 02.04.13.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import "PYGPayConceptGateway.h"
#import "PYGPayTagGateway.h"
#import "PYGCodeNameRefer.h"
#import "PYGSymbolTags.h"
#import "PYGPayrollProcess.h"
#import "PYGPayrollPeriod.h"
#import "PYGTagRefer.h"
#import "PYGScheduleWeeklyConcept.h"
#import "PYGScheduleResult.h"
#import "PYGTimesheetResult.h"
#import "NSDate+PYGDateOnly.h"
#import "PYGTermEffectResult.h"
#import "PYGTermHoursResult.h"
#import "PYGPayrollProcessTestCase.h"

@interface PayrollCalcScheduleTests : PYGPayrollProcessTestCase

@end

@implementation PayrollCalcScheduleTests {

}
- (void)setUp
{
    [super setUp];

    // Set-up code here.
    self.payrollTags = [[PYGPayTagGateway alloc] init];
    self.payConcepts = [[PYGPayConceptGateway alloc] init];
    self.payProcess = [PYGPayrollProcess payrollProcessWithPeriodYear:2013 andMonth:1
                                                              andTags:[self payrollTags] andConcepts:[self payConcepts]];
}

- (void)tearDown
{
    // Tear-down code here.

    [super tearDown];
}

- (void)testPayrollPeriod_Returns_Year2013andMonth1
{
    PYGPayrollPeriod * period = [self.payProcess period];
    STAssertTrue(period.year==2013 && period.month==1, @"Returns payroll period month = 1 and year = 2013!");
}

- (void)testWorkingSchedule_Returns_40WeeklyHours
{
    NSDictionary * testTagValues = @{ @"hours_weekly" : @(40) };
    PYGCodeNameRefer * testTagCodeRef = [PYGSymbolTags codeRef:TAG_SCHEDULE_WORK];
    PYGTagRefer  * testPayTag = [self.payProcess addTermTagRef:testTagCodeRef andValues:testTagValues];
    NSDictionary * testTagSel = [self.payProcess getTerm:testPayTag];
    PYGScheduleWeeklyConcept * testConcept = (PYGScheduleWeeklyConcept*)testTagSel[testPayTag];

    STAssertTrue(testConcept.hoursWeekly==40, @"Working schedule should return %d, NOT %d!", 40, testConcept.hoursWeekly);
}

- (void)testWorkingSchedule_Returns_HoursInWeekSchedule
{
    NSDictionary * testTagValues = @{ @"hours_weekly" : @(40) };
    PYGCodeNameRefer * testTagCodeRef = [PYGSymbolTags codeRef:TAG_SCHEDULE_WORK];
    PYGTagRefer  * testPayTag = [self.payProcess addTermTagRef:testTagCodeRef andValues:testTagValues];
    NSDictionary * testResSel = [self.payProcess evaluate:testPayTag];
    PYGPayrollResult * testResult = (PYGPayrollResult*)testResSel[testPayTag];
    PYGScheduleResult * testSchedule = (PYGScheduleResult *)testResult;

    NSArray * testValue = @[@8,@8,@8,@8,@8,@0,@0];

    STAssertTrue([testSchedule.weekSchedule isEqualToArray:testValue], @"Week schedule should return %@, NOT %@!",
       [testValue componentsJoinedByString:@","], [testSchedule.weekSchedule componentsJoinedByString:@","]);
}

- (void)testWorkingSchedule_Returns_HoursInFirst7days
{
    PYGCodeNameRefer * scheduleWorkRef = [PYGSymbolTags codeRef:TAG_SCHEDULE_WORK];
    PYGCodeNameRefer * scheduleTermRef = [PYGSymbolTags codeRef:TAG_SCHEDULE_TERM];
    PYGCodeNameRefer * evResultTermRef = [PYGSymbolTags codeRef:TAG_TIMESHEET_PERIOD];

    NSDictionary * scheduleWorkValues = @{ @"hours_weekly" : @(40) };
    NSDictionary * scheduleTermValues = EMPTY_VALUES;
    NSDictionary * evResultTermValues = EMPTY_VALUES;

    PYGTagRefer  * scheduleWorkTag = [self.payProcess addTermTagRef:scheduleWorkRef andValues:scheduleWorkValues];
    PYGTagRefer  * scheduleTermTag = [self.payProcess addTermTagRef:scheduleTermRef andValues:scheduleTermValues];
    PYGTagRefer  * evResultTermTag = [self.payProcess addTermTagRef:evResultTermRef andValues:evResultTermValues];
    NSDictionary * evResultDictVal = [self.payProcess evaluate:evResultTermTag];

    PYGTimesheetResult * resultValue = [evResultDictVal objectForKey:evResultTermTag];

    NSInteger month_hours1 = ((NSNumber *)resultValue.monthSchedule[0]).integerValue;
    NSInteger month_hours2 = ((NSNumber *)resultValue.monthSchedule[1]).integerValue;
    NSInteger month_hours3 = ((NSNumber *)resultValue.monthSchedule[2]).integerValue;
    NSInteger month_hours4 = ((NSNumber *)resultValue.monthSchedule[3]).integerValue;
    NSInteger month_hours5 = ((NSNumber *)resultValue.monthSchedule[4]).integerValue;
    NSInteger month_hours6 = ((NSNumber *)resultValue.monthSchedule[5]).integerValue;
    NSInteger month_hours7 = ((NSNumber *)resultValue.monthSchedule[6]).integerValue;

    STAssertTrue(month_hours1==8, @"Working schedule should return %d, NOT %d!", 8, month_hours1);
    STAssertTrue(month_hours2==8, @"Working schedule should return %d, NOT %d!", 8, month_hours2);
    STAssertTrue(month_hours3==8, @"Working schedule should return %d, NOT %d!", 8, month_hours3);
    STAssertTrue(month_hours4==8, @"Working schedule should return %d, NOT %d!", 8, month_hours4);
    STAssertTrue(month_hours5==0, @"Working schedule should return %d, NOT %d!", 8, month_hours5);
    STAssertTrue(month_hours6==0, @"Working schedule should return %d, NOT %d!", 8, month_hours6);
    STAssertTrue(month_hours7==8, @"Working schedule should return %d, NOT %d!", 8, month_hours7);
}

- (void)testScheduleTerm_Returns_DateFromDateEnd
{
    PYGCodeNameRefer * scheduleWorkRef = [PYGSymbolTags codeRef:TAG_SCHEDULE_WORK];
    PYGCodeNameRefer * scheduleTermRef = [PYGSymbolTags codeRef:TAG_SCHEDULE_TERM];

    PYGPayrollPeriod * period = self.payProcess.period;
    NSDictionary * scheduleWorkValues = @{ @"hours_weekly" : @(40) };
    NSDate * dateTestBeg = [NSDate dateWithYear:period.year month:period.month day:15];
    NSDate * dateTestEnd = [NSDate dateWithYear:period.year month:period.month day:24];
    NSDictionary * scheduleTermValues = @{ @"date_from" : dateTestBeg, @"date_end" : dateTestEnd };

    PYGTagRefer  * scheduleWorkTag = [self.payProcess addTermTagRef:scheduleWorkRef andValues:scheduleWorkValues];
    PYGTagRefer  * scheduleTermTag = [self.payProcess addTermTagRef:scheduleTermRef andValues:scheduleTermValues];
    NSDictionary * evResultDictVal = [self.payProcess evaluate:scheduleTermTag];

    PYGTermEffectResult * resultValue = [evResultDictVal objectForKey:scheduleTermTag];

    NSUInteger day_result_beg = resultValue.dayOrdFrom;
    NSUInteger day_result_end = resultValue.dayOrdEnd;

    STAssertTrue(day_result_beg==15, @"Schedule Term should return %d, NOT %d!", 15, day_result_beg);
    STAssertTrue(day_result_end==24, @"Schedule Term should return %d, NOT %d!", 24, day_result_end);
}

- (void)testTimesheetPeriod_Returns_WorkingDaysInArray
{
    PYGCodeNameRefer * scheduleWorkRef = [PYGSymbolTags codeRef:TAG_SCHEDULE_WORK];
    PYGCodeNameRefer * scheduleTermRef = [PYGSymbolTags codeRef:TAG_SCHEDULE_TERM];
    PYGCodeNameRefer * evResultTermRef = [PYGSymbolTags codeRef:TAG_TIMESHEET_PERIOD];

    NSDictionary * scheduleWorkValues = @{ @"hours_weekly" : @(40) };
    NSDictionary * scheduleTermValues = EMPTY_VALUES;
    NSDictionary * evResultTermValues = EMPTY_VALUES;

    PYGTagRefer  * scheduleWorkTag = [self.payProcess addTermTagRef:scheduleWorkRef andValues:scheduleWorkValues];
    PYGTagRefer  * scheduleTermTag = [self.payProcess addTermTagRef:scheduleTermRef andValues:scheduleTermValues];
    PYGTagRefer  * evResultTermTag = [self.payProcess addTermTagRef:evResultTermRef andValues:evResultTermValues];
    NSDictionary * evResultDictVal = [self.payProcess evaluate:evResultTermTag];

    PYGTimesheetResult * resultValue = [evResultDictVal objectForKey:evResultTermTag];

    NSInteger month_hours1 = ((NSNumber *)resultValue.monthSchedule[0]).integerValue;

    STAssertTrue(month_hours1==8, @"Timesheet Period should return %d, NOT %d!", 8, month_hours1);
}

- (void)testTimesheetWork_Returns_WorkingDaysInArray
{
    PYGCodeNameRefer * scheduleWorkRef = [PYGSymbolTags codeRef:TAG_SCHEDULE_WORK];
    PYGCodeNameRefer * scheduleTermRef = [PYGSymbolTags codeRef:TAG_SCHEDULE_TERM];
    PYGCodeNameRefer * evResultTermRef = [PYGSymbolTags codeRef:TAG_TIMESHEET_WORK];

    NSDictionary * scheduleWorkValues = @{ @"hours_weekly" : @(40) };
    NSDictionary * scheduleTermValues = EMPTY_VALUES;
    NSDictionary * evResultTermValues = EMPTY_VALUES;

    PYGTagRefer  * scheduleWorkTag = [self.payProcess addTermTagRef:scheduleWorkRef andValues:scheduleWorkValues];
    PYGTagRefer  * scheduleTermTag = [self.payProcess addTermTagRef:scheduleTermRef andValues:scheduleTermValues];
    PYGTagRefer  * evResultTermTag = [self.payProcess addTermTagRef:evResultTermRef andValues:evResultTermValues];
    NSDictionary * evResultDictVal = [self.payProcess evaluate:evResultTermTag];

    PYGTimesheetResult * resultValue = [evResultDictVal objectForKey:evResultTermTag];

    //first week
    NSInteger month_hours1  = ((NSNumber *)resultValue.monthSchedule[0]).integerValue;
    NSInteger month_hours2  = ((NSNumber *)resultValue.monthSchedule[1]).integerValue;
    NSInteger month_hours3  = ((NSNumber *)resultValue.monthSchedule[2]).integerValue;
    NSInteger month_hours4  = ((NSNumber *)resultValue.monthSchedule[3]).integerValue;
    NSInteger month_hours5  = ((NSNumber *)resultValue.monthSchedule[4]).integerValue;
    NSInteger month_hours6  = ((NSNumber *)resultValue.monthSchedule[5]).integerValue;
    NSInteger month_hours7  = ((NSNumber *)resultValue.monthSchedule[6]).integerValue;
    NSInteger month_hours8  = ((NSNumber *)resultValue.monthSchedule[7]).integerValue;
    //third week
    NSInteger month_hours15 = ((NSNumber *)resultValue.monthSchedule[14]).integerValue;
    NSInteger month_hours16 = ((NSNumber *)resultValue.monthSchedule[15]).integerValue;
    NSInteger month_hours17 = ((NSNumber *)resultValue.monthSchedule[16]).integerValue;
    NSInteger month_hours18 = ((NSNumber *)resultValue.monthSchedule[17]).integerValue;
    NSInteger month_hours19 = ((NSNumber *)resultValue.monthSchedule[18]).integerValue;
    NSInteger month_hours20 = ((NSNumber *)resultValue.monthSchedule[19]).integerValue;
    NSInteger month_hours21 = ((NSNumber *)resultValue.monthSchedule[20]).integerValue;
    NSInteger month_hours22 = ((NSNumber *)resultValue.monthSchedule[21]).integerValue;

    STAssertTrue(month_hours1==8,  @"Timesheet Work should return %d, NOT %d!", 8, month_hours1);
    STAssertTrue(month_hours2==8,  @"Timesheet Work should return %d, NOT %d!", 8, month_hours2);
    STAssertTrue(month_hours3==8,  @"Timesheet Work should return %d, NOT %d!", 8, month_hours3);
    STAssertTrue(month_hours4==8,  @"Timesheet Work should return %d, NOT %d!", 8, month_hours4);
    STAssertTrue(month_hours5==0,  @"Timesheet Work should return %d, NOT %d!", 0, month_hours5);
    STAssertTrue(month_hours6==0,  @"Timesheet Work should return %d, NOT %d!", 0, month_hours6);
    STAssertTrue(month_hours7==8,  @"Timesheet Work should return %d, NOT %d!", 8, month_hours7);
    STAssertTrue(month_hours8==8,  @"Timesheet Work should return %d, NOT %d!", 8, month_hours8);

    STAssertTrue(month_hours15==8, @"Timesheet Work should return %d, NOT %d!", 8, month_hours15);
    STAssertTrue(month_hours16==8, @"Timesheet Work should return %d, NOT %d!", 8, month_hours16);
    STAssertTrue(month_hours17==8, @"Timesheet Work should return %d, NOT %d!", 8, month_hours17);
    STAssertTrue(month_hours18==8, @"Timesheet Work should return %d, NOT %d!", 8, month_hours18);
    STAssertTrue(month_hours19==0, @"Timesheet Work should return %d, NOT %d!", 0, month_hours19);
    STAssertTrue(month_hours20==0, @"Timesheet Work should return %d, NOT %d!", 0, month_hours20);
    STAssertTrue(month_hours21==8, @"Timesheet Work should return %d, NOT %d!", 8, month_hours21);
    STAssertTrue(month_hours22==8, @"Timesheet Work should return %d, NOT %d!", 8, month_hours22);
}

- (void)testTimesheetWork_Returns_WorkingDaysInArrayFrom10to25
{
    PYGCodeNameRefer * scheduleWorkRef = [PYGSymbolTags codeRef:TAG_SCHEDULE_WORK];
    PYGCodeNameRefer * scheduleTermRef = [PYGSymbolTags codeRef:TAG_SCHEDULE_TERM];
    PYGCodeNameRefer * evResultTermRef = [PYGSymbolTags codeRef:TAG_TIMESHEET_WORK];

    NSDictionary * scheduleWorkValues = @{ @"hours_weekly" : @(40) };
    PYGPayrollPeriod * period = self.payProcess.period;
    NSDate * dateTestBeg = [NSDate dateWithYear:period.year month:period.month day:15];
    NSDate * dateTestEnd = [NSDate dateWithYear:period.year month:period.month day:24];
    NSDictionary * scheduleTermValues = @{ @"date_from" : dateTestBeg, @"date_end" : dateTestEnd };
    NSDictionary * evResultTermValues = EMPTY_VALUES;

    PYGTagRefer  * scheduleWorkTag = [self.payProcess addTermTagRef:scheduleWorkRef andValues:scheduleWorkValues];
    PYGTagRefer  * scheduleTermTag = [self.payProcess addTermTagRef:scheduleTermRef andValues:scheduleTermValues];
    PYGTagRefer  * evResultTermTag = [self.payProcess addTermTagRef:evResultTermRef andValues:evResultTermValues];
    NSDictionary * evResultDictVal = [self.payProcess evaluate:evResultTermTag];

    PYGTimesheetResult * resultValue = [evResultDictVal objectForKey:evResultTermTag];

    NSInteger month_hours1  = ((NSNumber *)resultValue.monthSchedule[14-1]).integerValue;
    NSInteger month_hours2  = ((NSNumber *)resultValue.monthSchedule[25-1]).integerValue;
    NSInteger month_hours3  = ((NSNumber *)resultValue.monthSchedule[15-1]).integerValue;
    NSInteger month_hours4  = ((NSNumber *)resultValue.monthSchedule[24-1]).integerValue;

    STAssertTrue(month_hours1==0,  @"Timesheet Work should return %d, NOT %d!", 0, month_hours1);
    STAssertTrue(month_hours2==0,  @"Timesheet Work should return %d, NOT %d!", 0, month_hours2);
    STAssertTrue(month_hours3==8,  @"Timesheet Work should return %d, NOT %d!", 8, month_hours3);
    STAssertTrue(month_hours4==8,  @"Timesheet Work should return %d, NOT %d!", 8, month_hours4);
}

- (void)testWorkingHours_ShouldReturn_HoursSum184
{
    PYGCodeNameRefer * scheduleWorkRef = [PYGSymbolTags codeRef:TAG_SCHEDULE_WORK];
    PYGCodeNameRefer * scheduleTermRef = [PYGSymbolTags codeRef:TAG_SCHEDULE_TERM];
    PYGCodeNameRefer * evResultTermRef = [PYGSymbolTags codeRef:TAG_HOURS_WORKING];

    NSDictionary * scheduleWorkValues = @{ @"hours_weekly" : @(40) };
    NSDictionary * scheduleTermValues = EMPTY_VALUES;
    NSDictionary * evResultTermValues = EMPTY_VALUES;

    PYGTagRefer  * scheduleWorkTag = [self.payProcess addTermTagRef:scheduleWorkRef andValues:scheduleWorkValues];
    PYGTagRefer  * scheduleTermTag = [self.payProcess addTermTagRef:scheduleTermRef andValues:scheduleTermValues];
    PYGTagRefer  * evResultTermTag = [self.payProcess addTermTagRef:evResultTermRef andValues:evResultTermValues];
    NSDictionary * evResultDictVal = [self.payProcess evaluate:evResultTermTag];

    PYGTermHoursResult * resultValue = [evResultDictVal objectForKey:evResultTermTag];

    NSInteger working_hours = resultValue.hours;

    STAssertTrue(working_hours==184,  @"Hours Working should return %d, NOT %d!", 184, working_hours);
}

- (void)testAbsenceHours_ShouldReturn_HoursSum0
{
    PYGCodeNameRefer * scheduleWorkRef = [PYGSymbolTags codeRef:TAG_SCHEDULE_WORK];
    PYGCodeNameRefer * scheduleTermRef = [PYGSymbolTags codeRef:TAG_SCHEDULE_TERM];
    PYGCodeNameRefer * evResultTermRef = [PYGSymbolTags codeRef:TAG_HOURS_ABSENCE];

    NSDictionary * scheduleWorkValues = @{ @"hours_weekly" : @(40) };
    NSDictionary * scheduleTermValues = EMPTY_VALUES;
    NSDictionary * evResultTermValues = EMPTY_VALUES;

    PYGTagRefer  * scheduleWorkTag = [self.payProcess addTermTagRef:scheduleWorkRef andValues:scheduleWorkValues];
    PYGTagRefer  * scheduleTermTag = [self.payProcess addTermTagRef:scheduleTermRef andValues:scheduleTermValues];
    PYGTagRefer  * evResultTermTag = [self.payProcess addTermTagRef:evResultTermRef andValues:evResultTermValues];
    NSDictionary * evResultDictVal = [self.payProcess evaluate:evResultTermTag];

    PYGTermHoursResult * resultValue = [evResultDictVal objectForKey:evResultTermTag];

    NSInteger absence_hours = resultValue.hours;

    STAssertTrue(absence_hours==0,  @"Hours Absence should return %d, NOT %d!", 0, absence_hours);
}

@end
