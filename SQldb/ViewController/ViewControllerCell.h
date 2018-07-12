//
//  DetailTVCell.h
//  SQldb
//
//  Created by User on 7/10/18.
//  Copyright © 2018 BNR. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewControllerCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *highPtiorLbl;
@property (weak, nonatomic) IBOutlet UILabel *titleLbl;
@property (weak, nonatomic) IBOutlet UILabel *dateLbl;

- (void)setUpPriorityBttn:(NSArray *)dataSource columnName:(NSArray *)columnName indexPath:(NSIndexPath *)indexPath;
@end
