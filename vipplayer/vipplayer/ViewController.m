//
//  ViewController.m
//  vipplayer
//
//  Created by LUOSUONAN on 2022/4/30.
//

#import "ViewController.h"
#import "VipUrlItem.h"
#import "ARSafariActivity.h"

@import SafariServices;

@interface ViewController ()<UITableViewDelegate,UITableViewDataSource,SFSafariViewControllerDelegate>
{
    UITableView *_tableView;
}

@property (nonatomic, strong) NSMutableArray *itemsArray;
@property (nonatomic, strong) NSMutableArray *platformItemsArray;

@end


@implementation ViewController

- (void)initDefaultData{
    NSError *error = nil;
    NSString *path = [[NSBundle mainBundle] pathForResource:@"vlist" ofType:@"json"];
    if (!path) {
        return;
    }
    NSData *data = [NSData dataWithContentsOfFile:path options:NSDataReadingMappedIfSafe error:&error];
    NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];

    [self transformJsonToModel:dict[@"list"]];
    [self transformPlatformJsonToModel:dict[@"platformlist"]];
}

- (void)transformPlatformJsonToModel:(NSArray *)jsonArray
{
    if ([jsonArray isKindOfClass:[NSArray class]]) {
        NSMutableArray *urlsArray = [NSMutableArray array];
        for (NSDictionary *dict in jsonArray) {
            VipUrlItem *item = [[VipUrlItem alloc] init];
            item.title = dict[@"name"];
            item.icon = dict[@"icon"];
            item.url = dict[@"url"];
            [urlsArray addObject:item];
        }
        
        [self.platformItemsArray removeAllObjects];
        [self.platformItemsArray addObjectsFromArray:urlsArray];
    }
}


- (void)transformJsonToModel:(NSArray *)jsonArray
{
    if ([jsonArray isKindOfClass:[NSArray class]]) {
        NSMutableArray *urlsArray = [NSMutableArray array];
        for (NSDictionary *dict in jsonArray) {
            VipUrlItem *item = [[VipUrlItem alloc] init];
            item.title = dict[@"name"];
            item.icon = dict[@"icon"];
            item.url = dict[@"url"];
            [urlsArray addObject:item];
        }
        
        [self.itemsArray removeAllObjects];
        [self.itemsArray addObjectsFromArray:urlsArray];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.itemsArray = [NSMutableArray array];
    self.platformItemsArray = [NSMutableArray array];
    [self initDefaultData];
    
    
    
    _tableView=[[UITableView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height) style:UITableViewStylePlain];
    _tableView.delegate=self;
    _tableView.dataSource=self;
//    _tableView.backgroundColor=[self colorWithHexString:@"#eeeeee"];//设置背景颜色
//    _tableView.separatorColor=[self colorWithHexString:@"#dedede"];//设置线的颜色
    [self.view addSubview:_tableView];
}

//返回行数
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{

    return self.platformItemsArray.count;
}
//返回区数
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
//设置行高
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 44;
}


//设置cell
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    static NSString *str=@"indexpath";
    UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:str];
    if (!cell) {
        cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:str];
    }
    //将cell设置为可点击(默认yes)
   // cell.userInteractionEnabled = YES;
   
    VipUrlItem *item = self.platformItemsArray[indexPath.row];
    
    cell.textLabel.text=item.title;
    cell.detailTextLabel.text = item.url;
   
    return cell;
}
//点击cell执行该方法
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    VipUrlItem *item = self.platformItemsArray[indexPath.row];

    NSString *urlString = item.url;
    
    SFSafariViewController *sfViewControllr = [[SFSafariViewController alloc] initWithURL:[NSURL URLWithString:urlString]];
    
    sfViewControllr.delegate = self;
    
    [self presentViewController:sfViewControllr animated:YES completion:^{
        
    }];
}

- (NSArray<UIActivity *> *)safariViewController:(SFSafariViewController *)controller activityItemsForURL:(NSURL *)URL title:(nullable NSString *)title{
    
    NSLog(@"%@", URL);
    
    NSString * urlStr = [URL absoluteString];
    
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"https://jsap.attakids.com/?url=%@",urlStr]];
    
    ARSafariActivity *safariActivity = [[ARSafariActivity alloc] init];
    
    safariActivity.url = url;

    return @[safariActivity];
}

//根据UI设计师给的颜色值返回出UIColor
-(UIColor *) colorWithHexString: (NSString *)color{
    NSString *cString = [[color stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] uppercaseString];
    if ([cString length] <6) {
        return [UIColor clearColor];
    }
    if ([cString hasPrefix:@"0X"])
        cString = [cString substringFromIndex:2];
    if ([cString hasPrefix:@"#"])
        cString = [cString substringFromIndex:1];
    if ([cString length] !=6)
        return [UIColor clearColor];
    NSRange range;
    range.location =0;
    range.length =2;
    NSString *rString = [cString substringWithRange:range];
    range.location =2;
    NSString *gString = [cString substringWithRange:range];
    range.location =4;
    NSString *bString = [cString substringWithRange:range];
    unsigned int r, g, b;
    [[NSScanner scannerWithString:rString] scanHexInt:&r];
    [[NSScanner scannerWithString:gString] scanHexInt:&g];
    [[NSScanner scannerWithString:bString] scanHexInt:&b];
    return [UIColor colorWithRed:((float) r /255.0f) green:((float) g /255.0f) blue:((float) b /255.0f) alpha:1.0f];
}


@end
