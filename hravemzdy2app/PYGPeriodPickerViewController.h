//
// Created by Ladislav Lisy on 10.05.13.
// Copyright (c) 2013 ___HRAVEMZDY___. All rights reserved.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import <Foundation/Foundation.h>
#import "UIMonthYearPicker.h"


@interface PYGPeriodPickerViewController : UIViewController <UIMonthYearPickerDelegate>

@property (strong, nonatomic) NSDate* selectedDate;
@property (weak, nonatomic) IBOutlet UIMonthYearPicker *datePicker;

- (void)setSelectedDate:(NSDate *)date;

@end