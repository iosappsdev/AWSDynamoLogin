//
//  BCViewController.h
//  barcodeReader
//
//  Created by CtecTeacher on 5/20/14.
//  Copyright (c) 2014 ABC Adult School. All rights reserved.
//

#import <UIKit/UIKit.h>
@import AVFoundation;

// Protocol Declaration
@protocol BCViewControllerDelegate <NSObject>
@required
- (void)readBarcode:(NSString *)barcodeString;
@end

// Interface
@interface BCViewController : UIViewController<AVCaptureMetadataOutputObjectsDelegate, UIActionSheetDelegate>
{
    
    //Session
    AVCaptureSession *session;
    //Device Video
    AVCaptureDevice *device;
    //Input
    AVCaptureDeviceInput *input;
    //Output
    AVCaptureMetadataOutput *output;
    //Video Preview Layer
    AVCaptureVideoPreviewLayer *prevLayer;
    //Highlight View to Display Label
    UIView *highlightView;
    //Highlight Label to display Output Test
    UILabel *label;
    //Scan Frame
    UIImageView *frameView;
    //Save Button
	UIButton *saveButton;
	
	
    //Bardcode String
    NSString *barCode;
    // Torch State
    int torchState;
    
}
@property (nonatomic) id delegate;
- (void)torch:(BOOL)isOn;
@end
