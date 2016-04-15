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
    CGPoint startLocation;
    UIView  *parrentViewSticky;
    NSNumber *inAction;
    float menuPixelWidth;
    UICollectionView *myCollectionView;
    CGRect menuPosition;
    CGRect mainViewPosition;
    bool menuShouldStay;
    float nudgeFactorX;
    float nudgeFactorY;
    UIBlurEffect *blurEffect;
    UIVisualEffectView *visualEffectView;
    bool menuStartedExpanded;
    bool enableDisableFlag;
}

-(id)init:(id)newDelegate {
    self = [super init];
    if (self) {
        _adelegate = newDelegate;
        menuShouldStay=0;
        nudgeFactorX=0;
        nudgeFactorY=0;
        enableDisableFlag=true;
        menuStartedExpanded=false;
    }
    return self;
}

-(void) addPanRecognizer
{
    if ([_MDFMenuUseTouch integerValue] == MDF_TOUCH_YES ) {
        
        UIPanGestureRecognizer *panRecognizer = [[UIPanGestureRecognizer alloc]
                                                 initWithTarget:self
                                                 action:@selector(panGesture:)];
        
        [panRecognizer setMinimumNumberOfTouches:1];
        [panRecognizer setMaximumNumberOfTouches:1];
        [parrentViewSticky addGestureRecognizer:panRecognizer];
    }
}

-(void)makeMenu:(CGRect)myMeny {
    UICollectionViewFlowLayout *layout=[[UICollectionViewFlowLayout alloc] init];
    //layout.minimumInteritemSpacing=1.0f;
    
    myCollectionView=[[UICollectionView alloc] initWithFrame:myMeny collectionViewLayout:layout];
    [myCollectionView setDataSource:self];
    [myCollectionView setDelegate:self];
    
    [myCollectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"cellIdentifier"];
    [myCollectionView setBackgroundColor:[UIColor blueColor]];
    
    //Add blur effect to the icon bar
    blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
    visualEffectView = [[UIVisualEffectView alloc] initWithEffect:blurEffect];
    [visualEffectView setFrame:myCollectionView.bounds];
    myCollectionView.backgroundView=visualEffectView;
    
    [parrentViewSticky addSubview:myCollectionView];
}

-(BOOL)attachMenu:(UIView*)parrentView
{
    parrentViewSticky=parrentView;
    mainViewPosition=parrentView.frame;
    parrentView.backgroundColor = [UIColor redColor];
    parrentView.userInteractionEnabled=YES;
    
    menuPixelWidth=parrentView.frame.size.width*[_MDFMenuSize floatValue];
    
    switch ([_MDFMenuAction integerValue]) {
        case MDF_ACTIVATE_SLIDE_RIGHT:
            NSLog(@"Swipe Right");
            menuPosition= CGRectMake(parrentView.frame.origin.x-menuPixelWidth,
                                     parrentView.frame.origin.y,
                                     menuPixelWidth,
                                     parrentView.frame.size.height);
            [self addPanRecognizer];
            [self makeMenu:menuPosition];
            break;
        case MDF_ACTIVATE_SLIDE_LEFT:
            NSLog(@"Swipe Left");
            menuPosition= CGRectMake(parrentView.frame.origin.x+parrentView.frame.size.width,
                                     parrentView.frame.origin.y,
                                     menuPixelWidth,
                                     parrentView.frame.size.height);
            [self addPanRecognizer];
            [self makeMenu:menuPosition];
            break;
        case MDF_ACTIVATE_SLIDE_UP:
            menuPosition= CGRectMake(parrentView.frame.origin.x,
                                     parrentView.frame.origin.y+parrentView.frame.size.height,
                                     parrentView.frame.size.width,
                                     menuPixelWidth);
            NSLog(@"Swipe Up");
            [self addPanRecognizer];
            [self makeMenu:menuPosition];
            break;
        case MDF_ACTIVATE_SLIDE_DOWN:
            menuPosition= CGRectMake(parrentView.frame.origin.x,
                                     parrentView.frame.origin.y-menuPixelWidth,
                                     parrentView.frame.size.width,
                                     menuPixelWidth);
            NSLog(@"Swipe Down");
            [self addPanRecognizer];
            [self makeMenu:menuPosition];
            break;
        case MDF_ACTIVATE_DOUBLECLICK:
            NSLog(@"Double Click");
            break;
        case MDF_ACTIVATE_LONGPRESS:
            NSLog(@"Long Press");
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

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [_MDFMenuItems count];
}

// The cell that is returned must be retrieved from a call to -dequeueReusableCellWithReuseIdentifier:forIndexPath:
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell *cell=[collectionView dequeueReusableCellWithReuseIdentifier:@"cellIdentifier" forIndexPath:indexPath];
    
    NSArray *currentItem=[_MDFMenuItems objectAtIndex:0];
    [_MDFMenuItems removeObjectAtIndex:0];
    
    
    NSString *filename=[currentItem objectAtIndex:0];
    
    cell.backgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:filename]];
    
    cell.backgroundColor=[UIColor greenColor];
    
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(menuPixelWidth, menuPixelWidth);
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

-(void) disableMenu
{
    [self hideMenu];
    enableDisableFlag=false;
    if (_adelegate)
        [_adelegate MDFCallback:[NSNumber numberWithInt:MDF_MENU_DISABLE]];
}

-(void) enableMenu
{
    enableDisableFlag=true;
    if (_adelegate)
        [_adelegate MDFCallback:[NSNumber numberWithInt:MDF_MENU_ENABLE]];
}

