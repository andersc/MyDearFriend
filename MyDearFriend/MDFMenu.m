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

@implementation MDFMenu {
    CGPoint             startLocation;
    UIView              *parrentViewSticky;
    float               menuPixelWidth;
    UICollectionView    *myCollectionView;
    CGRect              menuPosition;
    CGRect              mainViewPosition;
    bool                menuShouldStay;
    float               nudgeFactorX;
    float               nudgeFactorY;
    bool                menuStartedExpanded;
    bool                enableDisableFlag;
}

-(id) init:(id)newDelegate {
    self = [super init];
    if (self) {
        _adelegate = newDelegate;   //set callback delegate
        
        //Set start values
        menuShouldStay=0;
        nudgeFactorX=0;
        nudgeFactorY=0;
        enableDisableFlag=true;
        menuStartedExpanded=false;
    }
    return self;
}

//Hide menu without detatching

-(void) visualHideMenu
{
    myCollectionView.hidden=true;
}

//Show the menu already attached

-(void) visualShowMenu
{
    myCollectionView.hidden=false;
}

//Add the touch recognizer

-(void) addPanRecognizer
{
    if (_MDFMenuUseTouch) {
        
        UIPanGestureRecognizer *panRecognizer = [[UIPanGestureRecognizer alloc]
                                                 initWithTarget:self
                                                 action:@selector(panGesture:)];
        
        [panRecognizer setMinimumNumberOfTouches:1];
        [panRecognizer setMaximumNumberOfTouches:1];
        [parrentViewSticky addGestureRecognizer:panRecognizer];
    }
}

//Build the menu using a UICollectionView
//Set the effects asked for and attach to the UIView

-(void)makeMenu:(CGRect)myMeny {
    UICollectionViewFlowLayout *layout=[[UICollectionViewFlowLayout alloc] init];
    myCollectionView=[[UICollectionView alloc] initWithFrame:myMeny collectionViewLayout:layout];
    [myCollectionView setDataSource:self];
    [myCollectionView setDelegate:self];
    [myCollectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"cellIdentifier"];
    
    if ([_MDFMenuEffect intValue]==MDF_BLUR) {
        //Add blur effect to the icon bar
        [myCollectionView setBackgroundColor:[UIColor clearColor]];
        UIBlurEffect *blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
        UIVisualEffectView *visualEffectView = [[UIVisualEffectView alloc] initWithEffect:blurEffect];
        [visualEffectView setFrame:myCollectionView.bounds];
        myCollectionView.backgroundView=visualEffectView;
    }
    else if ([_MDFMenuEffect intValue]==MDF_ALPHA) {
        myCollectionView.alpha=0.5f;
        [myCollectionView setBackgroundColor:_MDFMenuColor];
    }
    else if ([_MDFMenuEffect intValue]==MDF_PLAIN) {
        [myCollectionView setBackgroundColor:_MDFMenuColor];
    }
    else
    {
        if (_adelegate)
            [_adelegate MDFError:[NSNumber numberWithInt:MDF_EFFECT_UNKNOWN_CMD] MDFErrorString:MDF_EFFECT_UNKNOWN_CMD_TEXT];
    }
    
    [parrentViewSticky addSubview:myCollectionView];
}


//Set the frame to the correct position then build the menu

-(BOOL)attachMenu:(UIView*)parrentView
{
    parrentViewSticky=parrentView;
    mainViewPosition=parrentView.frame;
    parrentView.userInteractionEnabled=YES;
    menuPixelWidth=parrentView.frame.size.width*[_MDFMenuSize floatValue];
    
    switch ([_MDFMenuAction integerValue]) {
        case MDF_MENU_LOCATION_LEFT:
            menuPosition= CGRectMake(parrentView.frame.origin.x-menuPixelWidth,
                                     parrentView.frame.origin.y,
                                     menuPixelWidth,
                                     parrentView.frame.size.height);
            [self addPanRecognizer];
            [self makeMenu:menuPosition];
            break;
        case MDF_MENU_LOCATION_RIGHT:
            menuPosition= CGRectMake(parrentView.frame.origin.x+parrentView.frame.size.width,
                                     parrentView.frame.origin.y,
                                     menuPixelWidth,
                                     parrentView.frame.size.height);
            [self addPanRecognizer];
            [self makeMenu:menuPosition];
            break;
        case MDF_MENU_LOCATION_DOWN:
            menuPosition= CGRectMake(parrentView.frame.origin.x,
                                     parrentView.frame.origin.y+parrentView.frame.size.height,
                                     parrentView.frame.size.width,
                                     menuPixelWidth);
            [self addPanRecognizer];
            [self makeMenu:menuPosition];
            break;
        case MDF_MENU_LOCATION_UP:
            menuPosition= CGRectMake(parrentView.frame.origin.x,
                                     parrentView.frame.origin.y-menuPixelWidth,
                                     parrentView.frame.size.width,
                                     menuPixelWidth);
            [self addPanRecognizer];
            [self makeMenu:menuPosition];
            break;
        default:
            if (_adelegate)
                [_adelegate MDFError:[NSNumber numberWithInt:MDF_ACTIVATE_UNKNOWN_CMD] MDFErrorString:MDF_ACTIVATE_UNKNOWN_CMD_TEXT];
            return false;
            break;
    }
    return true;
}

