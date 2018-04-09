//
//  MGCommentToolBarView.h
//  MGComp
//
//  Created by 顾玉玺 on 2018/4/8.
//  Copyright © 2018年 Migu Video Technology. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, ToolBarRightViewState) {
    RightViewStateDown,
    RightViewStateEditting,
};

@interface ToolbarInputView : UIView


/**
 输入框
 */
@property (nonatomic, strong) UITextView *textView;


/**
 默认显示的文本
 */
@property (nonatomic, strong) NSString *placeHolderText;


/**
 default no
 */
@property (nonatomic) BOOL hiddenToolBarWhenKeyboardDismiss;


/**
 设置tableview 在键盘弹出时,tableview 自动抬起
 */
@property (nonatomic, strong) UITableView *tableView;


/**
 tableview 抬起时,滑动到将要显示的cell
 */
@property (nonatomic, strong) UITableViewCell *scrolledToToolBarTopOfCell;


/**
 自定义view
 */
@property (nonatomic, strong) UIView *rightViewWhileNormal;


/**
 自定义编辑view
 */
@property (nonatomic, strong) UIView *rightViewWhileEditting;


- (CGFloat)toolBarH;


@end

//ToolbarInputView *bar = [[ToolbarInputView alloc]initWithFrame:CGRectMake(0, 300, 300, 44)];
//
//UIView *v = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 114, 4)];
//v.backgroundColor = [UIColor orangeColor];
//bar.rightViewWhileNormal = v;
//
//for (int i = 0; i<3; i++) {
//    UIButton *btn = [UIButton buttonWithType:UIButtonTypeSystem];
//    [btn setBackgroundImage:[UIImage imageNamed:@"icon _download"] forState:UIControlStateNormal];
//    [v addSubview:btn];
//}
//[v.subviews mas_makeConstraints:^(MASConstraintMaker *make) {
//    make.centerY.offset(0);
//}];
//[v.subviews mas_distributeViewsAlongAxis:MASAxisTypeHorizontal withFixedSpacing:8 leadSpacing:8 tailSpacing:0];
//
//UIView *edit = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 68, 4)];
//
//UIButton *btn = [UIButton buttonWithType:UIButtonTypeSystem];
//[btn setTitle:@"发送" forState:UIControlStateNormal];
//btn.layer.cornerRadius = 4;
//btn.backgroundColor = [UIColor blueColor];
//[edit addSubview:btn];
//
//[btn mas_makeConstraints:^(MASConstraintMaker *make) {
//    make.left.offset(8);
//    make.centerY.offset(0);
//    make.size.mas_equalTo(CGSizeMake(60, 40));
//}];
//
//bar.rightViewWhileEditting = edit;
//bar.placeHolderText = @"11111111111";
//[self.view addSubview:bar];
