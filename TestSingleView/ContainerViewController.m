//
//  ContainerViewController.m
//  TestSingleView
//
//  Created by admin on 6/14/16.
//  Copyright © 2016 admin. All rights reserved.
//

#import "ContainerViewController.h"
#import "CommonChildView.h"
#import "ChildView1.h"
#import "ChildView2.h"

#define MAX_PHONE_HEIGHT 736 //height of iPhone 6 plus


@interface ContainerViewController ()

@end

@implementation ContainerViewController

CommonChildView*  _leftMenu = nil;
int _scrollPos = 0;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.myContentViews = [[NSMutableArray alloc] init];
    
    
    [self.containerScrollView setUserInteractionEnabled:YES];
    
    UISwipeGestureRecognizer *swipeLeft = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipe:)];
    UISwipeGestureRecognizer *swipeRight = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipe:)];
    
    UISwipeGestureRecognizer *swipeUp = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipe:)];
    UISwipeGestureRecognizer *swipeDown = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipe:)];
    
    
    
    
    // Setting the swipe direction.
    [swipeLeft setDirection:UISwipeGestureRecognizerDirectionLeft];
    [swipeRight setDirection:UISwipeGestureRecognizerDirectionRight];
    
    [swipeUp setDirection:UISwipeGestureRecognizerDirectionUp];
    [swipeDown setDirection:UISwipeGestureRecognizerDirectionDown];
    
    
    // Adding the swipe gesture on image view
    [self.containerScrollView addGestureRecognizer:swipeLeft];
    [self.containerScrollView addGestureRecognizer:swipeRight];
    [self.containerScrollView addGestureRecognizer:swipeUp];
    [self.containerScrollView addGestureRecognizer:swipeDown];
    
    [self.containerScrollView setScrollEnabled:true];
    [self.containerScrollView showsVerticalScrollIndicator];
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/



//==================================================================================================================
- (void)handleSwipe:(UISwipeGestureRecognizer *)swipe {
    
    
    if (swipe.direction == UISwipeGestureRecognizerDirectionLeft) {
         //NSLog(@"Left Swipe");
        if(_leftMenu!=nil){
            [self hideLeftMenu];
        }
       
    }
    
    else if (swipe.direction == UISwipeGestureRecognizerDirectionRight) {
        //NSLog(@"Right Swipe");
         [self showLeftMenu];
    }
    else if (swipe.direction == UISwipeGestureRecognizerDirectionUp) {
        
        if(_scrollPos>= MAX_PHONE_HEIGHT) return;
            
        _scrollPos += 100;
        
        [UIScrollView beginAnimations:@"scrollAnimation" context:nil];
        [UIScrollView setAnimationDuration:0.4f];
        [self.containerScrollView setContentOffset:CGPointMake(0, _scrollPos)];
        [UIScrollView commitAnimations];
        
        
    }
    else if (swipe.direction == UISwipeGestureRecognizerDirectionDown) {
        
        if(_scrollPos<=0){
           _scrollPos = 0;
         return;
        }
        
        _scrollPos -= 100;
        
        [UIScrollView beginAnimations:@"scrollAnimation" context:nil];
        [UIScrollView setAnimationDuration:0.1f];
        [self.containerScrollView setContentOffset:CGPointMake(0, _scrollPos)];
        [UIScrollView commitAnimations];
        
    }
    
    
}



//=======================================================
- (IBAction)touchUpBtHeader:(id)sender {
    [self addChildViewWithNibName:@"ChildView1"];
   
    
}

//=======================================================
- (IBAction)touchUpBtSignout:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

//=======================================================
- (IBAction)touchUpBtFooter:(id)sender {
    
    [self addChildViewWithNibName:@"ChildView2"];
}


//=======================================================

-(void) addChildViewWithNibName:(NSString*) nibName{
    
    _scrollPos = 0;
    CommonChildView *av;
    
    if (av == nil)
    {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:nibName owner:self options:nil];
        av = [nib objectAtIndex:0];
        //av.delegate = self;
        //av.Txt_Content.text = @"My View 1";
        
    }
    
    
    av.delegate = self;
    [self.containerScrollView addSubview:av];
    [self.myContentViews addObject:av];
    [av setDefaultValue];
    //av.userInteractionEnabled = true;
    
    [av setFrame:CGRectMake( self.containerScrollView.frame.size.width , 0, self.containerScrollView.frame.size.width  ,  MAX_PHONE_HEIGHT )]; //notice this is OFF screen!
    
    [UIView beginAnimations:@"animateAddChildView" context:nil];
    [UIView setAnimationDuration:0.4];
    
    [av setFrame:CGRectMake( 0 , 0, self.containerScrollView.frame.size.width  ,  MAX_PHONE_HEIGHT )]; //notice this is OFF screen!
    //notice this is ON screen!
    
    
    [UIView commitAnimations];

}

