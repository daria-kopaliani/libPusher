//
//  PTJSON.m
//  libPusher
//
//  Created by Luke Redpath on 30/03/2012.
//  Copyright (c) 2012 LJR Software Limited. All rights reserved.
//

#import "PTJSON.h"
#import "JSONKit.h"
#import "PTPusherMacros.h"

NSString *const PTJSONParserNotAvailable = @"PTJSONParserNotAvailable";

@implementation PTJSON

+ (id<PTJSONParser>)JSONParser
{
  if (![NSJSONSerialization class]) {
    if (NSClassFromString(@"JSONDecoder") == nil) {
      [NSException raise:PTJSONParserNotAvailable 
                  format:@"No JSON parser available. To support iOS4, you should link JSONKit to your project."];
    }
    return [PTJSONKitParser JSONKitParser];
  }
  return [PTNSJSONParser NSJSONParser];
}

@end

@implementation PTJSONKitParser

+ (id)JSONKitParser
{
  PT_DEFINE_SHARED_INSTANCE_USING_BLOCK(^{
    return [[self alloc] init];
  });
}

- (NSData *)JSONDataFromObject:(id)object
{
    NSData *data = nil;
    if (object) {
        data = [object JSONData];
    }
    return data;
}

- (NSString *)JSONStringFromObject:(id)object
{
    NSString *string = nil;
    if (object) {
        string = [object JSONString];
    }
    return string;
}

- (id)objectFromJSONData:(NSData *)data
{
    id object = nil;
    if (data) {
        object = [data objectFromJSONData];
    }
    return data;
}

- (id)objectFromJSONString:(NSString *)string
{
    id object = nil;
    if (string) {
        object = [string objectFromJSONString];
    }
    return object;
}

@end


@implementation PTNSJSONParser 

+ (id)NSJSONParser
{
  PT_DEFINE_SHARED_INSTANCE_USING_BLOCK(^{
    return [[self alloc] init];
  });
}

- (NSData *)JSONDataFromObject:(id)object
{
  return [NSJSONSerialization dataWithJSONObject:object options:0 error:nil];
}

- (NSString *)JSONStringFromObject:(id)object
{
  return [[NSString alloc] initWithData:[self JSONDataFromObject:object] encoding:NSUTF8StringEncoding];
}

- (id)objectFromJSONData:(NSData *)data
{
  return [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
}

- (id)objectFromJSONString:(NSString *)string
{
  return [self objectFromJSONData:[string dataUsingEncoding:NSUTF8StringEncoding]];
}

@end
