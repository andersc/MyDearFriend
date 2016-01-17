//
//  MDFProtocol.h
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

#ifndef MDFProtocol_h
#define MDFProtocol_h


// Activation of the menu
#define MDF_ACTIVATE_SLIDE_RIGHT    10      //Slide UIView to the right
#define MDF_ACTIVATE_SLIDE_LEFT     11      //Slide UIView to the left
#define MDF_ACTIVATE_DOUBLECLICK    12      //Double click the UIView
#define MDF_ACTIVATE_LONGPRESS      13      //Touch the UIView for a duration configured by XXX

#define MDF_ANIMATE_PARENT          20      //Animate the UIView when displaying the menu

#define MDF_BLUR_TROUGH             30      //Blur the menu // "See trough" //


@protocol MDFDelegate <NSObject>
-(void) MDFCallback:(NSNumber*)CallbackNotification;
@end


#endif /* MDFProtocol_h */
