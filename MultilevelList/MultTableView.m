//
//  MultTableView.m
//  MultilevelList
//
//  Created by lx on 2017/11/17.
//  Copyright © 2017年 pingan. All rights reserved.
//

#import "MultTableView.h"
#import "Const.h"

#define RGB(r,g,b) [UIColor colorWithRed:r/255.0f green:g/255.0f blue:b/255.0f alpha:1.0f]

static NSString *const TableViewOneCellKey = @"TableViewOneCellKey";
static NSString *const TableViewTwoCellKey = @"TableViewTwoCellKey";
static NSString *const TableViewThreeCellKey = @"TableViewThreeCellKey";

@interface MultTableView () <UITableViewDataSource, UITableViewDelegate>
//cell的高度，默认为40.0f
@property (nonatomic, assign) CGFloat rowHeight;
//一级表视图
@property (nonatomic, strong) UITableView *tableViewOne;
//二级表视图
@property (nonatomic, strong) UITableView *tableViewTwo;
//三级表视图
@property (nonatomic, strong) UITableView *tableViewThree;
//底层灰色取消按钮
@property (nonatomic, strong) UIButton *cancelButton;
//表视图容器视图
@property (nonatomic, strong) UIView *tableContainerView;
//视图显示/隐藏
@property (nonatomic, assign) BOOL isShow;
//一级表视图数据源
@property (nonatomic, strong) NSArray *dataArray;
//二级表视图数据源
@property (nonatomic, strong) NSArray *twoTableArray;
//三级表视图数据源
@property (nonatomic, strong) NSArray *threeTableArray;
//表类型
@property (nonatomic, assign)MultTableViewType type;

@property (nonatomic, assign) NSInteger selectedIntger;

@property (nonatomic, strong) NSMutableDictionary *colDictionary;

@end

@implementation MultTableView

#pragma mark -- init

- (instancetype)init {
    self = [super init];
    if (self) {
        _rowHeight = 40.0f;
        _isShow = NO;
        _selectedIntger = 0;
        self.dataArray = [NSArray array];
        _colDictionary = [NSMutableDictionary dictionaryWithDictionary:@{
                                                                         @"tableOneLevel1":@"0",
                                                                         @"tableTwoLevel1":@"0",
                                                                         @"tableTwoLevel2":@"0",
                                                                         @"tableThreeLevel1":@"0",
                                                                         @"tableThreeLevel2":@"0",
                                                                         @"tableThreeLevel3":@"0",
                                                                         }];
        [self addSubview:self.cancelButton];
        [_cancelButton addSubview:self.tableContainerView];
    }
    return self;
}

- (void)createMultTableWithView:(UIView *)view tableViewType:(MultTableViewType)type withData:(NSArray *)dataArray {
    if (!_isShow) {
        _isShow = !_isShow;
        
        //表视图数量和数据源
        _type = type;
        _dataArray = dataArray;
        
        //设置视图坐标
        CGFloat multTableViewY = view.frame.origin.y + view.frame.size.height;
        self.frame = CGRectMake(0.0f, multTableViewY, Screen_Width, Screen_Height - multTableViewY);
        self.cancelButton.frame = self.bounds;
        //暂时设置为7 *_rowHeight。。。。。。。
        self.tableContainerView.frame = CGRectMake(0, 0, self.frame.size.width, _rowHeight * 7);
        
        if (!self.superview) {
            //将视图添加到Window上
            [[[UIApplication sharedApplication] keyWindow] addSubview:self];
            self.alpha = 0.0f;
            [UIView animateWithDuration:0.2f animations:^{
                self.alpha = 1.0f;
            }];
            
            [self adjustMutlTableViewFrame];
            [self loadSelected];
        }
        
    }else{
        
        [self dismissView];
    }
}

#pragma mark -- private method

