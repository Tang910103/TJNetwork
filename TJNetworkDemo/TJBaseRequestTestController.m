//
//  ViewController.m
//  TJNetworkManager
//  Created by Tang杰 on 2019/3/8.
//  Copyright © 2019 Tang杰. All rights reserved.
//

#import "TJBaseRequestTestController.h"
#import "TJNetwork.h"
#import <objc/message.h>
#import "DetailViewController.h"

NSMutableArray *getTestMethods(Class class)
{
    NSMutableArray *ar = @[].mutableCopy;
    unsigned int count;
    Method *methods = class_copyMethodList(class, &count);
    for (int i = 0; i < count; i++)
    {
        Method method = methods[i];
        SEL selector = method_getName(method);
        NSString *name =   NSStringFromSelector(selector);
        if ([name hasPrefix:@"test"]) {
            [ar addObject:name];
        }
    }
    free(methods);
    
    return ar;
}


@interface TJBaseRequestTestController ()<UITableViewDelegate,UITableViewDataSource>
{
    NSMutableArray *_myTestMethods;
    NSString *_selectedMethodName;
    TJBaseRequest *_currentRequest;
}
@property (nonatomic, strong) UITableView *tableView;

@end

@implementation TJBaseRequestTestController

- (UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.estimatedRowHeight = 45;
        _tableView.estimatedSectionHeaderHeight = 0;
        _tableView.estimatedSectionFooterHeight = 0;
        _tableView.tableFooterView = [[UIView alloc] init];
        if (@available(iOS 10.0, *)) {
            _tableView.refreshControl = [[UIRefreshControl alloc] init];
            [_tableView.refreshControl addTarget:self action:@selector(refresh) forControlEvents:UIControlEventValueChanged];
        } else {
            // Fallback on earlier versions
        }
        
        [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
    }
    return _tableView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.navigationItem.title = NSStringFromClass(self.class);
    
    [self.view addSubview:self.tableView];
    
    [self refresh];
}

- (void)injected
{
    
}

- (void)refresh
{
    _myTestMethods = getTestMethods(self.class);
    if (@available(iOS 10.0, *)) {
        [self.tableView.refreshControl endRefreshing];
    } else {
        // Fallback on earlier versions
    }
    [self.tableView reloadData];
}


- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    _selectedMethodName = nil;
}

- (void)testGet {
    _currentRequest = [[TJBaseRequest alloc] init];
    _currentRequest.url = @"get";
    _currentRequest.requestHeaders = [NSDictionary dictionaryWithObjectsAndKeys:@"45678s9dfdsf789a0",@"token", nil];

    [_currentRequest startRequestWithCompleteBlock:self.requestComplete];
}

- (void)testPost {
    _currentRequest = [[TJBaseRequest alloc] init];
    _currentRequest.url = @"post";
    _currentRequest.requestMethod = TJRequestMethodPOST;
    [_currentRequest startRequestWithCompleteBlock:self.requestComplete];
}
- (void)testCacheResult {
    _currentRequest = [TJBaseRequest request];
    _currentRequest.url = @"post";
    _currentRequest.isCache = YES;
    _currentRequest.requestMethod = TJRequestMethodPOST;
    [_currentRequest startRequestWithCompleteBlock:self.requestComplete];
}

- (void)testDelete {
    _currentRequest = [TJBaseRequest request];
    _currentRequest.url = @"delete";
    _currentRequest.requestMethod = TJRequestMethodDELETE;
    [_currentRequest startRequestWithCompleteBlock:self.requestComplete];
}

- (void)testTimerout {
    _currentRequest = [TJBaseRequest request];
    _currentRequest.url = @"post";
    _currentRequest.isCache = YES;
    _currentRequest.timeoutInterval = 1;
    _currentRequest.requestMethod = TJRequestMethodPOST;
    [_currentRequest startRequestWithCompleteBlock:self.requestComplete];
    [NSThread sleepForTimeInterval:2];
}

- (void)testDownload {
    [TJBaseRequest download:@"http://wind4app-bdys.oss-cn-hangzhou.aliyuncs.com/CMD_MarkDown.zip" parameter:nil resumePath:@"/Users/tangjie/Desktop/001" downloadCachePath:^NSString *(NSURLResponse *response) {
        return [@"/Users/tangjie/Downloads" stringByAppendingPathComponent:response.suggestedFilename];
    } progress:nil complete:self.requestComplete];
}

- (void(^)(TJBaseRequest *request, BOOL *isCache))requestComplete {
    return nil;
    return ^(TJBaseRequest *request, BOOL *isCache){
        if (request.error) {
            NSLog(@"\n请求失败：%s\n%@",__FUNCTION__,request.error);
        } else {
            NSLog(@"\n请求成功：%s\n%@",__FUNCTION__,request.result);
        }
    };
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    _selectedMethodName = _myTestMethods[indexPath.row];
    ((void (*)(id, SEL))objc_msgSend)(self, NSSelectorFromString(_selectedMethodName));
    DetailViewController *vc = [[DetailViewController alloc] init];
    vc.request = _currentRequest;
    vc.title = self->_selectedMethodName;
    [self.navigationController pushViewController:vc animated:YES];
    self.navigationItem.rightBarButtonItem = nil;
    NSLog(@"当前线程---%@",[NSThread currentThread]);
}
#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _myTestMethods.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.textLabel.text = _myTestMethods[indexPath.row];
    
    return cell;
}

@end