//Collection view callbacks.

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [_MDFMenuItems count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    UICollectionViewCell *cell=[collectionView dequeueReusableCellWithReuseIdentifier:@"cellIdentifier" forIndexPath:indexPath];
    
    NSArray *currentItem=[_MDFMenuItems objectAtIndex:indexPath.row];
    NSString *filename=[currentItem objectAtIndex:0];
    UIImageView *theIcon=[[UIImageView alloc] initWithImage:[UIImage imageNamed:filename]];
    theIcon.contentMode=UIViewContentModeScaleAspectFit;
    
    if (_MDFMenuColorUsage)
    {
        if ([_MDFMenuEffect intValue]==MDF_BLUR)
            cell.backgroundColor=[[currentItem objectAtIndex:1] colorWithAlphaComponent:0.4f];
        if ([_MDFMenuEffect intValue]==MDF_ALPHA)
            cell.backgroundColor=[[currentItem objectAtIndex:1] colorWithAlphaComponent:0.7f];
        if ([_MDFMenuEffect intValue]==MDF_PLAIN)
            cell.backgroundColor=[currentItem objectAtIndex:1];
    }
    cell.backgroundView = theIcon;
    
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    float iconWidth=menuPixelWidth;
    float iconHight=menuPixelWidth;
    if (([_MDFMenuAction integerValue] == MDF_MENU_LOCATION_UP) || ([_MDFMenuAction integerValue] == MDF_MENU_LOCATION_DOWN)) {
        iconWidth=parrentViewSticky.frame.size.width/([_MDFMenuItems count]+.1f);
        if (iconWidth>menuPixelWidth)
            iconWidth=menuPixelWidth;
        
    }
    if (([_MDFMenuAction integerValue] == MDF_MENU_LOCATION_LEFT) || ([_MDFMenuAction integerValue] == MDF_MENU_LOCATION_RIGHT)) {
        iconHight=parrentViewSticky.frame.size.height/([_MDFMenuItems count]+.1f);
        if (iconHight>menuPixelWidth)
            iconHight=menuPixelWidth;
        
    }
    return CGSizeMake(iconWidth, iconHight);
}

- (UIEdgeInsets)collectionView:(UICollectionView*)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(0, 0, 0, 0); // top, left, bottom, right
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return 0.0;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return 0.0;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    // animate the cell user tapped on
    UICollectionViewCell  *cell = [collectionView cellForItemAtIndexPath:indexPath];
    
    UIColor *saveColor=cell.backgroundColor;
    cell.backgroundColor=[UIColor whiteColor];
    
    [UIView animateWithDuration:0.1f
                          delay:0
                        options:(UIViewAnimationOptionAllowUserInteraction)
                     animations:^{
                         cell.backgroundColor=saveColor;
                         
                     }
                     completion:^(BOOL finished){
                     }
     ];
    
    NSMutableArray *theItem=[_MDFMenuItems objectAtIndex:(NSUInteger)indexPath.row];
    
    if (_adelegate)
        [_adelegate MDFCallback:[NSNumber numberWithInt:MDF_MENU_SELECTION] selectionIndex:[theItem objectAtIndex:2]];
    
    if (_MDFMenuHideAfterAction && _adelegate) {
        [self hideMenu];
    }
}

//Disable menu

-(void) disableMenu
{
    [self hideMenu];
    enableDisableFlag=false;
    if (_adelegate)
        [_adelegate MDFCallback:[NSNumber numberWithInt:MDF_MENU_DISABLE] selectionIndex:nil];
}

