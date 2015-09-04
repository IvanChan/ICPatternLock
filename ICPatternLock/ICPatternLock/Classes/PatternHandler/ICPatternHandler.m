//
//  ICPatternHandler.m
//  ICPatternLock
//
//  Created by _ivanC on 8/22/15.
//  Copyright (c) 2015 _ivanC. All rights reserved.
//

#import "ICPatternHandler.h"

#define ICPL_PH_KEY_PWD  @"ICPL_PH_KEY_PWD"

@interface ICPatternHandler ()

@property id<ICPatternHandlerProtocol> innerCustomizedHandler;

@end

@implementation ICPatternHandler

#pragma mark - Lifecycle
+ (instancetype)sharedPatternHandler
{
    static ICPatternHandler *s_instance = nil;
    
    if (s_instance == nil)
    {
        @synchronized (self) {
            
            s_instance = [[ICPatternHandler alloc] init];
        }
    }
    
    return s_instance;
}

#pragma mark -
+ (void)setCustomizedHandler:(id<ICPatternHandlerProtocol>)customizedHandler
{
    [[ICPatternHandler sharedPatternHandler] setInnerCustomizedHandler:customizedHandler];
}

#pragma mark - Handler Protocol
- (void)setPattern:(NSString *)pwd
{
    if (self.innerCustomizedHandler)
    {
        [self.innerCustomizedHandler setPattern:pwd];
    }
    else
    {
        NSData *rawData = [pwd dataUsingEncoding:NSUTF8StringEncoding];
        NSData *base64Data = [rawData base64EncodedDataWithOptions:NSDataBase64Encoding64CharacterLineLength];
        
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        [defaults setObject:base64Data forKey:ICPL_PH_KEY_PWD];

        [defaults synchronize];
    }
}

- (BOOL)verifypattern:(NSString *)pwd
{
    BOOL ret = NO;
    if (self.innerCustomizedHandler)
    {
        ret = [self.innerCustomizedHandler verifypattern:pwd];
    }
    else
    {
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        NSData *pwdData = [defaults objectForKey:ICPL_PH_KEY_PWD];
        NSData *rawData = [[NSData alloc] initWithBase64EncodedData:pwdData options:NSDataBase64DecodingIgnoreUnknownCharacters];
        NSString *pwdLocal = [[NSString alloc] initWithData:rawData encoding:NSUTF8StringEncoding];
        
        ret = [pwdLocal isEqualToString:pwd];
    }
    
    return ret;
}

- (BOOL)isPatternSetted
{
    BOOL ret = NO;
    if (self.innerCustomizedHandler)
    {
        ret = [self.innerCustomizedHandler isPatternSetted];
    }
    else
    {
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        NSData *pwdData = [defaults objectForKey:ICPL_PH_KEY_PWD];
        ret = (pwdData != nil);
    }
    return ret;
}

@end
