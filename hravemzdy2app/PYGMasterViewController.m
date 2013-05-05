//
//  PYGMasterViewController.m
//  hravemzdyapp
//
//  Created by Ladislav Lisy on 04/24/13.
//  Copyright (c) 2013 ___HRAVEMZDY___. All rights reserved.
//

#import "PYGMasterViewController.h"

#import "PYGDetailViewController.h"

@interface PYGMasterViewController () {
}

@property (strong, nonatomic) UITextField* descriptionField;
@property (strong, nonatomic) UITextField* periodField;
@property (strong, nonatomic) UITextField* employerNameField;
@property (strong, nonatomic) UITextField* employeeNameField;
@property (strong, nonatomic) UITextField* employeeNumbField;
@property (strong, nonatomic) UITextField* departmentField;
@property (strong, nonatomic) UITextField* salaryMoneyField;
@property (strong, nonatomic) UISwitch * taxDeclarationField;
@property (strong, nonatomic) UISwitch * taxPayerClaimField;
@property (strong, nonatomic) UISwitch * taxStudyClaimField;
@property (strong, nonatomic) NSArray* sections;

@end

@implementation PYGMasterViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    if (!(self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil])) return nil;
    self.title = NSLocalizedString(@"Master", @"Master");
    self.sections = @[
            @"Payroll details",
            @"Payslip details",
            @"Tax payer declaration",
            @"Tax disability benefit",
            @"Tax child benefit",
            @"Contact for results"
    ];
    self.clearsSelectionOnViewWillAppear = NO;
    self.contentSizeForViewInPopover = CGSizeMake(320.0, 600.0);
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    self.detailViewController = (PYGDetailViewController *)[[self.splitViewController.viewControllers lastObject] topViewController];

    self.description  = @"" ;
    self.period       = @"" ;
    self.employerName = @"" ;
    self.employeeName = @"" ;
    self.employeeNumb = @"" ;
    self.department   = @"" ;
    self.salaryMoney  = @"";
    self.taxDeclaration = @YES;
    self.taxPayerClaim  = @YES;
    self.taxStudyClaim  = @NO;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table View


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.sections.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    switch (section) {
        case 0: return 3; break;
        case 1: return 4; break;
        case 2: return 3; break;
        case 3: return 3; break;
        case 4: return 5; break;
        case 5: return 3; break;
        default: break;
    }
    return 0;
}

- (NSString *)tableView:(UITableView *)tableView
titleForHeaderInSection:(NSInteger)section
{
    return (NSString *)self.sections[(NSUInteger)section];
}

//Payroll details
//  description
//  payroll period
//  salary
- (void)createCellInSectionPayrollDetails:(UITableViewCell *)cell forRow:(NSUInteger)row {
    UITextField* tf = nil ;
    switch ( row ) {
        case 0: {
            cell.textLabel.text = @"Description" ;
            tf = self.descriptionField = [self makeTextField:self.description placeholder:@"My happy payroll"];
            [cell addSubview:self.descriptionField];
            break ;
        }
        case 1: {
            cell.textLabel.text = @"Period" ;
            tf = self.periodField = [self makeTextField:self.period placeholder:@"January 2013"];
            [cell addSubview:self.periodField];
            break ;
        }
        case 2: {
            cell.textLabel.text = @"Salary" ;
            tf = self.salaryMoneyField = [self makeNumberField:self.salaryMoney placeholder:@" CZK"];
            [cell addSubview:self.salaryMoneyField];
            break ;
        }
        default:
            break;
    }
    [self setTextFieldDimensionAndAction:tf];
}

