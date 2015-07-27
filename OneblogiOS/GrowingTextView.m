//
//  GrowingTextView.m
//  iosapp
//
//  Created by Terwer Green on 11/17/14.
//  Copyright (c) 2014 Terwer Green. All rights reserved.
//

#import "GrowingTextView.h"

@implementation GrowingTextView

- (instancetype)initWithPlaceholder:(NSString *)placeholder
{
    self = [super initWithPlaceholder:placeholder];
    if (self) {
        self.font = [UIFont systemFontOfSize:16];
        self.scrollEnabled = NO;
        self.scrollsToTop = NO;
        self.showsHorizontalScrollIndicator = NO;
        self.enablesReturnKeyAutomatically = YES;
        self.textContainerInset = UIEdgeInsetsMake(7.5, 3.5, 7.5, 0);
        //NSLog(@"%@, %f", self.font, self.font.lineHeight);
        _maxNumberOfLines = 4;
        _maxHeight = ceilf(self.font.lineHeight * _maxNumberOfLines + 15 + 4 * (_maxNumberOfLines - 1));
    }
    
    return self;
}

// Code from apple developer forum - @Steve Krulewitz, @Mark Marszal, @Eric Silverberg
- (CGFloat)measureHeight
{
    //[self layoutIfNeeded];
    //NSLog(@"frameHeight: %f", self.frame.size.height);
    //NSLog(@"lineHeight: %f", self.font.lineHeight);
    //NSLog(@"contentSize:(height): %f, (width):%f", self.contentSize.height, self.contentSize.width);
    //NSLog(@"Height: %f", [self sizeThatFits:self.frame.size].height + 15);
    
    
    return ceilf([self sizeThatFits:self.frame.size].height + 10);
}


@end
