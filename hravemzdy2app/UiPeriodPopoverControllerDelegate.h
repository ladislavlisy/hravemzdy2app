//
// Created by Ladislav Lisy on 23.05.13.
// Copyright (c) 2013 ___HRAVEMZDY___. All rights reserved.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import <Foundation/Foundation.h>

@protocol UiPeriodPopoverControllerDelegate <UIPopoverControllerDelegate>

- (void)dismissPeriodPopoverCanceled;
- (void)dismissPeriodPopoverFinished;

@end