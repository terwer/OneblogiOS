//
//  OBObjsViewController.m
//  OneblogiOS
//
//  Created by Terwer Green on 15/7/10.
//  Copyright (c) 2015年 Terwer Green. All rights reserved.
//

#import "OBObjsViewController.h"
#import "OBBaseObject.h"
#import "LastCell.h"

#import <MBProgressHUD.h>

@interface OBObjsViewController ()

@property (nonatomic, assign) BOOL refreshInProgress;
@property (nonatomic, strong) AFHTTPRequestOperationManager *manager;

@end


@implementation OBObjsViewController

- (instancetype)init
{
    self = [super init];
    
    if (self) {
        _objects = [NSMutableArray new];
        _page = 0;
        _needRefreshAnimation = YES;
        _shouldFetchDataAfterLoaded = YES;
    }
    
    return self;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    self.edgesForExtendedLayout = UIRectEdgeNone;
    
    self.tableView.backgroundColor = [UIColor themeColor];
    
    _lastCell = [LastCell new];
    [_lastCell addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(fetchMore)]];
    self.tableView.tableFooterView = _lastCell;
    
    self.refreshControl = [UIRefreshControl new];
    [self.refreshControl addTarget:self action:@selector(refresh) forControlEvents:UIControlEventValueChanged];
    
    _label = [UILabel new];
    _label.numberOfLines = 0;
    _label.lineBreakMode = NSLineBreakByWordWrapping;
    _label.font = [UIFont boldSystemFontOfSize:14];
    
    
    _manager = [AFHTTPRequestOperationManager manager];
    [_manager.requestSerializer setValue:[Utils generateUserAgent] forHTTPHeaderField:@"User-Agent"];
    _manager.responseSerializer = [AFOnoResponseSerializer XMLResponseSerializer];
    
    if (!_shouldFetchDataAfterLoaded) {return;}
    if (_needRefreshAnimation) {
        [self.refreshControl beginRefreshing];
        [self.tableView setContentOffset:CGPointMake(0, self.tableView.contentOffset.y-self.refreshControl.frame.size.height)
                                animated:YES];
    }
    
    if (_needCache) {
        _manager.requestSerializer.cachePolicy = NSURLRequestReturnCacheDataElseLoad;
    }
    [self fetchObjectsOnPage:0 refresh:YES];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}



#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _objects.count;
}

/*
 // 这个方法会导致reloadData时，tableview自动滑动到底部
 // 暂时还没发现好的解决方法，只好不用这个方法了
 // http://stackoverflow.com/questions/22753858/implementing-estimatedheightforrowatindexpath-causes-the-tableview-to-scroll-do
 
 - (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath
 {
 return 56;
 }
 */




#pragma mark - 刷新

- (void)refresh
{
    _refreshInProgress = NO;
    
    if (!_refreshInProgress) {
        _refreshInProgress = YES;
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            _manager.requestSerializer.cachePolicy = NSURLRequestUseProtocolCachePolicy;
            [self fetchObjectsOnPage:0 refresh:YES];
            _refreshInProgress = NO;
        });
    }
}




#pragma mark - 上拉加载更多

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    if(scrollView.contentOffset.y > ((scrollView.contentSize.height - scrollView.frame.size.height)))
    {
        [self fetchMore];
    }
}

- (void)fetchMore
{
    if (!_lastCell.shouldResponseToTouch) {return;}
    
    _lastCell.status = LastCellStatusLoading;
    _manager.requestSerializer.cachePolicy = NSURLRequestUseProtocolCachePolicy;
    [self fetchObjectsOnPage:++_page refresh:NO];
}


#pragma mark - 请求数据

- (void)fetchObjectsOnPage:(NSUInteger)page refresh:(BOOL)refresh
{
    NSLog(@"Current requestUrl:%@",self.generateURL(page));
    [_manager GET:self.generateURL(page)
       parameters:nil
          success:^(AFHTTPRequestOperation *operation, ONOXMLDocument *responseDocument) {
              _allCount = [[[responseDocument.rootElement firstChildWithTag:@"allCount"] numberValue] intValue];
              //NSLog(@"All count:%d",_allCount);
              NSArray *objectsXML = [self parseXML:responseDocument];
              
              if (refresh) {
                  _page = 0;
                  [_objects removeAllObjects];
                  if (_didRefreshSucceed) {_didRefreshSucceed();}
              }
              
              if (_parseExtraInfo) {_parseExtraInfo(responseDocument);}
              
              for (ONOXMLElement *objectXML in objectsXML) {
                  BOOL shouldBeAdded = YES;
                  id obj = [[_objClass alloc] initWithXML:objectXML];
                  
                  for (OBBaseObject *baseObj in _objects) {
                      if ([obj isEqual:baseObj]) {
                          shouldBeAdded = NO;
                          break;
                      }
                  }
                  if (shouldBeAdded) {
                      [_objects addObject:obj];
                  }
              }
              
              dispatch_async(dispatch_get_main_queue(), ^{
                  if (self.tableWillReload) {self.tableWillReload(objectsXML.count);}
                  else {
                      if (_page == 0 && objectsXML.count == 0) {
                          _lastCell.status = LastCellStatusEmpty;
                      } else if (objectsXML.count == 0 || (_page == 0 && objectsXML.count < 20)) {
                          _lastCell.status = LastCellStatusFinished;
                      } else {
                          _lastCell.status = LastCellStatusMore;
                      }
                  }
                  
                  if (self.refreshControl.refreshing) {
                      [self.refreshControl endRefreshing];
                  }
                  
                  [self.tableView reloadData];
              });
          }
          failure:^(AFHTTPRequestOperation *operation, NSError *error) {
              MBProgressHUD *HUD = [Utils createHUD];
              HUD.mode = MBProgressHUDModeCustomView;
              HUD.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"HUD-error"]];
              HUD.detailsLabelText = [NSString stringWithFormat:@"%@", error.userInfo[NSLocalizedDescriptionKey]];
              
              [HUD hide:YES afterDelay:1];
              
              _lastCell.status = LastCellStatusError;
              if (self.refreshControl.refreshing) {
                  [self.refreshControl endRefreshing];
              }
              [self.tableView reloadData];
          }
     ];
}


- (NSArray *)parseXML:(ONOXMLDocument *)xml
{
    NSAssert(false, @"Over ride in subclasses");
    return nil;
}

@end
