//
//  BlogsViewController.m
//  OneblogiOS
//
//  Created by Terwer Green on 15/7/10.
//  Copyright (c) 2015年 Terwer Green. All rights reserved.
//

#import "BlogsViewController.h"
#import "BlogCell.h"
#import "OBBlog.h"
#import "Config.h"
#import "DetailsViewController.h"

static NSString *kBlogCellID = @"BlogCell";

@implementation BlogsViewController


#pragma mark - init method

- (instancetype)initWithBlogsType:(BlogsType)type
{
    if (self = [super init]) {
        //NSString *blogType = type == BlogTypeLatest? @"latest" : @"recommend";
        self.generateURL = ^NSString * (NSUInteger page) {
        return @"http://www.oschina.net/action/api/blog_list?type=latest&pageIndex=0&pageSize=20";
        //    return [NSString stringWithFormat:@"%@%@?type=%@&pageIndex=%lu&%@", OSCAPI_PREFIX, OSCAPI_BLOGS_LIST, blogType, (unsigned long)page, OSCAPI_SUFFIX];
        };
        //当前对象设置为博客
        self.objClass = [OBBlog class];
    }
    
    return self;
}

- (instancetype)initWithUserID:(int64_t)userID
{
    if (self = [super init]) {
        self.generateURL = ^NSString * (NSUInteger page) {
            return @"http://www.oschina.net/action/api/blog_list?type=latest&pageIndex=0&pageSize=20";
//        self.generateURL = ^NSString * (NSUInteger page) {
//            return [NSString stringWithFormat:@"%@%@?authoruid=%lld&pageIndex=%lu&uid=%lld", OSCAPI_PREFIX, OSCAPI_USERBLOGS_LIST, userID, (unsigned long)page, [Config getOwnID]];
        };
        self.objClass = [OBBlog class];
   }
    
    return self;
}


- (NSArray *)parseXML:(ONOXMLDocument *)xml
{
    return [[xml.rootElement firstChildWithTag:@"blogs"] childrenWithTag:@"blog"];
}

#pragma mark - life cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.tableView registerClass:[BlogCell class] forCellReuseIdentifier:kBlogCellID];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - tableView things

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    BlogCell *cell = [self.tableView dequeueReusableCellWithIdentifier:kBlogCellID forIndexPath:indexPath];
    OBBlog *blog = self.objects[indexPath.row];
    
    [cell.titleLabel setAttributedText:blog.attributedTittle];
    [cell.bodyLabel setText:blog.body];
    [cell.authorLabel setText:blog.author];
    //[cell.timeLabel setAttributedText:[Utils attributedTimeString:blog.pubDate]];
    [cell.commentCount setAttributedText:blog.attributedCommentCount];
    return cell;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    OBBlog *blog = self.objects[indexPath.row];
    
    self.label.font = [UIFont boldSystemFontOfSize:15];
    [self.label setAttributedText:blog.attributedTittle];
    CGFloat height = [self.label sizeThatFits:CGSizeMake(tableView.frame.size.width - 16, MAXFLOAT)].height;
    
    self.label.text = blog.body;
    self.label.font = [UIFont systemFontOfSize:13];
    height += [self.label sizeThatFits:CGSizeMake(tableView.frame.size.width - 16, MAXFLOAT)].height;
    
    return height + 42;
    return 0;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    OBBlog *blog = self.objects[indexPath.row];
    //DetailsViewController *detailsViewController = [[DetailsViewController alloc] initWithBlog:blog];
    //[self.navigationController pushViewController:detailsViewController animated:YES];
}

@end
