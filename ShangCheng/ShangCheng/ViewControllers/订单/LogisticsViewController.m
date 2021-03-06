//
//  LogisticsViewController.m
//  ShangCheng
//
//  Created by TongLi on 2017/1/5.
//  Copyright © 2017年 TongLi. All rights reserved.
//

#import "LogisticsViewController.h"
#import "LogisticsModel.h"
#import "LogisticsTableViewCell.h"
@interface LogisticsViewController ()<UITableViewDataSource,UITableViewDelegate>
@property (nonatomic,strong)NSMutableArray *logisticsDataSource;
@property (weak, nonatomic) IBOutlet UITableView *logisticsTabelView;

//headView
@property (weak, nonatomic) IBOutlet UIImageView *orderProductImageView;
@property (weak, nonatomic) IBOutlet UILabel *orderProductTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *orderProductCompanyLabel;
@property (weak, nonatomic) IBOutlet UILabel *orderProductFormatLabel;

@end

@implementation LogisticsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    //刷新头部视图
    [self upHeadView];
    
    self.logisticsDataSource = [NSMutableArray array];
    
    //网络请求物流信息
    Manager *manager = [Manager shareInstance];
    [manager orderLogisticsWithOrderId:self.tempSonOrderModel.o_id withSuccessLogisticsBlock:^(id successResult) {
        
        for (NSDictionary *tempDic in successResult) {
            LogisticsModel *logisticsModel = [[LogisticsModel alloc] init];
            [logisticsModel setValuesForKeysWithDictionary:tempDic];
            [self.logisticsDataSource addObject:logisticsModel];
        }
        //刷新列表
        [self.logisticsTabelView reloadData];
        
        
    } withFailLogisticsBlock:^(NSString *failResultStr) {
        
    }];
    
    
    
}

- (void)upHeadView {
    
    self.orderProductTitleLabel.text = self.tempSonOrderModel.p_name;
    self.orderProductCompanyLabel.text = @"";
    self.orderProductFormatLabel.text = [NSString stringWithFormat:@"规格:%@  数量:%@",self.tempSonOrderModel.productst,self.tempSonOrderModel.o_num];
}


#pragma mark - TableView Delegate -
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.logisticsDataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    LogisticsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"logisticsCell" forIndexPath:indexPath];
    
    LogisticsModel *tempLogisticsModel = self.logisticsDataSource[indexPath.row];
    
    [cell updateLogisticsCellWithLogisticsModel:tempLogisticsModel];
    return cell;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
