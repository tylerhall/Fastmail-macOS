// DejaLu
// Copyright (c) 2015 Hoa V. DINH. All rights reserved.

#import "DJLURLHandler.h"

#import "NSURL+DJL.h"
#import "NSString+DJL.h"

enum {
    PENDING_URL,
    PENDING_MAIL_WEBLINK,
};

@implementation DJLURLHandler {
    int _pendingType;
    NSAppleEventDescriptor * _pendingDescriptor;
    NSAppleEventDescriptor * _pendingReplyEvent;
}

@synthesize ready = _ready;
@synthesize delegate = _delegate;

+ (instancetype) sharedManager
{
    static DJLURLHandler *sharedInstance = nil;
    static dispatch_once_t pred;

    dispatch_once(&pred, ^{
        sharedInstance = [[DJLURLHandler alloc] init];
    });

    return sharedInstance;
}

- (id) init
{
    self = [super init];
    [[NSAppleEventManager sharedAppleEventManager] setEventHandler:self andSelector:@selector(_handleURL:withReplyEvent:) forEventClass:kInternetEventClass andEventID:kAEGetURL];

    [[NSAppleEventManager sharedAppleEventManager] setEventHandler:self andSelector:@selector(_handleMailWebLinkEvent:replyEvent:) forEventClass:'mail' andEventID:'mllk'];
    return self;
}

- (void) _handleURL:(NSAppleEventDescriptor *)event withReplyEvent:(NSAppleEventDescriptor *)replyEvent
{
    _pendingType = PENDING_URL;
    _pendingDescriptor = [event copy];
    _pendingReplyEvent = [replyEvent copy];

    [self _handleURLAfterLoad];
}

- (void) _handleURLAfterLoad
{
    if (![self isReady])
        return;

    if (_pendingType != PENDING_URL)
        return;

    if ((_pendingDescriptor == nil) || (_pendingReplyEvent == nil))
        return;

    NSAppleEventDescriptor * descriptor;
    NSAppleEventDescriptor * replyEvent;

    descriptor = _pendingDescriptor;
    replyEvent = _pendingReplyEvent;

    NSString * urlString = [[descriptor paramDescriptorForKeyword:keyDirectObject] stringValue];
    NSURL * url = [NSURL URLWithString:urlString];

    [self openURL:url];

    _pendingDescriptor = nil;
    _pendingReplyEvent = nil;
}

- (void) _handleMailToURL:(NSURL *)url
{
    NSDictionary * values;
    NSString * mainRecipient;
    NSString * to;
    NSString * cc;
    NSString * bcc;
    NSString * subject;
    NSString * body;

    mainRecipient = [url djlRecipient];
    to = nil;
    cc = nil;
    bcc = nil;
    subject = nil;
    body = nil;

    values = [url djlQueryStringValues];
    // do this because this is a small dictionary and because of case insensitivity
    for(NSString * key in values) {
        if ([key caseInsensitiveCompare:@"to"] == NSOrderedSame) {
            to = [values objectForKey:key];
        }
        else if ([key caseInsensitiveCompare:@"cc"] == NSOrderedSame) {
            cc = [values objectForKey:key];
        }
        else if ([key caseInsensitiveCompare:@"bcc"] == NSOrderedSame) {
            bcc = [values objectForKey:key];
        }
        else if ([key caseInsensitiveCompare:@"subject"] == NSOrderedSame) {
            subject = [values objectForKey:key];
        }
        else if ([key caseInsensitiveCompare:@"body"] == NSOrderedSame) {
            body = [values objectForKey:key];
        }
    }

    //NSLog(@"%@ %@ %@ %@ %@ %@", mainRecipient, to, cc, bcc, subject, body);
    if ([mainRecipient length] > 0) {
        to = mainRecipient;
    }

    [[self delegate] DJLURLHandler:self composeMessageWithTo:to cc:cc bcc:bcc subject:subject body:body];
    //[[MMMainWindowController sharedController] composeMessageWithTo:to cc:cc bcc:bcc subject:subject body:body];
}

- (void) _handleOtherURL:(NSURL *)url
{
    [[self delegate] DJLURLHandler:self composeMessageWithTo:nil cc:nil bcc:nil subject:nil body:[url absoluteString]];
    //[[MMMainWindowController sharedController] composeMessageWithTo:nil cc:nil bcc:nil subject:nil body:[url absoluteString]];
}

- (void) _handleMailWebLinkEvent:(NSAppleEventDescriptor *)descriptor replyEvent:(NSAppleEventDescriptor *)replyEvent
{
    _pendingType = PENDING_MAIL_WEBLINK;
    _pendingDescriptor = [descriptor copy];
    _pendingReplyEvent = [replyEvent copy];

    [self _handleMailWebLinkEventAfterLoad];
}

- (void) _handleMailWebLinkEventAfterLoad
{
    if (![self isReady])
        return;

    if (_pendingType != PENDING_MAIL_WEBLINK)
        return;

    if ((_pendingDescriptor == nil) || (_pendingReplyEvent == nil))
        return;

    NSAppleEventDescriptor * descriptor;
    NSAppleEventDescriptor * replyEvent;

    descriptor = _pendingDescriptor;
    replyEvent = _pendingReplyEvent;

    NSString * urlString = [[descriptor paramDescriptorForKeyword:keyDirectObject] stringValue];
    NSString *subject = [[descriptor paramDescriptorForKeyword:'urln'] stringValue];

    NSString * htmlStr = [NSString stringWithFormat:@"<a href=\"%@\">%@</a>", urlString, urlString];
    [[self delegate] DJLURLHandler:self composeMessageWithTo:nil cc:nil bcc:nil subject:subject htmlBody:htmlStr];
    
    _pendingDescriptor = nil;
    _pendingReplyEvent = nil;
}

- (void) openURL:(NSURL *)url
{
    if ([[url scheme] caseInsensitiveCompare:@"mailto"] == NSOrderedSame) {
        [self _handleMailToURL:url];
    }

}

@end
