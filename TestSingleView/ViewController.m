//
//  ViewController.m
//  TestSingleView
//
//  Created by admin on 6/10/16.
//  Copyright © 2016 admin. All rights reserved.
//

#import "ViewController.h"
#import "Globals.h"

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
    
    
    //get product list
    NSString *api_url =  @"gateway.php?controller=test.testfunc";
    NSString *postString = [NSString stringWithFormat:@"Param1=%d&Param2=%@",1,@"aaa"];
    
    [self showWaitingIcon];
    Globals* globals = [[Globals alloc] init];
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
        
        
    }
}


@end
