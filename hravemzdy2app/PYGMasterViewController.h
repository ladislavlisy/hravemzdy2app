//
//  PYGMasterViewController.h
//  hravemzdyapp
//
//  Created by Ladislav Lisy on 04/24/13.
//  Copyright (c) 2013 ___HRAVEMZDY___. All rights reserved.
//

#import <UIKit/UIKit.h>

@class PYGDetailViewController;

@interface PYGMasterViewController : UITableViewController<UITextFieldDelegate> {
}

// Handles UIControlEventEditingDidEndOnExit
- (IBAction)textFieldFinished:(id)sender ;

@property (nonatomic,copy) NSString* description;
@property (nonatomic,copy) NSString* employerName;
@property (nonatomic,copy) NSString* employeeName;
@property (nonatomic,copy) NSString* employeeNumb;
@property (nonatomic,copy) NSString* department;
@property (nonatomic,copy) NSString* salaryMoney;
@property (nonatomic,copy) NSNumber* taxDeclaration;
@property (nonatomic,copy) NSNumber* taxPayerClaim;
@property (nonatomic,copy) NSNumber* taxStudyClaim;
@property (nonatomic,copy) NSNumber* taxDisability1;
@property (nonatomic,copy) NSNumber* taxDisability2;
@property (nonatomic,copy) NSNumber* taxDisability3;
@property (nonatomic,copy) NSNumber* taxBenefitChild1;
@property (nonatomic,copy) NSNumber* taxBenefitChild2;
@property (nonatomic,copy) NSNumber* taxBenefitChild3;
@property (nonatomic,copy) NSNumber* taxBenefitChild4;
@property (nonatomic,copy) NSNumber* taxBenefitChild5;
@property (nonatomic,copy) NSString* companyName;
@property (nonatomic,copy) NSString* payrolleeName;
@property (nonatomic,copy) NSString* payrolleeEmail;

@property (strong, nonatomic) PYGDetailViewController *detailViewController;

@end