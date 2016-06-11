//
//  CommonViewController.h
//  
//
//  Created by admin on 6/10/16.
//
//

#import <UIKit/UIKit.h>
#import "Globals.h"

@interface CommonViewController : UIViewController <MyGlobalDelegate>

- (void)showWaitingIcon;
- (void)hideWaitingIcon;

@property (nonatomic) UIView* backgroudView;
@property (nonatomic) UIView* waitingView;



@end
