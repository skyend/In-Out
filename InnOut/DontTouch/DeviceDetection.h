//
//  DeviceDetection.h
//  KeepInTheMind
//
//  Created by JinWoong Han on 11. 7. 27..
//  Copyright 2011 -. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <sys/utsname.h>



@interface DeviceDetection : NSObject
enum {
    MODEL_UNKNOWN=0,/**< unknown model */
    MODEL_IPHONE_SIMULATOR,/**< iphone simulator */
    MODEL_IPAD_SIMULATOR,/**< ipad simulator */
    MODEL_IPOD_TOUCH_GEN1,/**< ipod touch 1st Gen */
    MODEL_IPOD_TOUCH_GEN2,/**< ipod touch 2nd Gen */
    MODEL_IPOD_TOUCH_GEN3,/**< ipod touch 3th Gen */
    MODEL_IPHONE,/**< iphone  */
    MODEL_IPHONE_3G,/**< iphone 3G */
    MODEL_IPHONE_3GS,/**< iphone 3GS */
    MODEL_IPHONE_4,	/**< iphone 4 */
    MODEL_IPAD/** ipad  */
};


+(uint) detectDevice;
+(NSString *) returnDeviceName:(BOOL)ignoreSimulator;
    
@end