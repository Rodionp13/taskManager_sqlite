								//
//  EditInfoViewController.m
//  SQLiteFIrstSample
//
//  Created by Radzivon Uhrynovich on 7/9/18.
//  Copyright © 2018 BNR. All rights reserved.
//

#import "EditInfoViewController.h"
#import "MyFirstDBManager.h"

//static NSString * dbName = @"MYTasks.db";

@interface EditInfoViewController ()

@property (weak, nonatomic) IBOutlet UITextField *taskTitle;
@property (weak, nonatomic) IBOutlet UITextField *taskDate;
@property (weak, nonatomic) IBOutlet UITextView *taskDescription;
@property (weak, nonatomic) IBOutlet UITextField *priority;

@property (strong, nonatomic) MyFirstDBManager *dbManager;


- (IBAction)saveInfo:(id)sender;
- (void)loadInfoToEdit;
@end

@implementation EditInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.taskTitle setDelegate:self];
    [self.taskDate setDelegate:self];
    [self.taskDescription setDelegate:self];
    
    NSString *dbFileName = @"myTasks.db";
    [self setDbManager:[[MyFirstDBManager alloc] initWithDataBaseFileName:dbFileName]];
    
    if(self.idToEdit != -1) {
        [self loadInfoToEdit];
    }
    
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}
- (BOOL)textViewShouldEndEditing:(UITextView *)textView {
    [textView resignFirstResponder];
    return YES;
}

- (void)saveInfo:(id)sender {
    NSString *query;
    if(self.idToEdit == -1) {
        query = [NSString stringWithFormat:@"insert into myTasks values(null, '%@', '%@', '%@', '%@')", self.taskTitle.text, self.taskDate.text, self.priority.text, self.taskDescription.text];
    } else {
        query = [NSString stringWithFormat:@"update myTasks set title='%@', date='%@', priority='%@', description='%@' where taskID=%d", self.taskTitle.text, self.taskDate.text, self.priority.text,self.taskDescription.text,self.idToEdit];
    }
    
    [self.dbManager executeQuery:query];
    
    if([self.dbManager affectedRows] != 0) {
        NSLog(@"Query was executed! Number of Affected rows:%d", [self.dbManager affectedRows]);
        [self.delegate editingInfoWasFinished];
        [self.navigationController popViewControllerAnimated:YES];
    } else {
        NSLog(@"Couldn't execute query");
        
    }
}

-(void)loadInfoToEdit{
    // Create the query.
    NSString *query = [NSString stringWithFormat:@"select * from myTasks where taskID=%d", self.idToEdit];
    
    // Load the relevant data.
    NSArray *results = [[NSArray alloc] initWithArray:[self.dbManager loadDatatFromDB:query]];
    
    // Set the loaded data to the textfields.
    self.taskTitle.text = [[results objectAtIndex:0] objectAtIndex:[self.dbManager.arrColumnNames indexOfObject:@"title"]];
    self.taskDate.text = [[results objectAtIndex:0] objectAtIndex:[self.dbManager.arrColumnNames indexOfObject:@"date"]];
    self.taskDescription.text = [[results objectAtIndex:0] objectAtIndex:[self.dbManager.arrColumnNames indexOfObject:@"description"]];
    self.priority.text = [[results objectAtIndex:0] objectAtIndex:[[self.dbManager arrColumnNames] indexOfObject:@"priority"]];
}





@end
