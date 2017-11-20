//
//  ViewController.m
//  MultilevelList
//
//  Created by lx on 2017/11/17.
//  Copyright © 2017年 pingan. All rights reserved.
//

#import "ViewController.h"
#import "Const.h"
#import "MultMenuView.h"

@interface ViewController ()<MultMenuViewDelegate>

@property(nonatomic, strong) MultMenuView *menuView;

@end

@implementation ViewController

#pragma mark -- life cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    self.menuView = [[MultMenuView alloc] initWithFrame:CGRectMake(0, 64, Screen_Width, 36)];
    self.menuView.delegate = self;
    [self.view addSubview:self.menuView];
    
}

#pragma mark -- MultMenuViewDelegate

- (void)multMenuViewWithString:(NSString *)text{
    NSLog(@"------------------:%@",text);
}

@end
