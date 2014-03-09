/*
 The MIT License (MIT)
 
 Copyright (c) 2014 Snapp Solutions Ltd
 
 Permission is hereby granted, free of charge, to any person obtaining a copy
 of this software and associated documentation files (the "Software"), to deal
 in the Software without restriction, including without limitation the rights
 to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 copies of the Software, and to permit persons to whom the Software is
 furnished to do so, subject to the following conditions:
 
 The above copyright notice and this permission notice shall be included in all
 copies or substantial portions of the Software.
 
 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
 SOFTWARE.
 */

#import <Foundation/Foundation.h>

/**
 Define interface for an entry in the caption list
*/
@interface CaptionEntry : NSObject

/**
 Caption entry presentation time relative to the player time.
 This is the time where the caption should be displayed on the screen.
 */
@property NSTimeInterval startTime;

/** 
 Caption endtime or expiration time, represents the time where the caption should be removed fro mthe display
 */
@property NSTimeInterval endTime;

/** The caption string */
@property (readonly, nonatomic) NSString *text;

- (void) parseTime:(NSString *)timeString;

- (void) appendText:(NSString *)text;

@end
