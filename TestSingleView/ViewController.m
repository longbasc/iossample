//
//  ViewController.m
//  TestSingleView
//
//  Created by admin on 6/10/16.
//  Copyright © 2016 admin. All rights reserved.
//

#import "ViewController.h"
#import "Globals.h"
#import "ContainerViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)touchUpBtLogin:(id)sender {
    
    //NSString *RememberMe = [[NSUserDefaults standardUserDefaults] stringForKey:@"RememberMe"];
    
    self.Cst_Bt2Bt1.constant = 0;
    
    [self.BtLogin setTitle:@"Sign In" forState:UIControlStateNormal];
    //get product list
    NSString *api_url =  @"test_post.php";
    NSString *postString = [NSString stringWithFormat:@"Username=%@&Password=%@"  ,@"longnguyen",@"password"];
    
    [self showWaitingIcon];
    Globals* globals = [[Globals sharedInstance]init];//[[Globals alloc] init];
    globals.delegate = self;
    [globals doHTTPPostWithURL:api_url  postString:postString markData:@"TEST_FUNC" onDone:nil onError:nil];
    
}

//==========================================================================
- (void)doHTPPostSuccessWithMarkData:(id)markData Data:(NSData*)data{
    [super doHTPPostSuccessWithMarkData:markData Data:data];
    
    NSString* callerCode = (NSString*)markData;
    
    if([callerCode isEqualToString:@"TEST_FUNC"])
    {
        
        //only store raw data, when select store then extract right data
        //NSArray* ResultData
        NSDictionary* ResultData = [NSJSONSerialization JSONObjectWithData:data
                                                                   options:0
                                                                     error:NULL];
        
        int status = [[ResultData objectForKey:@"status"] intValue];
        
        if(status != 200){
            
            
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Warning"
                                                            message:@"Could not connect internet or wrong username and password"
                                                           delegate:self
                                                  cancelButtonTitle:@"OK"
                                                  otherButtonTitles:@"Say Hello",nil];
            alert.tag = 100;
            [alert show];
            
            
        }else{
            
            //[[NSUserDefaults standardUserDefaults] setValue:@"true" forKey:@"RememberMe"];
            //[[NSUserDefaults standardUserDefaults] synchronize];
            
            //GL_MV_Customer.hadStripeID = true;
            UIStoryboard * storyboard = self.storyboard;
            ContainerViewController * nextpage = [storyboard instantiateViewControllerWithIdentifier: @ "ContainerViewController"];
            [self.navigationController pushViewController: nextpage animated: YES];
            
        }
    
        
        
        
    }
}

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex {
    
    if(alertView.tag != 100) return;
    
    if (buttonIndex == 0) {
        NSLog(@"OK Tapped.");
    }
    else if (buttonIndex == 1) {
        NSLog(@"Hello Tapped. Hello World!");
    }
}

@end
