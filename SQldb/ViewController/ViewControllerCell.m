//
//  DetailTVCell.m
//  SQldb
//
//  Created by User on 7/10/18.
//  Copyright © 2018 BNR. All rights reserved.
//

#import "ViewControllerCell.h"

@implementation ViewControllerCell

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

- (void)setUpPriorityBttn:(NSArray *)dataSource columnName:(NSArray *)columnName indexPath:(NSIndexPath *)indexPath {
    NSInteger indexOfPriority = [columnName indexOfObject:@"priority"];
    NSString *priorityText = [NSString stringWithFormat:@"%@", [dataSource objectAtIndex:indexPath.row][indexOfPriority]];
    
    if([priorityText isEqualToString:@"high"]) {
        [self configurePriorityBttn:@"high"];
    } else {
        self.highPtiorLbl.text = @"";
        [self.highPtiorLbl setBackgroundColor:UIColor.clearColor];
    }
}

- (void)configurePriorityBttn:(NSString *)text {
    self.highPtiorLbl.text = text;
    [self.highPtiorLbl.layer setBackgroundColor:UIColor.redColor.CGColor];
    [self.highPtiorLbl.layer setBorderWidth:1];
    [self.highPtiorLbl.layer setCornerRadius:10];
    [self.highPtiorLbl.layer setBorderColor:UIColor.clearColor.CGColor];
    [self.highPtiorLbl setTextColor:UIColor.whiteColor];
}

@end
