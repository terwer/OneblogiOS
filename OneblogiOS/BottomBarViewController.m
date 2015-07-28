//
//  BottomBarViewController.m
//  iosapp
//
//  Created by Terwer Green on 11/19/14.
//  Copyright (c) 2014 Terwer Green. All rights reserved.
//

#import "BottomBarViewController.h"
#import "EditingBar.h"
#import "OperationBar.h"
#import "GrowingTextView.h"
#import "EmojiPageVC.h"
#import "Config.h"
#import "Utils.h"
#import "LoginViewController.h"


@interface BottomBarViewController () <UITextViewDelegate>

@property (nonatomic, assign) BOOL hasAModeSwitchButton;
@property (nonatomic, strong) EmojiPageVC *emojiPageVC;
@property (nonatomic, assign) BOOL isEmojiPageOnScreen;

@end

@implementation BottomBarViewController

- (instancetype)initWithModeSwitchButton:(BOOL)hasAModeSwitchButton
{
    self = [super init];
    if (self) {
        _editingBar = [[EditingBar alloc] initWithModeSwitchButton:hasAModeSwitchButton];
        _editingBar.editView.delegate = self;
        if (hasAModeSwitchButton) {
            _hasAModeSwitchButton = hasAModeSwitchButton;
            _operationBar = [OperationBar new];
            _operationBar.hidden = YES;
        }
    }
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor themeColor];
    
    [self setup];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark -

- (void)setup
{
    [self addBottomBar];
    _emojiPageVC = [[EmojiPageVC alloc] initWithTextView:_editingBar.editView];
    [self.view addSubview:_emojiPageVC.view];
    _emojiPageVC.view.hidden = YES;
    _emojiPageVC.view.translatesAutoresizingMaskIntoConstraints = NO;
    NSDictionary *views = @{@"emojiPage": _emojiPageVC.view};
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[emojiPage(216)]|" options:0 metrics:nil views:views]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"|[emojiPage]|" options:0 metrics:nil views:views]];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textDidUpdate:)    name:UITextViewTextDidChangeNotification object:nil];
}


- (void)addBottomBar
{
    _editingBar.translatesAutoresizingMaskIntoConstraints = NO;
    [_editingBar.inputViewButton addTarget:self action:@selector(switchInputView) forControlEvents:UIControlEventTouchUpInside];
    [_editingBar.modeSwitchButton addTarget:self action:@selector(switchMode) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_editingBar];
    
    _editingBarYConstraint = [NSLayoutConstraint constraintWithItem:self.view    attribute:NSLayoutAttributeBottom   relatedBy:NSLayoutRelationEqual
                                                             toItem:_editingBar  attribute:NSLayoutAttributeBottom   multiplier:1.0 constant:0];
    
    _editingBarHeightConstraint = [NSLayoutConstraint constraintWithItem:_editingBar attribute:NSLayoutAttributeHeight         relatedBy:NSLayoutRelationEqual
                                                                  toItem:nil         attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:[self minimumInputbarHeight]];
    
    [self.view addConstraint:_editingBarYConstraint];
    [self.view addConstraint:_editingBarHeightConstraint];
    
    if (_hasAModeSwitchButton) {
        [_operationBar.modeSwitchButton addTarget:self action:@selector(switchMode) forControlEvents:UIControlEventTouchUpInside];
        __weak BottomBarViewController *weakSelf = self;
        _operationBar.switchMode = ^ {[weakSelf switchMode];};
        _operationBar.editComment = ^ {
            [weakSelf switchMode];
            [weakSelf.editingBar.editView becomeFirstResponder];
        };
        
        _operationBar.translatesAutoresizingMaskIntoConstraints = NO;
        [self.view addSubview:_operationBar];
        NSDictionary *metrics = @{@"height": @([self minimumInputbarHeight])};
        NSDictionary *views = NSDictionaryOfVariableBindings(_operationBar);
        [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[_operationBar(height)]|" options:0 metrics:metrics views:views]];
        [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"|[_operationBar]|" options:0 metrics:nil views:views]];
    }
}


- (void)switchInputView
{
    if (_isEmojiPageOnScreen) {
        _emojiPageVC.view.hidden = YES;
        [_editingBar.editView becomeFirstResponder];
        
        [_editingBar.inputViewButton setImage:[UIImage imageNamed:@"toolbar-emoji2"] forState:UIControlStateNormal];
        _isEmojiPageOnScreen = NO;
    } else {
        [_editingBar.editView resignFirstResponder];
        [_editingBar.inputViewButton setImage:[UIImage imageNamed:@"toolbar-text"] forState:UIControlStateNormal];
        
        _editingBarYConstraint.constant = 216;
        [self setBottomBarHeight];
        _emojiPageVC.view.hidden = NO;
        _isEmojiPageOnScreen = YES;
    }
}

