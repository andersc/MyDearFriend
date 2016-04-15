//
//  ViewController.m
//  MyDearFriend
//
//  Created by Anders Cedronius on 15/01/16.
//  Copyright © 2016 Anders Cedronius. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController
{
    MDFMenu *myMenu;
    
    UIButton *buttonDisableEnable;
    UIButton *buttonShowHide;
    bool     isMenuVisible;
}

-(void) populateSettings
{
    myMenu.MDFMenuAction=[NSNumber numberWithInt:MDF_ACTIVATE_SLIDE_LEFT];
    myMenu.MDFMenuAnimate=[NSNumber numberWithInt:MDF_ANIMATE_PARENT_NO];
    myMenu.MDFMenuEffect=[NSNumber numberWithInt:MDF_BLUR_TROUGH];
    myMenu.MDFMenuUseTouch=[NSNumber numberWithInt:MDF_TOUCH_YES];
    myMenu.MDFMenuSize=[NSNumber numberWithFloat:0.20];
    
    myMenu.MDFMenuItems=[[NSMutableArray alloc] init];
    NSArray *menuItem=@[@"book.png", [UIColor blueColor], [NSNumber numberWithInteger:BOOK_ACTION]];
    [myMenu.MDFMenuItems addObject:menuItem];
    menuItem=@[@"clock.png", [UIColor yellowColor], [NSNumber numberWithInteger:CLOCK_ACTION]];
    [myMenu.MDFMenuItems addObject:menuItem];
    menuItem=@[@"crown.png", [UIColor greenColor], [NSNumber numberWithInteger:CROWN_ACTION]];
    [myMenu.MDFMenuItems addObject:menuItem];
    menuItem=@[@"e-mail.png", [UIColor purpleColor], [NSNumber numberWithInteger:EMAIL_ACTION]];
    [myMenu.MDFMenuItems addObject:menuItem];
    menuItem=@[@"heart.png", [UIColor blackColor], [NSNumber numberWithInteger:HEART_ACTION]];
    [myMenu.MDFMenuItems addObject:menuItem];
    menuItem=@[@"home.png", [UIColor redColor], [NSNumber numberWithInteger:HOME_ACTION]];
    [myMenu.MDFMenuItems addObject:menuItem];
    
    NSLog(@"Num items %lu",(unsigned long)[myMenu.MDFMenuItems count]);
    
}

- (void)button1Pressed:(UIButton *)button {
    
    if([myMenu isEnabled])
    {
        [myMenu disableMenu];
    }
    else
    {
        [myMenu enableMenu];
    }
    
}
- (void)button2Pressed:(UIButton *)button {
    if([myMenu isVisible])
    {
        [myMenu hideMenu];
    }
    else
    {
        [myMenu showMenu];
    }
}

-(void) attatchButtons
{
    buttonDisableEnable = [UIButton buttonWithType:UIButtonTypeSystem];
    [buttonDisableEnable setTitle:@"Disable Menu" forState:UIControlStateNormal];
    [buttonDisableEnable sizeToFit];
    buttonDisableEnable.center = CGPointMake(self.view.center.x, self.view.center.y+buttonDisableEnable.frame.size.height);
    [buttonDisableEnable addTarget:self action:@selector(button1Pressed:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:buttonDisableEnable];
    
    buttonShowHide = [UIButton buttonWithType:UIButtonTypeSystem];
    [buttonShowHide setTitle:@"Show Menu" forState:UIControlStateNormal];
    [buttonShowHide sizeToFit];
    buttonShowHide.center = CGPointMake(self.view.center.x, self.view.center.y-buttonShowHide.frame.size.height);
    [buttonShowHide addTarget:self action:@selector(button2Pressed:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:buttonShowHide];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    [self attatchButtons];
    
    // This is the MDF part
    myMenu=[[MDFMenu alloc] init:self];                         //Create a menu object and delegate callback to self.
    [self populateSettings];                //Populate a NSArray with settings
    if (![myMenu attachMenu:self.view])     //Attach the menu to a UIView with the settings provided
        NSLog(@"Failed ataching menu");
    //End of the MDF part
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void) MDFCallback:(NSNumber*)CallbackNotification
{
    switch ([CallbackNotification intValue]) {
        case MDF_MENU_APPEAR:
            NSLog(@"Menu on display");
            [buttonShowHide setTitle:@"Hide Menu" forState:UIControlStateNormal];
            break;
        case MDF_MENU_DISAPPEAR:
            NSLog(@"Menu hidden");
            [buttonShowHide setTitle:@"Show Menu" forState:UIControlStateNormal];
            break;
        case MDF_MENU_ENABLE:
            [buttonDisableEnable setTitle:@"Disable Menu" forState:UIControlStateNormal];
            break;
        case MDF_MENU_DISABLE:
            [buttonDisableEnable setTitle:@"Enable Menu" forState:UIControlStateNormal];
            break;
        default:
            NSLog(@"MDF Menu unknown callback");
            break;
    }
}

-(void) MDFError:(NSNumber*)MDFError MDFErrorString:(NSString*)MDFErrorString
{
    NSLog(@"MDF error: %@",MDFErrorString);
}

@end
