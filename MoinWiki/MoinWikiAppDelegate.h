//
//  MoinWikiAppDelegate.h
//  MoinWiki
//
//  Created by Just Zhang on 12-3-7.
//  Copyright 2012年 BTBU. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface MoinWikiAppDelegate : NSObject <NSApplicationDelegate> {
    NSWindow *window;
    
    IBOutlet NSMenu *wikiMenu;
    IBOutlet NSMenuItem *toggleAutoStart;
    NSStatusItem *statusItem;
    
    NSTask *serverTask;
}

@property (assign) IBOutlet NSWindow *window;

- (IBAction)openWiki:(id)sender;
- (IBAction)quit:(id)sender;
- (IBAction)toggleAutoStart:(id)sender;

@end
