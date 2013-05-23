//
//  PYGMasterViewController.m
//  hravemzdyapp
//
//  Created by Ladislav Lisy on 04/24/13.
//  Copyright (c) 2013 ___HRAVEMZDY___. All rights reserved.
//

#import "PYGMasterViewController.h"

#import "PYGDetailViewController.h"
#import "PYGSymbolTags.h"

#define DEFAULT_SCHEDULE 40
#define DEFAULT_ABSENCE 0
#define DEFAULT_TAX_PAYER 1
#define DEFAULT_INS_PAYER 1
#define DEFAULT_INS_MINIM 1
#define DEFAULT_INS_PENSION 0
#define DEFAULT_INS_EMPLOYER 1


@interface PYGMasterViewController () {
}

@property (strong, nonatomic) UITextField* descriptionField;
@property (strong, nonatomic) UITextField* employerNameField;
@property (strong, nonatomic) UITextField* employeeNameField;
@property (strong, nonatomic) UITextField* employeeNumbField;
@property (strong, nonatomic) UITextField* departmentField;
@property (strong, nonatomic) UITextField* salaryMoneyField;
@property (strong, nonatomic) UISwitch * taxDeclarationField;
@property (strong, nonatomic) UISwitch * taxPayerClaimField;
@property (strong, nonatomic) UISwitch * taxStudyClaimField;
@property (strong, nonatomic) UISwitch * taxDisability1Field;
@property (strong, nonatomic) UISwitch * taxDisability2Field;
@property (strong, nonatomic) UISwitch * taxDisability3Field;
@property (strong, nonatomic) UISwitch * taxBenefitChild1Field;
@property (strong, nonatomic) UISwitch * taxBenefitChild2Field;
@property (strong, nonatomic) UISwitch * taxBenefitChild3Field;
@property (strong, nonatomic) UISwitch * taxBenefitChild4Field;
@property (strong, nonatomic) UISwitch * taxBenefitChild5Field;
@property (strong, nonatomic) UITextField* companyNameField;
@property (strong, nonatomic) UITextField* payrolleeNameField;
@property (strong, nonatomic) UITextField* payrolleeEmailField;
@property (strong, nonatomic) NSArray* sections;
@property (strong, nonatomic) NSArray* sectionRows1;
@property (strong, nonatomic) NSArray* sectionRows2;
@property (strong, nonatomic) NSArray* sectionRows3;
@property (strong, nonatomic) NSArray* sectionRows4;
@property (strong, nonatomic) NSArray* sectionRows5;
@property (strong, nonatomic) NSArray* sectionRows6;
@property (strong, nonatomic) NSArray* placeholders1;
@property (strong, nonatomic) NSArray* placeholders2;
@property (strong, nonatomic) NSArray* placeholders6;
@property (strong, nonatomic) NSNumberFormatter* currencyFormatter;
@property (strong, nonatomic) NSLocale* currencyLocaleCZ;
@end

@implementation PYGMasterViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    if (!(self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil])) return nil;
    self.title = NSLocalizedString(@"Payroll specs", @"Payroll specs");
    self.sections = @[
            @"Payroll details",
            @"Tax payer declaration",
            @"Tax disability benefit",
            @"Tax child benefit",
            @"Payslip details",
            @"Contact for results"
    ];
    self.sectionRows1 = @[
            @"Description",
            @"Salary"
    ];
    self.placeholders1 = @[
            @"My happy payroll",
            @" CZK"
    ];
    self.sectionRows2 = @[
            @"Employee",
            @"Employer",
            @"Department",
            @"Personnel"
    ];
    self.placeholders2 = @[
            @"Jája Pája",
            @"Employer name",
            @"Work department",
            @"Number"
    ];
    self.sectionRows3 = @[
            @"Tax declaration",
            @"Tax payer claim",
            @"Tax studying claim"
    ];
    self.sectionRows4 = @[
            @"claim level 1",
            @"claim level 2",
            @"claim level 3"
    ];
    self.sectionRows5 = @[
            @"claim 1. child",
            @"claim 2. child",
            @"claim 3. child",
            @"claim 4. child",
            @"claim 5. child"
    ];
    self.sectionRows6 = @[
            @"Company",
            @"Payrollee",
            @"Email"
    ];
    self.placeholders6 = @[
            @"My Company Inc.",
            @"MyPayroll Best",
            @"pyarollee@my-company.com"
    ];
    [self setupCurrencyFormatter];

    self.clearsSelectionOnViewWillAppear = NO;
    self.contentSizeForViewInPopover = CGSizeMake(320.0, 600.0);
    return self;
}

