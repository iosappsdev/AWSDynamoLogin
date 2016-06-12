//
//  BCViewController.m
//  barcodeReader
//
//  Created by CtecTeacher on 5/20/14.
//  Copyright (c) 2014 ABC Adult School. All rights reserved.
//

#import "BCViewController.h"
#import "Constants.h"

@interface BCViewController ()

@end

@implementation BCViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Scan for barcode
    UIBarButtonItem *scan = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemAction target:self action:@selector(options)];
    self.navigationItem.rightBarButtonItem = scan;
    
    // Do any additional setup after loading the view.
    // Title Label
    UILabel *titleLabel = [[UILabel alloc]init];
    titleLabel.frame = CGRectMake(fieldWidthCenter, 15, fieldWidth, 50);
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.text = @"Search Smart Tag";
    titleLabel.font = [Constants font1_withSize:19];
    [self.view addSubview:titleLabel];
    
    highlightView = [[UIView alloc]init];
    highlightView.layer.borderColor = [UIColor greenColor].CGColor;
    highlightView.layer.borderWidth = 3;
    highlightView.autoresizingMask = UIViewAutoresizingFlexibleTopMargin |UIViewAutoresizingFlexibleLeftMargin |
    UIViewAutoresizingFlexibleRightMargin |
    UIViewAutoresizingFlexibleBottomMargin;
    //highlightView.frame = CGRectMake(screenWidth/2-hightlightWidth/2, screenHeight/2-hightlightHeight/2, hightlightWidth, hightlightHeight);
    [self.view addSubview:highlightView];
    
    frameView = [[UIImageView alloc]init];
    frameView.frame = CGRectMake(screenWidth/2-75, screenHeight/2-75, 150, 150);
    frameView.image = [UIImage imageNamed:@"scanFrame"];
    frameView.contentMode = UIViewContentModeScaleAspectFill;
    frameView.alpha = 0.4;
    [self.view addSubview:frameView];
    
