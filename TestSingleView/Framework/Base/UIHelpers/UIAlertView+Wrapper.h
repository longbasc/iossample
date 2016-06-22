//
//  UIAlertView+Wrapper.h
//
//
//  Created by luongnguyen on 7/23/14.
//  Copyright (c) 2014 appiphany. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface UIAlertView (Wrapper)

#pragma mark STATIC
+ (void) showWithTitle:(NSString*)title andMsg:(NSString*)msg; //OK only

+ (void) showWithTitle:(NSString*)title andMsg:(NSString*)msg andOnOK:(void(^)(void))onOK;

+ (void) showWithTitle:(NSString*)title andMsg:(NSString*)msg andOnYes:(void(^)(void))onYes andOnNo:(void(^)(void))onNo;
+ (void) showWithTitle:(NSString*)title andMsg:(NSString*)msg andOnOK:(void(^)(void))onOK andOnCancel:(void(^)(void))onCancel;

+ (void) showWithTitle:(NSString*)title andMsg:(NSString*)msg buttons:(NSArray*)buttons onClickedButton:(void(^)(id))onClicked;

+ (UIAlertView*) getCurrentAlertView;
@end
