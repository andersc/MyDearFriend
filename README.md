# MyDearFriend
IOS GUI made by a programmer for programmers bypassing UX stuff we done understand anyway.

When creating simple applications where I just want a simple meny for actions it's always complicated for me as a programmer to use story boards and tons of settings I have no clue of. Most of the time i just want something simple and fast to test a specific function or idea.

I want to use 'my dear friend' to help me with that. Just create a single view application. Then init 'my dear friend' give him some settings and attatch him your view. Done!

    myMenu=[[MDFMenu alloc] init:self];                         //Create a menu object and delegate callback to self.
    NSArray *mySettings=[self populateSettings];                //Populate a NSArray with settings
    if (![myMenu attachMenu:self.view settings:mySettings])     //Attach the menu to a UIView with the settings provided
        NSLog(@"Failed ataching menu");

