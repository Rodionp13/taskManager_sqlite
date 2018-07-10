//
//  ViewController.m
//  SQldb
//
//  Created by User on 7/10/18.
//  Copyright © 2018 BNR. All rights reserved.
//

#import "ViewController.h"
#import "MyFirstDBManager.h"

//static NSString * dbName = @"MYTasks.db";

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) MyFirstDBManager *dbManager;
@property (strong, nonatomic) NSArray *tasksArr;
@property (assign, nonatomic) int idToEdit;

- (void)loadData;
- (IBAction)addNewTask:(id)sender;
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
    NSString *cellID = @"idCellRecord";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID forIndexPath:indexPath];
    NSArray *columnNames = self.dbManager.arrColumnNames;
    NSInteger indexOfTitle = [columnNames indexOfObject:@"title"];
    NSInteger indexOfDate = [columnNames indexOfObject:@"date"];
    
    NSString *labelText = [NSString stringWithFormat:@"%@", [self.tasksArr objectAtIndex:indexPath.row][indexOfTitle]];
    NSString *subtitleText = [NSString stringWithFormat:@"Date %@", [self.tasksArr objectAtIndex:indexPath.row][indexOfDate]];
    cell.textLabel.text = labelText;
    cell.detailTextLabel.text = subtitleText;
//    UIButton *bttn = [UIButton buttonWithType:UIButtonTypeCustom];
//    [bttn setFrame:CGRectMake(0, 0, 50, 50)];
//    [bttn setCenter:cell.center];
//    [bttn setBackgroundColor:UIColor.redColor];
//    [bttn addTarget:self action:@selector(bttnTapped:) forControlEvents:UIControlEventTouchUpInside];
//    [cell addSubview:bttn];
    
    return cell;
}

//- (void)bttnTapped:(UIButton *)sender {
//    if([sender backgroundColor] == UIColor.redColor) {
//        [sender setBackgroundColor:UIColor.greenColor];
//        [sender setFrame:CGRectMake(sender.frame.origin.x, sender.frame.origin.y, 100, sender.frame.size.height)];
//    } else {
//        [sender setBackgroundColor:UIColor.redColor];
//        [sender setFrame:CGRectMake(0, 0, 50, 50)];
//    }
//}

- (void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath {
    self.idToEdit = [[[self.tasksArr objectAtIndex:indexPath.row] objectAtIndex:0] intValue];
    NSInteger num = self.idToEdit;
    [self performSegueWithIdentifier:@"idSegueEditInfo" sender:self];
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


- (IBAction)addNewTask:(id)sender {
    [self setIdToEdit:-1];
    NSLog(@"%d", self.idToEdit);
    NSString *identifite = @"idSegueEditInfo";
    [self performSegueWithIdentifier:identifite sender:self];
}

- (void)editingInfoWasFinished {
    [self loadData];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    EditInfoViewController *editInfoVC = [segue destinationViewController];
    NSInteger num = self.idToEdit;
    [editInfoVC setDelegate:self];
    [editInfoVC setIdToEdit:self.idToEdit];
}


@end

