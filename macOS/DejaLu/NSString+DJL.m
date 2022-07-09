// DejaLu
// Copyright (c) 2015 Hoa V. DINH. All rights reserved.

#import "NSString+DJL.h"

@implementation NSString (DJL)


- (NSString *) djlURLDecode
{
    return [self stringByRemovingPercentEncoding];
}

@end