- (void)switchMode
{
    if (_operationBar.isHidden) {
        [_editingBar.editView resignFirstResponder];
        _editingBar.hidden = YES;
        _operationBar.hidden = NO;
    } else {
        _operationBar.hidden = YES;
        _editingBar.hidden = NO;
    }
}



#pragma mark - textView的基本设置

- (GrowingTextView *)textView
{
    return _editingBar.editView;
}

- (CGFloat)minimumInputbarHeight
{
    return _editingBar.intrinsicContentSize.height;
}

- (CGFloat)deltaInputbarHeight
{
    return _editingBar.intrinsicContentSize.height - self.textView.font.lineHeight;
}

- (CGFloat)barHeightForLines:(NSUInteger)numberOfLines
{
    CGFloat height = [self deltaInputbarHeight];
    
    height += roundf(self.textView.font.lineHeight * numberOfLines);
    
    return height;
}





#pragma mark - 调整bar的高度

- (void)keyboardWillShow:(NSNotification *)notification
{
    CGRect keyboardBounds = [notification.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    _editingBarYConstraint.constant = keyboardBounds.size.height;
    
    _emojiPageVC.view.hidden = YES;
    _isEmojiPageOnScreen = NO;
    [_editingBar.inputViewButton setImage:[UIImage imageNamed:@"toolbar-emoji2"] forState:UIControlStateNormal];
    
    [self setBottomBarHeight];
}

- (void)keyboardWillHide:(NSNotification *)notification
{
    _editingBarYConstraint.constant = 0;

    [self setBottomBarHeight];
}

- (void)setBottomBarHeight
{
#if 0
    NSTimeInterval animationDuration;
    [notification.userInfo[UIKeyboardAnimationDurationUserInfoKey] getValue:&animationDuration];
    
    UIViewKeyframeAnimationOptions animationOptions;
    animationOptions = [notification.userInfo[UIKeyboardAnimationCurveUserInfoKey] integerValue] << 16;
#endif
    // 用注释的方法有可能会遮住键盘
    
    [self.view setNeedsUpdateConstraints];
    [UIView animateKeyframesWithDuration:0.25       //animationDuration
                                   delay:0
                                 options:7 << 16    //animationOptions
                              animations:^{
                                  [self.view layoutIfNeeded];
                              } completion:nil];
}



#pragma mark - 编辑框相关

- (void)textDidUpdate:(NSNotification *)notification
{
    [self updateInputBarHeight];
}

- (void)updateInputBarHeight
{
    CGFloat inputbarHeight = [self appropriateInputbarHeight];
    
    if (inputbarHeight != self.editingBarHeightConstraint.constant) {
        self.editingBarHeightConstraint.constant = inputbarHeight;
        
        [self.view layoutIfNeeded];
    }
}

- (CGFloat)appropriateInputbarHeight
{
    CGFloat height = 0;
    CGFloat minimumHeight = [self minimumInputbarHeight];
    CGFloat newSizeHeight = [self.textView measureHeight];
    CGFloat maxHeight     = self.textView.maxHeight;
    
    self.textView.scrollEnabled = newSizeHeight >= maxHeight;
    
    if (newSizeHeight < minimumHeight) {
        height = minimumHeight;
    } else if (newSizeHeight < self.textView.maxHeight) {
        height = newSizeHeight;
    } else {
        height = self.textView.maxHeight;
    }
    
    return roundf(height);
}


- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if ([text isEqualToString: @"\n"]) {
        if (![Config getAuthoizedApiInfo]) {
            [self.navigationController pushViewController:[LoginViewController new] animated:YES];
        } else {
            [self sendContent];
            [textView resignFirstResponder];
        }
        return NO;
    }
    return YES;
}


#pragma mark - 收起表情面板

- (void)hideEmojiPageView
{
    if (_editingBarYConstraint.constant != 0) {
        _emojiPageVC.view.hidden = YES;
        _isEmojiPageOnScreen = NO;
        
        [_editingBar.inputViewButton setImage:[UIImage imageNamed:@"toolbar-emoji2"] forState:UIControlStateNormal];
        _editingBarYConstraint.constant = 0;
        [self setBottomBarHeight];
    }
}


// ugly
- (void)textViewDidEndEditing:(PlaceholderTextView *)textView
{
    [textView checkShouldHidePlaceholder];
}

- (void)textViewDidChange:(PlaceholderTextView *)textView
{
    [textView checkShouldHidePlaceholder];
}


- (void)sendContent
{
    NSAssert(false, @"Over ride in subclasses");
}





@end