//==========================
UIView* _animatedView = nil;
-(bool) popChildViewToIndex: (int)index{
    
    _scrollPos = 0;
    
    NSArray*  viewArr =  self.myContentViews;
    if(index==-1){
        if([viewArr count]>0){
            UIView* av = viewArr[[viewArr count]-1];
            
            [av setFrame:CGRectMake( 0 , 0, self.containerScrollView.frame.size.width  , self.containerScrollView.frame.size.height  )]; //notice this is OFF screen!
            
            _animatedView = av;
            [UIView beginAnimations:@"animatePopChildView" context:nil];
            [UIView setAnimationDelegate: self]; //or some other object that has necessary method
            [UIView setAnimationDidStopSelector: @selector(animationDidStop:finished:context:)];
            [UIView setAnimationDuration:0.4];
            
            [av setFrame:CGRectMake( self.containerScrollView.frame.size.width , 0, self.containerScrollView.frame.size.width  , self.containerScrollView.frame.size.height  )]; //notice this is OFF screen!
            //notice this is ON screen!
             [UIView commitAnimations];
            
            
            
            
            return true;
        }
    }
    else{
        if(index<viewArr.count){
            for(long i=viewArr.count-1;i>=0;i--){
                if(i<=index) break;
                
                UIView* av = viewArr[i];
                [av removeFromSuperview];
                [self.myContentViews removeObject:av];
                
                
            }
        }
    }
    
    return false;
}

//==========================
-(void)animationDidStop:(NSString *)animationID finished:(NSNumber *)finished context:(void *)context {
    //do smth
    if([animationID isEqualToString:@"animatePopChildView"]){
        [_animatedView removeFromSuperview];
        [self.myContentViews removeObject:_animatedView];
        _animatedView = nil;
    }else if([animationID isEqualToString:@"animateHideLeftMenu"]){
        if(_leftMenu != nil){
            [_leftMenu removeFromSuperview];
            _leftMenu = nil;
        }
        
    }
}

//==========================
- (IBAction)touchUpBtBack:(id)sender {
    [self popChildViewToIndex:-1];
    
}



//==========================
- (IBAction)touchUpBtLeftMenu:(id)sender {
    [self showLeftMenu];
    
}


//==========================
-(void)selectMenuAtIndex:(NSIndexPath*)indexPath{
    [self hideLeftMenu];
}

//==========================
-(void)touchCloseLeftMenu{
    [self hideLeftMenu];
}



//==========================
- (void) showLeftMenu{
    CommonChildView *av;
    
    if (av == nil)
    {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"LeftMenuView" owner:self options:nil];
        av = [nib objectAtIndex:0];
        //av.delegate = self;
        //av.Txt_Content.text = @"My View 1";
        
    }
    
    
    av.delegate = self;
    [self.view addSubview:av];
    [av setDefaultValue];
    //av.userInteractionEnabled = true;
    
    [av setFrame:CGRectMake( -self.view.frame.size.width , 20, self.view.frame.size.width  -100 , self.view.frame.size.height - 20 )]; //notice this is OFF screen!
    
    [UIView beginAnimations:@"animateAddChildView" context:nil];
    [UIView setAnimationDuration:0.4];
    
    [av setFrame:CGRectMake( 0 , 20, self.view.frame.size.width - 100 , self.view.frame.size.height -20 )]; //notice this is OFF screen!
    //notice this is ON screen!
    
    
    [UIView commitAnimations];
    _leftMenu = av;

}

//==========================
- (void) hideLeftMenu{
    
    if(_leftMenu == nil) return;
    
    [_leftMenu setFrame:CGRectMake( 0 , 20, self.view.frame.size.width - 100 , self.view.frame.size.height -20 )]; //notice this is OFF screen!
    
    _animatedView = _leftMenu;
    [UIView beginAnimations:@"animateHideLeftMenu" context:nil];
    [UIView setAnimationDelegate: self]; //or some other object that has necessary method
    [UIView setAnimationDidStopSelector: @selector(animationDidStop:finished:context:)];
    [UIView setAnimationDuration:0.4];
    
   [_leftMenu setFrame:CGRectMake( -self.view.frame.size.width , 20, self.view.frame.size.width  -100 , self.view.frame.size.height - 20 )]; //notice this is OFF screen!
    //notice this is ON screen!
    [UIView commitAnimations];

    
}

//============================
-(void)wantCloseChildView{
    [self popChildViewToIndex:-1];
    
}



@end
