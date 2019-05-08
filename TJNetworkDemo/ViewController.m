//
//  ViewController.m
//  TJNetworking
//  Created by Tang杰 on 2019/3/21.
//  Copyright © 2019 Tang杰. All rights reserved.
//

#import "ViewController.h"
#import "TJBaseRequestTestController.h"
#import "TJRequestTestController.h"
#import "TJNetwork.h"

@interface ViewController ()<TJNetworkDelegate>
@property (weak, nonatomic) IBOutlet UIButton *button1;
@property (weak, nonatomic) IBOutlet UIButton *button2;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self networkConfig];
    
    [self.button1 setTitle:NSStringFromClass([TJBaseRequestTestController class]) forState:UIControlStateNormal];
    
    [self.button2 setTitle:NSStringFromClass([TJRequestTestController class]) forState:UIControlStateNormal];
}

- (void)networkConfig {
    [[TJNetworkConfig shareObject] setDelegate:self];
    [[TJNetworkConfig shareObject] setResponseSerializer:TJJSONResponseSerializer];
}


#pragma mark --------------- TJNetworkDelegate

- (BOOL)requestWillStart:(TJBaseRequest *)request
{
    NSURL *baseURL = [NSURL URLWithString:@"https://httpbin.org/"];
    request.url = [TJNetworkTools URLWithString:request.url relativeToURL:baseURL];

    NSLog(@"请求即将开始");
    return request.requestHeaders;
}

- (void)requestWillStop:(TJBaseRequest *)request
{
    NSLog(@"请求即将结束");
}

- (IBAction)clickButton:(UIButton *)sender {
    [self.navigationController pushViewController:[NSClassFromString(sender.currentTitle) new] animated:YES];
}


@end
