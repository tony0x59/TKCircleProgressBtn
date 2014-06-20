//
//  TKCircleProgressBtn.m
//  CircleBtnDemo
//
//  Created by Tony on 14-6-17.
//  Copyright (c) 2014年 itony.me. All rights reserved.
//

#import "TKCircleProgressBtn.h"
#import <QuartzCore/QuartzCore.h>


#define DEGREES_TO_RADIANS(degrees)  ((M_PI * ((degrees) - 90))/ 180)


@interface TKCircleProgressBtn ()

@property (nonatomic, assign) BOOL isShinkCircle;
@property (nonatomic, assign) BOOL isBuffering;

@end


@implementation TKCircleProgressBtn {
    UIBezierPath *circlePath;
    UIBezierPath *tranglePath;
    UIBezierPath *bufferingPath;
    
    CALayer *mainLayer;
    CAShapeLayer *progressLayer;
    CALayer      *thumbLayer;
    CAShapeLayer *trangleLayer;
    
    CAShapeLayer *leftArrow;
    CAShapeLayer *rightArrow;
    CAShapeLayer *circleLayer;
    
    UIView *borderView;
    
    CGRect  innerRect;
    CGFloat thumbRadius;
    CGFloat margin;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _tintColor = [UIColor magentaColor];
        
        [self initSquareButtonLayer];
        
        [self initCircleButtonLayer];
        
        [self initArrowLayer];
        
        self.btnState = TKCircleProgressBtnStateInitial;
    }
    return self;
}

#pragma mark - init

- (void)initSquareButtonLayer
{
    CGRect frame = self.frame;
    
    borderView = [[UIView alloc] init];
    borderView.center = CGPointMake(frame.size.width/2, frame.size.height/2);
    borderView.bounds = CGRectMake(0, 0, CGRectGetWidth(self.bounds)*1.15, CGRectGetHeight(self.bounds)*0.44);
    borderView.layer.borderColor = _tintColor.CGColor;
    borderView.layer.cornerRadius = 5.0;
    borderView.layer.borderWidth = 1.0;
    borderView.userInteractionEnabled = NO;
    [self addSubview:borderView];
    
    _initialLabel = [[UILabel alloc] init];
    _initialLabel.center = CGPointMake(CGRectGetWidth(borderView.bounds)/2 + 12,
                                       CGRectGetHeight(borderView.bounds)/2 - 0.5);
    _initialLabel.bounds = borderView.bounds;
    _initialLabel.text = @"试听";
    _initialLabel.backgroundColor = [UIColor clearColor];
    _initialLabel.textColor = _tintColor;
    _initialLabel.textAlignment = NSTextAlignmentCenter;
    _initialLabel.font = [UIFont systemFontOfSize:14.0];
    _initialLabel.userInteractionEnabled = NO;
    [borderView addSubview:_initialLabel];
}

