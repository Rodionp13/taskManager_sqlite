//
//  MyFirstDBManager.m
//  SQLiteFIrstSample
//
//  Created by User on 7/9/18.
//  Copyright © 2018 BNR. All rights reserved.
//

#import "MyFirstDBManager.h"
#import <sqlite3.h>


@interface MyFirstDBManager()
@property(nonatomic, strong) NSString *documentsDirectory;
@property(nonatomic, strong) NSString *databaseFilename;

@property(nonatomic, strong) NSMutableArray *arrResults;

- (void)copyDatabaseIntoDocumentsDirectory;
- (void)runQuery:(const char *)query isQueryExecutable:(BOOL)queryExecutable;
@end

@implementation MyFirstDBManager

- (id)initWithDataBaseFileName:(NSString *)dbFileName {
    self = [super init];
    
    if(self) {
        //set documents directory path to the documentsDirectory property
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        self.documentsDirectory = [paths objectAtIndex:0];
        
        //Keep the data base file name;
        _databaseFilename = dbFileName;
        
        //Copy the data base file into the documents directory if neccessary (custom method)
        [self copyDatabaseIntoDocumentsDirectory];
    }
    return self;
}

- (void)copyDatabaseIntoDocumentsDirectory {
    //Chek if db file exists in documents directory
    NSString *destination = [self.documentsDirectory stringByAppendingPathComponent:self.databaseFilename];
    if(![[NSFileManager defaultManager] fileExistsAtPath:destination]) {
        //DB copping
        NSString *sourcePath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:self.databaseFilename];
        NSError *error;
        [[NSFileManager defaultManager] copyItemAtPath:sourcePath toPath:destination error:&error];
        
        //Check if an error ucured and display it
        if(error != nil) {
            NSLog(@"%@",[error localizedDescription]);
        }
    }
}

- (void)runQuery:(const char *)query isQueryExecutable:(BOOL)queryExecutable {
    //Create SQLite object
    sqlite3 *sqlite3Database;

    //Set the db file path
    NSLog(@"%@", [self.documentsDirectory stringByAppendingPathComponent:self.databaseFilename]);
    NSString *databasePath = [self.documentsDirectory stringByAppendingPathComponent:self.databaseFilename];


    //init the results Array
    if(self.arrResults != nil) {
        [self.arrResults removeAllObjects];
        self.arrResults = nil;
    }
    self.arrResults = [NSMutableArray array];

    //init the columns Array
    if(self.arrColumnNames != nil) {
        [self.arrColumnNames removeAllObjects];
        self.arrColumnNames = nil;
    }
    self.arrColumnNames = [NSMutableArray array];

    //Open db
    BOOL openDatabaseResult = sqlite3_open([databasePath UTF8String], &sqlite3Database);
//    sqlite3_open(<#const char *filename#>, <#sqlite3 **ppDb#>)
    BOOL open_v2 = sqlite3_open_v2([databasePath UTF8String], &sqlite3Database, SQLITE_OPEN_READWRITE, NULL);
    if(open_v2 == SQLITE_OK) {
        //declare sql stmt object -> to store in it query after it compiled into sql statement
        sqlite3_stmt *compiledStatement;

    //Load all data from db to memory
    BOOL prepareStatementResult = sqlite3_prepare_v2(sqlite3Database, query, -1, &compiledStatement, NULL);
        if(prepareStatementResult == SQLITE_OK) {
            if(!queryExecutable) {
                //arr to keep each data row
                NSMutableArray *arrDataRow;

                //Loop through the results and add them to the result Array row by row
                while (sqlite3_step(compiledStatement) == SQLITE_ROW) {
                    arrDataRow = [NSMutableArray array];

                    int totalColums = sqlite3_column_count(compiledStatement);
                    for(int i = 0; i < totalColums; i++)
                    {
                        //Convert column data to text(characters)
                        char *dbDataAsChars = (char *)sqlite3_column_text(compiledStatement, i);

                        if(dbDataAsChars != NULL) {
                        [arrDataRow addObject:[NSString stringWithUTF8String:dbDataAsChars]];
                        }
                        //Keep the current column name
                        if(self.arrColumnNames.count != totalColums) {
                            dbDataAsChars = (char *)sqlite3_column_name(compiledStatement, i);
                            [self.arrColumnNames addObject:[NSString stringWithUTF8String:dbDataAsChars]];
                        }
                    }
                    if(arrDataRow.count > 0) {
                        [self.arrResults addObject:arrDataRow];
//                        NSLog(@"RESULT ARRAY:\n%@", self.arrResults);
                    }
                }
            }  else {
                //executable
                if(sqlite3_step(compiledStatement) == SQLITE_DONE) {
                    //keep affected fows and last inserted row's ID
                    self.affectedRows = sqlite3_changes(sqlite3Database);
                    self.lastInsertedRowID = sqlite3_last_insert_rowid(sqlite3Database);
                    NSLog(@"1.\n\naffected %d, inserted ID %lld\n\n", self.affectedRows, self.lastInsertedRowID);
                } else {
                    NSLog(@"2.Data Base error: %s", sqlite3_errmsg(sqlite3Database));
                }
            }
        } else {
            NSLog(@"3.%s", sqlite3_errmsg(sqlite3Database));
        }
        sqlite3_finalize(compiledStatement);
    }
    sqlite3_close(sqlite3Database);
}

- (NSArray *)loadDatatFromDB:(NSString *)query {
    //run non executable quary
    [self runQuery:[query UTF8String] isQueryExecutable:NO];
    
    return (NSArray *)self.arrResults;
}

- (void)executeQuery:(NSString *)query {
    [self runQuery:[query UTF8String] isQueryExecutable:YES];
}


@end