- (void)setupCurrencyFormatter {
    self.currencyLocaleCZ = [[NSLocale alloc] initWithLocaleIdentifier:@"cz_CZ"];
    self.currencyFormatter = [[NSNumberFormatter alloc] init];

    [self.currencyFormatter setFormatterBehavior:NSNumberFormatterBehavior10_4];
    [self.currencyFormatter setNumberStyle:NSNumberFormatterCurrencyStyle];
    [self.currencyFormatter setMaximumFractionDigits:2];
    [self.currencyFormatter setGeneratesDecimalNumbers:YES];
    [self.currencyFormatter setLocale:self.currencyLocaleCZ];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    self.detailViewController = (PYGDetailViewController *)[[self.splitViewController.viewControllers lastObject] topViewController];

    self.description       = @"" ;
    self.employerName      = @"" ;
    self.employeeName      = @"" ;
    self.employeeNumb      = @"" ;
    self.department        = @"" ;
    self.salaryMoney       = DECIMAL_ZERO;
    self.taxDeclaration    = @YES;
    self.taxPayerClaim     = @YES;
    self.taxStudyClaim     = @NO;
    self.taxDisability1    = @NO;
    self.taxDisability2    = @NO;
    self.taxDisability3    = @NO;
    self.taxBenefitChild1  = @NO;
    self.taxBenefitChild2  = @NO;
    self.taxBenefitChild3  = @NO;
    self.taxBenefitChild4  = @NO;
    self.taxBenefitChild5  = @NO;
    self.companyName       = @"";
    self.payrolleeName     = @"";
    self.payrolleeEmail    = @"";
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
        case 0: return self.sectionRows1.count; break;
        case 1: return self.sectionRows3.count; break;
        case 2: return self.sectionRows4.count; break;
        case 3: return self.sectionRows5.count; break;
        case 4: return self.sectionRows2.count; break;
        case 5: return self.sectionRows6.count; break;
        default: break;
    }
    return 0;
}

- (NSString *)tableView:(UITableView *)tableView
titleForHeaderInSection:(NSInteger)section
{
    return (NSString *)self.sections[(NSUInteger)section];
}

- (UITextField *)createSection1CellWithTextField:(UITableViewCell *)cell andValue:(NSString*) textFieldValue inRow:(NSUInteger)row {
    UITextField *tf;
    cell.textLabel.text = self.sectionRows1[row] ;
    tf = [self makeTextField:textFieldValue placeholder:self.placeholders1[row]];
    [cell addSubview:tf];
    [self setTextFieldDimensionAndAction:tf];
    return tf;
}

- (UITextField *)createSection1CellWithNumberField:(UITableViewCell *)cell andValue:(NSDecimalNumber *) decimalValue inRow:(NSUInteger)row {
    UITextField *tf;
    cell.textLabel.text = self.sectionRows1[row] ;
    NSString * textFieldValue = [self formatCurrencyString:decimalValue];
    tf = [self makeTextField:textFieldValue placeholder:self.placeholders1[row]];
    [tf setTextAlignment:NSTextAlignmentRight];
    [tf setKeyboardType:UIKeyboardTypeNumberPad];
    [cell addSubview:tf];
    [self setNumberFieldDimensionAndAction:tf];
    return tf;
}

