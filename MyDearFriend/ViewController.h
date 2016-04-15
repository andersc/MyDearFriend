//
//  ViewController.h
//  MyDearFriend
//
//  Created by Anders Cedronius on 15/01/16.
//  Copyright © 2016 Anders Cedronius. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MDFMenu.h"

#define BOOK_ACTION     1000
#define CLOCK_ACTION    1010
#define CROWN_ACTION    1020
#define EMAIL_ACTION    1030
#define HEART_ACTION    1040
#define HOME_ACTION     1050

@interface ViewController : UIViewController <MDFDelegate>

@end

