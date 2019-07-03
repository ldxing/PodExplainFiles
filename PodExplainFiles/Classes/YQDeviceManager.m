//
//  YQDeviceManager.m
//  TeacherServiceUI
//
//  Created by dx l on 2019/5/30.
//  Copyright © 2019 __YiQiSchool__. All rights reserved.
//

#define kUUIDKey  @"uuid"

#import "YQDeviceManager.h"
#import <Security/Security.h>

@interface YQDeviceManager ()

@property (nonatomic, strong) NSString *deviceUUID;

@end

@implementation YQDeviceManager

+ (instancetype)sharedInstance {
    static YQDeviceManager *manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[YQDeviceManager alloc] init];
    });
    return manager;
}

+ (NSString *)getCurrentDeviceUUID {
    NSString *device_uuid = [[YQDeviceManager sharedInstance] deviceUUID];
    if (device_uuid == nil) {
        NSString *bundleIdentifier = [[[[NSBundle mainBundle] infoDictionary] valueForKey:@"CFBundleIdentifier"] stringByAppendingString:@".uuid"];
        
        NSDictionary *dict = [YQDeviceManager getData:bundleIdentifier];
        if (dict == nil || dict.count == 0) {
            NSString *uuid = [[[UIDevice currentDevice] identifierForVendor] UUIDString];
            dict = @{kUUIDKey:uuid};
            [YQDeviceManager save:bundleIdentifier data:dict];
        }
        device_uuid = [dict objectForKey:kUUIDKey];
    }
    return device_uuid;
}


#pragma mark -
#pragma mark keychain 存储
#pragma mark -

+ (NSMutableDictionary *)getKeychainQuery:(NSString *)service {
    return [NSMutableDictionary dictionaryWithObjectsAndKeys:(id)kSecClassGenericPassword,(id)kSecClass,service, (id)kSecAttrService,service, (id)kSecAttrAccount,(id)kSecAttrAccessibleAlwaysThisDeviceOnly,(id)kSecAttrAccessible,nil];
}

+ (void)save:(NSString *)service data:(id)data {
    //Get search dictionary
    NSMutableDictionary *keychainQuery = [YQDeviceManager getKeychainQuery:service];
    //Delete old item before add new item
    SecItemDelete((CFDictionaryRef)keychainQuery);
    //Add new object to search dictionary(Attention:the data format)
    [keychainQuery setObject:[NSKeyedArchiver archivedDataWithRootObject:data] forKey:(id)kSecValueData];
    //Add item to keychain with the search dictionary
    SecItemAdd((CFDictionaryRef)keychainQuery, NULL);}

+ (id)getData:(NSString *)service {
    id ret = nil;
    NSMutableDictionary *keychainQuery = [YQDeviceManager getKeychainQuery:service];
    //Configure the search setting
    //Since in our simple case we are expecting only a single attribute to be returned (the password) we can set the attribute kSecReturnData to kCFBooleanTrue
    [keychainQuery setObject:(id)kCFBooleanTrue forKey:(id)kSecReturnData];
    [keychainQuery setObject:(id)kSecMatchLimitOne forKey:(id)kSecMatchLimit];
    CFDataRef keyData = NULL;
    if (SecItemCopyMatching((CFDictionaryRef)keychainQuery, (CFTypeRef *)&keyData) == noErr) {
        @try {
            ret = [NSKeyedUnarchiver unarchiveObjectWithData:(__bridge NSData *)keyData];
            
        } @catch (NSException *e) {
            
            NSLog(@"Unarchive of %@ failed: %@", service, e);
            
        } @finally {
            
        }
    }
    if (keyData)
        CFRelease(keyData);
    return ret;
}
    

@end
