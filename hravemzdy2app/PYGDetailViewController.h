//
//  PYGDetailViewController.h
//  hravemzdyapp
//
//  Created by Ladislav Lisy on 04/24/13.
//  Copyright (c) 2013 ___HRAVEMZDY___. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PYGDetailViewController : UIViewController <UISplitViewControllerDelegate, UIPopoverControllerDelegate, UIActionSheetDelegate>

@property(nonatomic, strong) IBOutlet UITableView * payrollResultView;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil;

- (void)setPayrollTitles:(NSDictionary *)values;
- (void)setPayrollValues:(NSDictionary *)values;
@end