- (UITextField *)createSection2CellWithTextField:(UITableViewCell *)cell andValue:(NSString*) textFieldValue inRow:(NSUInteger)row {
    UITextField *tf;
    cell.textLabel.text = self.sectionRows2[row] ;
    tf = [self makeTextField:textFieldValue placeholder:self.placeholders2[row]];
    [cell addSubview:tf];
    [self setTextFieldDimensionAndAction:tf];
    return tf;
}

- (UISwitch *)createSection3CellWithSwitchField:(UITableViewCell *)cell andValue:(NSNumber*) switchFieldValue inRow:(NSUInteger)row {
    UISwitch* sf = nil ;
    cell.textLabel.text = self.sectionRows3[row] ;
    sf = [self makeYesNoField:switchFieldValue];
    [cell addSubview:sf];
    [self setSwitchFieldDimensionAndAction:sf];
    return sf;
}

- (UISwitch *)createSection4CellWithSwitchField:(UITableViewCell *)cell andValue:(NSNumber*) switchFieldValue inRow:(NSUInteger)row {
    UISwitch* sf = nil ;
    cell.textLabel.text = self.sectionRows4[row] ;
    sf = [self makeYesNoField:switchFieldValue];
    [cell addSubview:sf];
    [self setSwitchFieldDimensionAndAction:sf];
    return sf;
}

- (UISwitch *)createSection5CellWithSwitchField:(UITableViewCell *)cell andValue:(NSNumber*) switchFieldValue inRow:(NSUInteger)row {
    UISwitch* sf = nil ;
    cell.textLabel.text = self.sectionRows5[row] ;
    sf = [self makeYesNoField:switchFieldValue];
    [cell addSubview:sf];
    [self setSwitchFieldDimensionAndAction:sf];
    return sf;
}

- (UITextField *)createSection6CellWithTextField:(UITableViewCell *)cell andValue:(NSString*) textFieldValue inRow:(NSUInteger)row {
    UITextField *tf;
    cell.textLabel.text = self.sectionRows6[row] ;
    tf = [self makeTextField:textFieldValue placeholder:self.placeholders6[row]];
    [cell addSubview:tf];
    [self setTextFieldDimensionAndAction:tf];
    return tf;
}

//Payroll details
//  description
//  payroll period
//  salary
- (void)createCellInSectionPayrollDetails:(UITableViewCell *)cell forRow:(NSUInteger)row {
    switch ( row ) {
        case 0: {
            self.descriptionField = [self createSection1CellWithTextField:cell andValue:self.description inRow:row];
            break ;
        }
        case 1: {
            self.salaryMoneyField = [self createSection1CellWithNumberField:cell andValue:self.salaryMoney inRow:row];
            break ;
        }
        default:
            break;
    }
}

//Payslip details
//  employer name
//  employee name
//  department
//  employee number
- (void)createCellInSectionPayslipDetails:(UITableViewCell *)cell forRow:(NSUInteger)row {
    switch ( row ) {
        case 0: {
            self.employeeNameField = [self createSection2CellWithTextField:cell andValue:self.employeeName inRow:row];
            break ;
        }
        case 1: {
            self.employerNameField = [self createSection2CellWithTextField:cell andValue:self.employerName inRow:row];
            break ;
        }
        case 2: {
            self.departmentField = [self createSection2CellWithTextField:cell andValue:self.department inRow:row];
            break ;
        }
        case 3: {
            self.employeeNumbField = [self createSection2CellWithTextField:cell andValue:self.employeeNumb inRow:row];
            break ;
        }
        default:
            break;
    }
}

