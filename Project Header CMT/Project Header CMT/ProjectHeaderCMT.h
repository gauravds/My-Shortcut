//
//  Project Header CMT.h
//  Project Header CMT
//
//  Created by Gaurav Sharma on 21/01/16.
//  Copyright © 2016 iOS Dev Group. All rights reserved.
//

#import <AppKit/AppKit.h>

@class ProjectHeaderCMT;

static ProjectHeaderCMT *sharedPlugin;

@interface ProjectHeaderCMT : NSObject

+ (instancetype)sharedPlugin;
- (id)initWithBundle:(NSBundle *)plugin;

@property (nonatomic, strong, readonly) NSBundle* bundle;
@end