![logo](http://update.orbotix.com/developer/sphero-small.png)

# Sphero Streaming Animation

This sample code demonstrates how to connect to a Sphero and use its streaming Accelerometer Data to move an object on the screen, and IMU yaw values to rotate the object. 


ViewController.h
</br>
Sets up timer, floats for streaming values and setting up the location of the image used to animate Sphero's movements.

			
	@interface ViewController : UIViewController <UIAlertViewDelegate>{

    BOOL robotOnline;
    int packetCounter;
    
    //Create labels 
    IBOutlet UILabel* yawLabel;
    IBOutlet UILabel* accelxLabel;
    IBOutlet UILabel* accelyLabel;

    //Sets Sphero's center location
    CGPoint targetSpheroLoc; //Sphero's Center

    //Timer
    NSTimer *randomMain;
    
    //Sphero Image
    IBOutlet UIImageView *sphero;  //Sphero
    }
    @property(nonatomic, retain) UILabel* IBOutlet yawLabel;
	@property(nonatomic, retain) UILabel* IBOutlet accelxLabel;
	@property(nonatomic, retain) UILabel* IBOutlet accelyLabel;
	@property(nonatomic, retain)  UIImageView *sphero;
	@property CGPoint targetSpheroLoc;
	@property(nonatomic, retain)  NSTimer *randomMain;

	-(void)sendSetDataStreamingCommand;
	-(void)setupRobotConnection;
	-(void)handleRobotOnline;

	-(void)animateSphero;


</br>

ViewController.m
</br>
Define constants.

	#define DEGREES_TO_RADIANS(angle) (angle / 180.0 * M_PI)
	#define TOTAL_PACKET_COUNT 200
	#define PACKET_COUNT_THRESHOLD 50


viewDidLoad
</br>
* Set up notification for termination of application </br>
* Place image in center of screen.
 

	- (void)viewDidLoad
	{
    [super viewDidLoad];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationWillTerminate:) name:UIApplicationWillTerminateNotification object:nil];
    
    //SpaceFighter
    targetSpheroLoc = sphero.center;
    
    /*Register for application lifecycle notifications so we known when to connect and disconnect from the robot*/
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(appDidBecomeActive:) name:UIApplicationDidBecomeActiveNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(appWillResignActive:) name:UIApplicationWillResignActiveNotification object:nil];
    
    robotOnline = NO;
    

	}
	
</br>
Set up Sphero for Gameplay by turning on streaming in handleRobotOnline.

        // Request Data Streaming
        [self sendSetDataStreamingCommand];

        ////Register for asynchronise data streaming packets
        [[RKDeviceMessenger sharedMessenger] addDataStreamingObserver:self selector:@selector(handleDataStreaming:)];


</br>
Sphero Streaming:
Get data from Accelerometers and attitude.

Also set up finite streaming.

	-(void)sendSetDataStreamingCommand {
    
    // Requesting the Accelerometer X, Y, and Z filtered (in Gs)
    //            the IMU Angles yaw
    RKDataStreamingMask mask =  RKDataStreamingMaskAccelerometerFilteredAll |
                                RKDataStreamingMaskIMUYawAngleFiltered;
    
    // Note: If your ball has Firmware < 1.20 then these Quaternions
    //       will simply show up as zeros.
    
    // Sphero samples this data at 400 Hz.  The divisor sets the sample
    // rate you want it to store frames of data.  In this case 400Hz/40 = 10Hz
    uint16_t divisor = 20;
    
    // Packet frames is the number of frames Sphero will store before it sends
    // an async data packet to the iOS device
    uint16_t packetFrames = 1;
    
    // Count is the number of async data packets Sphero will send you before
    // it stops.  You want to register for a finite count and then send the command
    // again once you approach the limit.  Otherwise data streaming may be left
    // on when your app crashes, putting Sphero in a bad state.
    uint8_t count = TOTAL_PACKET_COUNT;
    
    // Reset finite packet counter
    packetCounter = 0;
    
    // Send command to Sphero
    [RKSetDataStreamingCommand sendCommandWithSampleRateDivisor:divisor
                                                   packetFrames:packetFrames
                                                     sensorMask:mask
                                                    packetCount:count];
    
	}