- (void)loadSelected{
    
    switch (_type) {
        case MultTableViewTypeOne:
            [_tableViewOne reloadData];
            
             [_tableViewOne selectRowAtIndexPath:[NSIndexPath indexPathForRow:[_colDictionary[@"tableOneLevel1"] integerValue] inSection:0] animated:NO scrollPosition:UITableViewScrollPositionNone];
            break;
        case MultTableViewTypeTwo:
            _twoTableArray = _dataArray[[_colDictionary[@"tableTwoLevel1"] integerValue]][@"subcategories"];//默认选中第一列
            [_tableViewOne reloadData];
            [_tableViewTwo reloadData];
            
            [_tableViewOne selectRowAtIndexPath:[NSIndexPath indexPathForRow:[_colDictionary[@"tableTwoLevel1"] integerValue] inSection:0] animated:NO scrollPosition:UITableViewScrollPositionNone];
            [_tableViewTwo selectRowAtIndexPath:[NSIndexPath indexPathForRow:[_colDictionary[@"tableTwoLevel2"] integerValue] inSection:0] animated:NO scrollPosition:UITableViewScrollPositionNone];
            
            break;
        case MultTableViewTypeThree:
            
            _twoTableArray = [self dataHandler:[_colDictionary[@"tableThreeLevel1"] integerValue]];
            _threeTableArray = _dataArray[[_colDictionary[@"tableThreeLevel1"] integerValue]][@"sub"][[_colDictionary[@"tableThreeLevel2"] integerValue]][@"sub"];
            [_tableViewOne reloadData];
            [_tableViewTwo reloadData];
            [_tableViewThree reloadData];
            
            [_tableViewOne selectRowAtIndexPath:[NSIndexPath indexPathForRow:[_colDictionary[@"tableThreeLevel1"] integerValue] inSection:0] animated:NO scrollPosition:UITableViewScrollPositionNone];
            [_tableViewTwo selectRowAtIndexPath:[NSIndexPath indexPathForRow:[_colDictionary[@"tableThreeLevel2"] integerValue] inSection:0] animated:NO scrollPosition:UITableViewScrollPositionNone];
            [_tableViewThree selectRowAtIndexPath:[NSIndexPath indexPathForRow:[_colDictionary[@"tableThreeLevel3"] integerValue] inSection:0] animated:NO scrollPosition:UITableViewScrollPositionNone];
            
            break;
        default:
            break;
    }
    //箭头View动画
    [UIView animateWithDuration:0.2f animations:^{
        if (self.arrowView) {
            self.arrowView.transform = CGAffineTransformMakeRotation(M_PI);
        }
    }];
}

- (NSArray *)dataHandler:(NSInteger)row {
    NSMutableArray *mutableArray = [NSMutableArray array];
    for (NSInteger i = 0; i < ((NSArray *)_dataArray[row][@"sub"]).count; i ++) {
        NSDictionary *dictionary = _dataArray[row][@"sub"][i];
        [mutableArray addObject:dictionary[@"name"]];
    }
    return [mutableArray copy];
}

- (void)adjustMutlTableViewFrame {
    if (_type == MultTableViewTypeOne) {
        self.tableViewOne.frame = CGRectMake(0, 0, Screen_Width, _tableContainerView.frame.size.height);
         [_tableContainerView addSubview:self.tableViewOne];
        
    }else if (_type == MultTableViewTypeTwo){
        self.tableViewOne.frame = CGRectMake(0, 0, Screen_Width/2.0f, _tableContainerView.frame.size.height);
        self.tableViewTwo.frame = CGRectMake(Screen_Width/2.0f, 0, Screen_Width/2.0f, _tableContainerView.frame.size.height);
         [_tableContainerView addSubview:self.tableViewOne];
         [_tableContainerView addSubview:self.tableViewTwo];
        
    }else if (_type == MultTableViewTypeThree){
        self.tableViewOne.frame = CGRectMake(0, 0, Screen_Width / 3.0f, _tableContainerView.frame.size.height);
        self.tableViewTwo.frame = CGRectMake(Screen_Width / 3.0f, 0, Screen_Width/3.0f, _tableContainerView.frame.size.height);
        self.tableViewThree.frame = CGRectMake(Screen_Width * 2 / 3.0f, 0, Screen_Width/3.0f, _tableContainerView.frame.size.height);
        [_tableContainerView addSubview:self.tableViewOne];
        [_tableContainerView addSubview:self.tableViewTwo];
        [_tableContainerView addSubview:self.tableViewThree];
    }else{
        NSLog(@"表格数量出错");
    }
}

- (void)dismissView {
    if (self.superview) {
        _isShow = !_isShow;
        [self endEditing:YES];
        self.alpha = 0.0f;
        [self.tableContainerView.subviews enumerateObjectsUsingBlock:^(UIView *obj, NSUInteger idx, BOOL *stop) {
            [obj removeFromSuperview];
        }];
        [self removeFromSuperview];
        
        [UIView animateWithDuration:0.2 animations:^{
            if (self.arrowView) {
                self.arrowView.transform = CGAffineTransformMakeRotation(0);
            }
        }];
        
    }
}

