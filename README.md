# MyDearFriend
IOS GUI made by a programmer for programmers bypassing UX stuff we done understand anyway.

When creating simple applications where I just want a simple meny for actions it's always complicated for me as a programmer to use story boards and tons of settings I have no clue of. Most of the time i just want something simple and fast to test a specific function or idea.

'My dear friend' will assist you creating a simple menu system. 

1. Just create a single view application
2. Init 'my dear friend'
3. Give it some settings
4. Attatch it your view
5. Done

    myMenu=[[MDFMenu alloc] init:self];                         //Create a menu object and delegate callback to self.
    NSArray *mySettings=[self populateSettings];                //Populate a NSArray with settings
    if (![myMenu attachMenu:self.view settings:mySettings])     //Attach the menu to a UIView with the settings provided
        NSLog(@"Failed ataching menu");

