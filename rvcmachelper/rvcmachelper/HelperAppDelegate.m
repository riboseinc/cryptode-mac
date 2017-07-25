//
//  HelperAppDelegate.m
//  rvcmachelper
//
//  Created by Nikita Titov on 24/07/2017.
//  Copyright © 2017 Ribose. All rights reserved.
//

#import "HelperAppDelegate.h"

@interface HelperAppDelegate ()

@end

@implementation HelperAppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
    
    for (NSRunningApplication *running in NSWorkspace.sharedWorkspace.runningApplications) {
        if ([@"com.ribose.rvcmac" isEqualToString:running.bundleIdentifier]) {
            NSLog(@"rvcmac is already running");
            [NSApp terminate:nil];
            return;
        }
    }
    
    NSMutableArray *pathComponents = NSBundle.mainBundle.bundlePath.pathComponents.mutableCopy;
    [pathComponents removeLastObject];
    [pathComponents removeLastObject];
    [pathComponents removeLastObject];
    [pathComponents addObject:@"MacOS"];
    [pathComponents addObject:@"rvcmac"];
    NSString *path = [NSString pathWithComponents:pathComponents];
    NSURL *url = [NSURL fileURLWithPath:path];
    
    NSError *error;
    if (![NSWorkspace.sharedWorkspace launchApplicationAtURL:url
                                                     options:kNilOptions
                                               configuration:@{NSWorkspaceLaunchConfigurationArguments: @[@"autoload"]}
                                                       error:&error]) {
        NSLog(@"Could not load application: %@", error.localizedDescription);
    }
    
    [NSApp terminate:nil];
}

@end