//Payslip details
//  employer name
//  employee name
//  department
//  employee number
- (void)createCellInSectionPayslipDetails:(UITableViewCell *)cell forRow:(NSUInteger)row {
    UITextField* tf = nil ;
    switch ( row ) {
        case 0: {
            cell.textLabel.text = @"Employee" ;
            tf = self.employeeNameField = [self makeTextField:self.employeeName placeholder:@"Jája Pája"];
            [cell addSubview:self.employeeNameField];
            break ;
        }
        case 1: {
            cell.textLabel.text = @"Employer" ;
            tf = self.employerNameField = [self makeTextField:self.employerName placeholder:@"Employer name"];
            [cell addSubview:self.employerNameField];
            break ;
        }
        case 2: {
            cell.textLabel.text = @"Department" ;
            tf = self.departmentField = [self makeTextField:self.department placeholder:@"Work department"];
            [cell addSubview:self.departmentField];
            break ;
        }
        case 3: {
            cell.textLabel.text = @"Personnel" ;
            tf = self.employeeNumbField = [self makeTextField:self.employeeNumb placeholder:@"Number"];
            [cell addSubview:self.employeeNumbField];
            break ;
        }
        default:
            break;
    }
    [self setTextFieldDimensionAndAction:tf];
}

//Tax payer declaration
//  tax declaration
//  claim tax payer benefit
//  claim studying benefit
- (void)createCellInSectionTaxDeclaration:(UITableViewCell *)cell forRow:(NSUInteger)row {
    UISwitch* sf = nil ;
    switch ( row ) {
        case 0: {
            cell.textLabel.text = @"Tax declaration" ;
            sf = self.taxDeclarationField = [self makeYesNoField:self.taxDeclaration];
            [cell addSubview:self.taxDeclarationField];
            break ;
        }
        case 1: {
            cell.textLabel.text = @"Tax payer claim" ;
            sf = self.taxPayerClaimField = [self makeYesNoField:self.taxPayerClaim];
            [cell addSubview:self.taxPayerClaimField];
            break ;
        }
        case 2: {
            cell.textLabel.text = @"Tax studying claim" ;
            sf = self.taxStudyClaimField = [self makeYesNoField:self.taxStudyClaim];
            [cell addSubview:self.taxStudyClaimField];
            break ;
        }
        default:
            break;
    }
    [self setSwitchFieldDimensionAndAction:sf];
}

//Tax disability benefit
//  claim disability benefit 1
//  claim disability benefit 2
//  claim disability benefit 3
- (void)createCellInSectionDisabilityBenefit:(UITableViewCell *)cell forRow:(NSUInteger)row {
    switch ( row ) {
        case 0: {
            break;
        }
        case 1: {
            break;
        }
        case 2: {
            break;
        }
        default:
            break;
    }
}

//Tax child benefit
//  claim 1. child benefit
//  claim 2. child benefit
//  claim 3. child benefit
//  claim 4. child benefit
//  claim 5. child benefit
- (void)createCellInSectionChildBenefit:(UITableViewCell *)cell forRow:(NSUInteger)row {
    switch ( row ) {
        case 0: {
            break;
        }
        case 1: {
            break;
        }
        case 2: {
            break;
        }
        case 3: {
            break;
        }
        case 4: {
            break;
        }
        default:
            break;
    }
}

//Contact for results
//  company name
//  payrollee name
//  payrollee email
- (void)createCellInSectionContactDetails:(UITableViewCell *)cell forRow:(NSUInteger)row {
    switch ( row ) {
        case 0: {
            break;
        }
        case 1: {
            break;
        }
        case 2: {
            break;
        }
        default:
            break;
    }
}

- (void)setTextFieldDimensionAndAction:(UITextField*)tf {
    // TextField dimensions
    if (tf != nil) {
        tf.frame = CGRectMake(150, 12, 140, 30);
        // Workaround to dismiss keyboard when Done/Return is tapped
        [tf addTarget:self action:@selector(textFieldFinished:) forControlEvents:UIControlEventEditingDidEnd];

        // We want to handle textFieldDidEndEditing
        tf.delegate = self ;
    }
}

