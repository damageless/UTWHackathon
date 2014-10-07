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
    
    
    [self presentViewController:calibrateFieldVC animated:YES completion:nil];
}

- (BOOL)shouldDismissCalibrateFieldView
{
    return YES;
}

- (void)dismissCalibrateFieldView
{
    [self.calibrateFieldVC dismissViewControllerAnimated:YES completion:nil];
}

@end
