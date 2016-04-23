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
#define MDF_MENU_LOCATION_RIGHT     10      //Slide UIView to the right
#define MDF_MENU_LOCATION_LEFT      11      //Slide UIView to the left
#define MDF_MENU_LOCATION_DOWN      12      //Slide UIView up
#define MDF_MENU_LOCATION_UP        13      //Slide UIView down

#define MDF_BLUR                    30      //Blur the menu
#define MDF_ALPHA                   31      //Alpha blend the meny
#define MDF_PLAIN                   32      //No effect

#define MDF_ANIMATE_PARENT_YES      true      //Animate the UIView when displaying the menu
#define MDF_ANIMATE_PARENT_NO       false      //Do not animate the UIView when displaying the menu

#define MDF_TOUCH_YES               true      //Attach a touch recognizer to your view
#define MDF_TOUCH_NO                false      //If you only want to show the menu using the 'show' method

#define MDF_USE_COLOR_YES           true    //Use the submitted icon color
#define MDF_USE_COLOR_NO            false   //Do not use the submitted icon color

#define MDF_HIDE_AFTER_ACTION_YES   true    //Hide the menu after item selection
#define MDF_HIDE_AFTER_ACTION_NO    false   //Do not hide menu after item selection

@interface MDFMenu : NSObject <UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>
-(BOOL) attachMenu:(UIView*)parrentView;
-(id) init:(id)newDelegate;
-(void) showMenu;
-(void) hideMenu;
-(bool) isVisible;
-(bool) isEnabled;
-(void) disableMenu;
-(void) enableMenu;
-(void) visualHideMenu;
-(void) visualShowMenu;
@property id <MDFDelegate> adelegate;

@property NSNumber *MDFMenuAction;
@property bool      MDFMenuAnimate;
@property NSNumber *MDFMenuEffect;
@property UIColor  *MDFMenuColor;
@property bool      MDFMenuColorUsage;
@property bool      MDFMenuUseTouch;
@property bool      MDFMenuHideAfterAction;
@property NSNumber *MDFMenuSize;

@property NSMutableArray *MDFMenuItems;

@end