- (void)setSwitchFieldDimensionAndAction:(UISwitch*)sf {
    // Switch dimensions
    if (sf != nil) {
        sf.frame = CGRectMake(220, 8, 70, 30);
        // Workaround to dismiss keyboard when Done/Return is tapped
        [sf addTarget:self action:@selector(switchFieldFinished:) forControlEvents:UIControlEventValueChanged];
    }
}

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];

    // Make cell un-selectable
    cell.selectionStyle = UITableViewCellSelectionStyleNone;

    switch ( indexPath.section ) {
        case 0: {
            [self createCellInSectionPayrollDetails:cell forRow:(NSUInteger)indexPath.row];
            break;
        }
        case 1: {
            [self createCellInSectionPayslipDetails:cell forRow:(NSUInteger)indexPath.row];
            break;
        }
        case 2: {
            [self createCellInSectionTaxDeclaration:cell forRow:(NSUInteger)indexPath.row];
            break;
        }
        case 3: {
            [self createCellInSectionDisabilityBenefit:cell forRow:(NSUInteger)indexPath.row];
            break;
        }
        case 4: {
            [self createCellInSectionChildBenefit:cell forRow:(NSUInteger)indexPath.row];
            break;
        }
        case 5: {
            [self createCellInSectionContactDetails:cell forRow:(NSUInteger)indexPath.row];
            break;
        }
        default:
            break;
    }
    return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}

-(UITextField*) makeTextField: (NSString*)text
                  placeholder: (NSString*)placeholder  {
    UITextField *tf = [[UITextField alloc] init];
    tf.placeholder = placeholder ;
    tf.text = text ;
    tf.autocorrectionType = UITextAutocorrectionTypeNo ;
    tf.autocapitalizationType = UITextAutocapitalizationTypeNone;
    tf.adjustsFontSizeToFitWidth = YES;
    tf.textColor = [UIColor colorWithRed:56.0f/255.0f green:84.0f/255.0f blue:135.0f/255.0f alpha:1.0f];
    return tf ;
}

-(UITextField*) makeNumberField: (NSString*)text
                  placeholder: (NSString*)placeholder  {
    UITextField *tf = [[UITextField alloc] init];
    tf.placeholder = placeholder ;
    tf.text = text ;
    tf.autocorrectionType = UITextAutocorrectionTypeNo ;
    tf.autocapitalizationType = UITextAutocapitalizationTypeNone;
    tf.textAlignment = NSTextAlignmentRight;
    tf.adjustsFontSizeToFitWidth = YES;
    tf.textColor = [UIColor colorWithRed:56.0f/255.0f green:84.0f/255.0f blue:135.0f/255.0f alpha:1.0f];
    return tf ;
}

-(UISwitch*) makeYesNoField: (NSNumber*)value  {
    UISwitch *sf = [[UISwitch alloc] init];
    [sf setOn:[value boolValue] animated:NO];
    return sf ;
}

// Workaround to hide keyboard when Done is tapped
- (IBAction)textFieldFinished:(id)sender {
    // [sender resignFirstResponder];
}

// Textfield value changed, store the new value.
- (void)textFieldDidEndEditing:(UITextField *)textField {
    if ( textField == _descriptionField ) {
        self.description = textField.text ;
        if (self.detailViewController != nil) {
            [self.detailViewController setDescription:self.description];
        }
    }
    else if ( textField == _employerNameField ) {
        self.employerName = textField.text ;
    }
    else if ( textField == _employeeNameField ) {
        self.employeeName = textField.text ;
    }
    else if ( textField == _employeeNumbField ) {
        self.employeeNumb = textField.text ;
    }
    else if ( textField == _departmentField ) {
        self.department = textField.text ;
    }
    else if ( textField == _salaryMoneyField ) {
        self.salaryMoney = textField.text;
    }
}
// Switchfield value changed, store the new value.
- (void)switchFieldFinished:(UISwitch *)switchField {
    if ( switchField == _taxDeclarationField ) {
        self.taxDeclaration = @(switchField.isOn);
    }
    else if ( switchField == _taxPayerClaimField ) {
        self.taxPayerClaim = @(switchField.isOn);
    }
}
@end