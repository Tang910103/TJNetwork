//
//  ViewController.m
//  TJNetworkManager
//  Created by Tang杰 on 2019/3/8.
//  Copyright © 2019 Tang杰. All rights reserved.
//

#import "TJRequestTestController.h"
#import "TJNetwork.h"
#import <objc/runtime.h>
#import <objc/message.h>
#import "DetailViewController.h"


@interface TJRequestTestController ()<UITableViewDelegate,UITableViewDataSource,TJNetworkDelegate>
{
//    NSMutableArray *_myTestMethods;
//    NSString *_selectedMethodName;
//    TJRequest *_currentRequest;
}
@property (nonatomic, strong) UITableView *tableView;

@end

@implementation TJRequestTestController


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.navigationItem.title = NSStringFromClass(self.class);
}

- (void)injected
{
    
    
    
}


//
//- (void)viewDidDisappear:(BOOL)animated
//{
//    [super viewDidDisappear:animated];
//    _selectedMethodName = nil;
//}
//
//- (void)testGet {
//    _currentRequest = TJRequest.get(@"get", nil)
//    .jsonResponse(self.requestComplete);
//}
//
//- (void)testPost {
//    _currentRequest = TJRequest.post(@"post", nil)
//    .requestWillStop(^(TJRequest *request) {
//        NSLog(@"-=-=-=-=-=-==-=-=-=-");
//    }).jsonResponse(self.requestComplete);
//}
//- (void)testCacheResult {
//    _currentRequest = TJRequest.get(@"get", nil)
//    .jsonResponse(self.requestComplete)
//    .readCache(^(TJRequest *r){
//        NSLog(@"%@",r.jsonResult);
//        return YES;
//    });
//}
//
//- (void)testDelete {
//    _currentRequest = TJRequest.delet(@"delete", nil)
//    .jsonResponse(self.requestComplete).readCache(^(TJRequest *r){
//        return YES;
//    });
//}
//
//- (void)testTimerout {
//    _currentRequest = TJRequest.request(^(TJRequest *re) {
//        re.requestMethod = TJRequestMethodGET;
//        re.timeoutInterval = 1;
//        re.url = @"get";
//    }).dataResponse(self.requestComplete);
//    [NSThread sleepForTimeInterval:1];
//}
//
//
//- (void)testDownload {
//    NSString *filePath = @"/Users/tangjie/Downloads/001";
//    if ([[NSFileManager defaultManager] fileExistsAtPath:filePath]) {
//        [[NSFileManager defaultManager] removeItemAtPath:filePath error:nil];
//    }
//    
////    _currentRequest = TJRequest.download(@"http://wind4app-bdys.oss-cn-hangzhou.aliyuncs.com/CMD_MarkDown.zip", nil,@{@"kkk":@"999"}, ^NSURL *(NSURL *targetPath, NSURLResponse *response) {
////        return [NSURL fileURLWithPath:[filePath stringByAppendingPathExtension:response.suggestedFilename.pathExtension] isDirectory:NO];
////    })
////    .jsonResponse(self.requestComplete);
//}
//
//- (void(^)(TJRequest *))requestComplete {
//    return ^(TJRequest *request){
//        if (request.error) {
//            NSLog(@"\n请求失败：%s\n%@",__FUNCTION__,request.error);
//        } else {
//            NSLog(@"\n请求成功：%s\n%@",__FUNCTION__,request.result);
//        }
//    };
//}
//
//#pragma mark --------------- TJNetworkDelegate
//
//- (void)requestWillStart:(TJRequest *)request
//{
//    NSURL *baseURL = [NSURL URLWithString:@"https://httpbin.org/"];
//    request.url = [TJNetworkTools URLWithString:request.url relativeToURL:baseURL];
//    NSLog(@"请求即将开始");
//}
//
//- (void)requestWillStop:(TJRequest *)request
//{
//    NSLog(@"请求即将结束");
//}
//#pragma mark - UITableViewDelegate
//- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    [tableView deselectRowAtIndexPath:indexPath animated:YES];
//    _selectedMethodName = _myTestMethods[indexPath.row];
//    ((void (*)(id, SEL))objc_msgSend)(self, NSSelectorFromString(_selectedMethodName));
//    DetailViewController *vc = [[DetailViewController alloc] init];
//    vc.request = _currentRequest;
//    vc.title = self->_selectedMethodName;
//    [self.navigationController pushViewController:vc animated:YES];
//    self.navigationItem.rightBarButtonItem = nil;
//    NSLog(@"当前线程---%@",[NSThread currentThread]);
//}
//#pragma mark - UITableViewDataSource
//- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
//{
//    return _myTestMethods.count;
//}
//- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
//    cell.selectionStyle = UITableViewCellSelectionStyleNone;
//    cell.textLabel.text = _myTestMethods[indexPath.row];
//    
//    return cell;
//}

@end

