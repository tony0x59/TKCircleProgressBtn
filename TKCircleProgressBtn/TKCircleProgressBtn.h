//
//  TKCircleProgressBtn.h
//  CircleBtnDemo
//
//  Created by Tony on 14-6-17.
//  Copyright (c) 2014年 itony.me. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, TKCircleProgressBtnState) {
    TKCircleProgressBtnStateInitial   = 1,
    TKCircleProgressBtnStateBuffering = 2,
    TKCircleProgressBtnStatePlaying   = 3,
    TKCircleProgressBtnStatePause     = 4,
    TKCircleProgressBtnStateStop      = TKCircleProgressBtnStateInitial,
};

@interface TKCircleProgressBtn : UIControl

@property (nonatomic, assign) CGFloat progress;
@property (nonatomic, assign) BOOL    isAnimatedProgress;   // default YES
@property (nonatomic, assign) CGFloat perAnimProgressDuration; // default 1.0 sec
@property (nonatomic, assign) CGFloat perAnimProgressValueChangeThreshold;  // default 0.05 sec
- (void)setProgress:(CGFloat)progress withAnimateDuration:(NSTimeInterval)duration;

@property (nonatomic, assign) TKCircleProgressBtnState btnState;
- (void)reset;

@property (nonatomic, readonly) UILabel *initialLabel;
@property (nonatomic, readonly) UILabel *playingLabel;

@property (nonatomic, strong) UIColor *tintColor;   // default magentaColor

@property (nonatomic, assign) CGPoint initialBtnOffset;

@property (nonatomic, assign) BOOL    rotate;

@end