//Enable menu

-(void) enableMenu
{
    enableDisableFlag=true;
    if (_adelegate)
        [_adelegate MDFCallback:[NSNumber numberWithInt:MDF_MENU_ENABLE] selectionIndex:nil];
}

-(bool) isEnabled
{
    return enableDisableFlag;
}

-(bool) isVisible
{
    return (bool)nudgeFactorX | (bool)nudgeFactorY;
}

//Make the menu appear

-(void) showMenu {
    
    if (!enableDisableFlag) {
        return;
    }
    
    nudgeFactorX=0;
    nudgeFactorY=0;
    switch ([_MDFMenuAction integerValue]) {
        case MDF_MENU_LOCATION_LEFT:
            nudgeFactorX=menuPixelWidth;
            break;
        case MDF_MENU_LOCATION_RIGHT:
            nudgeFactorX=menuPixelWidth*-1;
            break;
        case MDF_MENU_LOCATION_DOWN:
            nudgeFactorY=menuPixelWidth*-1;
            break;
        case MDF_MENU_LOCATION_UP:
            nudgeFactorY=menuPixelWidth;
            break;
        default:
            if (_adelegate)
                [_adelegate MDFError:[NSNumber numberWithInt:MDF_POSITION_UNKNOWN_CMD] MDFErrorString:MDF_POSITION_UNKNOWN_CMD_TEXT];
            return;
            break;
    }
    
    if (_MDFMenuAnimate) {
        CGRect newPosition=CGRectMake(nudgeFactorX, nudgeFactorY, parrentViewSticky.frame.size.width, parrentViewSticky.frame.size.height);
        
        [UIView animateWithDuration:0.2f
                              delay:0
                            options: UIViewAnimationOptionCurveEaseInOut
                         animations:^{
                             parrentViewSticky.frame=newPosition;
                         } completion:^(BOOL finished){
                         } ];
    }
    else
    {
        CGRect newPosition=CGRectMake(menuPosition.origin.x+nudgeFactorX, menuPosition.origin.y+nudgeFactorY, menuPosition.size.width, menuPosition.size.height);
        [UIView animateWithDuration:0.2f
                              delay:0
                            options: UIViewAnimationOptionCurveEaseInOut
                         animations:^{
                             myCollectionView.frame=newPosition;
                         } completion:^(BOOL finished){
                         } ];
    }
    
    if (!menuStartedExpanded) {
        if (_adelegate)
            [_adelegate MDFCallback:[NSNumber numberWithInt:MDF_MENU_APPEAR] selectionIndex:nil];
    }
    menuStartedExpanded=true;
}

//Make the menu disappear

-(void) hideMenu {
    
    nudgeFactorX=0;
    nudgeFactorY=0;
    
    if (_MDFMenuAnimate) {
        CGRect newPosition=CGRectMake(0, 0, parrentViewSticky.frame.size.width, parrentViewSticky.frame.size.height);
        
        [UIView animateWithDuration:0.2f
                              delay:0
                            options: UIViewAnimationOptionCurveEaseInOut
                         animations:^{
                             parrentViewSticky.frame=newPosition;
                         } completion:^(BOOL finished){
                         } ];
    }
    else
    {
        [UIView animateWithDuration:0.2f
                              delay:0.2f
                            options: UIViewAnimationOptionCurveEaseInOut
                         animations:^{
                             myCollectionView.frame=menuPosition;
                         } completion:^(BOOL finished){
                         } ];
        
    }
    if (menuStartedExpanded) {
        if (_adelegate)
            [_adelegate MDFCallback:[NSNumber numberWithInt:MDF_MENU_DISAPPEAR] selectionIndex:nil];
    }
    menuStartedExpanded=false;
}

//What to do when someone touches the UIView

