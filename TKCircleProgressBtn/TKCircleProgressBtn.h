//
//  TKCircleProgressBtn.h
//  CircleBtnDemo
//
//  Created by Tony on 14-6-17.
//  Copyright (c) 2014年 itony.me. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, TKCircleProgressBtnState) {
    TKCircleProgressBtnStateInitial = 1,
    TKCircleProgressBtnStatePlaying = 2,
    TKCircleProgressBtnStatePause   = 3,
    TKCircleProgressBtnStateStop    = TKCircleProgressBtnStateInitial,
};

@interface TKCircleProgressBtn : UIControl

@property (nonatomic, assign) CGFloat progress;
- (void)setProgress:(CGFloat)progress withAnimateDuration:(NSTimeInterval)duration;

@property (nonatomic, assign) TKCircleProgressBtnState btnState;
- (void)reset;

@property (nonatomic, readonly) UILabel *initialLabel;
@property (nonatomic, readonly) UILabel *playingLabel;

@property (nonatomic, strong) UIColor *tintColor;

@property (nonatomic, assign) CGPoint initialBtnOffset;

@property (nonatomic, assign) BOOL    rotate;

@end
