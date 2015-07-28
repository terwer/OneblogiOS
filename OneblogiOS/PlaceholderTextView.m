//
//  PlaceholderTextView.m
//  iosapp
//
//  Created by Terwer Green on 3/3/15.
//  Copyright (c) 2015 Terwer Green. All rights reserved.
//

#import "PlaceholderTextView.h"
#import "AppDelegate.h"
#import "Config.h"

@interface PlaceholderTextView ()

@property (nonatomic, strong) UILabel *placeholderLabel;

@end

@implementation PlaceholderTextView

- (instancetype)initWithPlaceholder:(NSString *)placeholder
{
    self = [super init];
    if (self) {
        [self setUpPlaceholderLabel:placeholder];
        ((AppDelegate *)[UIApplication sharedApplication].delegate).inNightMode = [Config getMode];
        if (((AppDelegate *)[UIApplication sharedApplication].delegate).inNightMode) {
            self.keyboardAppearance = UIKeyboardAppearanceDark;
        } else {
            self.keyboardAppearance = UIKeyboardAppearanceLight;
        }
    }
    
    return self;
}

- (void)setUpPlaceholderLabel:(NSString *)placeholder
{
    _placeholderLabel = [UILabel new];
    _placeholderLabel.textColor = [UIColor lightGrayColor];
    _placeholderLabel.backgroundColor = [UIColor clearColor];
    _placeholderLabel.text = placeholder;
    [self addSubview:_placeholderLabel];
    
    _placeholderLabel.translatesAutoresizingMaskIntoConstraints = NO;
    NSDictionary *views = NSDictionaryOfVariableBindings(_placeholderLabel);
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"|-8-[_placeholderLabel]-6-|" options:0 metrics:nil views:views]];
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-7-[_placeholderLabel]"   options:0 metrics:nil views:views]];
}


- (void)checkShouldHidePlaceholder
{
    _placeholderLabel.hidden = [self hasText];
}


#pragma mark - property accessor
#pragma mark placeholder

- (void)setPlaceholder:(NSString *)placeholder
{
    _placeholderLabel.text = placeholder;
}

- (NSString *)placeholder
{
    return _placeholderLabel.text;
}

#pragma mark placeholderFont

- (void)setPlaceholderFont:(UIFont *)placeholderFont
{
    _placeholderLabel.font = placeholderFont;
}

- (UIFont *)placeholderFont
{
    return _placeholderLabel.font;
}




@end
