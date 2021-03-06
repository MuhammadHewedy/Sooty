//
//  NSObject+Util.h
//  soundy
//
//  Created by Muhammad Hewedy on 9/4/14.
//  Copyright (c) 2014 Muhammad Hewedy. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Track;

#define Persist
#define SearchResultsPlaylist (@"Search Results")

typedef struct{
    int playedTrackIndex;
    BOOL isPlaying;
    CFStringRef playlist;
}PlaybackStatus;

@import AppKit.NSWindow;
@import AppKit.NSAlert;

@interface NSObject (Util)

- (void)alert:(NSWindow*) window withMessage: (NSString*) msg;
- (void)alert:(NSString*) msg;
- (void) showNotification:(NSString*) playStatus aboutTrack:(Track*) track;

@end