- (void)initCircleButtonLayer
{
    CGRect frame = self.frame;
    
    margin = frame.size.width * 0.1;
    innerRect = CGRectInset(self.bounds, margin, margin);
    CGPoint center = CGPointMake(frame.size.width/2, frame.size.height/2);
    
    mainLayer = [CALayer layer];
    mainLayer.bounds = self.bounds;
    mainLayer.position = center;
    [self.layer addSublayer:mainLayer];
    
    circleLayer = [CAShapeLayer layer];
    circleLayer.bounds = self.bounds;
    circleLayer.position = center;
    circleLayer.path = [UIBezierPath bezierPathWithOvalInRect:innerRect].CGPath;
    circleLayer.strokeColor = [_tintColor colorWithAlphaComponent:0.5].CGColor;
    circleLayer.fillColor = nil;
    circleLayer.lineWidth = 1.0;
    [mainLayer addSublayer:circleLayer];
    
    _playingLabel = [[UILabel alloc] init];
    _playingLabel.center = center;
    _playingLabel.bounds = CGRectOffset(CGRectInset(innerRect, 5, 5), 0, 0);
    _playingLabel.backgroundColor = [UIColor clearColor];
    _playingLabel.font = [UIFont fontWithName:@"Hiragino Kaku Gothic ProN" size:13.0] ;
    _playingLabel.textColor = _tintColor;
    _playingLabel.textAlignment = NSTextAlignmentCenter;
    _playingLabel.text = @"04:35";
    _playingLabel.alpha = 0.0;
    [mainLayer addSublayer:_playingLabel.layer];
    
    CGFloat tlenth = innerRect.size.width / 2.5;
    tranglePath = [UIBezierPath bezierPath];
    [tranglePath moveToPoint:CGPointMake(center.x - tlenth/4, center.y - tlenth/2)];
    [tranglePath addLineToPoint:CGPointMake(center.x - tlenth/4, center.y + tlenth/2)];
    [tranglePath addLineToPoint:CGPointMake(center.x + sqrtf(powf(tlenth/4, 2) + powf(tlenth/2, 2)),
                                            center.y)];
    [tranglePath closePath];
    
    trangleLayer = [CAShapeLayer layer];
    trangleLayer.strokeColor = _tintColor.CGColor;
    trangleLayer.fillColor = nil;
    trangleLayer.lineWidth = 1.0;
    trangleLayer.path = tranglePath.CGPath;
    [mainLayer addSublayer:trangleLayer];
    
    circlePath = [UIBezierPath bezierPathWithArcCenter:center
                                                radius:(innerRect.size.width)/2
                                            startAngle:DEGREES_TO_RADIANS(0)
                                              endAngle:DEGREES_TO_RADIANS(360)
                                             clockwise:YES];
    
    progressLayer = [CAShapeLayer layer];
    progressLayer.path = circlePath.CGPath;
    progressLayer.strokeColor = _tintColor.CGColor;
    progressLayer.fillColor = nil;
    progressLayer.lineWidth = 1.5;
    progressLayer.strokeStart = 0.0;
    progressLayer.strokeEnd = 0.0;
    [mainLayer addSublayer:progressLayer];
    
    thumbRadius = frame.size.width * 0.03;
    thumbLayer = [CALayer layer];
    thumbLayer.position = CGPointMake(center.x, margin);
    thumbLayer.bounds = CGRectMake(0, 0, thumbRadius*2, thumbRadius*2);
    thumbLayer.cornerRadius = thumbRadius;
    thumbLayer.backgroundColor = _tintColor.CGColor;
    thumbLayer.opacity = 0.0;
    [mainLayer addSublayer:thumbLayer];
}

- (void)initArrowLayer
{
    /* the arrow */
    CGRect frame = self.frame;
    CGFloat len = frame.size.width * 0.1 / 2;
    CGPoint center = CGPointMake(frame.size.width/2, frame.size.height/2);
    
    UIBezierPath *path = [UIBezierPath bezierPath];
    
    /* top arrow */
    CGPoint tCenter = CGPointMake(center.x, margin);
    [path moveToPoint:CGPointMake(tCenter.x - len, tCenter.y - len)];
    [path addLineToPoint:CGPointMake(tCenter.x + len, tCenter.y)];
    [path addLineToPoint:CGPointMake(tCenter.x - len, tCenter.y + len)];
    
    /* bottom arrow */
    CGPoint bCenter = CGPointMake(center.x, center.y + innerRect.size.height/2);
    [path moveToPoint:CGPointMake(bCenter.x + len, bCenter.y - len)];
    [path addLineToPoint:CGPointMake(bCenter.x - len, bCenter.y)];
    [path addLineToPoint:CGPointMake(bCenter.x + len, bCenter.y + len)];
    
    /* left arc */
    CGFloat marginAngle = 20;
    [path moveToPoint:tCenter];
    [path addArcWithCenter:center
                    radius:innerRect.size.width/2
                startAngle:DEGREES_TO_RADIANS(3)
                  endAngle:DEGREES_TO_RADIANS(180 + marginAngle)
                 clockwise:NO];
    
    /* right arc */
    [path moveToPoint:bCenter];
    [path addArcWithCenter:center
                    radius:innerRect.size.width/2
                startAngle:DEGREES_TO_RADIANS(180 + 3)
                  endAngle:DEGREES_TO_RADIANS(marginAngle)
                 clockwise:NO];
    
    bufferingPath = path;
}

