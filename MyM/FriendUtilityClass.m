//
//  FriendUtilityClass.m
//  MyM
//
//  Created by Justin Wagner on 4/30/13.
//  Copyright (c) 2013 MyM Co. All rights reserved.
//

#import "FriendUtilityClass.h"
#import "UtilityClass.h"

@implementation FriendUtilityClass

@synthesize friends;

+ (NSArray *)getFriends:(NSString *)token
{
    NSDictionary *jsonDictionary = @{ @"access_token" : token};
    
    NSArray *jsonGetFriends = [UtilityClass GetFriendsJSON:jsonDictionary toAddress:@"http://54.225.76.23:3000/friends"];
    
    NSArray *friends;
    if(jsonGetFriends) {
        friends = [[NSArray alloc ] initWithArray: jsonGetFriends];
    }
    else {
        NSLog(@"Http request for friends list failed.");
    }
    
    return friends;
}

+ (NSString *)getEmailFromUsername:(NSString *)username
{
    NSDictionary *jsonDictionary = @{ @"username" : username };
    
    NSDictionary *response = [UtilityClass SendJSON:jsonDictionary toAddress:@"http://54.225.76.23:3000/get_user"];
    
    NSString *email;
    if(response) {
        email = [response valueForKey:@"email"];
    }
    else {
        NSLog(@"HTTP request for email failed");
    }
    
    return email;
}

@end
