								//
//  EditInfoViewController.m
//  SQLiteFIrstSample
//
//  Created by Radzivon Uhrynovich on 7/9/18.
//  Copyright © 2018 BNR. All rights reserved.
//

#import "EditInfoViewController.h"
#import "MyFirstDBManager.h"
#import "DetailViewController.h"

//static NSString * dbName = @"MYTasks.db";

@interface EditInfoViewController ()

@property (weak, nonatomic) IBOutlet UITextField *taskTitle;
@property (weak, nonatomic) IBOutlet UITextField *taskDate;
@property (weak, nonatomic) IBOutlet UITextView *taskDescription;
@property (weak, nonatomic) IBOutlet UIButton *priorityBttn;
@property (strong ,nonatomic) UIAlertController *dateAlert;

@property (strong, nonatomic) MyFirstDBManager *dbManager;
@property (strong, nonatomic) DetailViewController *detailVC;

@property(assign, nonatomic, getter=isSelectedTitleBttn) BOOL selectedTitleBttn;
@property(assign, nonatomic, getter=isSelectedDateBttn) BOOL selectedDateBttn;
- (IBAction)willVaryForTitle:(id)sender;
- (IBAction)willVaryForDate:(id)sender;

@property (weak, nonatomic) IBOutlet UIButton *titleBttnQuery;
@property (weak, nonatomic) IBOutlet UIButton *dateBttnQuery;


- (IBAction)hightPriorBttnTapped:(UIButton *)sender;
- (IBAction)saveInfo:(id)sender;
- (void)loadInfoToEdit;
@end

@implementation EditInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
//    [self.taskTitle setDelegate:self];
    [self.taskDate setDelegate:self];
    [self.taskDescription setDelegate:self];
    
    NSString *dbFileName = @"myTasks.db";
    [self setDbManager:[[MyFirstDBManager alloc] initWithDataBaseFileName:dbFileName]];
    
    if(self.idToEdit != -1) {
        [self loadInfoToEdit];
        [self.titleBttnQuery setHidden:NO];
        [self.dateBttnQuery setHidden:NO];
    } else {
        [self.titleBttnQuery setHidden:YES];
        [self.dateBttnQuery setHidden:YES];
    }
    
    [self setBordersToTextFieldsAndButtons];
    
    // 1) add to Category methods for appearence of ui  elements
    //2) add buttons for fetching data from db
    
}

- (void) setBordersToTextFieldsAndButtons {
    CALayer *titleLayer = self.taskTitle.layer;
    CALayer *dateLayer = self.taskDate.layer;
    CALayer *descriptLayer = self.taskDescription.layer;
    CALayer *priorBttn = self.priorityBttn.layer;
    [self configureElements:titleLayer color:UIColor.blueColor borderWidth:1];
    [self configureElements:dateLayer color:UIColor.blueColor borderWidth:1];
    [self configureElements:descriptLayer color:UIColor.blueColor borderWidth:2];
    [self configureElements:priorBttn color:UIColor.clearColor borderWidth:1];
}

- (void) configureElements:(CALayer *)element color:(UIColor *)color borderWidth:(CGFloat)borderWidth {
    [element setBorderWidth:2];
    [element setBorderColor:color.CGColor];
    [element setCornerRadius:15];
}

#pragma mark - configuration for text fields

- (void)textFieldDidEndEditing:(UITextField *)textField {
    [self convertTextIntoDateFormatToCheck:textField.text];
}

// Check validity of date string
- (void)convertTextIntoDateFormatToCheck:(NSString *)dateStr {
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"DD.MM.YYYY"];
    NSDate *date = [dateFormat dateFromString:dateStr];
    if(!date || dateStr.length != 10) {
        [self showDateAlert];
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    NSLog(@"textFieldShouldReturn");
    [textField resignFirstResponder];
    return YES;
}

- (BOOL)textViewShouldEndEditing:(UITextView *)textView {
    [textView resignFirstResponder];
    return YES;
}

- (IBAction)hightPriorBttnTapped:(UIButton *)sender {
    if([sender backgroundColor] == UIColor.whiteColor) {
        [sender setTitle:@"high" forState:UIControlStateNormal];
        [sender setBackgroundColor:UIColor.redColor];
    } else {
        [sender setTitle:@"set priority" forState:UIControlStateNormal];
         [sender setBackgroundColor:UIColor.whiteColor];
    }
}

