//
//  ViewController.m
//  SQldb
//
//  Created by User on 7/10/18.
//  Copyright © 2018 BNR. All rights reserved.
//

#import "ViewController.h"
#import "MyFirstDBManager.h"

static NSString * const myCellId = @"idCellTask";

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) MyFirstDBManager *dbManager;
@property (strong, nonatomic) NSArray *tasksArr;
@property (assign, nonatomic) int idToEdit;

- (IBAction)massDelete:(id)sender;
- (IBAction)addNewTask:(id)sender;
- (void)loadData;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    NSString *dbFileName = @"myTasks.db";
    [self setDbManager:[[MyFirstDBManager alloc] initWithDataBaseFileName:dbFileName]];
    
    [[self tableView] setDataSource:self];
    [[self tableView] setDelegate:self];
    
    [self loadData];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.tasksArr count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ViewControllerCell *cell = [tableView dequeueReusableCellWithIdentifier:myCellId forIndexPath:indexPath];
    
    NSArray *columnNames = self.dbManager.arrColumnNames;
    NSInteger indexOfTitle = [columnNames indexOfObject:@"title"];
    NSInteger indexOfDate = [columnNames indexOfObject:@"date"];
    
    NSString *labelText = [NSString stringWithFormat:@"%@", [self.tasksArr objectAtIndex:indexPath.row][indexOfTitle]];
    NSString *subtitleText = [NSString stringWithFormat:@"Date %@", [self.tasksArr objectAtIndex:indexPath.row][indexOfDate]];
    
    cell.titleLbl.text = labelText;
    cell.dateLbl.text = subtitleText;
    [cell setUpPriorityBttn:self.tasksArr columnName:self.dbManager.arrColumnNames indexPath:indexPath];
    return cell;
}


- (void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath {
    self.idToEdit = [[[self.tasksArr objectAtIndex:indexPath.row] objectAtIndex:0] intValue];
    [self performSegueWithIdentifier:@"idSegueEditInfo" sender:self];
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if(editingStyle == UITableViewCellEditingStyleDelete) {
        int taskId = [NSNumber numberWithUnsignedInteger:[[self.dbManager arrColumnNames] indexOfObject:@"taskID"]].intValue;
        int taskIdToDELETE = [[[self.tasksArr objectAtIndex:indexPath.row] objectAtIndex:taskId] intValue];
        NSLog(@"%d", taskIdToDELETE);
        NSString *query = [NSString stringWithFormat:@"delete from myTasks where taskID=%d", taskIdToDELETE];
        [self.dbManager executeQuery:query];
        
        //reload tableView
        [self loadData];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 60;
}



- (void)loadData {
    NSString *query = @"select * from myTasks";;
    
    if(self.tasksArr != nil) {
        self.tasksArr = nil;
    }
    [self setTasksArr:[[NSArray alloc] initWithArray:[self.dbManager loadDatatFromDB:query]]];
    [[self tableView] reloadData];
    NSLog(@"%@", self.tasksArr);
    NSLog(@"%lu", [self.tasksArr count]);
}


- (IBAction)massDelete:(id)sender {
    NSString *deleteQuery = [NSString stringWithFormat:@"delete from myTasks"];
    NSString *fetchQuery = [NSString stringWithFormat:@"select * from myTasks"];
    if([self.tasksArr count] != 0) {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Delete All Tasks" message:@"All tips will be removed from you store" preferredStyle:UIAlertControllerStyleActionSheet];
    [alert addAction:[UIAlertAction actionWithTitle:@"Delete All Tasks" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * action) {
        [self.dbManager executeQuery:deleteQuery];
        NSArray *result = [self.dbManager loadDatatFromDB:fetchQuery];
        [self setTasksArr:result];
        [self.tableView reloadData];
        }]];
        [alert addAction:[UIAlertAction actionWithTitle:@"Cencel" style:UIAlertActionStyleCancel handler:nil]];
        
        UIPopoverPresentationController *popoverController = alert.popoverPresentationController;
        [popoverController setSourceView:self.view];
        [popoverController setSourceRect:self.view.frame];
        [self presentViewController:alert animated:YES completion:nil];
    }
    NSLog(@"delete!!!");
}

- (IBAction)addNewTask:(id)sender {
    //indicate that we are going to create a new task
    [self setIdToEdit:-1];
    NSLog(@"%d", self.idToEdit);
    NSString *identifite = @"idSegueEditInfo";
    [self performSegueWithIdentifier:identifite sender:self];
}

- (void)editingInfoWasFinishedWithIDofNewElement {
    [self loadData];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    EditInfoViewController *editInfoVC = [segue destinationViewController];
    [editInfoVC setDelegate:self];
    [editInfoVC setIdToEdit:self.idToEdit];
}


@end

