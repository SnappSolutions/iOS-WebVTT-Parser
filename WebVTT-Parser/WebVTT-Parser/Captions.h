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

@class CaptionEntry;

/**
 Defines interface for a list of closed captions.
 */
@interface CaptionList : NSObject

/** Mutable Array holding CaptionEntry objects. */
@property (nonatomic, retain) NSMutableArray *captions;

/** 
 Parses WebVTT file with captions and adds its content to the caption list.
 @param captionsFileURL Captions file URL.
 */
- (BOOL) parseCaptionsFile:(NSURL *)captionsFileURL;

/**
 Retrieves a CaptionEntry that is valid for the provided playback time.
 @param currentPlaybackTime Current playback time.
 @returns CaptionEntry instance with caption for currentPlaybackTime.
 */
- (CaptionEntry *) getCaptionForCurrentPlaybackTime:(NSTimeInterval)currentPlaybackTime;

@end