//    label = [[UILabel alloc]init];
//    label.frame = CGRectMake(0, self.view.bounds.size.height - 40, self.view.bounds.size.width, 40);
//    label.autoresizingMask = UIViewAutoresizingFlexibleTopMargin;
//    label.backgroundColor = [UIColor colorWithWhite:0.15 alpha:.65];
//    label.font = [Constants font1_withSize:18];
//    label.textColor = [UIColor whiteColor];
//    label.textAlignment = NSTextAlignmentCenter;
//    label.text = barCode;
    //[self.view addSubview:label];
    
    float buttonOffset;
    
    if (IS_IPHONE_5 || IS_IPHONE_4_OR_LESS) {
        buttonOffset = screenHeight/2+150;
    } else if (IS_IPHONE_6) {
        buttonOffset = screenHeight/2+170;
    } else if (IS_IPHONE_6P) {
        buttonOffset = screenHeight/2+200;
    }
    
	
	saveButton = [[UIButton alloc]init];
	saveButton.frame = CGRectMake(screenWidth/2-40, buttonOffset, 80, 80);
    saveButton.enabled = NO;
    saveButton.hidden = YES;
    saveButton.layer.cornerRadius = 10;
    [[saveButton titleLabel] setFont:[Constants font1_withSize:16]];
	[saveButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
	[saveButton setBackgroundColor:[[UIColor redColor]colorWithAlphaComponent:0.45]];
	[saveButton addTarget:self action:@selector(capture) forControlEvents: UIControlEventTouchUpInside];
	
	[self.view addSubview:saveButton];
	
    session = [[AVCaptureSession alloc]init];
    device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    NSError *error = nil;
    input = [AVCaptureDeviceInput deviceInputWithDevice:device error:&error];
    
    if (input) {
        [session addInput:input];
    } else {
        
        UIAlertController *alertController = [UIAlertController
                                              alertControllerWithTitle:@"Barcode Scanner"
                                              message:[NSString stringWithFormat:@"Error: %@ \n %@",error.localizedDescription, error.localizedRecoveryOptions]
                                              preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction *okAction = [UIAlertAction
                                   actionWithTitle:NSLocalizedString(@"Dismiss", @"Dismiss")
                                   style:UIAlertActionStyleDefault
                                   handler:^(UIAlertAction *action)
                                   {
                                       NSLog(@"Alert Dismissed");
                                       [self dismissViewControllerAnimated:YES completion:nil];
                                   }];
        
        //[alertController addAction:cancelAction];
        [alertController addAction:okAction];
        [self presentViewController:alertController animated:YES completion:nil];
        
        NSLog(@"Error: %@\n%@", error.localizedDescription, error.localizedFailureReason);
    }
    
    output = [[AVCaptureMetadataOutput alloc]init];
    [output setMetadataObjectsDelegate:self queue:dispatch_get_main_queue()];
    [session addOutput:output];
    output.metadataObjectTypes = [output availableMetadataObjectTypes];
    
    prevLayer = [AVCaptureVideoPreviewLayer layerWithSession:session];
    prevLayer.frame = self.view.bounds;
    prevLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;
    [self.view.layer addSublayer:prevLayer];
    
    [session startRunning];
    
    UIButton *close = [[UIButton alloc]initWithFrame:CGRectMake(7, 17, 40, 40)];
    close.alpha = 0.4;
    [[close imageView] setContentMode:UIViewContentModeScaleAspectFill];
    [close addTarget:self action:@selector(dismissView) forControlEvents:UIControlEventTouchUpInside];
    [close setImage:[UIImage imageNamed:@"close"] forState:UIControlStateNormal];
    [self.view addSubview:close];
    
    [self.view bringSubviewToFront:close];
    [self.view bringSubviewToFront:highlightView];
    [self.view bringSubviewToFront:label];
	[self.view bringSubviewToFront:saveButton];
    [self.view bringSubviewToFront:frameView];
    [self.view bringSubviewToFront:titleLabel];

}

- (BOOL)prefersStatusBarHidden {
    return YES;
}

- (void)capture {
    
    if ([[barCode substringToIndex:3] isEqualToString:@"GSA"]) {
        [[self delegate] readBarcode:barCode];
        [self dismissViewControllerAnimated:YES completion:^{}];
    } else {
        UIAlertController * alert=   [UIAlertController
                                      alertControllerWithTitle:@"Good Samaritan"
                                      message:@"Invaild Tag"
                                      preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction *dismiss = [UIAlertAction
                                 actionWithTitle:@"Dismiss"
                                 style:UIAlertActionStyleDefault
                                 handler:^(UIAlertAction * action)
                                 {
                                     [alert dismissViewControllerAnimated:YES completion:nil];
                                 }];
        
        [alert addAction:dismiss];
        
        [self presentViewController:alert animated:YES completion:nil];
    }
}

- (void)dismissView {
    [self dismissViewControllerAnimated:YES completion:nil];
}

//// Options
//- (void)options {
//
//    UIActionSheet *options = [[UIActionSheet alloc]initWithTitle:@"Options" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:@"Disable Torch" otherButtonTitles:@"Save Barcode", nil];
//    [options showInView:self.view];
//}
//
//// ActionSheet Delegate Method
//-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
//    
//    switch (buttonIndex) {
//        case 0: {
//            [self torch:NO];
//        }
//            break;
//        case 1: {
//            [[self delegate] readBarcode:barCode];
//			[self dismissViewControllerAnimated:YES completion:^{
//				
//			}];
//				//[self.navigationController popViewControllerAnimated:YES];
//        }
//            break;
//        case 2:
//            NSLog(@"User Cancelled");
//            break;
//            
//        default:
//            break;
//    }
//}

// Enable Torch
- (void)viewWillAppear:(BOOL)animated {
 
		//[self torch:YES];
}

// Torch off when we leave View
- (void)viewWillDisappear:(BOOL)animated {
    
    [self torch:NO];
}

// Torch
- (void)torch:(BOOL)isOn {
    
    AVCaptureDevice *torch = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    if ([torch hasTorch]) {
        if (isOn == YES) {

                [torch lockForConfiguration:nil];
                // Use AVCaptureTorchModeOff to turn off
                [torch setTorchMode:AVCaptureTorchModeOn];
                [torch unlockForConfiguration];
        } else {
    
                [torch lockForConfiguration:nil];
                // Use AVCaptureTorchModeOff to turn off
                [torch setTorchMode:AVCaptureTorchModeOff];
                [torch unlockForConfiguration];
            }
        }
}

// Parse Barcode
- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputMetadataObjects:(NSArray *)metadataObjects fromConnection:(AVCaptureConnection *)connection
{
    CGRect highlightViewRect = CGRectZero;
    AVMetadataMachineReadableCodeObject *barCodeObject;
    NSString *detectionString = nil;
    NSArray *barCodeTypes = @[AVMetadataObjectTypeQRCode];
    
    for (AVMetadataObject *metadata in metadataObjects) {
        for (NSString *type in barCodeTypes) {
            if ([metadata.type isEqualToString:type])
            {
                barCodeObject = (AVMetadataMachineReadableCodeObject *)[prevLayer transformedMetadataObjectForMetadataObject:(AVMetadataMachineReadableCodeObject *)metadata];
                highlightViewRect = barCodeObject.bounds;
                detectionString = [(AVMetadataMachineReadableCodeObject *)metadata stringValue];
                break;
            } else {
                saveButton.enabled = NO;
                saveButton.hidden = YES;
                //label.text = @"No Tag Detected";
            }
        }

        if (detectionString != nil)
        {
            saveButton.enabled = YES;
            saveButton.hidden = NO;
            [saveButton setTitle:@"Search" forState:UIControlStateNormal];
            [saveButton setBackgroundColor:[[UIColor greenColor]colorWithAlphaComponent:0.65]];
			barCode = detectionString;
            //label.text = @"Tag Found!";
            break;
        }
        else
            saveButton.enabled = NO;
            saveButton.hidden = YES;
            //[saveButton setBackgroundColor:[[UIColor redColor]colorWithAlphaComponent:0.45]];
            //label.text = @"No Tag Detected";
    }
    highlightView.frame = highlightViewRect;
    
    if ([NSStringFromCGRect(highlightViewRect) isEqualToString:@"{{0, 0}, {0, 0}}"] ) {
        saveButton.enabled = NO;
        saveButton.hidden = YES;
    }
    
}
@end
