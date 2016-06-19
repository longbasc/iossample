//
//  CommonChildView.m
//  TestSingleView
//
//  Created by admin on 6/14/16.
//  Copyright © 2016 admin. All rights reserved.
//

#import "CommonChildView.h"
#import "ContainerViewController.h"



@implementation CommonChildView


bool _keyBoardIsShown = false;
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void) setDefaultValue{
    UITapGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(viewTapped)];
    tapRecognizer.numberOfTapsRequired = 1;
    [self addGestureRecognizer:tapRecognizer];
    
    [self registerForKeyboardNotifications];
    
    
    for(UIView * subView in self.subviews ) // here write Name of you ScrollView.
    {
        // Here You can Get all subViews of your myScrollView.
        // But For Check subview is specific UIClass such like label, button, textFiled etc.. write following code (here checking for example UILabel class).
        
        if([subView isKindOfClass:[UITextField class]]) // Check is SubView Class Is UILabel class?
        {
            // You can write code here for your UILabel;
            ((UITextField*)subView).delegate = self;
            
            //toolbar for keyboard
            UIToolbar* toolBar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, 320, 44)];
            [toolBar setBackgroundColor:[UIColor lightGrayColor]];
            
            UIBarButtonItem* itmSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
            UIBarButtonItem* itm = [[UIBarButtonItem alloc] initWithTitle:@"Done" style:UIBarButtonItemStyleDone target:self action:@selector(onTouchBarItemDone:)];
            
            [toolBar setItems:@[itmSpace,itm]];
            
            
            ((UITextField*)subView).inputAccessoryView = toolBar;
            [((UITextField*)subView) setAutocorrectionType:UITextAutocorrectionTypeNo];
            
        }
    }

    

}


//=============================================================================================
- (void) onTouchBarItemDone:(id) sender
{
    //[self.Txt_Text1 resignFirstResponder];
     //[((UITextField*)sender) resignFirstResponder];
    
}



//=============================================================================================
- (void)registerForKeyboardNotifications {
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWasShown:)
                                                 name:UIKeyboardDidShowNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillBeHidden:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
    
}



//=============================================================================================
- (void)deregisterFromKeyboardNotifications {
    
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIKeyboardDidHideNotification
                                                  object:nil];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIKeyboardWillHideNotification
                                                  object:nil];
    
}



//=============================================================================================
CGPoint _scrollOriginPoint;
- (void)keyboardWasShown:(NSNotification *)notification {
    
    _keyBoardIsShown = true;
    
    if(_focusTextField ==nil) return;
    
    UIView* totalView = ((ContainerViewController*)self.delegate).view;
    UIScrollView* contentView = ((ContainerViewController*)self.delegate).containerScrollView;
    
    NSDictionary* info = [notification userInfo];
    CGSize keyboardSize = [[info objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
    _scrollOriginPoint = totalView.frame.origin;
    
    CGPoint txtFocusPoint = _focusTextField.frame.origin;
    
    //CGFloat txtCommentHeight = self.Txt_Comment.frame.size.height;
    CGRect visibleRect = totalView.frame;
    visibleRect.size.height -= keyboardSize.height + 30;
    
    if (!CGRectContainsPoint(visibleRect, txtFocusPoint)){
        
        CGPoint scrollNewPoint = CGPointMake(0.0, keyboardSize.height - _scrollOriginPoint.y );
        [contentView setContentOffset:scrollNewPoint animated:YES];
        //[self.view setContentOffset:scrollPoint animated:YES];
        
    }
    
}



//=============================================================================================
- (void)keyboardWillBeHidden:(NSNotification *)notification {
    
    _keyBoardIsShown = false;
    
    UIScrollView* contentView = ((ContainerViewController*)self.delegate).containerScrollView;
    //CGPoint scrollNewPoint = CGPointMake(_scrollOriginPoint.x, _scrollOriginPoint.y  );
    CGPoint scrollNewPoint = CGPointMake(0, 0  );
    [contentView  setContentOffset:scrollNewPoint animated:YES];
    
}


//================================================================================================
- (void) viewTapped {
    //[self.Txt_Text1 resignFirstResponder];
    if(!_keyBoardIsShown) return;
    
    for(UIView * subView in self.subviews ) // here write Name of you ScrollView.
    {
        // Here You can Get all subViews of your myScrollView.
        // But For Check subview is specific UIClass such like label, button, textFiled etc.. write following code (here checking for example UILabel class).
        
        if([subView isKindOfClass:[UITextField class]]) // Check is SubView Class Is UILabel class?
        {
            // You can write code here for your UILabel;
            [(UITextField*)subView resignFirstResponder];
        }
    }
}


//================================================================================================
-(BOOL) textFieldShouldReturn:(UITextField *)textField{
    
     [textField resignFirstResponder];
    return YES;
}


//=============================================================================================
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    BOOL editable = true;
    _focusTextField  = textField;
    return editable;
}

//=============================================================================================

- (BOOL)textFieldShouldEndEditing:(UITextField *)textField {
    BOOL editable =  true;
   _focusTextField  = nil;
    return editable;
}



//================================================================================================
-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    
    
    return YES;
    /*
    // Always allow a backspace
    if ([string isEqualToString:@""]) {
        return YES;
    }
    
    
    BOOL allowChars = NO;
    //  limit to only numeric characters
    NSCharacterSet *myCharSet = [NSCharacterSet characterSetWithCharactersInString:@"0123456789"];
    
    for (int i = 0; i < [string length]; i++) {
        unichar c = [string characterAtIndex:i];
        if ([myCharSet characterIsMember:c]) {
            //return YES;
            allowChars = YES;
        }
    }
    
    
    NSString* sNewText =  [NSString stringWithFormat:@"%@%@",textField.text,string];
    
    if (  [sNewText isEqualToString:@"0"]   ){
        return NO;
    }
    
    
    
    
    return allowChars;
     */
    
}



@end