- (void)setInitialBtnOffset:(CGPoint)initialBtnOffset
{
    _initialBtnOffset = initialBtnOffset;
    borderView.center = CGPointMake(CGRectGetWidth(self.bounds)/2 + _initialBtnOffset.x,
                                    CGRectGetHeight(self.bounds)/2 + _initialBtnOffset.y);
    if (self.isShinkCircle) {
        [self updateCircleLayerLayout];
    }
}

#pragma mark - state

- (void)setBtnState:(TKCircleProgressBtnState)btnState
{
    if (_btnState != btnState) {
        _btnState = btnState;
        switch (_btnState) {
            case TKCircleProgressBtnStateInitial:
            {
                [self setIsShinkCircle:YES];
                [self showPauseStyle];
            }
                break;
            case TKCircleProgressBtnStateBuffering:
            {
                [self setIsShinkCircle:NO];
                [self showBufferingStyle:YES];
            }
                break;
            case TKCircleProgressBtnStatePlaying:
            {
                [self setIsShinkCircle:NO];
                [self showPlayingStyle];
            }
                break;
            case TKCircleProgressBtnStatePause:
            {
                [self setIsShinkCircle:NO];
                [self showPauseStyle];
            }
                break;
            default:
                break;
        }
    }
}

- (void)showPlayingStyle
{
    [UIView animateWithDuration:0.5 animations:^{
        _playingLabel.alpha = 1.0;
    }];
    thumbLayer.opacity = 1.0;
    progressLayer.opacity = 1.0;
    trangleLayer.opacity = 0.0;
    
    [self showBufferingStyle:NO];
}

- (void)showPauseStyle
{
    _playingLabel.alpha = 0.0;
    thumbLayer.opacity = 0.0;
    progressLayer.opacity = 0.0;
    trangleLayer.opacity = 1.0;
    
    // 三角形绘制动画
    CABasicAnimation *anim = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
    anim.fromValue = @0.0;
    anim.toValue = @1.0;
    anim.duration = 0.3;
    trangleLayer.strokeEnd = 1.0;
    [trangleLayer addAnimation:anim forKey:@"trangleAnimation"];
    
    [self showBufferingStyle:NO];
}

- (void)showBufferingStyle:(BOOL)isTrue
{
    if (isTrue == NO) {
        if (circleLayer.path == bufferingPath.CGPath) {
            [circleLayer removeAnimationForKey:@"bufferingAnimation"];
            circleLayer.path = circlePath.CGPath;
        }
        return;
    }
    
    [UIView animateWithDuration:0.5 animations:^{
        _playingLabel.alpha = 1.0;
    }];
    thumbLayer.opacity = 0.0;
    progressLayer.opacity = 0.0;
    trangleLayer.opacity = 0.0;
    
    circleLayer.path = bufferingPath.CGPath;
    circleLayer.strokeColor = _tintColor.CGColor;
    thumbLayer.opacity = 0.0;
    
    CABasicAnimation *animation;
    animation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    animation.toValue = [NSNumber numberWithFloat: M_PI * 2.0];
    animation.duration = 3.0;
    animation.cumulative = YES;
    animation.repeatCount = HUGE_VALF;
    
    [circleLayer addAnimation:animation forKey:@"bufferingAnimation"];
}

- (void)setIsShinkCircle:(BOOL)isShinkCircle
{
    _isShinkCircle = isShinkCircle;
    [self updateCircleLayerLayout];
}

