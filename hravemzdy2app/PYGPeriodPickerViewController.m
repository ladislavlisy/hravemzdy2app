//
// Created by Ladislav Lisy on 10.05.13.
// Copyright (c) 2013 ___HRAVEMZDY___. All rights reserved.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import "PYGPeriodPickerViewController.h"
#import "NSDate+PYGDateOnly.h"


@implementation PYGPeriodPickerViewController {
    NSDate * _selectedDate;
}

@dynamic selectedDate;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    if (!(self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil])) return nil;
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.datePicker.my_delegate = self;
    self.datePicker.minimumDate = [NSDate dateWithYear:2010 month:1 day:1];
    NSDate * currentDate = [NSDate date];
    self.datePicker.maximumDate = [NSDate dateWithYear:currentDate.year endDayOfmonth:currentDate.month + 2];
    self.datePicker.date = [self.selectedDate copy];
}

- (void)viewDidUnload
{
    [self setDatePicker:nil];
}

- (NSDate *)selectedDate {
    return _selectedDate;
}

- (void)setSelectedDate:(NSDate *)date {
    _selectedDate = [date copy];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (UIInterfaceOrientationIsPortrait(interfaceOrientation));
}

#pragma mark - UIMonthYearPickerDelegate
- (void) pickerView:(UIPickerView *)pickerView didChangeDate:(NSDate *)newDate{
    _selectedDate = newDate;
}

- (IBAction)editingCanceled:(id)sender {
    [self.delegate dismissPeriodPopoverCanceled];
}

- (IBAction)editingFinished:(id)sender {
    [self.delegate dismissPeriodPopoverFinished];
}


@end