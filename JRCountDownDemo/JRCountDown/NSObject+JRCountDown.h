//
//  NSObject+JRCountDown.h
//  JRCountDownButton
//
// This code is distributed under the terms and conditions of the Jerry license.

// Copyright (c) 2016 Jerry ( http://www.JerryGod.com )
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.


#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#if NS_BLOCKS_AVAILABLE
typedef void (^JRCountDownWhileExecutingBlock)(NSObject* selfInstance, CGFloat SurplusSec);  //units: second
typedef void (^JRCountCompletionBlock)(NSObject* selfInstance);  //units: second
#endif

#ifndef JR_INSTANCETYPE
#if __has_feature(objc_instancetype)
#define JR_INSTANCETYPE instancetype
#else
#define JR_INSTANCETYPE id
#endif
#endif

#ifndef JR_STRONG
#if __has_feature(objc_arc)
#define JR_STRONG strong
#else
#define JR_STRONG retain
#endif
#endif

#ifndef JR_WEAK
#if __has_feature(objc_arc_weak)
#define JR_WEAK weak
#elif __has_feature(objc_arc)
#define JR_WEAK unsafe_unretained
#else
#define JR_WEAK assign
#endif
#endif

@interface NSObject (JRCountDown)

/**
 *  Configure info for the countdown, the method uses total time(the units is seconds) to the parameters.
 *
 *  @param time       the countdown time(units: second)
 *  @param interval   execute once interval time(units: second)
 *  @param block      executing the block at time changed
 *  @param completion executing the block at completion
 */
- (JR_INSTANCETYPE)jr_configureWithCountDownTime:(CGFloat)time
                      intervalTime:(CGFloat)interval
               whileExecutingBlock:(JRCountDownWhileExecutingBlock)block
                   completionBlock:(JRCountCompletionBlock)completion;

/**
 *  Configure info for the conutdown, the method uses the future date to the parameters, if more than present time, the jr_start method will not be executed.
 *
 *  @param date       the future time(NSDate)
 *  @param interval   execute once interval time(units: second)
 *  @param block      executing the block at time changed
 *  @param completion executing the block at completion
 *
 *  @return return the class instance, you can call the jr_start after the method.
 */
- (JR_INSTANCETYPE)jr_configureWithToFutureDate:(NSDate *)date
                                  intervaltTime:(CGFloat)interval
                            whileExecutingBlock:(JRCountDownWhileExecutingBlock)block
                                completionBlock:(JRCountCompletionBlock)completion;

/**
 *  Start the countdown.
 */
- (void)jr_start;

/**
 *  Stop the countdown, instance auto execut the method at the completion of the countdown.
 *  Usually call before popViewController, Or the view leaves monment.
 */
- (void)jr_stop;

@end
