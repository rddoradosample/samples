//
//  NewsTableViewController.m
//  
//
//  Created by Ronaldo II Dorado on 11/5/15.
//
//

#import "NewsTableViewController.h"
#import "News.h"
#import "NewsItem.h"
#import "NewsItemTableViewCell.h"
#import "NewsItemImageTableViewCell.h"
#import "ImageDownloader.h"
#import "WebViewController.h"

#define kRowHeight 100.0f
#define kRowHeightMinimum 55.0f

@interface NewsTableViewController ()<NewsDelegate>

@property (nonatomic, strong) News *news;
@property (nonatomic, strong) UINib *newsItemTableViewCellNib;
@property (nonatomic, strong) NSIndexPath *selectedIndexPath;

@end

@implementation NewsTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Set table view
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    UIRefreshControl *aRefreshControl = [[UIRefreshControl alloc] init];
    self.refreshControl = aRefreshControl;
    self.refreshControl.attributedTitle = [[NSAttributedString alloc] initWithString:@"Pull to Refresh"];
    [self.refreshControl addTarget:self
                            action:@selector(refresh:)
                  forControlEvents:UIControlEventValueChanged];
    [self.tableView setHidden:YES];
    [self.navigationController.navigationBar setHidden:NO];
    
    // Set Navbar and Title
    self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:41.0/255.0f green:41.0/255.0f blue:41.0/255.0f alpha:41.0/255.0f];
    self.navigationController.navigationBar.tintColor = [UIColor colorWithRed:238.0/255.0f green:128.0/255.0f blue:34.0/255.0f alpha:255.0/255.0f];
    [self.navigationController.navigationBar
     setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor]}];
    self.title = @"tigerspike";
    
    
    // News allocate and refresh
    self.news = [[News alloc] initWithDelegate:self];
    [self.news refresh];
    
    self.tableView.estimatedRowHeight=100;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidAppear:(BOOL)animated {
    
    if (!self.selectedIndexPath) {
        [self.tableView deselectRowAtIndexPath:self.selectedIndexPath animated:YES];
    }
}
- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation {
    [self.tableView reloadData];
}

#pragma mark - Table View Delegate Methods
-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Remove seperator inset
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
    
    // Prevent the cell from inheriting the Table View's margin settings
    if ([cell respondsToSelector:@selector(setPreservesSuperviewLayoutMargins:)]) {
        [cell setPreservesSuperviewLayoutMargins:NO];
    }
    
    // Explictly set your cell's layout margins
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([self hasImageAtIndexPath:indexPath]) {
        return [self heightForNewsItemImageTableViewCellAtIndexPath:indexPath];
    }
    else {
        return [self heightForNewsItemTableViewCellAtIndexPath:indexPath];
    }
}

#pragma mark - Private Methods
- (BOOL)hasImageAtIndexPath:(NSIndexPath *)indexPath {
    
    NSInteger row = indexPath.row;
    
    if (row<self.news.newsArray.count) {
        
        NSDictionary *newsItemDictionary = [self.news.newsArray objectAtIndex:row];
        if (newsItemDictionary)
        {
            NewsItem *newsItem = [[NewsItem alloc] initWithDictionary:newsItemDictionary];
            NSString *imageUrl = newsItem.iconUrl?newsItem.iconUrl:@"";
            if (imageUrl && imageUrl.length > 0 ) {
                return YES;
            }
            else {
                return NO;
            }
            
        }
        else {
            return NO;
        }
    }
    else {
        return NO;
        
    }
}

-(NewsItemImageTableViewCell *)createNewsItemImageCellAtIndexPath:(NSIndexPath *)indexPath
{
    NewsItemImageTableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:NewsItemImageTableViewCellIdentifier forIndexPath:indexPath];
    [self setNewsItemImageCell:cell AtIndexPath:indexPath];
    
    return cell;
    
}

-(NewsItemTableViewCell *)createNewsItemCellAtIndexPath:(NSIndexPath *)indexPath
{
    NewsItemTableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:NewsItemTableViewCellIdentifier forIndexPath:indexPath];
    [self setNewsItemCell:cell AtIndexPath:indexPath];
    
    return cell;
    
}

- (void)setNewsItemImageCell:(NewsItemImageTableViewCell *)cell AtIndexPath:(NSIndexPath *)indexPath
{
    
    // Create table cell
    NSInteger row = indexPath.row;
    
    if (row<self.news.newsArray.count) {
        
        NSDictionary *newsItemDictionary = [self.news.newsArray objectAtIndex:row];
        if (newsItemDictionary)
        {
            NewsItem *newsItem = [[NewsItem alloc] initWithDictionary:newsItemDictionary];
            if (!newsItem) {
                cell.titleLabel.text = @"";
                cell.descriptionLabel.text = @"";
            }
            // Set Title
            cell.titleLabel.text =  newsItem.name?newsItem.name:@"";
            // Set Description
            cell.descriptionLabel.text =  newsItem.newsDescription?newsItem.newsDescription:@"";
            
            // Set Image View
            NSString *imageUrl = newsItem.iconUrl?newsItem.iconUrl:@"";
            cell.rightImageView.image = nil;
            ImageDownloader *imageDownloader = [[ImageDownloader alloc] init];
            [imageDownloader downloadImageUrl:imageUrl forTableView:self.tableView forCellIndexPath:indexPath];
        }
        else {
            cell.titleLabel.text = @"";
            cell.descriptionLabel.text = @"";
            
        }
    }
}

