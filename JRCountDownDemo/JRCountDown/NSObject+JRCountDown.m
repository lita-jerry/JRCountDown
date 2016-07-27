//
//  NSObject+JRCountDown.m
//  JRCountDownButton
//

#import "NSObject+JRCountDown.h"
#import <objc/runtime.h>

#if __has_feature(objc_arc)
#define JR_AUTORELEASE(exp) exp
#define JR_RELEASE(exp) exp
#define JR_RETAIN(exp) exp
#else
#define JR_AUTORELEASE(exp) [exp autorelease]
#define JR_RELEASE(exp) [exp release]
#define JR_RETAIN(exp) [exp retain]
#endif

@implementation NSObject (JRCountDown)
#if NS_BLOCKS_AVAILABLE
- (JR_INSTANCETYPE)jr_configureWithCountDownTime:(CGFloat)time intervalTime:(CGFloat)interval whileExecutingBlock:(JRCountDownWhileExecutingBlock)block completionBlock:(JRCountCompletionBlock)completion {
    self.jr_whileExecutingBlock = block;
    self.jr_completionBlock     = completion;
    
    self.jr_time                = time;
    self.jr_interval            = interval;
    
    return self;
}
- (void)_jr_timer_ExecBlock:(NSTimer *)timer {
    if ([timer userInfo]) {
        void (^block)(NSTimer *timer) = (void (^)(NSTimer *timer))[timer userInfo];
        block(timer);
    }
}

- (JR_INSTANCETYPE)jr_configureWithToFutureDate:(NSDate *)date intervaltTime:(CGFloat)interval whileExecutingBlock:(JRCountDownWhileExecutingBlock)block completionBlock:(JRCountCompletionBlock)completion {
    self.jr_whileExecutingBlock = block;
    self.jr_completionBlock     = completion;
    
    self.jr_futureDate = date;
    self.jr_interval = interval;
    
    return self;
}
#endif

- (void)jr_start {
    
    if(self.jr_timer || self.jr_timer.isValid){
        [self.jr_timer invalidate];
        self.jr_timer = nil;
    }
    
    NSDate *startDate = [NSDate date];
    
    if(self.jr_futureDate){
        double deltaTime = [[NSDate date] timeIntervalSinceDate:self.jr_futureDate];
        if(deltaTime > 0.f){
            #if NS_BLOCKS_AVAILABLE
            if(self.jr_completionBlock) self.jr_completionBlock(self);
            #endif
            [self jr_stop];
        }
    }else{
        #if NS_BLOCKS_AVAILABLE
        if(self.jr_whileExecutingBlock) self.jr_whileExecutingBlock(self, self.jr_time);
        #endif
    }
    
    #if NS_BLOCKS_AVAILABLE
    __weak __typeof(self)weakSelf = self;
    void (^block)(NSTimer *timer) = ^(NSTimer *timer){
        if(weakSelf.jr_futureDate){
            double deltaTime = [[NSDate date] timeIntervalSinceDate:weakSelf.jr_futureDate];
            if (deltaTime > 0.f) {
                if(weakSelf.jr_completionBlock) weakSelf.jr_completionBlock(self);
                [weakSelf jr_stop];
            } else {
                if(weakSelf.jr_whileExecutingBlock) weakSelf.jr_whileExecutingBlock(self, -(deltaTime));
            }
        }else{
            double deltaTime = [[NSDate date] timeIntervalSinceDate:startDate];
            double SurplusTime = weakSelf.jr_time - deltaTime;
            if(SurplusTime < 0.f){
                if(weakSelf.jr_completionBlock) weakSelf.jr_completionBlock(self);
                [weakSelf jr_stop];
            }else{
                if(weakSelf.jr_whileExecutingBlock) weakSelf.jr_whileExecutingBlock(self, SurplusTime);
            }
        }
        
    };
    
    self.jr_timer = [NSTimer timerWithTimeInterval:self.jr_interval target:self selector:@selector(_jr_timer_ExecBlock:) userInfo:[block copy] repeats:YES];
    [[NSRunLoop currentRunLoop] addTimer:self.jr_timer forMode:NSRunLoopCommonModes];
    #else
    //will to coding with target style,with target method nonsupport the block.
    #endif
}

- (void)jr_stop {
    if([self.jr_timer isValid]){
        [self.jr_timer invalidate];
        self.jr_timer = nil;
        
        self.jr_futureDate = nil;
    }
}

#pragma mark - category geter and setter method
//jr_time
- (CGFloat)jr_time {
    NSNumber *number = objc_getAssociatedObject(self, _cmd);
    if(number){
        return [number floatValue];
    }else{
        return 0.f;
    }
}
- (void)setJr_time:(CGFloat)time {
    NSNumber *number = [NSNumber numberWithFloat:time];
    objc_setAssociatedObject(self, @selector(jr_time), number, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

//jr_interval
- (CGFloat)jr_interval {
    NSNumber *number = objc_getAssociatedObject(self, _cmd);
    if(number){
        return [number floatValue];
    }else{
        return 0.f;
    }
}
- (void)setJr_interval:(CGFloat)time {
    NSNumber *number = [NSNumber numberWithFloat:time];
    objc_setAssociatedObject(self, @selector(jr_interval), number, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

//jr_executing
- (BOOL)isJr_executing {
    NSNumber *number = objc_getAssociatedObject(self, _cmd);
    if(number){
        return [number boolValue];
    }else{
        return NO;
    }
}
- (void)setJr_executing:(BOOL)jr_executing {
    NSNumber *number = [NSNumber numberWithBool:jr_executing];
    objc_setAssociatedObject(self, @selector(isJr_executing), number, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
#if NS_BLOCKS_AVAILABLE
//jr_whileExecutingBlock
- (JRCountDownWhileExecutingBlock)jr_whileExecutingBlock {
    return objc_getAssociatedObject(self, _cmd);
}
- (void)setJr_whileExecutingBlock:(JRCountDownWhileExecutingBlock)block {
    objc_setAssociatedObject(self, @selector(jr_whileExecutingBlock), block, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

//jr_completionBlock
- (JRCountCompletionBlock)jr_completionBlock {
    return objc_getAssociatedObject(self, _cmd);
}
- (void)setJr_completionBlock:(JRCountCompletionBlock)block {
    objc_setAssociatedObject(self, @selector(jr_completionBlock), block, OBJC_ASSOCIATION_COPY_NONATOMIC);
}
#endif

//jr_timer
- (NSTimer *)jr_timer {
    return objc_getAssociatedObject(self, _cmd);
}
- (void)setJr_timer:(NSTimer *)timer {
    objc_setAssociatedObject(self, @selector(jr_timer), timer, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

//jr_futureDate
- (NSDate *)jr_futureDate {
    return objc_getAssociatedObject(self, _cmd);
}
- (void)setJr_futureDate:(NSDate *)date {
    objc_setAssociatedObject(self, @selector(jr_futureDate), date, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

@end
