//
//  MultMenuView.h
//  MultilevelList
//
//  Created by lx on 2017/11/17.
//  Copyright © 2017年 pingan. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol MultMenuViewDelegate <NSObject>

- (void)multMenuViewWithString:(NSString *)text;

@end

@interface MultMenuView : UIView

@property (nonatomic, assign)id<MultMenuViewDelegate> delegate;

@end
