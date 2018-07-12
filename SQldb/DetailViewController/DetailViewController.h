//
//  DetailViewController.h
//  SQldb
//
//  Created by User on 7/10/18.
//  Copyright © 2018 BNR. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol DetailViewControllerDelegate
- (void) goBackToEditVCAndResetButtonsBOOLProperties;
@end

@interface DetailViewController : UIViewController <UITableViewDataSource ,UITableViewDelegate>
@property(assign, nonatomic, getter=isSelectedTitleBttn) BOOL selectedTitleBttn;
@property(assign, nonatomic, getter=isSelectedDateBttn) BOOL selectedDateBttn;
@property(strong, nonatomic) NSString *titleText;
@property(strong, nonatomic) NSString *dateText;
@property(strong, nonatomic) NSString *descriptionText;

@property(weak, nonatomic) id<DetailViewControllerDelegate> delegate;

@end
