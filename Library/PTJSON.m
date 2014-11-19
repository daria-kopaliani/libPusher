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
  return [object JSONData];
}

- (NSString *)JSONStringFromObject:(id)object
{
  return [object JSONString];
}

- (id)objectFromJSONData:(NSData *)data
{
  return [data objectFromJSONData];
}

- (id)objectFromJSONString:(NSString *)string
{
  return [string objectFromJSONString];
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
    return (object) ? [NSJSONSerialization dataWithJSONObject:object options:0 error:nil] : nil;
}

- (NSString *)JSONStringFromObject:(id)object
{
    return (object) ? [[NSString alloc] initWithData:[self JSONDataFromObject:object] encoding:NSUTF8StringEncoding] : nil;
}

- (id)objectFromJSONData:(NSData *)data
{
    return ([data isKindOfClass:[NSData class]]) ? [NSJSONSerialization JSONObjectWithData:data options:0 error:nil] : nil;
}

- (id)objectFromJSONString:(NSString *)string
{
    return ([string isKindOfClass:[NSString class]]) ? [self objectFromJSONData:[string dataUsingEncoding:NSUTF8StringEncoding]] : nil;
}

@end
