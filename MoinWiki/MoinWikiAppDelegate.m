//
//  MoinWikiAppDelegate.m
//  MoinWiki
//
//  Created by Just Zhang on 12-3-7.
//  Copyright 2012年 BTBU. All rights reserved.
//

#import "MoinWikiAppDelegate.h"
#import "MWUtils.h"
#import "UKLoginItemRegistry.h"

@implementation MoinWikiAppDelegate

@synthesize window;

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    // Insert code here to initialize your application
    if (![MWUtils isAppSetToRunAtLogon]) {
        [toggleAutoStart setState:NSOffState];
    } else {
        [toggleAutoStart setState:NSOnState];
    }
    //NSLog(@"%@",[[NSBundle mainBundle] bundlePath]);
    NSString *serverPath = [NSString stringWithFormat:@"%@/moin/server.py",[[NSBundle mainBundle] resourcePath]];
    NSArray *args = [NSArray arrayWithObject:serverPath];
    NSDictionary *env = [NSDictionary dictionaryWithObject:[NSString stringWithFormat:@"%@/moin/lib/python2.7/site-packages",[[NSBundle mainBundle] resourcePath]] 
                                                    forKey:@"PYTHONPATH"];
    //serverTask = [NSTask launchedTaskWithLaunchPath:@"/usr/bin/python" arguments:args];
    serverTask = [[NSTask alloc] init];
    [serverTask setEnvironment:env];
    [serverTask setArguments:args];
    [serverTask setLaunchPath:@"/usr/bin/python"];
    [serverTask launch];
}

- (void)awakeFromNib
{
    statusItem = [[[NSStatusBar systemStatusBar] statusItemWithLength:NSVariableStatusItemLength] retain];
    [statusItem setMenu:wikiMenu];
    [statusItem setTitle:@"W"];
    [statusItem setHighlightMode:TRUE];
}

#pragma mark Open Wiki action.
- (IBAction)openWiki:(id)sender
{
    [[NSWorkspace sharedWorkspace] openURL:[NSURL URLWithString:@"http://localhost:8080/"]];
}

- (NSApplicationTerminateReply)applicationShouldTerminate:(NSApplication *)sender
{
    //kill the server thread.
    [serverTask terminate];
    return NSTerminateNow;
}

#pragma mark Quit Wiki
- (IBAction)quit:(id)sender
{
    [NSApp terminate:sender];
}

#pragma mark Toggle Auto Start 
- (IBAction)toggleAutoStart:(id)sender
{
    if ([MWUtils isAppSetToRunAtLogon]) {
        [toggleAutoStart setState:NSOffState];
    } else {
        [toggleAutoStart setState:NSOnState];
    }
    
    [MWUtils toggleOpenAtLogon:sender];
}

@end
