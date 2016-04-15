//
//  MDFMenu.h
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

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "MDFProtocol.h"

// Activation of the menu
#define MDF_ACTIVATE_SLIDE_RIGHT    10      //Slide UIView to the right
#define MDF_ACTIVATE_SLIDE_LEFT     11      //Slide UIView to the left
#define MDF_ACTIVATE_SLIDE_UP       12      //Slide UIView up
#define MDF_ACTIVATE_SLIDE_DOWN     13      //Slide UIView down
#define MDF_ACTIVATE_DOUBLECLICK    14      //Double click the UIView
#define MDF_ACTIVATE_LONGPRESS      15      //Touch the UIView for a duration configured by XXX
#define MDF_ACTIVATE_NO_ACTION      16      //No user action. The Menu can only be triggered by caling a method.

#define MDF_ANIMATE_PARENT_YES      20      //Animate the UIView when displaying the menu
#define MDF_ANIMATE_PARENT_NO       21      //Do not animate the UIView when displaying the menu

#define MDF_BLUR_TROUGH             30      //Blur the menu // "See trough" //

#define MDF_TOUCH_YES               40      //Attach a touch recognizer to your view
#define MDF_TOUCH_NO                41      //If you only want to show the menu using the 'show' method

@interface MDFMenu : NSObject <UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>
-(BOOL)attachMenu:(UIView*)parrentView;
-(id)init:(id)newDelegate;
-(void) showMenu;
-(void) hideMenu;
-(bool) isVisible;
-(bool) isEnabled;
-(void) disableMenu;
-(void) enableMenu;
@property id <MDFDelegate> adelegate;

@property NSNumber *MDFMenuAction;
@property NSNumber *MDFMenuAnimate;
@property NSNumber *MDFMenuEffect;
@property NSNumber *MDFMenuUseTouch;
@property NSNumber *MDFMenuSize;
@property NSMutableArray *MDFMenuItems;

@end
