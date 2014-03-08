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

#import "Captions.h"
#import "CaptionEntry.h"

#include <stdio.h>

@implementation CaptionList
{
    NSRegularExpression *_subtitlesTimeRegex;
    NSRegularExpression *_sentenceRegex;
}

- (id) init
{
    self = [super init];
    
    if ( self != nil )
    {
        _captions = [[NSMutableArray alloc]init];
        
        NSString *subtitlesTimePattern = @"(\\d+):(\\d+):((\\d+).\\d+)\\s[-][-][>]\\s(\\d+):(\\d+):((\\d+).\\d+)";
        NSString *sentencePattern = @"([A-Z|a-z][^\\.!?]*)";
        
        _subtitlesTimeRegex = [NSRegularExpression regularExpressionWithPattern:subtitlesTimePattern
                                                                        options:0
                                                                          error:nil];
        
        _sentenceRegex = [NSRegularExpression regularExpressionWithPattern:sentencePattern
                                                                   options:0
                                                                     error:nil];
    }
    
    return self;
}

- (BOOL) parseCaptionsFile:(NSURL *)captionsFileURL
{
    if (self.captions == nil)
    {
        self.captions = [[NSMutableArray alloc] init];
    }
    
    FILE *file = fopen([[captionsFileURL path] cStringUsingEncoding:NSUTF8StringEncoding], "r");

    CaptionEntry *captionEntry;
    
    NSUInteger lineNubmber = 0;
    
    while(!feof(file))
    {
        NSString *line = readLineAsNSString(file);
     
        if (lineNubmber == 0)
        {
            lineNubmber++;
            if([line rangeOfString:@"WEBVTT"].location == NSNotFound)
            {
                return NO;
            }
            
            continue;
        }
        
        NSTextCheckingResult *subtitlesTimeMatch = [_subtitlesTimeRegex firstMatchInString:line
                                                                                   options:0
                                                                                     range:NSMakeRange(0, line.length)];
        
        if (subtitlesTimeMatch != nil)
        {
            //add caption to list
            if (captionEntry != nil)
            {
                [self.captions addObject:captionEntry];
            }
            
            //parse new time
            captionEntry = [[CaptionEntry alloc] init];
            [captionEntry parseTime:line];
        }
        
        NSTextCheckingResult *sentenceMatch = [_sentenceRegex firstMatchInString:line
                                                                         options:0
                                                                           range:NSMakeRange(0, line.length)];
        
        if (sentenceMatch != nil)
        {
            //add text with multiline support
            [captionEntry appendText:line];
        }
    }
    
    fclose(file);
    
    return YES;
}

- (CaptionEntry *) getCaptionForCurrentPlaybackTime:(NSTimeInterval)currentPlaybackTime
{
    for ( CaptionEntry *captionEntry in _captions)
    {
        if (currentPlaybackTime >= captionEntry.startTime &&
            captionEntry.endTime > currentPlaybackTime)
        {
            return  captionEntry;
        }
    }
    
    return  nil;
}

/**
 Reads one line of given file.
 @param Pointer to the file with subtitles.
 */
NSString *readLineAsNSString(FILE *file)
{
    char buffer[4096];
    
    NSMutableString *result = [NSMutableString stringWithCapacity:256];
    
    int charsRead;
    
    do
    {
        if(fscanf(file, "%4095[^\n]%n%*c", buffer, &charsRead) == 1)
        {
            [result appendFormat:@"%s", buffer];
        }
        else
        {
            break;
        }
    }
    while(charsRead == 4095);
    
    return result;
}

@end
