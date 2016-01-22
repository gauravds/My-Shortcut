//
//  NSObject_Extension.m
//  Project Header CMT
//
//  Created by Gaurav Sharma on 21/01/16.
//  Copyright © 2016 iOS Dev Group. All rights reserved.
//


#import "NSObject_Extension.h"
#import "ProjectHeaderCMT.h"

@implementation NSObject (Xcode_Plugin_Template_Extension)

+ (void)pluginDidLoad:(NSBundle *)plugin
{
    static dispatch_once_t onceToken;
    NSString *currentApplicationName = [[NSBundle mainBundle] infoDictionary][@"CFBundleName"];
    if ([currentApplicationName isEqual:@"Xcode"]) {
        dispatch_once(&onceToken, ^{
            sharedPlugin = [[ProjectHeaderCMT alloc] initWithBundle:plugin];
        });
    }
}
@end