#pragma mark -- Action Method

- (void)clickCancelButton:(UIButton *)sender {
    [self dismissView];
}

#pragma mark -- UITableViewDataSource,UITableViewDelegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (_type == MultTableViewTypeOne) {
        return _dataArray.count;
    }else if (_type == MultTableViewTypeTwo){
        
            if (tableView == _tableViewOne) {
                return self.dataArray.count;
            }else if (tableView == _tableViewTwo){
                return _twoTableArray.count;
            }
        
    }else if (_type == MultTableViewTypeThree){
        if (tableView == _tableViewOne) {
            return self.dataArray.count;
        }else if (tableView == _tableViewTwo){
            return self.twoTableArray.count;
        }else if (tableView == _tableViewThree){
            return _threeTableArray.count;
        }
        
    }
    
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (_type == MultTableViewTypeOne) {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:TableViewOneCellKey forIndexPath:indexPath];
        cell.textLabel.text =_dataArray[indexPath.row][@"label"];
        cell.textLabel.font = [UIFont systemFontOfSize:14.0f];
        UIView *background =  [[UIView alloc]initWithFrame:CGRectMake(0, 0, cell.frame.size.width, cell.frame.size.height)];
        background.backgroundColor = [UIColor whiteColor];
        cell.selectedBackgroundView = background;
        cell.backgroundColor = [UIColor whiteColor];
        if ([_colDictionary[@"tableOneLevel1"] integerValue] == indexPath.row) {
            cell.textLabel.textColor = [UIColor orangeColor];
        }else{
            cell.textLabel.textColor = [UIColor blackColor];
        }
        return cell;
    }else if (_type  == MultTableViewTypeTwo){
        if (tableView == _tableViewOne) {
            tableView.separatorColor = [UIColor clearColor];
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:TableViewOneCellKey forIndexPath:indexPath];
            cell.textLabel.text =_dataArray[indexPath.row][@"name"];
            cell.textLabel.font = [UIFont systemFontOfSize:14.0f];
            UIView *background =  [[UIView alloc]initWithFrame:CGRectMake(0, 0, cell.frame.size.width, cell.frame.size.height)];
            background.backgroundColor = [UIColor whiteColor];
            cell.selectedBackgroundView = background;
            if ([_colDictionary[@"tableTwoLevel1"] integerValue] == indexPath.row) {
                cell.backgroundColor = [UIColor whiteColor];
                cell.textLabel.textColor = [UIColor orangeColor];
            }else{
                cell.backgroundColor = RGB(238,243,246);
                cell.textLabel.textColor = [UIColor blackColor];
            }
            return cell;
        }else if (tableView == _tableViewTwo){
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:TableViewTwoCellKey forIndexPath:indexPath];
            cell.textLabel.text = _twoTableArray[indexPath.row];
            cell.textLabel.font = [UIFont systemFontOfSize:14.0f];
            UIView *background =  [[UIView alloc]initWithFrame:CGRectMake(0, 0, cell.frame.size.width, cell.frame.size.height)];
            background.backgroundColor = [UIColor whiteColor];
            cell.selectedBackgroundView = background;
            cell.backgroundColor = [UIColor whiteColor];
            if ([_colDictionary[@"tableTwoLevel2"] integerValue] == indexPath.row) {
                cell.textLabel.textColor = [UIColor orangeColor];
            }else{
                 cell.textLabel.textColor = [UIColor blackColor];
            }
            return cell;
        }
        
    }else if (_type == MultTableViewTypeThree){
        if (tableView == _tableViewOne) {
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:TableViewOneCellKey forIndexPath:indexPath];
            cell.textLabel.text = _dataArray[indexPath.row][@"name"];
            cell.textLabel.font = [UIFont systemFontOfSize:14.0f];
            UIView *background =  [[UIView alloc]initWithFrame:CGRectMake(0, 0, cell.frame.size.width, cell.frame.size.height)];
            background.backgroundColor = [UIColor whiteColor];
            cell.selectedBackgroundView = background;
            if ([_colDictionary[@"tableThreeLevel1"] integerValue] == indexPath.row) {
                cell.backgroundColor = [UIColor whiteColor];
                cell.textLabel.textColor = [UIColor orangeColor];
            }else{
                cell.backgroundColor = RGB(238,243,246);
                cell.textLabel.textColor = [UIColor blackColor];
            }
            return cell;
        }else if (tableView == _tableViewTwo){
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:TableViewTwoCellKey forIndexPath:indexPath];
            cell.textLabel.text = _twoTableArray[indexPath.row];
            cell.textLabel.font = [UIFont systemFontOfSize:14.0f];
            UIView *background =  [[UIView alloc]initWithFrame:CGRectMake(0, 0, cell.frame.size.width, cell.frame.size.height)];
            background.backgroundColor = RGB(238,243,246);
            cell.selectedBackgroundView = background;
            if ([_colDictionary[@"tableThreeLevel2"] integerValue] == indexPath.row) {
                cell.backgroundColor = RGB(238,243,246);
                cell.textLabel.textColor = [UIColor orangeColor];
            }else{
                cell.backgroundColor = [UIColor whiteColor];
                cell.textLabel.textColor = [UIColor blackColor];
            }
            return cell;
        }else if (tableView == _tableViewThree){
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:TableViewThreeCellKey forIndexPath:indexPath];
            cell.textLabel.text =  _threeTableArray[indexPath.row];;
            cell.textLabel.font = [UIFont systemFontOfSize:14.0f];
            UIView *background =  [[UIView alloc]initWithFrame:CGRectMake(0, 0, cell.frame.size.width, cell.frame.size.height)];
            background.backgroundColor = [UIColor whiteColor];
            cell.selectedBackgroundView = background;
            if ([_colDictionary[@"tableThreeLevel3"] integerValue] == indexPath.row) {
                cell.backgroundColor = [UIColor whiteColor];
                cell.textLabel.textColor = [UIColor orangeColor];
            }else{
                cell.backgroundColor = RGB(238,243,246);
                cell.textLabel.textColor = [UIColor blackColor];
            }
            return cell;
        }
    }
    return nil;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSMutableString *string = [NSMutableString stringWithString:@""];
    NSInteger selectedRow = tableView.indexPathForSelectedRow.row;
    if (_type == MultTableViewTypeOne) {
        
        [string appendString:_dataArray[indexPath.row][@"label"]];
        if ([self.delegate respondsToSelector:@selector(multTableViewClickWithView:withSelectText:)]) {
            [self.delegate multTableViewClickWithView:self withSelectText:string];
        }
        [_colDictionary setValue:[NSString stringWithFormat:@"%ld",(long)selectedRow] forKey:@"tableOneLevel1"];
        [self dismissView];
    }else if (_type == MultTableViewTypeTwo){
        
        if (tableView == _tableViewOne) {
            _twoTableArray = _dataArray[selectedRow][@"subcategories"];//默认选中第一列
             //[string appendString:_dataArray[selectedRow][@"name"]];
            [_colDictionary setValue:[NSString stringWithFormat:@"%ld",(long)selectedRow] forKey:@"tableTwoLevel1"];
             [_colDictionary setValue:@"0" forKey:@"tableTwoLevel2"];
            
            [_tableViewOne reloadData];
            [_tableViewTwo reloadData];
        }else if (tableView == _tableViewTwo){
            //[string appendString:_dataArray[_tableViewOne.indexPathForSelectedRow.row][@"name"]];
            [string appendString:_twoTableArray[indexPath.row]];
            if ([self.delegate respondsToSelector:@selector(multTableViewClickWithView:withSelectText:)]) {
                [self.delegate multTableViewClickWithView:self withSelectText:string];
            }
            [_colDictionary setValue:[NSString stringWithFormat:@"%ld",(long)selectedRow] forKey:@"tableTwoLevel2"];
            [self dismissView];
        }
        
    }else if (_type == MultTableViewTypeThree){
        
        if (tableView == _tableViewOne) {
            //[string appendString:_dataArray[_tableViewOne.indexPathForSelectedRow.row][@"name"]];
            _twoTableArray = [self dataHandler:selectedRow];
            _threeTableArray = _dataArray[selectedRow][@"sub"][0][@"sub"];
             [_colDictionary setValue:[NSString stringWithFormat:@"%ld",(long)selectedRow] forKey:@"tableThreeLevel1"];
            [_colDictionary setValue:@"0" forKey:@"tableThreeLevel2"];
            [_colDictionary setValue:@"0" forKey:@"tableThreeLevel3"];
            [_tableViewOne reloadData];
            [_tableViewTwo reloadData];
            [_tableViewThree reloadData];
        }else if (tableView == _tableViewTwo){
            
            _threeTableArray = _dataArray[[_colDictionary[@"tableThreeLevel1"] integerValue]][@"sub"][selectedRow][@"sub"];
            //[string appendString:_dataArray[_tableViewOne.indexPathForSelectedRow.row][@"name"]];
            //[string appendString:_twoTableArray[_tableViewTwo.indexPathForSelectedRow.row]];
             [_colDictionary setValue:[NSString stringWithFormat:@"%ld",(long)selectedRow] forKey:@"tableThreeLevel2"];
             [_colDictionary setValue:@"0" forKey:@"tableThreeLevel3"];
            [_tableViewTwo reloadData];
            [_tableViewThree reloadData];
        }else if (tableView == _tableViewThree){
//            [string appendString:_dataArray[_tableViewOne.indexPathForSelectedRow.row][@"name"]];
//            [string appendString:_twoTableArray[_tableViewTwo.indexPathForSelectedRow.row]];
            [string appendString:_threeTableArray[selectedRow]];
            if ([self.delegate respondsToSelector:@selector(multTableViewClickWithView:withSelectText:)]) {
                [self.delegate multTableViewClickWithView:self withSelectText:string];
            }
             [_colDictionary setValue:[NSString stringWithFormat:@"%ld",(long)selectedRow] forKey:@"tableThreeLevel3"];
            [self dismissView];
        }
    }
}

