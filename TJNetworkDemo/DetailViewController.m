//
//  DetailViewController.m
//  TJNetworking
//  Created by Tang杰 on 2019/3/15.
//  Copyright © 2019 Tang杰. All rights reserved.
//

#import "DetailViewController.h"
#import "TJBaseRequest.h"

#define weakObj(self) autoreleasepool {} __weak typeof(self) weak_##self = self;
#define strongObj(self) autoreleasepool {} __strong typeof(self) self = weak_##self;

@interface DetailViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    NSDictionary *allHTTPHeaderFields;
    UIProgressView *_progressView;
}
@property (nonatomic, strong) UITableView *tableView;

@end

@implementation DetailViewController
- (void)dealloc
{
    NSLog(@"%@-----------%s",self.class,__func__);
}
- (void)back {
    if (self.request.requestTask.state < NSURLSessionTaskStateCanceling) {
        [self.request cancel];
    }
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStylePlain target:self action:@selector(back)];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"暂停" style:UIBarButtonItemStyleDone target:self action:@selector(suspend)];
    
    allHTTPHeaderFields = self.request.requestTask.currentRequest.allHTTPHeaderFields;
    [self.request readCacheBlock:^(NSString * _Nonnull key, id<NSCoding>  _Nullable object) {
        NSLog(@"读取缓存---->%@",object);
    }];
    
//    这里其实可以不用__weak修饰self，TJBaseRequest内部对block做了清空处理不会造成循环引用问题
//    此处使用只是单纯消除警告
    @weakObj(self)
    [self.request setComplete:^(TJBaseRequest *request, BOOL *isCache) {
        @strongObj(self)
//        *isCache = YES;// 可以在请求完成后设置是否要缓存请求结果
        _progressView.progress = 0.0;
        self.navigationItem.rightBarButtonItem = nil;
        [self.tableView reloadData];
    }];
    [self.request setProgress:self.progress];
    [self.view addSubview:self.tableView];
    _progressView = [[UIProgressView alloc] initWithProgressViewStyle:(UIProgressViewStyleDefault)];
    [self.view addSubview:_progressView];
    _progressView.frame = CGRectMake(0, CGRectGetHeight(self.navigationController.navigationBar.bounds) + CGRectGetHeight([UIApplication sharedApplication].statusBarFrame), CGRectGetWidth(self.view.bounds), 1);
}


- (void)suspend {
    [self.request.requestTask suspend];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"继续" style:UIBarButtonItemStyleDone target:self action:@selector(resume)];
}

- (void)resume
{
    [self.request.requestTask resume];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"暂停" style:UIBarButtonItemStyleDone target:self action:@selector(suspend)];
}

- (void(^)(NSProgress *))progress
{
    return ^(NSProgress *progress){
        self->_progressView.progress = progress.completedUnitCount*1.0/progress.totalUnitCount;
    };
}

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
        
    }
    return _tableView;
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewAutomaticDimension;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 30;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.001;
}
#pragma mark - UITableViewDataSource
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return section == 0 ? @"header" : @"body";
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return section == 0 ? allHTTPHeaderFields.allKeys.count : 1;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *identifier = indexPath.section == 0 ? @"header" : @"body";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:identifier];
    }
    if (indexPath.section == 0) {
        NSArray *allKeys = [allHTTPHeaderFields.allKeys sortedArrayUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
            return obj1 > obj2;
        }];
        cell.detailTextLabel.text = allHTTPHeaderFields[allKeys[indexPath.row]];
        cell.textLabel.text = allKeys[indexPath.row];
    } else {
        if (self.request.error) {
            cell.textLabel.text = self.request.error.description;
        } else if (self.request.result) {
            cell.textLabel.text = [NSString stringWithFormat:@"%@",self.request.result ? self.request.result : self.request.originalResult];
        }
    }
    cell.textLabel.numberOfLines = 0;
    
    return cell;
}

//NSStringEncoding stringEncoding = NSUTF8StringEncoding;
//if (response.textEncodingName) {
//    CFStringEncoding encoding = CFStringConvertIANACharSetNameToEncoding((CFStringRef)response.textEncodingName);
//    if (encoding != kCFStringEncodingInvalidId) {
//        stringEncoding = CFStringConvertEncodingToNSStringEncoding(encoding);
//    }
//}
//
//NSString *string = [[NSString alloc] initWithData:data encoding:stringEncoding];

@end