</br>
Handling Data Streaming:

	#pragma mark-SPHERO SENSOR STREAMING CODE

	//Observer method that will be called as sensor data arrives from Sphero
	- (void)handleDataStreaming:(RKDeviceAsyncData *)data
	{
    //NSLog(@"handleDataStreaming: data - %@", data);
    
    if ([data isKindOfClass:[RKDeviceSensorsAsyncData class]]) {
        RKDeviceSensorsAsyncData *sensors_data = (RKDeviceSensorsAsyncData *)data;
        
        // If we are getting close to packet limit, request more
        packetCounter++;
        if( packetCounter > (TOTAL_PACKET_COUNT-PACKET_COUNT_THRESHOLD)) {
            [self sendSetDataStreamingCommand];
        }
        
        for (RKDeviceSensorsData *data in sensors_data.dataFrames) {
            RKAccelerometerData *accelerometer_data = data.accelerometerData;
            RKAttitudeData *attitude_data = data.attitudeData;
            
            //Accelerometer & Yaw Values Floats
            float yaw = attitude_data.yaw;
            yawLabel.text = [NSString stringWithFormat:@"%.f", (yaw)];
            
            // call method to rotate image for yaw value
            [self rotateImage:sphero degrees:-yaw];
            
            float y = accelerometer_data.acceleration.y + 1.0;
            if(y < 0.0) y = 0.0;
            if(y > 2.0) y = 2.0;
            y = y * 0.5;
            accelyLabel.text = [NSString stringWithFormat:@"%1.2f", (y)];
            
            float x = accelerometer_data.acceleration.x;
            y = accelerometer_data.acceleration.y * -1.0;
            float xOffset = x * 20.0;
            float yOffset = y * 20.0;
            accelxLabel.text = [NSString stringWithFormat:@"%1.2f", (x)];
            
            
            //Places Sphero's center
            CGPoint newCenter = CGPointMake(sphero.center.x + xOffset, sphero.center.y + yOffset);
            
            //Place Sphero Back in center
            //Creates a boundary around the frame of the Phone so you can't lose him.
            if(newCenter.x < 0.0) newCenter.x = 0.0;
            if(newCenter.x > self.view.frame.size.height) newCenter.x = self.view.frame.size.height;
            if(newCenter.y < 0.0) newCenter.y = 0.0;
            if(newCenter.y > self.view.frame.size.width - 20.0) newCenter.y = self.view.frame.size.width - 20.0;
            
            targetSpheroLoc = newCenter;
        }
    }
	}

</br>
Animate Sphero by checking the movement transition produced by the Sphero and adjust image accordingly.

	//Make Linear movements for Sphero's Image View

	-(void)animateSphero {
    [UIView animateWithDuration:0.06
                          delay:0.0
                        options:UIViewAnimationCurveLinear 
                     animations:^{
                         sphero.center = targetSpheroLoc;
                     }
                     completion:^(BOOL finished) {
                         [self animateSphero];
                     }];
	}

</br>
To rotate the image through an animation produced from Sphero's yaw.

	// method to rotate
	-(void) rotateImage:(UIImageView *) imageView degrees:(CGFloat) degrees
	{
    CGAffineTransform transform = CGAffineTransformMakeRotation(DEGREES_TO_RADIANS(degrees));
    imageView.transform = transform;
	}

</br>
When Application closes, return Sphero to normal state.

	- (void)applicationWillTerminate:(NSNotification *)notifaction
	{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:RKDeviceConnectionOnlineNotification object:nil];
    [[RKRobotProvider sharedRobotProvider] closeRobotConnection];
	}
