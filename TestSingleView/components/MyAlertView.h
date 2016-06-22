//
//  MyAlertView.h
//  TestSingleView
//
//  Created by Lisa on 6/22/16.
//  Copyright © 2016 admin. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol MyAlertViewDelegate
-(void)onTouchMyAlertViewOK;
-(void)onTouchMyAlertViewCancel;
@end

@interface MyAlertView : UIView
@property (assign,nonatomic) id delegate;
- (void) setDefaultValue;

@end