//pass date to ViewController. Can be new task or task that was editted
- (void)saveInfo:(id)sender {
    //Check if string in dateField is valid
    [self convertTextIntoDateFormatToCheck:self.taskDate.text];
    
    NSString *query;

    if(([self.taskTitle.text  isEqualToString: @""] && [self.taskDate.text  isEqualToString: @""] && [self.taskDescription.text  isEqualToString: @""]) || [self.taskTitle.text isEqualToString:@""]) {
        [self showAlert];
    }
    // id==-1 if we are going to create a new task; (idToEdit was passed to editVC from VC)
    if(self.idToEdit == -1) {
        query = [NSString stringWithFormat:@"insert into myTasks values(null, '%@', '%@', '%@', '%@')", [self.taskTitle.text lowercaseString], self.taskDate.text, self.priorityBttn.titleLabel.text, self.taskDescription.text];
    } else {
        query = [NSString stringWithFormat:@"update myTasks set title='%@', date='%@', priority='%@', description='%@' where taskID=%d", [self.taskTitle.text lowercaseString], self.taskDate.text, self.priorityBttn.titleLabel.text, self.taskDescription.text, self.idToEdit];
    }
    
    [self.dbManager executeQuery:query];
    
    if([self.dbManager affectedRows] != 0) {
        NSLog(@"Query was executed! Number of Affected rows:%d", [self.dbManager affectedRows]);
        NSLog(@"column count %lu\n%@", self.dbManager.arrColumnNames.count, self.dbManager.arrColumnNames);
        [self.delegate editingInfoWasFinishedWithIDofNewElement];
        [self.navigationController popViewControllerAnimated:YES];
    } else {
        NSLog(@"Couldn't execute query");
        
    }
}

- (void)showAlert {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Wait" message:@"You'd better to fill in all of the fields!!!" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *action = [UIAlertAction actionWithTitle:@"I got it" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
    }];
    [alert addAction:action];
    [self presentViewController:alert animated:YES completion:^{
        [self.priorityBttn setHidden:YES];
    }];
}

- (void)showDateAlert {
    self.dateAlert = [UIAlertController alertControllerWithTitle:@"Wrond Date" message:@"Preferred date format only: dd.mm.yyyy; for instance(01.01.2018)" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *action = [UIAlertAction actionWithTitle:@"I got it" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                [self.taskDate becomeFirstResponder];
    }];
    [self.dateAlert addAction:action];
    [self presentViewController:self.dateAlert animated:YES completion:^{
        [self.priorityBttn setHidden:YES];
    }];
}

//pass editted info to VC
-(void)loadInfoToEdit{
    // Create the query.
    NSString *query = [NSString stringWithFormat:@"select * from myTasks where taskID=%d", self.idToEdit];
    
    // Load the relevant data.
    NSArray *results = [[NSArray alloc] initWithArray:[self.dbManager loadDatatFromDB:query]];
    
    // Set the loaded data to the textfields.
    self.taskTitle.text = [[results objectAtIndex:0] objectAtIndex:[self.dbManager.arrColumnNames indexOfObject:@"title"]];
    self.taskDate.text = [[results objectAtIndex:0] objectAtIndex:[self.dbManager.arrColumnNames indexOfObject:@"date"]];
    self.taskDescription.text = [[results objectAtIndex:0] objectAtIndex:[self.dbManager.arrColumnNames indexOfObject:@"description"]];
    NSString *priority = [[results objectAtIndex:0] objectAtIndex:[self.dbManager.arrColumnNames indexOfObject:@"priority"]];
    if ([priority isEqualToString:@"high"]) {
        [self.priorityBttn setBackgroundColor:UIColor.redColor];
        [self.priorityBttn setTitle:@"high" forState:UIControlStateNormal];
    } else {
        [self.priorityBttn setBackgroundColor:UIColor.whiteColor];
        [self.priorityBttn setTitle:@"set priority" forState:UIControlStateNormal];
    }
}

#pragma mark - vary Buttons' methods check which button's tapped

- (void)willVaryForTitle:(id)sender {
    [self setSelectedTitleBttn:YES];
    [self performSegueWithIdentifier:@"sortId" sender:self];
}

- (void)willVaryForDate:(id)sender {
    [self setSelectedDateBttn:YES];
    [self performSegueWithIdentifier:@"sortId" sender:self];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    DetailViewController *detailVC = [segue destinationViewController];
    if(self.isSelectedTitleBttn) {
        [detailVC setSelectedTitleBttn:YES];
    } else if(self.isSelectedDateBttn) {
        [detailVC setSelectedDateBttn:YES];
    }
    
    //check
    if(self.isSelectedTitleBttn && self.isSelectedDateBttn) {
        NSAssert(errno, @"ERROR 2 BUTTONS WITH YES STATEMENT");
    }
    
    // pass data to DetailVC - then take each one to make a query according to propertie's value
    [detailVC setTitleText:self.taskTitle.text];
    [detailVC setDateText:self.taskDate.text];
    [detailVC setDescriptionText:self.taskDescription.text];
}


#pragma mark - call back after popping DetailVC

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self setSelectedTitleBttn:NO];
    [self setSelectedDateBttn:NO];
}


@end