- (void)updateCircleLayerLayout
{
    if (_isShinkCircle) {
        [UIView animateWithDuration:0.2 animations:^{
            borderView.alpha = 1.0;
        }];
        
        [CATransaction begin];
        [CATransaction setAnimationDuration:0.4];
        
        CGFloat radio = 0.38;
        mainLayer.transform = CATransform3DMakeScale(radio, radio, 1.0);
        
        CGFloat centerX = margin/2 + CGRectGetWidth(mainLayer.bounds) * radio / 2;
        CGFloat centerY = CGRectGetMidY(self.bounds);
        mainLayer.position = CGPointMake(centerX + _initialBtnOffset.x,
                                         centerY + _initialBtnOffset.y);
        circleLayer.lineWidth = 1.5;
        circleLayer.strokeColor = _tintColor.CGColor;
        [CATransaction commit];
    } else {
        [UIView animateWithDuration:0.2 animations:^{
            borderView.alpha = 0.0;
        }];
        
        [CATransaction begin];
        [CATransaction setAnimationDuration:0.4];
        mainLayer.transform = CATransform3DMakeScale(1.0, 1.0, 1.0);
        mainLayer.position = CGPointMake(CGRectGetMidX(self.bounds),
                                         CGRectGetMidY(self.bounds));
        circleLayer.lineWidth = 1.0;
        circleLayer.strokeColor = [_tintColor colorWithAlphaComponent:0.5].CGColor;
        [CATransaction commit];
    }
}

- (void)setProgress:(CGFloat)progress
{
    progress = MIN(MAX(progress, 0.0), 1.0);
    
    if (_progress != progress) {
        _progress = progress;
        
        [CATransaction begin];
        [CATransaction setValue:(id)kCFBooleanTrue forKey:kCATransactionDisableActions];
        progressLayer.strokeEnd = _progress;
        [CATransaction commit];
        
        [CATransaction begin];
        [CATransaction setValue: (id) kCFBooleanTrue forKey: kCATransactionDisableActions];
        thumbLayer.position = [self thumbPostionWithProgress:_progress];
        [CATransaction commit];
    }
}

- (void)setProgress:(CGFloat)progress withAnimateDuration:(NSTimeInterval)duration
{
    // 旋转小圆点
    CAKeyframeAnimation *thumbRotate = [CAKeyframeAnimation animationWithKeyPath:@"position"];
    thumbRotate.path = [UIBezierPath bezierPathWithArcCenter:CGPointMake(self.frame.size.width/2,
                                                                         self.frame.size.height/2)
                                                      radius:(innerRect.size.width)/2
                                                  startAngle:DEGREES_TO_RADIANS(_progress * 360)
                                                    endAngle:DEGREES_TO_RADIANS(progress * 360)
                                                   clockwise:YES].CGPath;
    thumbRotate.duration = duration;
    thumbRotate.calculationMode = kCAAnimationPaced;    // important!
    thumbLayer.position = [self thumbPostionWithProgress:progress];
    [thumbLayer addAnimation:thumbRotate forKey:@"thumbRotate"];
    
    // 绘制进度线
    CABasicAnimation *progressRotate = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
    progressRotate.fromValue = @(self.progress);
    progressRotate.toValue = @(progress);
    progressRotate.duration = duration;
    progressRotate.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
    progressLayer.strokeEnd = progress;
    [progressLayer addAnimation:progressRotate forKey:@"progressRotate"];
    
    _progress = progress;
}

- (CGPoint)thumbPostionWithProgress:(CGFloat)progress
{
    CGPoint origin = CGPointMake(CGRectGetWidth(self.bounds)/2, CGRectGetHeight(self.bounds)/2);
    CGFloat radius = CGRectGetWidth(innerRect) / 2;
    CGFloat angle = progress * 360;
    CGPoint point = CGPointMake(origin.x + radius * cosf(DEGREES_TO_RADIANS(angle)),
                                origin.y + radius * sinf(DEGREES_TO_RADIANS(angle)));
    return point;
}


- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesBegan:touches withEvent:event];
    [self shrinkAnimation];
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesEnded:touches withEvent:event];
    [self popAnimation];
}

- (void)shrinkAnimation
{
    CGFloat duration = 0.15;
    UIView *view = self;
    
    view.transform = CGAffineTransformMakeScale(1, 1);
    [UIView animateWithDuration:duration animations:^{
        view.transform = CGAffineTransformMakeScale(0.8, 0.8);
    }];
}

