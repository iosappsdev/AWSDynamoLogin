//
//  Constants.h
//  Standard Constants Helper Class
//
//  Created by Ricardo Ruiz on 2/23/16.
//  Copyright © 2016 Kenetic Labs Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

//Devices
#define IS_IPHONE (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
#define IS_RETINA ([[UIScreen mainScreen] scale] >= 2.0)

#define SYSTEM_VERSION_EQUAL_TO(v)                  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedSame)
#define SYSTEM_VERSION_GREATER_THAN(v)              ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedDescending)
#define SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(v)  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedAscending)
#define SYSTEM_VERSION_LESS_THAN(v)                 ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedAscending)
#define SYSTEM_VERSION_LESS_THAN_OR_EQUAL_TO(v)     ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedDescending)

#define SCREEN_WIDTH ([[UIScreen mainScreen] bounds].size.width)
#define SCREEN_HEIGHT ([[UIScreen mainScreen] bounds].size.height)
#define SCREEN_MAX_LENGTH (MAX(SCREEN_WIDTH, SCREEN_HEIGHT))
#define SCREEN_MIN_LENGTH (MIN(SCREEN_WIDTH, SCREEN_HEIGHT))

#define IS_IPHONE_4_OR_LESS (IS_IPHONE && SCREEN_MAX_LENGTH < 568.0)
#define IS_IPHONE_5 (IS_IPHONE && SCREEN_MAX_LENGTH == 568.0)
#define IS_IPHONE_6 (IS_IPHONE && SCREEN_MAX_LENGTH == 667.0)
#define IS_IPHONE_6P (IS_IPHONE && SCREEN_MAX_LENGTH == 736.0)

//Screen
#define screenWidth self.view.bounds.size.width
#define screenHeight self.view.bounds.size.height
#define fieldWidth self.view.bounds.size.width-50
#define fieldWidthCenter (self.view.bounds.size.width/2)-((self.view.bounds.size.width-50)/2)
#define buttonWidth self.view.bounds.size.width-66
#define buttonWidthCenter (self.view.bounds.size.width/2)-((self.view.bounds.size.width-66)/2)

//Colors
#define _Color_Blue [UIColor colorWithRed:0.204 green:0.596 blue:0.859 alpha:1]
#define _Color_Blue2 [UIColor colorWithRed:0.161 green:0.502 blue:0.725 alpha:1]
#define _Color_DarkBlue [UIColor colorWithRed:0.204 green:0.286 blue:0.369 alpha:1]
#define _Color_LightGray [UIColor colorWithRed:0.925 green:0.941 blue:0.945 alpha:1]
#define _Color_Gray [UIColor colorWithRed:0.584 green:0.647 blue:0.651 alpha:1]
#define _Color_Yellow [UIColor colorWithRed:0.945 green:0.769 blue:0.059 alpha:1]
#define _Color_Orange [UIColor colorWithRed:0.902 green:0.494 blue:0.133 alpha:1]
#define _Color_Purple [UIColor colorWithRed:0.608 green:0.349 blue:0.714 alpha:1]
#define _Color_Red [UIColor colorWithRed:0.906 green:0.298 blue:0.235 alpha:1]
#define _Color_Green [UIColor colorWithRed:0.18 green:0.8 blue:0.443 alpha:1]

//Fonts
@interface Constants : NSObject
+ (UIFont *)font1_withSize:(float)fontSize;
+ (UIFont *)font2_withSize:(float)fontSize;
@end
