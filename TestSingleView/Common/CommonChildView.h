//
//  CommonChildView.h
//  TestSingleView
//
//  Created by admin on 6/14/16.
//  Copyright © 2016 admin. All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol ChildViewDelegate <UITextFieldDelegate>
-(void)wantCloseChildView;
@end

@interface CommonChildView : UIView


@property (assign,nonatomic) id delegate;
- (void) setDefaultValue;
-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string;

@property (assign,nonatomic) UITextField* focusTextField;
@end


