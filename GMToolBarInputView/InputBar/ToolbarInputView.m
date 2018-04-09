//
//  MGCommentToolBarView.m
//  MGComp
//
//  Created by 顾玉玺 on 2018/4/8.
//  Copyright © 2018年 Migu Video Technology. All rights reserved.
//

#import "ToolbarInputView.h"
@interface ToolbarInputView()<UITextViewDelegate>

@property (nonatomic, strong) UILabel *palceHolderLabel;

@property (nonatomic, strong) UITapGestureRecognizer *tapGesture;

@property (nonatomic) CGFloat keyboardH;

@property (nonatomic) CGFloat singleLineHeight;

@property (nonatomic) CGFloat textViewH;

@property (nonatomic) CGFloat toolBarH;

@property (nonatomic) ToolBarRightViewState state;

@end

static int toolBarMaxLines = 5;
static CGFloat spaceH = 8;
static CGFloat spaceL = 12;

#define KH [UIScreen mainScreen].bounds.size.height
#define KW [UIScreen mainScreen].bounds.size.width

static CGFloat textViewFontSize = 15;



@implementation ToolbarInputView

#pragma mark - envent
- (void)enventForTapTableViewToDimissKeyboard:(UITapGestureRecognizer *)sender{
    [self.textView resignFirstResponder];
}

- (void)enventForKeyboard:(NSNotification *)noti{
    NSDictionary *userInfo = noti.userInfo;
    CGRect keyboardFrame = [userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    NSTimeInterval animationDuration = [userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    
    self.keyboardH = keyboardFrame.size.height;
    
    if (noti.name == UIKeyboardWillShowNotification) {
        self.state = RightViewStateEditting;
    }else{
        self.state = RightViewStateDown;
    }
    
    [UIView animateWithDuration:animationDuration delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        if (noti.name == UIKeyboardWillShowNotification) {
            self.transform = CGAffineTransformMakeTranslation(0, -keyboardFrame.size.height);
            self.alpha = 1;
            
            CGRect rect = [self.scrolledToToolBarTopOfCell convertRect:self.scrolledToToolBarTopOfCell.bounds toView:[UIApplication sharedApplication].keyWindow];
            CGFloat offY = keyboardFrame.size.height - (KH - CGRectGetMaxY(rect )- self.toolBarH);
            if (offY>keyboardFrame.size.height) {
                [self.tableView scrollToRowAtIndexPath:[self.tableView indexPathForCell:self.scrolledToToolBarTopOfCell] atScrollPosition:UITableViewScrollPositionBottom animated:false];
                self.tableView.transform = CGAffineTransformMakeTranslation(0, -keyboardFrame.size.height);
            }else if (offY>0){
                self.tableView.transform = CGAffineTransformMakeTranslation(0, -offY);
            }
        }else{
            if (self.hiddenToolBarWhenKeyboardDismiss) {
                self.alpha = 0;
            }
            self.transform = CGAffineTransformIdentity;
            self.tableView.transform = CGAffineTransformIdentity;
        }
    } completion:^(BOOL finished) {
        if (noti.name == UIKeyboardWillHideNotification && self.hiddenToolBarWhenKeyboardDismiss) {
            [self removeFromSuperview];
            [self.tableView removeGestureRecognizer:self.tapGesture];
        }else{
            [self.tableView addGestureRecognizer:self.tapGesture];
        }
    }];
}
#pragma mark - observer
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context{
    CGSize oldSize = [change[NSKeyValueChangeOldKey] CGSizeValue];
    CGSize newSize = [change[NSKeyValueChangeNewKey] CGSizeValue];
    CGFloat height = [self.textView sizeThatFits:CGSizeMake(self.textView.frame.size.width, CGFLOAT_MAX )].height;
    if (MAX(oldSize.height, newSize.height)<= self.textViewH) {
        return;
    }
    if (height - toolBarMaxLines * self.singleLineHeight>0) {
        return;
    }
    [UIView animateWithDuration:0.25 animations:^{
        self.frame = CGRectMake(0,  KH - self.keyboardH - (height + spaceH*2), KW, height + spaceL*2);
        CGRect rect = self.textView.frame;
        rect.size.height = height;
        self.textView.frame = rect;
 
        CGFloat offY = newSize.height > oldSize.height ? -self.singleLineHeight:self.singleLineHeight;
        self.tableView.transform = CGAffineTransformTranslate(self.tableView.transform, 0, offY);
    }];
}

#pragma mark - init
- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        
        [self addSubview:self.textView];
        [self.textView addSubview:self.palceHolderLabel];
        
        self.frame = CGRectMake(0, KH - self.toolBarH, KW, self.toolBarH);

        self.backgroundColor = [UIColor colorWithRed:216/255 green:216/255 blue:216/255 alpha:1];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(enventForKeyboard:) name:UIKeyboardWillShowNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(enventForKeyboard:) name:UIKeyboardWillHideNotification object:nil];
        
    }
    return self;
}