- (CGFloat)heightForNewsItemImageTableViewCellAtIndexPath:(NSIndexPath *)indexPath {
    static NewsItemImageTableViewCell *sizingCell = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sizingCell = [self.tableView dequeueReusableCellWithIdentifier:NewsItemImageTableViewCellIdentifier];
    });
    
    CGRect frame = sizingCell.frame;
    frame.size.width = self.tableView.frame.size.width;
    sizingCell.frame = frame;
    [sizingCell layoutIfNeeded];
    
    [self setNewsItemImageCell:sizingCell AtIndexPath:indexPath];
    return [self calculateHeightForConfiguredSizingCell:sizingCell];
}

- (CGFloat)heightForNewsItemTableViewCellAtIndexPath:(NSIndexPath *)indexPath {
    static NewsItemTableViewCell *sizingCell = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sizingCell = [self.tableView dequeueReusableCellWithIdentifier:NewsItemTableViewCellIdentifier];
    });
    
    CGRect frame = sizingCell.frame;
    frame.size.width = self.tableView.frame.size.width;
    sizingCell.frame = frame;
    [sizingCell layoutIfNeeded];
    
    [self setNewsItemCell:sizingCell AtIndexPath:indexPath];
    return [self calculateHeightForConfiguredSizingCell:sizingCell];
}

- (CGFloat)calculateHeightForConfiguredSizingCell:(UITableViewCell *)sizingCell {
    [sizingCell setNeedsLayout];
    [sizingCell layoutIfNeeded];
    [sizingCell needsUpdateConstraints];
    
    CGSize size = [sizingCell systemLayoutSizeFittingSize:UILayoutFittingCompressedSize];
    return size.height + 1.0f; // Add 1.0f for the cell separator height
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    // Store the index path of the last item selected
    self.selectedIndexPath = indexPath;
    
    // Create table cell
    NSInteger row = indexPath.row;
    
    if (row<self.news.newsArray.count) {
        
        NSDictionary *newsItemDictionary = [self.news.newsArray objectAtIndex:row];
        if (newsItemDictionary)
        {
            NewsItem *newsItem = [[NewsItem alloc] initWithDictionary:newsItemDictionary];
            
            // Open the URL
            NSString *url = newsItem.url?newsItem.url:@"";
            
            if (url && url.length>0) {
                //WebViewController *webViewController = [[WebViewController alloc] init];
                
                UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
                WebViewController *webViewController = [sb instantiateViewControllerWithIdentifier:@"WebViewController"];
                webViewController.title = newsItem.name;
                [webViewController openUrlString:url];
                [self.navigationController pushViewController:webViewController animated:YES];
            }
            else {
                [self.tableView deselectRowAtIndexPath:self.selectedIndexPath animated:YES];
            }
        }
        else {
            [self.tableView deselectRowAtIndexPath:self.selectedIndexPath animated:YES];
        }
    }
}

- (void)setNewsItemCell:(NewsItemTableViewCell *)cell AtIndexPath:(NSIndexPath *)indexPath {
    
    // Create table cell
    NSInteger row = indexPath.row;
    
    if (row<self.news.newsArray.count) {
        
        NSDictionary *newsItemDictionary = [self.news.newsArray objectAtIndex:row];
        if (newsItemDictionary)
        {
            NewsItem *newsItem = [[NewsItem alloc] initWithDictionary:newsItemDictionary];
            if (!newsItem) {
                cell.titleLabel.text = @"";
                cell.descriptionLabel.text = @"";
            }
            // Set Title
            cell.titleLabel.text =  newsItem.name?newsItem.name:@"";
            // Set Description
            cell.descriptionLabel.text =  newsItem.newsDescription?newsItem.newsDescription:@"";
        }
        else {
            cell.titleLabel.text = @"";
            cell.descriptionLabel.text = @"";
            
        }
    }
}


#pragma mark - Table View Data Source Methods
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (self.news.newsArray && self.news.newsArray.count>0) {
        return  self.news.newsArray.count;
    }
    else {
        return 0;
    }
}

// Row display. Implementers should *always* try to reuse cells by setting each cell's reuseIdentifier and querying for available reusable cells with dequeueReusableCellWithIdentifier:
// Cell gets various attributes set automatically based on table (separators) and data source (accessory views, editing controls)

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if ([self hasImageAtIndexPath:indexPath]) {
        return ([self createNewsItemImageCellAtIndexPath:indexPath]);
    }
    else {
        return ([self createNewsItemCellAtIndexPath:indexPath]);
    }
    
}

#pragma mark - News Delegate Method
- (void)newsDidUpdate:(id)sender {
    
    // End Refreshing
    [self.refreshControl endRefreshing];
    
    [self.tableView setHidden:NO];
    [self.tableView reloadData];
    
    if ([sender resultCode] != 200) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Unable to connect to server." message:@"Please try again at a later time." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alertView show];
    }
}

#pragma mark - Refresh Control Delegate Method
-(void)refresh:(id)sender {
    
    // Refresh News
    [self.news refresh];
    
}

@end

