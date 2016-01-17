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
}

-(NSArray*) populateSettings
{
    NSArray *theSettings=[[NSArray alloc] initWithObjects:
                          
                          @{@"keyMDFActivate" : [NSNumber numberWithInt:MDF_ACTIVATE_SLIDE],
                          @"keyMDFAnimate"  : [NSNumber numberWithInt:MDF_ANIMATE_PARENT],
                          @"keyMDFAperance" : [NSNumber numberWithInt:MDF_BLUR_TROUGH]
                            },nil];
    

    return theSettings;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    myMenu=[[MDFMenu alloc] init:self];                 //Create a menu
    NSArray *mySettings=[self populateSettings];        //Populate a NSArray with settings
    [myMenu attachMenu:self.view settings:mySettings];  //Attach the menu to a UIView with the settings provided
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void) MDFCallback:(NSNumber*)CallbackNotification
{
    
}


@end
