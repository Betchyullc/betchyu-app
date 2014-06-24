//
//  API.h
//  betchyu
//
//  Created by Adam Baratz on 12/11/13.
//  Copyright (c) 2013 BetchyuLLC. All rights reserved.
//

#import "AFHTTPClient.h"
#import "AFNetworking.h"
#import "Reachability.h"

//API call completion block with result as json
typedef void (^JSONResponseBlock)(NSDictionary* json);

@interface API : AFHTTPClient

+(API*)sharedInstance;

//send an API POST to the server
-(void)post:(NSString *)path withParams:(NSMutableDictionary*)params onCompletion:(JSONResponseBlock)completionBlock;
// send and API GET to the server
-(void)get:(NSString *)path withParams:(NSMutableDictionary*)params onCompletion:(JSONResponseBlock)completionBlock;
// send and API PUT to the server
-(void)put:(NSString *)path withParams:(NSMutableDictionary*)params onCompletion:(JSONResponseBlock)completionBlock;

@end
