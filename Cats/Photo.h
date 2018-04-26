//
//  Photo.h
//  Cats
//
//  Created by Alejandro Zielinsky on 2018-04-26.
//  Copyright © 2018 Alejandro Zielinsky. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@interface Photo : NSObject

@property (nonatomic) NSString *farmID;
@property (nonatomic) NSString *serverID;
@property (nonatomic) NSString *secret;
@property (nonatomic) NSString *identifier;

@property UIImage *image;
@property NSString* photoURL;
@property NSString* photoName;
@property NSString* flickrURL;

-(instancetype)initWithFarmID:(NSString*)fID serverID:(NSString*)serverID secret:(NSString*)secret identifier:(NSString*)ID name:(NSString*)title;

@end
