//
//  MultTableView.h
//  MultilevelList
//
//  Created by lx on 2017/11/17.
//  Copyright © 2017年 pingan. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, MultTableViewType){
    MultTableViewTypeOne = 1,
    MultTableViewTypeTwo,
    MultTableViewTypeThree
};

@protocol MultTableViewDelegate <NSObject>

- (void)multTableViewClickWithView:(UIView *)view withSelectText:(NSString *)text;

@end

@interface MultTableView : UIView

//箭头View
@property (nonatomic, strong) UIView *arrowView;

@property (nonatomic, assign) id<MultTableViewDelegate> delegate;

- (void)createMultTableWithView:(UIView *)view tableViewType:(MultTableViewType)type withData:(NSArray *)dataArray;

- (void)dismissView;

@end
