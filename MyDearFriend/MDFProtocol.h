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

@protocol MDFDelegate <NSObject>
-(void) MDFCallback:(NSNumber*)CallbackNotification selectionIndex:(NSNumber*)selectionIndex;
-(void) MDFError:(NSNumber*)MDFError MDFErrorString:(NSString*)MDFErrorString;
@end

//MDFError
#define MDF_ACTIVATE_UNKNOWN_CMD        0x00001001
#define MDF_ACTIVATE_UNKNOWN_CMD_TEXT   @"MDF Activate unknown parameter"
#define MDF_POSITION_UNKNOWN_CMD        0x00001002
#define MDF_POSITION_UNKNOWN_CMD_TEXT   @"MDF Menu position unknown"
#define MDF_EFFECT_UNKNOWN_CMD          0x00001003
#define MDF_EFFECT_UNKNOWN_CMD_TEXT     @"MDF Menu effect unknown"

//MDFCallback
#define MDF_MENU_APPEAR                 0x00002001
#define MDF_MENU_DISAPPEAR              0x00002002
#define MDF_MENU_ENABLE                 0x00002003
#define MDF_MENU_DISABLE                0x00002004
#define MDF_MENU_SELECTION              0x00002005

#endif /* MDFProtocol_h */
