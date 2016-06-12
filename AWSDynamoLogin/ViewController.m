//
//  ViewController.m
//  AWSDynamoLogin
//
//  Created by Rommel Brigaudit on 11/3/15.
//  Copyright © 2015 Rommel Brigaudit. All rights reserved.
//

#import "ViewController.h"
#import <AWSCore/AWSCore.h>
#import <AWSCognito/AWSCognito.h>
#import <AWSS3/AWSS3.h>
#import <AWSLambda/AWSLambda.h>



@interface ViewController ()
@property (nonatomic,strong)AWSCognitoCredentialsProvider *credentialsProvider;
- (IBAction)saveSomething:(UIButton *)sender;

@end


@implementation ViewController

-(AWSCognitoCredentialsProvider *)credentialsProvider{
    
    if(!_credentialsProvider){ _credentialsProvider = [[AWSCognitoCredentialsProvider alloc]init];
        
    }
    return _credentialsProvider;
}

- (IBAction)callLambda:(UIButton *)sender {
    
    AWSLambdaInvoker *lambdaInvoker = [AWSLambdaInvoker defaultLambdaInvoker];
    NSDictionary *parameters = @{@"key1" : @"value1",
                                 @"key2" : @"value2",
                                 @"key3" : @"value3",
                                 @"isError" : @NO};
    
    [[lambdaInvoker invokeFunction:@"hello-world"
                        JSONObject:parameters] continueWithBlock:^id(AWSTask *task) {
        if (task.error) {
            NSLog(@"Error: %@", task.error);
        }
        if (task.exception) {
            NSLog(@"Exception: %@", task.exception);
        }
        if (task.result) {
            NSLog(@"Result: %@", task.result);
            
            dispatch_async(dispatch_get_main_queue(), ^{
                NSLog(@"result %@",task.result);
            });
        }
        return nil;
    }];
}

- (IBAction)saveSomething:(UIButton *)sender {
    
    //image you want to upload
    UIImage* imageToUpload = [UIImage imageNamed:@"voltesV.jpg"];
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *filePath = [[paths objectAtIndex:0] stringByAppendingPathComponent:@"test.png"];
    [UIImagePNGRepresentation(imageToUpload) writeToFile:filePath atomically:YES];
    
    NSURL* fileUrl = [NSURL fileURLWithPath:filePath];
    
    AWSS3TransferManagerUploadRequest *uploadRequest = [AWSS3TransferManagerUploadRequest new];
    uploadRequest.bucket = @"octopus-development-bucket";
    uploadRequest.contentType = @"image/jpeg";
    uploadRequest.key = @"myTestFile2.jpg";
    uploadRequest.body = fileUrl;
    
    AWSS3TransferManager *transferManager = [AWSS3TransferManager defaultS3TransferManager];
    
    [[transferManager upload:uploadRequest]continueWithExecutor:[AWSExecutor mainThreadExecutor] withBlock:^id _Nullable(AWSTask * _Nonnull task) {
        
        if (task.error) {
            if ([task.error.domain isEqualToString:AWSS3TransferManagerErrorDomain]) {
                switch (task.error.code) {
                    case AWSS3TransferManagerErrorCancelled:
                    case AWSS3TransferManagerErrorPaused:
                        break;
                        
                    default:
                        NSLog(@"Error: %@", task.error);
                        break;
                }
            } else {
                // Unknown error.
                NSLog(@"Error: %@", task.error);
            }
        }
        
        if (task.result) {
            AWSS3TransferManagerUploadOutput *uploadOutput = task.result;
            NSLog(@"Task Result = %@",task.result);
            // The file uploaded successfully.
        }
        return nil;    }];
 }

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
     self.credentialsProvider = [[AWSCognitoCredentialsProvider alloc]
                                                          initWithRegionType:AWSRegionUSEast1
                                                         identityPoolId:@"us-east-1:213e8d4b-85c3-4ba0-afc4-6c5acae6d5e2" ];
    NSLog(@"Credentials Provider %@",self.credentialsProvider);
    AWSServiceConfiguration *configuration = [[AWSServiceConfiguration alloc] initWithRegion:AWSRegionUSEast1 credentialsProvider:self.credentialsProvider];
    
    [AWSServiceManager defaultServiceManager].defaultServiceConfiguration = configuration;
    
    NSString *theId = self.credentialsProvider.identityId;
    NSLog(@"The ID is %@",theId);
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
