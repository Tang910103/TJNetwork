//
//  ViewController.m
//  XCNetworking
//  Created by Tang杰 on 2019/3/21.
//  Copyright © 2019 Tang杰. All rights reserved.
//

#import "ViewController.h"
#import "XCBaseRequestTestController.h"
#import "XCRequestTestController.h"
#import "XCNetwork.h"

@interface ViewController ()<XCNetworkDelegate>
@property (weak, nonatomic) IBOutlet UIButton *button1;
@property (weak, nonatomic) IBOutlet UIButton *button2;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self networkConfig];
    
    [self.button1 setTitle:NSStringFromClass([XCBaseRequestTestController class]) forState:UIControlStateNormal];
    
    [self.button2 setTitle:NSStringFromClass([XCRequestTestController class]) forState:UIControlStateNormal];
}

- (void)networkConfig {
    [[XCNetworkConfig shareObject] setDelegate:self];
    [[XCNetworkConfig shareObject] setResponseSerializer:XCJSONResponseSerializer];
}


#pragma mark --------------- XCNetworkDelegate

- (void)requestWillStart:(XCBaseRequest *)request
{
    NSURL *baseURL = [NSURL URLWithString:@"https://httpbin.org/"];
    request.url = [XCNetworkTools URLWithString:request.url relativeToURL:baseURL];
    NSLog(@"请求即将开始");
}

- (void)requestWillStop:(XCBaseRequest *)request
{
    NSLog(@"请求即将结束");
}

- (IBAction)clickButton:(UIButton *)sender {
    [self.navigationController pushViewController:[NSClassFromString(sender.currentTitle) new] animated:YES];
}


@end
