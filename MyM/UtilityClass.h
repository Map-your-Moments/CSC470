//
//  UtilityClass.h
//  MyM
//
//  Created by Marcelo Mazzotti on 18/4/13.
//  Copyright (c) 2013 MyM Co. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UtilityClass : NSObject

+ (NSDictionary *)SendJSON:(NSDictionary *)jsonDictionary toAddress:(NSString *)address;
+ (NSURL*) getGravatarURL:(NSString*) emailAddress;
+ (NSData *) requestGravatar:(NSURL*) gravatarURL;

+ (NSArray *)GetFriendsJSON: (NSDictionary *)jsonDictionary toAddress:(NSString *)address;
+ (UIImage *)imageWithImage:(UIImage *)image scaledToSize:(CGSize)newSize;

@end