-(bool) isEnabled
{
    return enableDisableFlag;
}

-(bool) isVisible
{
    return (bool)nudgeFactorX | (bool)nudgeFactorY;
}

-(void) showMenu {
    
    if (!enableDisableFlag) {
        return;
    }
    
    nudgeFactorX=0;
    nudgeFactorY=0;
    switch ([_MDFMenuAction integerValue]) {
        case MDF_ACTIVATE_SLIDE_RIGHT:
            nudgeFactorX=menuPixelWidth;
            break;
        case MDF_ACTIVATE_SLIDE_LEFT:
            nudgeFactorX=menuPixelWidth*-1;
            break;
        case MDF_ACTIVATE_SLIDE_UP:
            nudgeFactorY=menuPixelWidth*-1;
            break;
        case MDF_ACTIVATE_SLIDE_DOWN:
            nudgeFactorY=menuPixelWidth;
            break;
        default:
            if (_adelegate)
                [_adelegate MDFError:[NSNumber numberWithInt:MDF_POSITION_UNKNOWN_CMD] MDFErrorString:MDF_POSITION_UNKNOWN_CMD_TEXT];
            return;
            break;
    }
    
    if ([_MDFMenuAnimate integerValue] == MDF_ANIMATE_PARENT_YES) {
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
    
    if (_adelegate)
        [_adelegate MDFCallback:[NSNumber numberWithInt:MDF_MENU_APPEAR]];
    
}

-(void) hideMenu {
    
    nudgeFactorX=0;
    nudgeFactorY=0;
    
    if ([_MDFMenuAnimate integerValue] == MDF_ANIMATE_PARENT_YES) {
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
                              delay:0
                            options: UIViewAnimationOptionCurveEaseInOut
                         animations:^{
                             myCollectionView.frame=menuPosition;
                         } completion:^(BOOL finished){
                         } ];
        
    }
    if (_adelegate)
        [_adelegate MDFCallback:[NSNumber numberWithInt:MDF_MENU_DISAPPEAR]];
}

- (void)panGesture:(UIPanGestureRecognizer *)sender {
    
    if (!enableDisableFlag) {
        return;
    }
    
    if (sender.state == UIGestureRecognizerStateBegan) {
        startLocation = [sender locationInView:nil];
        
        if (nudgeFactorX || nudgeFactorY) {
            menuStartedExpanded=true;
        }
        else
        {
            menuStartedExpanded=false;
        }
        NSLog(@"Swipe began %d",menuStartedExpanded);
        //kolla om man börjar en touch som inte kommer gå att slutföra
    }
    else if (sender.state == UIGestureRecognizerStateEnded) {
        NSLog(@"Swipe ended %d",menuShouldStay);
        if (menuShouldStay)
        {
            [self showMenu];
        }
        else
        {
            
            [self hideMenu];
            
            
        }
    }
    else {
        CGPoint stopLocation = [sender locationInView:nil];
        CGFloat swipeDistanceX = stopLocation.x - startLocation.x;
        CGFloat swipeDistanceY = stopLocation.y - startLocation.y;
        
        CGRect newPosition;
        
        
        if ([_MDFMenuAnimate integerValue] == MDF_ANIMATE_PARENT_YES) {
            
            newPosition=mainViewPosition;
        }
        else
        {
            newPosition=menuPosition;
        }
        
        swipeDistanceX+=nudgeFactorX;
        swipeDistanceY+=nudgeFactorY;
        
        CGRect refPosition=newPosition;
        
        switch ([_MDFMenuAction integerValue]) {
            case MDF_ACTIVATE_SLIDE_RIGHT:
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
                
            case MDF_ACTIVATE_SLIDE_LEFT:
                
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
                
            case MDF_ACTIVATE_SLIDE_DOWN:
                
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
                
            case MDF_ACTIVATE_SLIDE_UP:
                
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
        
        //  NSLog(@" %f %f", swipeDistanceX,swipeDistanceX);
        
        //NSLog(@"%f",fabs(refPosition.origin.y-newPosition.origin.y));
        
        
        if (menuStartedExpanded) {
            NSLog(@"igot %f %f",fabs(refPosition.origin.x-newPosition.origin.x),fabs(refPosition.origin.y-newPosition.origin.y));
            if (((fabs(refPosition.origin.y-newPosition.origin.y) < (menuPixelWidth-(menuPixelWidth/4))) * nudgeFactorY) || ((fabs(refPosition.origin.x-newPosition.origin.x) < (menuPixelWidth-menuPixelWidth/4)) * nudgeFactorX)|| !(nudgeFactorX || nudgeFactorY))
            {
                menuShouldStay=false;
            }
            else
            {
                menuShouldStay=true;
            }
        }
        else
        {
            if (fabs(refPosition.origin.y-newPosition.origin.y) > menuPixelWidth/4 || fabs(refPosition.origin.x-newPosition.origin.x) > menuPixelWidth/4)
            {
                menuShouldStay=true;
                //NSLog(@"HERE!!");
            }
            else
            {
                menuShouldStay=false;
            }
        }
        
        if ([_MDFMenuAnimate integerValue] == MDF_ANIMATE_PARENT_YES) {
            parrentViewSticky.frame=newPosition; //newPosition is always initialized
        }
        else
        {
            myCollectionView.frame=newPosition; //newPosition is always initialized
        }
        
        
        // NSLog(@"Dist: %f %f",swipeDistanceX,parrentViewSticky.frame.origin.y);
    }
    
}

@end
