//
//  ViewController.m
//  UTWHackathon
//
//  Created by Adam Gessel on 10/7/14.
//  Copyright (c) 2014 TradeStation. All rights reserved.
//

#import "ViewController.h"
#import "CalibrateFieldViewController.h"


@interface ViewController () <CalibrateFieldDelegate>

@property (weak, nonatomic) IBOutlet UIButton *calibrateFieldButton;

@property (strong, nonatomic) CalibrateFieldViewController *calibrateFieldVC;

- (IBAction)calibrateFieldButtonTapped:(id)sender;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(appDidBecomeActive:) name:UIApplicationDidBecomeActiveNotification object:nil]; [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(appWillResignActive:) name:UIApplicationWillResignActiveNotification object:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)calibrateFieldButtonTapped:(id)sender
{
    UIViewController *calibrateFieldVC = [self.storyboard instantiateViewControllerWithIdentifier:@"CalibrateField"];
    self.calibrateFieldVC = (CalibrateFieldViewController *)calibrateFieldVC;
    self.calibrateFieldVC.delegate = self;
    
    
    
    [self.navigationController pushViewController:calibrateFieldVC animated:YES];
}


@end