- (void)popAnimation
{
    UIView *view = self;
    CALayer *layer = view.layer;
    CGFloat duration = 0.6;
    
    view.transform = CGAffineTransformMakeScale(1, 1);
    
    CAKeyframeAnimation *anim = [CAKeyframeAnimation animationWithKeyPath:@"transform"];
    anim.values = @[ [NSValue valueWithCATransform3D:CATransform3DScale(layer.transform, 1.0, 1.0, 1.0)],
                     [NSValue valueWithCATransform3D:CATransform3DScale(layer.transform, 1.2, 1.2, 1.0)],
                     [NSValue valueWithCATransform3D:CATransform3DScale(layer.transform, 0.9, 0.9, 1.0)],
                     [NSValue valueWithCATransform3D:CATransform3DScale(layer.transform, 1.0, 1.0, 1.0)] ];
    anim.keyTimes = @[ @0.0f, @(duration/3.f*1), @(duration/3.f*2), @(duration/3.f*3) ];
    [anim setTimingFunctions:@[ [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut],
                                [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut],
                                [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut] ]];
    anim.fillMode = kCAFillModeForwards;
    anim.duration = duration;
    [view.layer addAnimation:anim forKey:@"popAnimation"];
}

- (void)buttonPressed:(TKCircleProgressBtn*)sender
{
    switch (self.btnState) {
        case TKCircleProgressBtnStateInitial:
            self.btnState = TKCircleProgressBtnStatePlaying;
            break;
        case TKCircleProgressBtnStatePlaying:
            self.btnState = TKCircleProgressBtnStatePause;
            break;
        case TKCircleProgressBtnStatePause:
            self.btnState = TKCircleProgressBtnStatePlaying;
            break;
        default:
            break;
    }
}

- (void)reset
{
    self.btnState = TKCircleProgressBtnStateInitial;
}

- (void)setRotate:(BOOL)rotate
{
    if (_rotate != rotate) {
        _rotate = rotate;
        if (_rotate) {
            
            self.btnState = TKCircleProgressBtnStatePlaying;
            
            // 旋转小圆点
            CAKeyframeAnimation *thumbRotate = [CAKeyframeAnimation animationWithKeyPath:@"position"];
            thumbRotate.path = circlePath.CGPath;
            thumbRotate.duration = 3.0;
            thumbRotate.repeatCount = HUGE_VALF;
            thumbRotate.calculationMode = kCAAnimationPaced;    // important!
            [thumbLayer addAnimation:thumbRotate forKey:@"thumbRotate"];
            
            // 绘制进度线
            CABasicAnimation *progressRotate = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
            progressRotate.fromValue = @0;
            progressRotate.toValue = @1;
            progressRotate.duration = 3.0;
            progressRotate.repeatCount = HUGE_VALF;
            progressRotate.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
            [progressLayer addAnimation:progressRotate forKey:@"progressRotate"];
            
        } else {
            
            [UIView animateWithDuration:0.25 animations:^{
                self.alpha = 0.0;
            } completion:^(BOOL finished) {
                self.btnState = TKCircleProgressBtnStatePause;
                [UIView animateWithDuration:0.25 animations:^{
                    // 停止自动旋转动画
                    [thumbLayer removeAnimationForKey:@"thumbRotate"];
                    [progressLayer removeAnimationForKey:@"progressRotate"];
                    self.alpha = 1.0;
                }];
            }];
        }
    }
}

- (void)setTintColor:(UIColor *)tintColor
{
    _tintColor = tintColor;
    borderView.layer.borderColor = _tintColor.CGColor;
    _initialLabel.textColor = _tintColor;
    _playingLabel.textColor = _tintColor;
    trangleLayer.strokeColor = _tintColor.CGColor;
    progressLayer.strokeColor = _tintColor.CGColor;
    thumbLayer.backgroundColor = _tintColor.CGColor;
    [self updateCircleLayerLayout];
}

@end
