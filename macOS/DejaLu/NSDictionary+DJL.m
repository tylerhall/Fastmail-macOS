// DejaLu
// Copyright (c) 2015 Hoa V. DINH. All rights reserved.

#import "NSDictionary+DJL.h"

#import "NSString+DJL.h"

@implementation NSDictionary (DJL)

+ (NSDictionary *) djlDictionaryWithQueryString:(NSString *)queryString
{
    NSMutableDictionary* ret = [NSMutableDictionary dictionary];
    NSArray* components = [queryString componentsSeparatedByString:@"&"];

    // Use reverse order so that the first occurrence of a key replaces
    // those subsequent.
    for(int i = (int) [components count] - 1 ; i >= 0 ; i --) {
        NSString * component;

        component = [components objectAtIndex:i];
        if ([component length] == 0)
            continue;

        NSRange pos = [component rangeOfString:@"="];
        NSString * key;
        NSString * val;

        if (pos.location == NSNotFound) {
            key = [component djlURLDecode];
            val = @"";
        }
        else {
            key = [[component substringToIndex:pos.location] djlURLDecode];
            val = [[component substringFromIndex:pos.location + pos.length] djlURLDecode];
        }

        if (key == nil)
            key = @"";
        if (val == nil)
            val = @"";

        [ret setObject:val forKey:key];
    }
    return ret;
}



@end
