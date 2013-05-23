//
// Created by Ladislav Lisy on 10.05.13.
// Copyright (c) 2013 ___HRAVEMZDY___. All rights reserved.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import <Foundation/Foundation.h>
#import "UIMonthYearPicker.h"

@protocol UiPeriodPopoverControllerDelegate;


@interface PYGPeriodPickerViewController : UIViewController <UIMonthYearPickerDelegate>

@property (strong, nonatomic) NSDate* selectedDate;
@property (weak, nonatomic) IBOutlet UIMonthYearPicker *datePicker;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *buttonCancel;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *buttonDone;
@property (assign, nonatomic) id <UiPeriodPopoverControllerDelegate> delegate;

- (void)setSelectedDate:(NSDate *)date;

- (IBAction)editingCanceled:(id)sender;
- (IBAction)editingFinished:(id)sender;

@end