//Tax payer declaration
//  tax declaration
//  claim tax payer benefit
//  claim studying benefit
- (void)createCellInSectionTaxDeclaration:(UITableViewCell *)cell forRow:(NSUInteger)row {
    switch ( row ) {
        case 0: {
            self.taxDeclarationField = [self createSection3CellWithSwitchField:cell andValue:self.taxDeclaration inRow:row];
            break ;
        }
        case 1: {
            self.taxPayerClaimField = [self createSection3CellWithSwitchField:cell andValue:self.taxPayerClaim inRow:row];
            break ;
        }
        case 2: {
            self.taxStudyClaimField = [self createSection3CellWithSwitchField:cell andValue:self.taxStudyClaim inRow:row];
            break ;
        }
        default:
            break;
    }
}

//Tax disability benefit
//  claim disability benefit 1
//  claim disability benefit 2
//  claim disability benefit 3
- (void)createCellInSectionDisabilityBenefit:(UITableViewCell *)cell forRow:(NSUInteger)row {
    switch ( row ) {
        case 0: {
            self.taxDisability1Field = [self createSection4CellWithSwitchField:cell andValue:self.taxDisability1 inRow:row];
            break;
        }
        case 1: {
            self.taxDisability2Field = [self createSection4CellWithSwitchField:cell andValue:self.taxDisability2 inRow:row];
            break;
        }
        case 2: {
            self.taxDisability3Field = [self createSection4CellWithSwitchField:cell andValue:self.taxDisability3 inRow:row];
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
            self.taxBenefitChild1Field = [self createSection5CellWithSwitchField:cell andValue:self.taxBenefitChild1 inRow:row];
            break;
        }
        case 1: {
            self.taxBenefitChild2Field = [self createSection5CellWithSwitchField:cell andValue:self.taxBenefitChild2 inRow:row];
            break;
        }
        case 2: {
            self.taxBenefitChild3Field = [self createSection5CellWithSwitchField:cell andValue:self.taxBenefitChild3 inRow:row];
            break;
        }
        case 3: {
            self.taxBenefitChild4Field = [self createSection5CellWithSwitchField:cell andValue:self.taxBenefitChild4 inRow:row];
            break;
        }
        case 4: {
            self.taxBenefitChild5Field = [self createSection5CellWithSwitchField:cell andValue:self.taxBenefitChild5 inRow:row];
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
            self.companyNameField = [self createSection6CellWithTextField:cell andValue:self.companyName inRow:row];
            break;
        }
        case 1: {
            self.payrolleeNameField = [self createSection6CellWithTextField:cell andValue:self.payrolleeName inRow:row];
            break;
        }
        case 2: {
            self.payrolleeEmailField = [self createSection6CellWithTextField:cell andValue:self.payrolleeEmail inRow:row];
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

- (void)setNumberFieldDimensionAndAction:(UITextField*)tf {
    // TextField dimensions
    if (tf != nil) {
        tf.frame = CGRectMake(150, 12, 140, 30);
        // Workaround to dismiss keyboard when Done/Return is tapped
        [tf addTarget:self action:@selector(numberFieldEditStarted:) forControlEvents:UIControlEventEditingDidBegin];
        [tf addTarget:self action:@selector(numberFieldFinished:) forControlEvents:UIControlEventEditingDidEnd];

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
            [self createCellInSectionTaxDeclaration:cell forRow:(NSUInteger)indexPath.row];
            break;
        }
        case 2: {
            [self createCellInSectionDisabilityBenefit:cell forRow:(NSUInteger)indexPath.row];
            break;
        }
        case 3: {
            [self createCellInSectionChildBenefit:cell forRow:(NSUInteger)indexPath.row];
            break;
        }
        case 4: {
            [self createCellInSectionPayslipDetails:cell forRow:(NSUInteger)indexPath.row];
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

// Workaround to hide keyboard when Done is tapped
- (IBAction)numberFieldEditStarted:(id)sender {
    UITextField * textField = (UITextField *)sender;
    NSString * stringValue = [textField text];

    NSDecimalNumber * decimalValue = [self getDecimalNumberOrZeroFromCurrencyString:stringValue];
    [textField setText:[self formatString:decimalValue]];
}

- (IBAction)numberFieldFinished:(id)sender {
    UITextField * textField = (UITextField *)sender;
    NSString * stringValue = [textField text];

    NSDecimalNumber * decimalValue = [self getDecimalNumberOrZeroFromString:stringValue];
    [textField setText:[self formatCurrencyString:decimalValue]];
}

// TextField value changed, store the new value.
- (void)textFieldDidEndEditing:(UITextField *)textField {
    if ( textField == self.descriptionField ) {
        self.description = textField.text ;
    }
    else if ( textField == self.salaryMoneyField ) {
        self.salaryMoney = [self getDecimalNumberOrZeroFromCurrencyString:textField.text];
    }
    else if ( textField == self.employerNameField ) {
        self.employerName = textField.text ;
    }
    else if ( textField == self.employeeNameField ) {
        self.employeeName = textField.text ;
    }
    else if ( textField == self.employeeNumbField ) {
        self.employeeNumb = textField.text ;
    }
    else if ( textField == self.departmentField ) {
        self.department = textField.text ;
    }
    else if ( textField == self.companyNameField ) {
        self.companyName = textField.text;
    }
    else if ( textField == self.payrolleeNameField ) {
        self.payrolleeName = textField.text;
    }
    else if ( textField == self.payrolleeEmailField ) {
        self.payrolleeEmail = textField.text;
    }
    NSDictionary * payroll_titles = [self collectPayrollTitles];
    if (self.detailViewController != nil) {
        [self.detailViewController setPayrollTitles:payroll_titles];
    }
    NSDictionary * payroll_values = [self collectPayrollValues];
    if (self.detailViewController != nil) {
        [self.detailViewController setPayrollValues:payroll_values];
    }
}

// SwitchField value changed, store the new value.
- (void)switchFieldFinished:(UISwitch *)switchField {
    if ( switchField == self.taxDeclarationField ) {
        self.taxDeclaration = @(switchField.isOn);
    }
    else if ( switchField == self.taxPayerClaimField ) {
        self.taxPayerClaim = @(switchField.isOn);
    }
    else if ( switchField == self.taxStudyClaimField ) {
        self.taxStudyClaim = @(switchField.isOn);
    }
    else if ( switchField == self.taxDisability1Field ) {
        self.taxDisability1 = @(switchField.isOn);
    }
    else if ( switchField == self.taxDisability2Field ) {
        self.taxDisability2 = @(switchField.isOn);
    }
    else if ( switchField == self.taxDisability3Field ) {
        self.taxDisability3 = @(switchField.isOn);
    }
    else if ( switchField == self.taxBenefitChild1Field ) {
        self.taxBenefitChild1 = @(switchField.isOn);
    }
    else if ( switchField == self.taxBenefitChild2Field ) {
        self.taxBenefitChild2 = @(switchField.isOn);
    }
    else if ( switchField == self.taxBenefitChild3Field ) {
        self.taxBenefitChild3 = @(switchField.isOn);
    }
    else if ( switchField == self.taxBenefitChild4Field ) {
        self.taxBenefitChild4 = @(switchField.isOn);
    }
    else if ( switchField == self.taxBenefitChild5Field ) {
        self.taxBenefitChild5 = @(switchField.isOn);
    }
    NSDictionary * payroll_titles = [self collectPayrollTitles];
    if (self.detailViewController != nil) {
        [self.detailViewController setPayrollTitles:payroll_titles];
    }
    NSDictionary * payroll_values = [self collectPayrollValues];
    if (self.detailViewController != nil) {
        [self.detailViewController setPayrollValues:payroll_values];
    }
}

- (NSDictionary *)collectPayrollTitles {
    NSDictionary * payroll_titles = @{
        @"description" : self.description,
        @"employer" : self.employerName,
        @"employee" : self.employeeName,
        @"personnel" : self.employeeNumb,
        @"department" : self.department,
        @"company" : self.companyName,
        @"payrollee" : self.payrolleeName,
        @"email" : self.payrolleeEmail
    };
    return payroll_titles;
}

- (NSString *)formatString:(NSDecimalNumber *)decimalValue {
    if (isnan(decimalValue.doubleValue) || [decimalValue isEqual:DECIMAL_ZERO]) {
        return  @"";
    }
    return [decimalValue stringValue];
}

- (NSString *)formatCurrencyString:(NSDecimalNumber *)decimalValue {
    return [self.currencyFormatter stringFromNumber:decimalValue];
}

- (NSDecimalNumber *)getDecimalNumberOrZeroFromString:(NSString *)formattedValue {
    NSDecimalNumber * decimalValue = [NSDecimalNumber decimalNumberWithString:formattedValue];
    if (isnormal(decimalValue.doubleValue)) {
        return decimalValue ;
    }
    return DECIMAL_ZERO;
}

- (NSDecimalNumber *)getDecimalNumberOrZeroFromCurrencyString:(NSString *)formattedValue {
    NSError *error = NULL;
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"(CZK )"
                                                                           options:NSRegularExpressionCaseInsensitive
                                                                             error:&error];
    // create the new string by replacing the matching of the regex pattern with the template pattern(whitespace)
    NSString * formattedAmount = [regex stringByReplacingMatchesInString:formattedValue options:0
                                                                range:NSMakeRange(0, [formattedValue length])
                                                         withTemplate:@"CZK\u00A0"];
    NSNumber *numberValue = [self.currencyFormatter numberFromString:formattedAmount];
    NSDecimalNumber *decimalValue = [NSDecimalNumber decimalNumberWithDecimal:[numberValue decimalValue]];
    if (!isnan(decimalValue.doubleValue)) {
        return decimalValue ;
    }
    return DECIMAL_ZERO;
}

- (NSDictionary *)collectPayrollValues {
    PYGCodeNameRefer * REF_SCHEDULE_WORK         = TAGS_REF(TAG_SCHEDULE_WORK);
    PYGCodeNameRefer * REF_SCHEDULE_TERM         = TAGS_REF(TAG_SCHEDULE_TERM);
    PYGCodeNameRefer * REF_HOURS_ABSENCE         = TAGS_REF(TAG_HOURS_ABSENCE);
    PYGCodeNameRefer * REF_SALARY_BASE           = TAGS_REF(TAG_SALARY_BASE);
    PYGCodeNameRefer * REF_TAX_INCOME_BASE       = TAGS_REF(TAG_TAX_INCOME_BASE);
    PYGCodeNameRefer * REF_INSURANCE_HEALTH_BASE = TAGS_REF(TAG_INSURANCE_HEALTH_BASE);
    PYGCodeNameRefer * REF_INSURANCE_HEALTH      = TAGS_REF(TAG_INSURANCE_HEALTH);
    PYGCodeNameRefer * REF_INSURANCE_SOCIAL_BASE = TAGS_REF(TAG_INSURANCE_SOCIAL_BASE);
    PYGCodeNameRefer * REF_INSURANCE_SOCIAL      = TAGS_REF(TAG_INSURANCE_SOCIAL);
    PYGCodeNameRefer * REF_SAVINGS_PENSIONS      = TAGS_REF(TAG_SAVINGS_PENSIONS);
    PYGCodeNameRefer * REF_TAX_CLAIM_PAYER       = TAGS_REF(TAG_TAX_CLAIM_PAYER);
    PYGCodeNameRefer * REF_TAX_CLAIM_CHILD       = TAGS_REF(TAG_TAX_CLAIM_CHILD);
    PYGCodeNameRefer * REF_TAX_CLAIM_DISABILITY  = TAGS_REF(TAG_TAX_CLAIM_DISABILITY);
    PYGCodeNameRefer * REF_TAX_CLAIM_STUDYING    = TAGS_REF(TAG_TAX_CLAIM_STUDYING);
    PYGCodeNameRefer * REF_TAX_EMPLOYERS_HEALTH  = TAGS_REF(TAG_TAX_EMPLOYERS_HEALTH);
    PYGCodeNameRefer * REF_TAX_EMPLOYERS_SOCIAL  = TAGS_REF(TAG_TAX_EMPLOYERS_SOCIAL);

    NSDictionary * payroll_values = @{
            REF_SCHEDULE_WORK : @{
                    I_MAKE_PAIR(@"hours_weekly", DEFAULT_SCHEDULE)
            },
            REF_SCHEDULE_TERM : @{
                    //DT_MAKE_PAIR(@"date_from", nil),
                    //DT_MAKE_PAIR(@"date_end", nil),
            },
            REF_HOURS_ABSENCE : @{
                    I_MAKE_PAIR(@"hours", DEFAULT_ABSENCE)
            },
            REF_SALARY_BASE : @{
                    D_MAKE_PAIR(@"amount_monthly", self.salaryMoney)
            },
            REF_TAX_INCOME_BASE : @{
                    U_MAKE_PAIR(@"interest_code", DEFAULT_TAX_PAYER),
                    U_MAKE_PAIR(@"declare_code",  self.taxDeclaration.unsignedIntegerValue)
            },
            REF_INSURANCE_HEALTH_BASE : @{
                    U_MAKE_PAIR(@"interest_code", DEFAULT_INS_PAYER),
                    U_MAKE_PAIR(@"minimum_asses", DEFAULT_INS_MINIM)
            },
            REF_INSURANCE_HEALTH : @{
                    U_MAKE_PAIR(@"interest_code", DEFAULT_INS_PAYER),
            },
            REF_INSURANCE_SOCIAL_BASE : @{
                    U_MAKE_PAIR(@"interest_code", DEFAULT_INS_PAYER)
            },
            REF_INSURANCE_SOCIAL : @{
                    U_MAKE_PAIR(@"interest_code", DEFAULT_INS_PAYER),
            },
            REF_SAVINGS_PENSIONS : @{
                    U_MAKE_PAIR(@"interest_code", DEFAULT_INS_PENSION)
            },
            REF_TAX_CLAIM_PAYER : @{
                    U_MAKE_PAIR(@"relief_code", self.taxPayerClaim.unsignedIntegerValue)
            },
            REF_TAX_CLAIM_DISABILITY : @{
                    U_MAKE_PAIR(@"relief_code_1", self.taxDisability1.unsignedIntegerValue),
                    U_MAKE_PAIR(@"relief_code_2", self.taxDisability2.unsignedIntegerValue),
                    U_MAKE_PAIR(@"relief_code_3", self.taxDisability3.unsignedIntegerValue)
            },
            REF_TAX_CLAIM_STUDYING : @{
                    U_MAKE_PAIR(@"relief_code", self.taxStudyClaim.unsignedIntegerValue)
            },
            REF_TAX_CLAIM_CHILD : @{
                    U_MAKE_PAIR(@"relief_code",
                    self.taxBenefitChild1.unsignedIntegerValue +
                    self.taxBenefitChild2.unsignedIntegerValue +
                    self.taxBenefitChild3.unsignedIntegerValue +
                    self.taxBenefitChild4.unsignedIntegerValue +
                    self.taxBenefitChild5.unsignedIntegerValue)
            },
            REF_TAX_EMPLOYERS_HEALTH : @{
                    U_MAKE_PAIR(@"interest_code", DEFAULT_INS_EMPLOYER)
            },
            REF_TAX_EMPLOYERS_SOCIAL : @{
                    U_MAKE_PAIR(@"interest_code", DEFAULT_INS_EMPLOYER)
            }
    };
    return payroll_values;
}
@end