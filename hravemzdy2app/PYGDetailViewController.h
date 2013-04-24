//
//  PYGDetailViewController.h
//  hravemzdyapp
//
//  Created by Ladislav Lisy on 04/24/13.
//  Copyright (c) 2013 ___HRAVEMZDY___. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PYGDetailViewController : UIViewController <UISplitViewControllerDelegate>
{
    IBOutlet UITextField *descriptionField;
    IBOutlet UITextField *employeeNameField;
}
- (IBAction) showEmployeePayslip:(id)sender;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil;

@end