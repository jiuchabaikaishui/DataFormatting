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
        
        SectionModel *timezone = [SectionModel modelWithTitle:@"日历计算"];
        [timezone addRowModelWithTitle:@"系统已知的时区名称的完整列表" detail:@"使用knownTimeZoneNames类方法查看系统已知的时区名称的完整列表。" selectedAction:^(UIViewController *controller, UITableView *tableView, NSIndexPath *indexPath) {
            NSLog(@"%@", [NSTimeZone knownTimeZoneNames]);
        }];
        [timezone addRowModelWithTitle:@"使用特定时区从组件创建日期" detail:@"创建独立于时区的日期，则可以将日期存储为NSDateComponents对象。" selectedAction:^(UIViewController *controller, UITableView *tableView, NSIndexPath *indexPath) {
            NSTimeZone *timezone = [NSTimeZone timeZoneWithAbbreviation:@"CDT"];
            NSCalendar *calendar = [NSCalendar calendarWithIdentifier:NSCalendarIdentifierGregorian];
            [calendar setTimeZone:timezone];
            NSDateComponents *components = [[NSDateComponents alloc] init];
            components.year = 2019;
            components.month = 4;
            components.day = 26;
            NSDate *date = [calendar dateFromComponents:components];
            NSLog(@"%@", date);
        }];
        [_mainModel addSectionModel:timezone];
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
