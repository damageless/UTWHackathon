//
//  ViewController.h
//  HelloWorld
//
//  Created by Jon Carroll on 12/8/11.
//  Copyright (c) 2011 Orbotix, Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <RobotUIKit/RobotUIKit.h>

@interface ViewController : UIViewController {
    BOOL ledON;
    BOOL robotOnline;
    BOOL robotInitialized;
    BOOL noSpheroViewShowing;
    UILabel *connetionLabel;
    
    RUINoSpheroConnectedViewController* noSpheroView;
}
@property (nonatomic, retain) IBOutlet UILabel* connectionLabel;

-(void)setupRobotConnection;
-(void)handleRobotOnline;
-(void)toggleLED;

@end

