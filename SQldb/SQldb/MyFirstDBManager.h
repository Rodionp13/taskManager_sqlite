//
//  MyFirstDBManager.h
//  SQLiteFIrstSample
//
//  Created by User on 7/9/18.
//  Copyright © 2018 BNR. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MyFirstDBManager : NSObject
@property(nonatomic, strong) NSMutableArray *arrColumnNames;

@property(nonatomic) int affectedRows;

@property(nonatomic) long long lastInsertedRowID;

- (id) initWithDataBaseFileName:(NSString *)dbFileName;

- (NSArray *)loadDatatFromDB:(NSString *)query;

- (void)executeQuery:(NSString *)query;
@end
