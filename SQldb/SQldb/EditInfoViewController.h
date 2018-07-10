//
//  EditInfoViewController.h
//  SQLiteFIrstSample
//
//  Created by Radzivon Uhrynovich on 7/9/18.
//  Copyright © 2018 BNR. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol EditInfoViewControllerDelegate
- (void) editingInfoWasFinished;
@end

@interface EditInfoViewController : UIViewController <UITextFieldDelegate, UITextViewDelegate>
@property (weak, nonatomic) id<EditInfoViewControllerDelegate> delegate;
@property (assign, nonatomic) int idToEdit;

@end
