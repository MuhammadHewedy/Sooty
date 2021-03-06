//
//  DBUtil.m
//  Sooty
//
//  Created by Muhammad Hewedy on 9/16/14.
//  Copyright (c) 2014 Muhammad Hewedy. All rights reserved.
//

#import "DBUtil.h"
#import "Track.h"

@implementation DBUtil

// Load from db
+ (NSMutableArray*) loadPlaylistsKeys{
    NSMutableArray* ret = [[NSUserDefaults standardUserDefaults] objectForKey:PlaylistPersistenceKeyPlaylistKeys];
    if (!ret){
        ret = [[NSMutableArray alloc]initWithObjects:SearchResultsPlaylist, nil];
    }
    
    NSMutableArray* finalRet = [[NSMutableArray alloc]init];
    
    [ret enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        [finalRet addObject:obj];
    }];
    
    return finalRet;
}

+ (NSMutableDictionary*) loadPlaylists{
    NSMutableDictionary* ret = [[NSUserDefaults standardUserDefaults] objectForKey:PlaylistPersistenceKeyPlaylistDictionary];
    if (!ret){
        ret = [[NSMutableDictionary alloc]initWithObjectsAndKeys:nil, SearchResultsPlaylist, nil];
    }
    
    
    NSMutableDictionary* finalRet = [[NSMutableDictionary alloc]init];
    
    [ret enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
        
        NSMutableArray* trackArrTo = [[NSMutableArray alloc]init];
        
        NSArray* trackArrFrom =  (NSArray*) obj;
        [trackArrFrom enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            
            Track* trackObj = [[Track alloc]init];
            NSMutableDictionary* trackDict = obj;
            
            trackObj.id = trackDict[@"id"] ;
            trackObj.title = trackDict[@"title"];
            trackObj.username = trackDict[@"username"];
            trackObj.genre = trackDict[@"genre"];
            trackObj.streamURL = trackDict[@"streamURL"];
            trackObj.originalURL = trackDict[@"originalURL"];
            trackObj.duration = trackDict[@"duration"];
            trackObj.artworkURL = trackDict[@"artworkURL"];
            
            [trackArrTo addObject:trackObj];
        }];
        finalRet[key] = trackArrTo;
    }];
    
    NSLog(@"%@", finalRet);
    
    return finalRet;
}

+ (int) loadPlaylistNumber{
    int ret = (int)[[NSUserDefaults standardUserDefaults] integerForKey:PlaylistPersistenceKeyPlaylistNumber];
    if (ret == 0){
        ret = 1;
    }
    return ret;
}

// save to db
+ (void) savePlaylistKeys:(NSArray*) playlistKeys{
    [[NSUserDefaults standardUserDefaults] setObject:playlistKeys forKey:PlaylistPersistenceKeyPlaylistKeys];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (void) savePlaylists:(NSDictionary*) playlists{
    
    NSMutableDictionary* plistComplaintDict = [[NSMutableDictionary alloc]init];
    
    [playlists enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
        
        if (![SearchResultsPlaylist isEqualToString:key]){
            NSMutableArray* trackArrTo = [[NSMutableArray alloc]init];
            
            NSArray* trackArrFrom =  (NSArray*) obj;
            [trackArrFrom enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                
                Track* trackObj = (Track*) obj;
                NSMutableDictionary* trackDict = [[NSMutableDictionary alloc]init];
                
                trackDict[@"id"] = trackObj.id;
                trackDict[@"title"] = trackObj.title;
                trackDict[@"username"] = trackObj.username;
                trackDict[@"genre"] = trackObj.genre;
                trackDict[@"streamURL"] = trackObj.streamURL;
                trackDict[@"originalURL"] = trackObj.originalURL;
                trackDict[@"duration"] = trackObj.duration;
                trackDict[@"artworkURL"] = trackObj.artworkURL ? trackObj.artworkURL : @""; // for backward compitability
                
                [trackArrTo addObject:trackDict];
            }];
            
            plistComplaintDict[key] = trackArrTo;
        }
    }];
    
    [[NSUserDefaults standardUserDefaults] setObject:plistComplaintDict forKey:PlaylistPersistenceKeyPlaylistDictionary];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (void) savePlaylistNumber:(int) num{
    [[NSUserDefaults standardUserDefaults] setInteger:num forKey:PlaylistPersistenceKeyPlaylistNumber];
    [[NSUserDefaults standardUserDefaults] synchronize];
}
//


@end
