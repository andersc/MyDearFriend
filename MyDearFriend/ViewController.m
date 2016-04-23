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
    
    UIImageView *myImage;
    UIButton *buttonDisableEnable;
    UIButton *buttonShowHide;
    bool     isMenuVisible;
}

-(void) populateSettings
{
    myMenu.MDFMenuAction=[NSNumber numberWithInt:MDF_MENU_LOCATION_RIGHT];
    myMenu.MDFMenuAnimate=MDF_ANIMATE_PARENT_NO;
    myMenu.MDFMenuEffect=[NSNumber numberWithInt:MDF_BLUR];
    myMenu.MDFMenuUseTouch=MDF_TOUCH_YES;
    myMenu.MDFMenuHideAfterAction=MDF_HIDE_AFTER_ACTION_YES;
    myMenu.MDFMenuSize=[NSNumber numberWithFloat:0.2f];
    myMenu.MDFMenuColor=[UIColor clearColor];
    myMenu.MDFMenuColorUsage=MDF_USE_COLOR_NO;
    
    myMenu.MDFMenuItems=[[NSMutableArray alloc] init];
    NSArray *menuItem=@[@"book.png", [UIColor blueColor], [NSNumber numberWithInteger:BOOK_ACTION]];
    [myMenu.MDFMenuItems addObject:menuItem];
    menuItem=@[@"clock.png", [UIColor yellowColor], [NSNumber numberWithInteger:CLOCK_ACTION]];
    [myMenu.MDFMenuItems addObject:menuItem];
    menuItem=@[@"crown.png", [UIColor greenColor], [NSNumber numberWithInteger:CROWN_ACTION]];
    [myMenu.MDFMenuItems addObject:menuItem];
    menuItem=@[@"e-mail.png", [UIColor purpleColor], [NSNumber numberWithInteger:EMAIL_ACTION]];
    [myMenu.MDFMenuItems addObject:menuItem];
    menuItem=@[@"heart.png", [UIColor cyanColor], [NSNumber numberWithInteger:HEART_ACTION]];
    [myMenu.MDFMenuItems addObject:menuItem];
    menuItem=@[@"home.png", [UIColor redColor], [NSNumber numberWithInteger:HOME_ACTION]];
    [myMenu.MDFMenuItems addObject:menuItem];
}

- (void)button1Pressed:(UIButton *)button {
    if([myMenu isEnabled]) [myMenu disableMenu];
    else [myMenu enableMenu];
}

- (void)button2Pressed:(UIButton *)button {
    if([myMenu isVisible]) [myMenu hideMenu];
    else [myMenu showMenu];
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
    
    
    
    myImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"vma.jpg"]];
    myImage.frame=self.view.frame;
    myImage.contentMode=UIViewContentModeScaleAspectFill;
    [self.view addSubview:myImage];
    
    [self attatchButtons];
    
    // This is the MDF part
    myMenu=[[MDFMenu alloc] init:self];                         //Create a menu object and delegate callback to self.
    [self populateSettings];                //Populate a NSArray with settings
    if (![myMenu attachMenu:self.view])     //Attach the menu to a UIView with the settings provided
        NSLog(@"Failed ataching menu");
    //End of the MDF part
    
    UIInterfaceOrientationMask k=[self supportedInterfaceOrientations];
    NSLog(@"The maske says: %ld",k);
}

-(void) willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
    NSLog(@"will rotate");
    [myMenu hideMenu];
    [myMenu visualHideMenu];
    buttonDisableEnable.hidden=true;
    buttonShowHide.hidden=true;
    
    if (toInterfaceOrientation == UIDeviceOrientationPortrait || toInterfaceOrientation == UIDeviceOrientationPortraitUpsideDown) {
        NSLog(@"Portrait");
        myMenu.MDFMenuSize=[NSNumber numberWithFloat:0.2f];
    }
    if (toInterfaceOrientation == UIDeviceOrientationLandscapeLeft || toInterfaceOrientation == UIDeviceOrientationLandscapeRight) {
        NSLog(@"Landscape");
        myMenu.MDFMenuSize=[NSNumber numberWithFloat:0.1125f];
    }

}

- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation
{
    NSLog(@"did rotate");
    [myMenu attachMenu:self.view];
     myImage.frame=self.view.frame;
    buttonDisableEnable.center = CGPointMake(self.view.center.x, self.view.center.y+buttonDisableEnable.frame.size.height);
    buttonShowHide.center = CGPointMake(self.view.center.x, self.view.center.y-buttonShowHide.frame.size.height);
    [myMenu visualShowMenu];
    buttonDisableEnable.hidden=false;
    buttonShowHide.hidden=false;
}

- (BOOL)shouldAutorotate
{
    return YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void)doAction:(NSNumber*)selectionIndex
{
    switch ([selectionIndex longValue]) {
        case BOOK_ACTION:
            NSLog(@"BOOK_ACTION");
            break;
        case CLOCK_ACTION:
            NSLog(@"CLOCK_ACTION");
            break;
        case CROWN_ACTION:
            NSLog(@"CROWN_ACTION");
            break;
        case EMAIL_ACTION:
            NSLog(@"EMAIL_ACTION");
            break;
        case HEART_ACTION:
            NSLog(@"HEART_ACTION");
            break;
        case HOME_ACTION:
            NSLog(@"HOME_ACTION");
            break;
        default:
            NSLog(@"MDF Menu unknown action");
            break;
    }

}

-(void) MDFCallback:(NSNumber*)CallbackNotification selectionIndex:(NSNumber*)selectionIndex
{
    switch ([CallbackNotification intValue]) {
        case MDF_MENU_APPEAR:
            [buttonShowHide setTitle:@"Hide Menu" forState:UIControlStateNormal];
            break;
        case MDF_MENU_DISAPPEAR:
            [buttonShowHide setTitle:@"Show Menu" forState:UIControlStateNormal];
            break;
        case MDF_MENU_ENABLE:
            [buttonDisableEnable setTitle:@"Disable Menu" forState:UIControlStateNormal];
            break;
        case MDF_MENU_DISABLE:
            [buttonDisableEnable setTitle:@"Enable Menu" forState:UIControlStateNormal];
            break;
        case MDF_MENU_SELECTION:
            [self doAction:selectionIndex];
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