#pragma mark - textview delegate
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    if ([text isEqualToString: @""]) {
        [textView scrollRangeToVisible:range];
    }
    if ([text isEqualToString:@"\n"]) {
        //TODO: delegate
        
        [textView resignFirstResponder];
        return false;
    }
    return true;
}

- (void)textViewDidChange:(UITextView *)textView{
    if (self.placeHolderText) {
        self.palceHolderLabel.hidden = textView.text.length>0;
    }
}


#pragma mark - set
- (void)setTableView:(UITableView *)tableView{
    _tableView = tableView;
    [_tableView addGestureRecognizer:self.tapGesture];
}

- (void)setPlaceHolderText:(NSString *)placeHolderText{
    _placeHolderText = placeHolderText;
    self.palceHolderLabel.text = placeHolderText;
}

- (void)layoutRightView:(UIView *)rightView{
    CGFloat width = CGRectGetWidth(rightView.frame);
    CGRect rect = self.textView.frame;
    rect.size.width = KW - width - spaceL*2;
    self.textView.frame = rect;
    rightView.frame = CGRectMake(CGRectGetMaxX(self.textView.frame), CGRectGetHeight(self.frame) - self.toolBarH, width, self.toolBarH);
    rightView.autoresizingMask = UIViewAutoresizingFlexibleTopMargin;

}
- (void)setState:(ToolBarRightViewState)state{
    _state = state;
    if (state == RightViewStateDown) {
        [self layoutRightView:self.rightViewWhileNormal];
        self.rightViewWhileEditting.hidden = YES;
        self.rightViewWhileNormal.hidden = NO;
    }else if (state == RightViewStateEditting){
        [self layoutRightView:self.rightViewWhileEditting];
        self.rightViewWhileEditting.hidden = NO;
        self.rightViewWhileNormal.hidden = YES;
    }
}

- (void)setRightViewWhileNormal:(UIView *)rightViewWhileNormal{
    _rightViewWhileNormal = rightViewWhileNormal;
    [self layoutRightView:rightViewWhileNormal];
    [self addSubview:rightViewWhileNormal];
}
- (void)setRightViewWhileEditting:(UIView *)rightViewWhileEditting{
    _rightViewWhileEditting = rightViewWhileEditting;
    rightViewWhileEditting.hidden = YES;
    [self addSubview:rightViewWhileEditting];
}
#pragma mark - get

- (CGFloat)singleLineHeight{
    return floorf([UIFont systemFontOfSize:textViewFontSize].lineHeight);
}
- (CGFloat)textViewH{
    return self.singleLineHeight + 17;
}

- (CGFloat)toolBarH{
    return self.textViewH + spaceH*2;
}

- (UITextView *)textView{
    if (!_textView) {
        _textView = [[UITextView alloc]initWithFrame:CGRectMake(spaceL, spaceH, KW - spaceL*2, self.textViewH)];
        _textView.backgroundColor = [UIColor whiteColor];
        _textView.returnKeyType = UIReturnKeySend;
        _textView.font = [UIFont systemFontOfSize:textViewFontSize];
        _textView.delegate = self;
        _textView.layer.borderColor = [UIColor lightGrayColor].CGColor;
        _textView.layer.borderWidth = 0.5;
        _textView.layer.cornerRadius = 5;
        [_textView addObserver:self forKeyPath:@"contentSize" options:NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld context:nil];
    }
    return _textView;
}

- (UILabel *)palceHolderLabel{
    if (!_palceHolderLabel) {
        _palceHolderLabel = [[UILabel alloc]initWithFrame:CGRectInset(self.textView.bounds, 5, 0)];
        _palceHolderLabel.font = self.textView.font;
        _palceHolderLabel.numberOfLines = 1;
        _palceHolderLabel.textColor = [UIColor colorWithRed:72/256 green:82/256 blue:93/256 alpha:1];
    }
    return _palceHolderLabel;
}

- (UITapGestureRecognizer *)tapGesture{
    if (!_tapGesture) {
        _tapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(enventForTapTableViewToDimissKeyboard:)];
//        _tapGesture.delegate = self;
    }
    return _tapGesture;
}


- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
