// DejaLu
// Copyright (c) 2015 Hoa V. DINH. All rights reserved.

#import <Foundation/Foundation.h>

#import <WebKit/WebKit.h>

@protocol DJLURLHandlerDelegate;

@interface DJLURLHandler : NSObject

@property (nonatomic, assign, getter=isReady) BOOL ready;
@property (nonatomic, assign) id <DJLURLHandlerDelegate> delegate;

+ (instancetype) sharedManager;

- (void) openURL:(NSURL *)url;

@end

@protocol DJLURLHandlerDelegate

- (void) DJLURLHandler:(DJLURLHandler *)handler composeMessageWithTo:(NSString *)to cc:(NSString *)cc bcc:(NSString *)bcc subject:(NSString *)subject body:(NSString *)body;
- (void) DJLURLHandler:(DJLURLHandler *)handler composeMessageWithTo:(NSString *)to cc:(NSString *)cc bcc:(NSString *)bcc subject:(NSString *)subject htmlBody:(NSString *)htmlBody;

@end
