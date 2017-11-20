//
//  MultMenuView.m
//  MultilevelList
//
//  Created by lx on 2017/11/17.
//  Copyright © 2017年 pingan. All rights reserved.
//

#import "MultMenuView.h"
#import "Const.h"
#import "MultTableView.h"

@interface MultMenuView ()<MultTableViewDelegate>

@property (nonatomic, strong) UIButton *oneLinkageButton;
@property (nonatomic, strong) UIButton *twoLinkageButton;
@property (nonatomic, strong) UIButton *threeLinkageButton;

@property (nonatomic, strong) MultTableView *oneLinkageDropMenu;
@property (nonatomic, strong) MultTableView *twoLinkageDropMenu;
@property (nonatomic, strong) MultTableView *threeLinkageDropMenu;

@property (nonatomic, strong) NSArray *addressArr;
@property (nonatomic, strong) NSArray *categoriesArr;
@property (nonatomic, strong) NSArray *sortsArr;

@end

@implementation MultMenuView

#pragma mark -- init

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        //1.
        self.oneLinkageButton = [UIButton buttonWithType:UIButtonTypeCustom];
        self.oneLinkageButton.frame = CGRectMake(0, 0, Screen_Width/3, 36);
        [self setUpButton:self.oneLinkageButton withText:@"一级"];
        
        self.oneLinkageDropMenu = [[MultTableView alloc] init];
        self.oneLinkageDropMenu.arrowView = self.oneLinkageButton.imageView;
        self.oneLinkageDropMenu.delegate = self;
        
        //2.
        self.twoLinkageButton = [UIButton buttonWithType:UIButtonTypeCustom];
        self.twoLinkageButton.frame = CGRectMake(Screen_Width/3, 0, Screen_Width/3, 36);
        [self setUpButton:self.twoLinkageButton withText:@"二级"];
        
        self.twoLinkageDropMenu = [[MultTableView alloc] init];
        self.twoLinkageDropMenu.arrowView = self.twoLinkageButton.imageView;
        self.twoLinkageDropMenu.delegate = self;
        
        //3.
        self.threeLinkageButton = [UIButton buttonWithType:UIButtonTypeCustom];
        self.threeLinkageButton.frame = CGRectMake(2 * Screen_Width/3, 0,  Screen_Width/3, 36);
        [self setUpButton:self.threeLinkageButton withText:@"三级"];
        
        self.threeLinkageDropMenu = [[MultTableView alloc] init];
        self.threeLinkageDropMenu.arrowView = self.threeLinkageButton.imageView;
        self.threeLinkageDropMenu.delegate = self;
        
        //最下面的横线
        UIView *horizontalLine2 = [[UIView alloc] initWithFrame:CGRectMake(0, self.frame.size.height - 1.0f, Screen_Width, 1.0f)];
        horizontalLine2.backgroundColor = [UIColor grayColor];
        [self addSubview:horizontalLine2];
    }
    return self;
}

#pragma mark -- action

-(void)clickButton:(UIButton *)button{
    
    if (button == self.oneLinkageButton) {
        
        [self.twoLinkageDropMenu dismissView];
        [self.threeLinkageDropMenu dismissView];
        
        [self.oneLinkageDropMenu createMultTableWithView:self tableViewType:1 withData:self.sortsArr];
    }else if (button == self.twoLinkageButton){
        
        [self.oneLinkageDropMenu dismissView];
        [self.threeLinkageDropMenu dismissView];
        
         [self.twoLinkageDropMenu createMultTableWithView:self tableViewType:2 withData:self.categoriesArr];
        
    }else if (button == self.threeLinkageButton){
        
        [self.oneLinkageDropMenu dismissView];
        [self.twoLinkageDropMenu dismissView];
        
         [self.threeLinkageDropMenu createMultTableWithView:self tableViewType:3 withData:self.addressArr];
    }
}

#pragma mark -- MultTableViewDelegate

- (void)multTableViewClickWithString:(NSString *)text {
    if ([self.delegate respondsToSelector:@selector(multMenuViewWithString:)]) {
        [self.delegate multMenuViewWithString:text];
    }
}

#pragma mark -- private method

-(void)setUpButton:(UIButton *)button withText:(NSString *)str{
    
    [button addTarget:self action:@selector(clickButton:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:button];
    [button setTitle:str forState:UIControlStateNormal];
    button.titleLabel.font =  [UIFont systemFontOfSize:14.0f];
    button.titleLabel.lineBreakMode = NSLineBreakByTruncatingTail;
    [button setTitleColor:[UIColor colorWithWhite:0.3 alpha:1.0] forState:UIControlStateNormal];
    [button setImage:[UIImage imageNamed:@"downarr"] forState:UIControlStateNormal];
    
    [self buttonEdgeInsets:button];
    //间隔线
    UIView *verticalLine = [[UIView alloc]init];
    verticalLine.backgroundColor = [UIColor colorWithWhite:0.9 alpha:1.0];
    [button addSubview:verticalLine];
    verticalLine.frame = CGRectMake(button.frame.size.width - 0.5, 10, 1, 16);
}

-(void)buttonEdgeInsets:(UIButton *)button{
    
    [button setTitleEdgeInsets:UIEdgeInsetsMake(0, -button.imageView.bounds.size.width + 2, 0, button.imageView.bounds.size.width + 5)];
    [button setImageEdgeInsets:UIEdgeInsetsMake(0, button.titleLabel.bounds.size.width + 5, 0, -button.titleLabel.bounds.size.width + 2)];
    
}

#pragma mark -- getter and setter

- (NSArray *)addressArr{
    if (_addressArr == nil) {
        NSDictionary *dic = [NSDictionary dictionaryWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"address.plist" ofType:nil]];
        _addressArr = dic[@"address"];
    }
    return _addressArr;
}

- (NSArray *)categoriesArr{
    if (_categoriesArr == nil) {
        _categoriesArr = [NSArray arrayWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"categories.plist" ofType:nil]];
    }
    return _categoriesArr;
}

- (NSArray *)sortsArr{
    if (_sortsArr == nil) {
        _sortsArr =  [NSArray arrayWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"sorts.plist" ofType:nil]];
    }
    return _sortsArr;
}

@end
