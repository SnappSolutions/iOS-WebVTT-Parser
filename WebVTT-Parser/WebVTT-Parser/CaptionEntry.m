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

#import "CaptionEntry.h"

@interface CaptionEntry ()

@property (strong, nonatomic) NSMutableString *mutableText;

@end

@implementation CaptionEntry

/**
 Retrieves the appropriate caption entry given the specified playback time
 @param timeString Time string with format "01:02:36.240 --> 01:02:36.240".
 */
- (void) parseTime:(NSString *)timeString
{
    NSArray *timeArray = [timeString componentsSeparatedByString:@"-->"];
    
    self.startTime = [self getInterval:timeArray[0]];
    self.endTime = [self getInterval:timeArray[1]];
}

/**
 Converts a string of the following format 01:02:36.240 into the appropriate NSTimerInterval value.
 @param timeString Time string.
 @returns NSTimeInterval representation of timeString.
 */
- (NSTimeInterval) getInterval:(NSString *)timeString
{
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"(\\d+):(\\d+):((\\d+).\\d+)"
                                                                           options:0
                                                                             error:nil];
    
    NSTextCheckingResult *clockMatch = [regex firstMatchInString:timeString
                                                         options:0
                                                           range:NSMakeRange(0, timeString.length)];

    NSTimeInterval time = 0;
    
    if(clockMatch != NULL)
    {
        NSRange hours = [clockMatch rangeAtIndex:1];
        NSRange minutes = [clockMatch rangeAtIndex:2];
        NSRange seconds = [clockMatch rangeAtIndex:3];

        if(hours.location != NSNotFound)
        {
            time += [[timeString substringWithRange:hours] intValue] * 3600;
        }
        if(minutes.location != NSNotFound)
        {
            time += [[timeString substringWithRange:minutes] intValue] * 60;
        }
        if(seconds.location != NSNotFound)
        {
            time += [[timeString substringWithRange:seconds] doubleValue];
        }
    }

    return  time;
}

- (void) appendText:(NSString *)text
{
    if (self.mutableText == nil)
    {
        self.mutableText = [[NSMutableString alloc] initWithString:text];
    }
    else
    {
        [self.mutableText appendFormat:@"\n %@", text];
    }
}

- (NSString *) text
{
    return [self.mutableText copy];
}

@end
