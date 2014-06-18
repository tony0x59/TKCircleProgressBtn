//
//  ViewController.m
//  CircleBtnDemo
//
//  Created by Tony on 14-6-17.
//  Copyright (c) 2014年 itony.me. All rights reserved.
//

#import "ViewController.h"
#import "TKCircleProgressBtn.h"

@interface ViewController ()

@property (nonatomic, strong) TKCircleProgressBtn *progressBtn;

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    self.progressBtn = [[TKCircleProgressBtn alloc] initWithFrame:CGRectMake(100, 100, 50, 50)];
    [self.view addSubview:_progressBtn];
    
    UISlider *slider = [[UISlider alloc] initWithFrame:CGRectMake(10, 300, 300, 30)];
    [slider addTarget:self action:@selector(sliderChanged:) forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:slider];
    
    UISwitch *swich = [[UISwitch alloc] initWithFrame:CGRectMake(10, 350, 100, 44)];
    swich.on = NO;
    [swich addTarget:self action:@selector(switchChanged:) forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:swich];
    
    UISwitch *swich2 = [[UISwitch alloc] initWithFrame:CGRectMake(100, 350, 100, 44)];
    swich2.on = NO;
    [swich2 addTarget:self action:@selector(switch2Changed:) forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:swich2];
    
    
    UIButton *button1 = [UIButton buttonWithType:UIButtonTypeSystem];
    button1.frame = CGRectMake(20, 400, 100, 44);
    [button1 setTitle:@"button1" forState:UIControlStateNormal];
    [button1 addTarget:self action:@selector(button1Pressed:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button1];
    
    UIButton *button2 = [UIButton buttonWithType:UIButtonTypeSystem];
    button2.frame = CGRectMake(20 + 110, 400, 100, 44);
    [button2 setTitle:@"button2" forState:UIControlStateNormal];
    [button2 addTarget:self action:@selector(button2Pressed:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button2];
    
    UIButton *button3 = [UIButton buttonWithType:UIButtonTypeSystem];
    button3.frame = CGRectMake(20 + 110*2, 400, 100, 44);
    [button3 setTitle:@"button3" forState:UIControlStateNormal];
    [button3 addTarget:self action:@selector(button3Pressed:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button3];
    
    UIButton *button4 = [UIButton buttonWithType:UIButtonTypeSystem];
    button4.frame = CGRectMake(20, 450, 100, 44);
    [button4 setTitle:@"button4" forState:UIControlStateNormal];
    [button4 addTarget:self action:@selector(button4Pressed:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button4];
}

- (void)sliderChanged:(UISlider*)sender
{
    _progressBtn.progress = sender.value;
}

- (void)switchChanged:(UISwitch*)sender
{
    _progressBtn.rotate = sender.on;
}

- (void)switch2Changed:(UISwitch*)sender
{
    [_progressBtn setProgress:0.5 withAnimateDuration:1.0];
}

- (void)button1Pressed:(UIButton*)sender
{
    _progressBtn.btnState = TKCircleProgressBtnStateInitial;
}

- (void)button2Pressed:(UIButton*)sender
{
    _progressBtn.btnState = TKCircleProgressBtnStatePlaying;
}

- (void)button3Pressed:(UIButton*)sender
{
    _progressBtn.btnState = TKCircleProgressBtnStatePause;
}

- (void)button4Pressed:(UIButton*)sender
{
    [_progressBtn reset];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
