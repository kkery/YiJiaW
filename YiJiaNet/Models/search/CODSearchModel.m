//
//  CODSearchModel.m
//  YiJiaNet
//
//  Created by KUANG on 2018/12/28.
//  Copyright © 2018年 JIARUI. All rights reserved.
//

#import "CODSearchModel.h"

#define kHasSearchBadgeShown @"com.cs.search.badge.hasShown"
#define kSearchHistory @"com.cs.search.history"
#define kNewFeature @"com.cs.NewFeature"

#define kTemporaryCache @"com.dv.cache.temporary"
#define kPermanentCache @"com.dv.cache.permanentCache"

@implementation CODSearchModel


+ (NSArray *)getSearchHistory {
    
    if(![[TMCache TemporaryCache] objectForKey:kSearchHistory]) {
        
        NSMutableArray *history = [[NSMutableArray alloc] initWithCapacity:3];
        [[TMCache TemporaryCache] setObject:history forKey:kSearchHistory];
    }
    
    return [[TMCache TemporaryCache] objectForKey:kSearchHistory];
}

+ (void)addSearchHistory:(NSString *)searchString {
    
    NSMutableArray *history = [NSMutableArray arrayWithArray:[CODSearchModel getSearchHistory]];
    if(![history containsObject:searchString]) {
        if(history.count >= 10)
            [history removeLastObject];
        [history insertObject:searchString atIndex:0];
        [[TMCache TemporaryCache] setObject:history forKey:kSearchHistory];
    }
}

+ (void)cleanAllSearchHistory {
    
    NSMutableArray *history = [NSMutableArray arrayWithArray:[CODSearchModel getSearchHistory]];
    [history removeAllObjects];
    [[TMCache TemporaryCache] setObject:history forKey:kSearchHistory];
}


@end

@implementation TMCache (Extension)

+ (instancetype)TemporaryCache{
    return [[TMCache sharedCache] initWithName:kTemporaryCache];
}
+ (instancetype)PermanentCache {
    return [[TMCache sharedCache] initWithName:kPermanentCache];
}

@end