#pragma mark -- getter

- (UIView *)tableContainerView {
    if (!_tableContainerView) {
        _tableContainerView = [[UIView alloc]initWithFrame:CGRectZero];
        _tableContainerView.backgroundColor =  [UIColor colorWithRed:0.74f green:0.73f blue:0.76f alpha:1.0f];
    }
    return _tableContainerView;
}

- (UITableView *)tableViewOne {
    if (!_tableViewOne) {
        _tableViewOne = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableViewOne.showsVerticalScrollIndicator = NO;
        _tableViewOne.showsHorizontalScrollIndicator = NO;
        _tableViewOne.backgroundColor = [UIColor whiteColor];
        _tableViewOne.tableFooterView = [UIView new];
        _tableViewOne.rowHeight = _rowHeight;
        _tableViewOne.dataSource = self;
        _tableViewOne.delegate = self;
        [_tableViewOne registerClass:[UITableViewCell class] forCellReuseIdentifier:TableViewOneCellKey];
    }
    return _tableViewOne;
}

- (UITableView *)tableViewTwo {
    if (!_tableViewTwo) {
        _tableViewTwo = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableViewTwo.showsVerticalScrollIndicator = NO;
        _tableViewTwo.showsHorizontalScrollIndicator = NO;
        _tableViewTwo.backgroundColor = [UIColor whiteColor];
        _tableViewTwo.tableFooterView = [UIView new];
        _tableViewTwo.rowHeight = _rowHeight;
        _tableViewTwo.dataSource = self;
        _tableViewTwo.delegate = self;
        [_tableViewTwo registerClass:[UITableViewCell class] forCellReuseIdentifier:TableViewTwoCellKey];
    }
    return _tableViewTwo;
}

- (UITableView *)tableViewThree {
    if (!_tableViewThree) {
        _tableViewThree = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableViewThree.showsVerticalScrollIndicator = NO;
        _tableViewThree.showsHorizontalScrollIndicator = NO;
        _tableViewThree.backgroundColor = [UIColor whiteColor];
        _tableViewThree.tableFooterView = [UIView new];
        _tableViewThree.rowHeight = _rowHeight;
        _tableViewThree.dataSource = self;
        _tableViewThree.delegate = self;
        [_tableViewThree registerClass:[UITableViewCell class] forCellReuseIdentifier:TableViewThreeCellKey];
    }
    return _tableViewThree;
}

- (UIButton *)cancelButton {
    if (!_cancelButton) {
        _cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _cancelButton.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.3];
        [_cancelButton addTarget:self action:@selector(clickCancelButton:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _cancelButton;
}

@end
