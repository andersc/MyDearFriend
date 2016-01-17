//
//  MDFMenu.m
//  MyDearFriend
//
/*
 The MIT License (MIT)
 
 Copyright (c) 2016 Anders Cedronius
 
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

#import "MDFMenu.h"

@implementation MDFMenu

-(id)init:(id)newDelegate {
    self = [super init];
    if (self) {
        _adelegate = newDelegate;
    }
    return self;
}

-(BOOL)attachMenu:(UIView*)parrentView settings:(NSArray*)settings
{
    NSLog(@"%@",settings);
    long MDFLocal;
    @try {
        MDFLocal=[[[settings valueForKey:@"keyMDFActivate"] objectAtIndex:0] integerValue];
    }
    @catch (NSException *exception) {
        if (_adelegate)
            [_adelegate MDFError:[NSNumber numberWithInt:MDF_ACTIVATE_KEY_ERROR] MDFErrorString:MDF_ACTIVATE_KEY_ERROR_TEXT];
        return false;
    }
    
    switch (MDFLocal) {
        case MDF_ACTIVATE_SLIDE_RIGHT:
            NSLog(@"Swipe Right");
            break;
        case MDF_ACTIVATE_SLIDE_LEFT:
            NSLog(@"Swipe Left");
            break;
        case MDF_ACTIVATE_SLIDE_UP:
            NSLog(@"Swipe Up");
            break;
        case MDF_ACTIVATE_SLIDE_DOWN:
            NSLog(@"Swipe Down");
            break;
        case MDF_ACTIVATE_DOUBLECLICK:
            NSLog(@"Swipe Double Click");
            break;
        case MDF_ACTIVATE_LONGPRESS:
            NSLog(@"Swipe Long Press");
            break;
        case MDF_ACTIVATE_NO_ACTION:
            NSLog(@"No action activation");
            break;
        default:
            if (_adelegate)
                [_adelegate MDFError:[NSNumber numberWithInt:MDF_ACTIVATE_UNKNOWN_CMD] MDFErrorString:MDF_ACTIVATE_UNKNOWN_CMD_TEXT];
            return false;
            break;
    }
    

    
    
    return true;
    
}

@end
