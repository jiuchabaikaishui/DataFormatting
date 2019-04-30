//
//  ViewController.m
//  FormatterExmaples
//
//  Created by 綦帅鹏 on 2019/4/26.
//  Copyright © 2019年 QSP. All rights reserved.
//

#import "ViewController.h"
#import "MainModel.h"
#import "MainTableViewCell.h"

@interface ViewController ()

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) MainModel *mainModel;

@end

@implementation ViewController

- (MainModel *)mainModel {
    if (_mainModel == nil) {
        _mainModel = [MainModel modelWithTitle:@"数据格式化编程"];
        
        SectionModel *dateFormatter = [SectionModel modelWithTitle:@"日期格式化"];
        [dateFormatter addRowModelWithTitle:@"使用格式化程序样式格式化日期" detail:@"使用setDateStyle:和setTimeStyle:分别指定日期格式化对象的日期和时间组件的样式。" selectedAction:^(UIViewController *controller, UITableView *tableView, NSIndexPath *indexPath) {
            NSDate *date = [NSDate date];
            NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
            [formatter setLocale:[NSLocale localeWithLocaleIdentifier:@"zh_CN"]];
            [formatter setDateStyle:NSDateFormatterFullStyle];
            [formatter setTimeStyle:NSDateFormatterShortStyle];
            NSLog(@"%@", [formatter stringFromDate:date]);
        }];
        [dateFormatter addRowModelWithTitle:@"使用格式字符串生成字符串" detail:@"为日期格式化对象指定自定义固定格式，使用setDateFormat:。" selectedAction:^(UIViewController *controller, UITableView *tableView, NSIndexPath *indexPath) {
            NSDate *date = [NSDate date];
            NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
            [formatter setDateFormat:@"yyyy/MM/dd HH:mm:ss"];
            NSLog(@"%@", [formatter stringFromDate:date]);
        }];
        [dateFormatter addRowModelWithTitle:@"使用当前区域设置显示今天的日期" detail:@"dateFormatFromTemplate:options:locale:方法生成一个格式字符串，其中包含要使用的日期组件，但具有适合用户的正确标点符号和顺序。" selectedAction:^(UIViewController *controller, UITableView *tableView, NSIndexPath *indexPath) {
            NSDate *date = [NSDate date];
            NSString *formatterString = [NSDateFormatter dateFormatFromTemplate:@"EdMMM" options:0 locale:[NSLocale localeWithLocaleIdentifier:@"zh-CN"]];
            NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
            [formatter setDateFormat:formatterString];
            NSLog(@"%@", [formatter stringFromDate:date]);
        }];
        [dateFormatter addRowModelWithTitle:@"根据需求显示日期" detail:@"来自美国的用户通常会期望日期为“Mon，Jan 3”，而来自英国的用户通常会期望日期为“Mon 31 Jan”。" selectedAction:^(UIViewController *controller, UITableView *tableView, NSIndexPath *indexPath) {
            NSDate *date = [NSDate date];
            NSString *formatterString = [NSDateFormatter dateFormatFromTemplate:@"EdMMM" options:0 locale:[NSLocale localeWithLocaleIdentifier:@"en_US"]];
            NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
            [formatter setDateFormat:formatterString];
            NSLog(@"%@", [formatter stringFromDate:date]);
            
            NSString *gbFormatterString = [NSDateFormatter dateFormatFromTemplate:@"EdMMM" options:0 locale:[NSLocale localeWithLocaleIdentifier:@"en_GB"]];
            NSDateFormatter *bgFormatter = [[NSDateFormatter alloc] init];
            [bgFormatter setDateFormat:gbFormatterString];
            NSLog(@"%@", [bgFormatter stringFromDate:date]);
        }];
        [dateFormatter addRowModelWithTitle:@"解析RFC 3339日期时间" detail:@"首先使用固定日期格式字符串和UTC作为时区，创建一个en_US_POSIX日期格式化程序来解析传入的RFC 3339日期字符串。接下来，创建一个标准日期格式化程序，以将日期呈现为要显示给用户的字符串。" selectedAction:^(UIViewController *controller, UITableView *tableView, NSIndexPath *indexPath) {
            NSString *rfc3399 = @"2019-04-28T18:19:22+0008";
            NSDateFormatter *rfc3399Formatter = [[NSDateFormatter alloc] init];
            [rfc3399Formatter setLocale:[NSLocale localeWithLocaleIdentifier:@"zh_CN_POSIX"]];
            [rfc3399Formatter setDateFormat:@"yyyy'-'MM'-'dd'T'HH':'mm':'ssZ"];
            [rfc3399Formatter setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:0]];
            NSDate *date = [rfc3399Formatter dateFromString:rfc3399];
            NSDate *otherDate = [NSDate date];
            NSLog(@"%@", [rfc3399Formatter stringFromDate:otherDate]);
            NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
            [formatter setDateStyle:NSDateFormatterMediumStyle];
            [formatter setTimeStyle:NSDateFormatterMediumStyle];
            NSLog(@"%@", [formatter stringFromDate:date]);
        }];
        [dateFormatter addRowModelWithTitle:@"缓存格式化对象解析RFC 3339日期时间" detail:@"经常使用格式化对象，则缓存单个实例通常比创建和处理多个实例更有效。" selectedAction:^(UIViewController *controller, UITableView *tableView, NSIndexPath *indexPath) {
            NSString *rfc3399 = @"2019-04-28T18:19:22+0008";
            static NSDateFormatter *rfc3399Formatter = nil;
            rfc3399Formatter = [[NSDateFormatter alloc] init];
            [rfc3399Formatter setLocale:[NSLocale localeWithLocaleIdentifier:@"zh_CN_POSIX"]];
            [rfc3399Formatter setDateFormat:@"yyyy'-'MM'-'dd'T'HH':'mm':'ssZ"];
            [rfc3399Formatter setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:0]];
            NSDate *date = [rfc3399Formatter dateFromString:rfc3399];
            static NSDateFormatter *formatter = nil;
            formatter = [[NSDateFormatter alloc] init];
            formatter.locale = [NSLocale localeWithLocaleIdentifier:@"zh_CN"];
            [formatter setDateStyle:NSDateFormatterMediumStyle];
            [formatter setTimeStyle:NSDateFormatterMediumStyle];
            NSLog(@"%@", [formatter stringFromDate:date]);
        }];
        [dateFormatter addRowModelWithTitle:@"固定格式、非本地化日期的Unix函数" detail:@"日期和时间在一个固定的，未本地化格式化对象，始终保证使用相同的日历，可能有时使用标准C库函数strptime_l和strftime_l是更容易和更有效。" selectedAction:^(UIViewController *controller, UITableView *tableView, NSIndexPath *indexPath) {
            struct tm sometime;
            const char *formatter = "%Y-%m-%d %H:%M:%S %z";
            strptime("2019-04-29 14:14:22 +0800", formatter, &sometime);
            NSLog(@"%@", [NSDate dateWithTimeIntervalSince1970:mktime(&sometime)]);
        }];
        [_mainModel addSectionModel:dateFormatter];
        
        SectionModel *numberFormatter = [SectionModel modelWithTitle:@"数字格式化"];
        [numberFormatter addRowModelWithTitle:@"使用格式化对象样式格式化数字" detail:@"使用setNumberStyle:指定数字格式对象的样式。" selectedAction:^(UIViewController *controller, UITableView *tableView, NSIndexPath *indexPath) {
            NSNumber *number = @1234567.1234567;
            NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
            [formatter setNumberStyle:NSNumberFormatterNoStyle];
            NSLog(@"%@", [formatter stringFromNumber:number]);
            [formatter setNumberStyle:NSNumberFormatterDecimalStyle];
            NSLog(@"%@", [formatter stringFromNumber:number]);
            [formatter setNumberStyle:NSNumberFormatterCurrencyStyle];
            NSLog(@"%@", [formatter stringFromNumber:number]);
            [formatter setNumberStyle:NSNumberFormatterPercentStyle];
            NSLog(@"%@", [formatter stringFromNumber:number]);
            [formatter setNumberStyle:NSNumberFormatterScientificStyle];
            NSLog(@"%@", [formatter stringFromNumber:number]);
            [formatter setNumberStyle:NSNumberFormatterSpellOutStyle];
            NSLog(@"%@", [formatter stringFromNumber:number]);
            [formatter setNumberStyle:NSNumberFormatterOrdinalStyle];
            NSLog(@"%@", [formatter stringFromNumber:number]);
            [formatter setNumberStyle:NSNumberFormatterCurrencyISOCodeStyle];
            NSLog(@"%@", [formatter stringFromNumber:number]);
            [formatter setNumberStyle:NSNumberFormatterCurrencyPluralStyle];
            NSLog(@"%@", [formatter stringFromNumber:number]);
            [formatter setNumberStyle:NSNumberFormatterCurrencyAccountingStyle];
            NSLog(@"%@", [formatter stringFromNumber:number]);
        }];
        [numberFormatter addRowModelWithTitle:@"使用格式字符串格式化数字" detail:@"可以使用setPositiveFormat:和setNegativeFormat:指定数字格式化对象的格式字符串。" selectedAction:^(UIViewController *controller, UITableView *tableView, NSIndexPath *indexPath) {
            NSNumber *number = @1234567.1234567;
            NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
            [formatter setPositiveFormat:@"###0.##"];
            NSLog(@"%@", [formatter stringFromNumber:number]);
        }];
        [numberFormatter addRowModelWithTitle:@"百分比" detail:@"使用带有“％”字符的格式字符串来格式化百分比。" selectedAction:^(UIViewController *controller, UITableView *tableView, NSIndexPath *indexPath) {
            NSNumber *number = @1;
            NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
            [formatter setPositiveFormat:@"0.00%"];
            NSLog(@"%@", [formatter stringFromNumber:number]);
        }];
        [_mainModel addSectionModel:numberFormatter];
    }
    
    return _mainModel;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    self.title = self.mainModel.title;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [self.mainModel sectionCount];
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.mainModel rowCountOfSetion:section];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [MainTableViewCell cellWithTableView:tableView indexPath:indexPath model:[self.mainModel rowModelOfIndexPath:indexPath]];
}
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    SectionModel *model = [self.mainModel sectionModelOfSection:section];
    return model.title;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    RowModel *model = [self.mainModel rowModelOfIndexPath:indexPath];
    if (model.selectedAction) {
        model.selectedAction(self, tableView, indexPath);
    }
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}


@end
