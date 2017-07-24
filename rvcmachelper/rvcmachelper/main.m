//
//  main.m
//  rvcmachelper
//
//  Created by Nikita Titov on 24/07/2017.
//  Copyright © 2017 Ribose. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "HelperAppDelegate.h"

int main(int argc, const char * argv[]) {
    NSApplication *application = NSApplication.sharedApplication;
    HelperAppDelegate *delegate = [[HelperAppDelegate alloc] init];
    application.delegate = delegate;
    return NSApplicationMain(argc, argv);
}