- (void)panGesture:(UIPanGestureRecognizer *)sender {
    
    if (!enableDisableFlag)
        return;
    
    
    if (sender.state == UIGestureRecognizerStateBegan) {
        startLocation = [sender locationInView:nil];
        if (nudgeFactorX || nudgeFactorY)
            menuStartedExpanded=true;
        else
            menuStartedExpanded=false;
        
    }
    else if (sender.state == UIGestureRecognizerStateEnded) {
        if (menuShouldStay)
            [self showMenu];
        else
            [self hideMenu];
    }
    else {
        CGPoint stopLocation = [sender locationInView:nil];
        CGFloat swipeDistanceX = stopLocation.x - startLocation.x;
        CGFloat swipeDistanceY = stopLocation.y - startLocation.y;
        
        CGRect newPosition;
        
        if (_MDFMenuAnimate)
            newPosition=mainViewPosition;
        else
            newPosition=menuPosition;
        
        swipeDistanceX+=nudgeFactorX;
        swipeDistanceY+=nudgeFactorY;
        
        CGRect refPosition=newPosition;
        
        switch ([_MDFMenuAction integerValue]) {
            case MDF_MENU_LOCATION_LEFT:
                if (swipeDistanceX > menuPixelWidth)
                {
                    nudgeFactorX=0;
                    swipeDistanceX=menuPixelWidth;
                    startLocation.x = [sender locationInView:nil].x-menuPixelWidth;
                }
                newPosition.origin.x=newPosition.origin.x+swipeDistanceX;
                if (newPosition.origin.x<refPosition.origin.x) {
                    startLocation.x=stopLocation.x+nudgeFactorX;
                    newPosition=refPosition;
                }
                break;
                
            case MDF_MENU_LOCATION_RIGHT:
                
                if (swipeDistanceX < (menuPixelWidth*-1))
                {
                    nudgeFactorX=0;
                    swipeDistanceX=menuPixelWidth*-1;
                    startLocation.x = [sender locationInView:nil].x+menuPixelWidth;
                }
                newPosition.origin.x=newPosition.origin.x+swipeDistanceX;
                
                if (newPosition.origin.x>refPosition.origin.x) {
                    startLocation.x=stopLocation.x+nudgeFactorX;
                    newPosition=refPosition;
                }
                break;
                
            case MDF_MENU_LOCATION_UP:
                
                if (swipeDistanceY > menuPixelWidth)
                {
                    nudgeFactorY=0;
                    swipeDistanceY=menuPixelWidth;
                    startLocation.y = [sender locationInView:nil].y-menuPixelWidth;
                }
                newPosition.origin.y=newPosition.origin.y+swipeDistanceY;
                if (newPosition.origin.y<refPosition.origin.y) {
                    startLocation.y=stopLocation.y+nudgeFactorY;
                    newPosition=refPosition;
                }
                break;
                
            case MDF_MENU_LOCATION_DOWN:
                
                if (swipeDistanceY < (menuPixelWidth*-1))
                {
                    nudgeFactorY=0;
                    swipeDistanceY=menuPixelWidth*-1;
                    startLocation.y = [sender locationInView:nil].y+menuPixelWidth;
                }
                newPosition.origin.y=newPosition.origin.y+swipeDistanceY;
                
                if (newPosition.origin.y>refPosition.origin.y) {
                    startLocation.y=stopLocation.y+nudgeFactorY;
                    newPosition=refPosition;
                }
                break;
                
            default:
                if (_adelegate)
                    [_adelegate MDFError:[NSNumber numberWithInt:MDF_POSITION_UNKNOWN_CMD] MDFErrorString:MDF_POSITION_UNKNOWN_CMD_TEXT];
                break;
        }
        
        if (menuStartedExpanded) {
            if (((fabs(refPosition.origin.y-newPosition.origin.y) < (menuPixelWidth-(menuPixelWidth/4))) * nudgeFactorY) || ((fabs(refPosition.origin.x-newPosition.origin.x) < (menuPixelWidth-menuPixelWidth/4)) * nudgeFactorX)|| !(nudgeFactorX || nudgeFactorY))
            {

                if (((fabs(refPosition.origin.x-newPosition.origin.x) < (menuPixelWidth-menuPixelWidth/4)) * nudgeFactorX) || ((fabs(refPosition.origin.y-newPosition.origin.y) < (menuPixelWidth-(menuPixelWidth/4))) * nudgeFactorY)) {
                    menuShouldStay=false;
                }
                
            }
            else
            {
                menuShouldStay=true;
            }
        }
        else
        {
            if (fabs(refPosition.origin.y-newPosition.origin.y) > menuPixelWidth/4 || fabs(refPosition.origin.x-newPosition.origin.x) > menuPixelWidth/4)
                menuShouldStay=true;
            else
                menuShouldStay=false;
        }
        
        if (_MDFMenuAnimate)
            parrentViewSticky.frame=newPosition; //newPosition is always initialized
        else
            myCollectionView.frame=newPosition; //newPosition is always initialized
    }
}

@end
