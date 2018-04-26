//
//  Photo.m
//  Cats
//
//  Created by Alejandro Zielinsky on 2018-04-26.
//  Copyright © 2018 Alejandro Zielinsky. All rights reserved.
//

#import "Photo.h"

@implementation Photo


-(instancetype)initWithFarmID:(NSString*)fID serverID:(NSString*)serverID secret:(NSString*)secret identifier:(NSString*)ID name:(NSString*)title
{
    self = [super init];
    if (self)
    {
        _farmID = fID;
        _serverID = serverID;
        _secret = secret;
        _identifier = ID;
        _photoURL = [NSString stringWithFormat:@"https://farm%@.staticflickr.com/%@/%@_%@.jpg",_farmID,_serverID,_identifier,_secret];
        
        _photoName = title;
    }
    return self;

}
@end
