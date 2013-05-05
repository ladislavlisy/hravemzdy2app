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
    UITextField* _descriptionField;
    UITextField* _employerNameField;
    UITextField* _employeeNameField;
    UITextField* _employeeNumbField;
    UITextField* _departmentField;
    UITextField* _salaryMoneyField;
    UISwitch * _taxDeclarationField;
    UISwitch * _taxPayerClaimField;
}
@end

@implementation PYGMasterViewController

@synthesize description = _description;
@synthesize employerName = _employerName;
@synthesize employeeName = _employeeName;
@synthesize employeeNumb = _employeeNumb;
@synthesize department = _department;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    if (!(self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil])) return nil;
    self.title = NSLocalizedString(@"Master", @"Master");
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
    self.employerName = @"" ;
    self.employeeName = @"" ;
    self.employeeNumb = @"" ;
    self.department   = @"" ;
    self.salaryMoney  = @"";
    self.taxDeclaration = @YES;
    self.taxPayerClaim  = @YES;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table View

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;

}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 8;
}

- (NSString *)tableView:(UITableView *)tableView
titleForHeaderInSection:(NSInteger)section
{
    return @"Payroll details";
}

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];

    // Make cell unselectable
    cell.selectionStyle = UITableViewCellSelectionStyleNone;

    UITextField* tf = nil ;
    UISwitch* sf = nil ;
    switch ( indexPath.row ) {
        case 0: {
            cell.textLabel.text = @"Description" ;
            tf = _descriptionField = [self makeTextField:self.description placeholder:@"My happy payroll"];
            [cell addSubview:_descriptionField];
            break ;
        }
        case 1: {
            cell.textLabel.text = @"Employer" ;
            tf = _employerNameField = [self makeTextField:self.employerName placeholder:@"Employer name"];
            [cell addSubview:_employerNameField];
            break ;
        }
        case 2: {
            cell.textLabel.text = @"Personnel" ;
            tf = _employeeNumbField = [self makeTextField:self.employeeNumb placeholder:@"Number"];
            [cell addSubview:_employeeNumbField];
            break ;
        }
        case 3: {
            cell.textLabel.text = @"Employee" ;
            tf = _employeeNameField = [self makeTextField:self.employeeName placeholder:@"Jája Pája"];
            [cell addSubview:_employeeNameField];
            break ;
        }
        case 4: {
            cell.textLabel.text = @"Department" ;
            tf = _departmentField = [self makeTextField:self.department placeholder:@"Work department"];
            [cell addSubview:_departmentField];
            break ;
        }
        case 5: {
            cell.textLabel.text = @"Salary" ;
            tf = _salaryMoneyField = [self makeNumberField:self.salaryMoney placeholder:@" CZK"];
            [cell addSubview:_salaryMoneyField];
            break ;
        }
        case 6: {
            cell.textLabel.text = @"Tax declaration" ;
            sf = _taxDeclarationField = [self makeYesNoField:self.taxDeclaration placeholder:@"Work department"];
            [cell addSubview:_taxDeclarationField];
            break ;
        }
        case 7: {
            cell.textLabel.text = @"Tax payer claim" ;
            sf = _taxPayerClaimField = [self makeYesNoField:self.taxPayerClaim placeholder:@"Work department"];
            [cell addSubview:_taxPayerClaimField];
            break ;
        }
    }

    // Textfield dimensions
    if (tf != nil) {
        tf.frame = CGRectMake(150, 12, 140, 30);
        // Workaround to dismiss keyboard when Done/Return is tapped
        [tf addTarget:self action:@selector(textFieldFinished:) forControlEvents:UIControlEventEditingDidEnd];

        // We want to handle textFieldDidEndEditing
        tf.delegate = self ;
    }

    // Switch dimensions
    if (sf != nil) {
        sf.frame = CGRectMake(220, 8, 70, 30);
        // Workaround to dismiss keyboard when Done/Return is tapped
        [sf addTarget:self action:@selector(switchFieldFinished:) forControlEvents:UIControlEventValueChanged];

        // We want to handle textFieldDidEndEditing
        tf.delegate = self ;
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

-(UISwitch*) makeYesNoField: (NSNumber*)value
                    placeholder: (NSString*)placeholder  {
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