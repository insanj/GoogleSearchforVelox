//Google Search for Velox by Julian "insanj" Weiss
//(c) 2013 Julian Weiss, see full license in README.md

#import "VeloxFolderViewProtocol.h"

@interface GoogleVeloxFolderView : UIView <VeloxFolderViewProtocol, UITextFieldDelegate>
-(void)textFieldDidBeginEditing:(UITextField *)textField;
-(BOOL)textFieldShouldReturn:(UITextField *)textField;
@end

@implementation GoogleVeloxFolderView

+(int)folderHeight{
    return 35;
}

-(float)realHeight{
    CGPoint position = [self convertPoint:self.frame.origin toView:[[UIApplication sharedApplication] keyWindow]];
    NSNumber *folderPositionNumber = [NSNumber numberWithFloat:position.y];
    [[NSUserDefaults standardUserDefaults] setObject:folderPositionNumber forKey:@"folderPositionNumber"];
    return 35;
}

-(UIView *)initWithFrame:(CGRect)aFrame{

    self = [super initWithFrame:aFrame];
    if (self) {

        UITextField *searchField = [[UITextField alloc] initWithFrame:CGRectMake(10, aFrame.size.height/4.25, aFrame.size.width - 20, aFrame.size.height - 10)];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(dynamicallyShiftWindowUp:) name:UIKeyboardWillShowNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(dynamicallyShiftWindowDown:) name:UIKeyboardWillHideNotification object:nil];

        [searchField setReturnKeyType:UIReturnKeyGoogle];
        [searchField setTextColor:[UIColor whiteColor]];
        [searchField setPlaceholder:@"Search Google"];
        [searchField setDelegate:self];
        [self addSubview:searchField];

        [searchField becomeFirstResponder];
    }

    return self;
}//end method

-(void)unregisterFromStuff{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

-(void)dynamicallyShiftWindowUp:(NSNotification*)notification{
    NSDictionary *keyboardInfo = [notification userInfo];
    NSValue *keyboardFrameBegin = [keyboardInfo valueForKey:UIKeyboardFrameBeginUserInfoKey];
    CGRect keyboardFrameBeginRect = [keyboardFrameBegin CGRectValue];
    float keyboardOrigin = keyboardFrameBeginRect.origin.y;

    //NSUserDefaults is highly unrecommended for tweaks-- a switch to posting 
    //userInfos with Darwin/CPDistributedCenter notifications is in the works.
    NSNumber *folderPositionNumber = [[NSUserDefaults standardUserDefaults] objectForKey:@"folderPositionNumber"];
    float folderPosition = [folderPositionNumber floatValue];

    UIWindow *keyWindow = [[UIApplication sharedApplication] keyWindow];
    float shiftedY = ([keyWindow center].y - (keyboardOrigin - folderPosition)) + 10;
    NSNumber *previousYNumber = [NSNumber numberWithFloat:keyWindow.frame.origin.y];
    [[NSUserDefaults standardUserDefaults] setObject:previousYNumber forKey:@"previousYNumber"];
            
    if(shiftedY > 0){
         [UIView animateWithDuration:[[keyboardInfo valueForKey:UIKeyboardAnimationDurationUserInfoKey] floatValue] delay:0.00 options:[[keyboardInfo valueForKey:UIKeyboardAnimationCurveUserInfoKey] intValue]
            animations:^ {
                [keyWindow setFrame:CGRectMake(keyWindow.frame.origin.x, keyWindow.frame.origin.y -shiftedY, keyWindow.frame.size.width, keyWindow.frame.size.height)];
            } completion:nil];
    }//end if
}//end method

-(void)dynamicallyShiftWindowDown:(NSNotification*)notification{
    UIWindow *keyWindow = [[UIApplication sharedApplication] keyWindow];
    NSNumber *previousYNumber = [[NSUserDefaults standardUserDefaults] objectForKey:@"previousYNumber"];
    float previousY = [previousYNumber floatValue];

    [UIView animateWithDuration:0.25 delay:0 options:UIViewAnimationOptionCurveEaseInOut
        animations:^(void) {
            [keyWindow setFrame:CGRectMake(keyWindow.frame.origin.x, previousY, keyWindow.frame.size.width, keyWindow.frame.size.height)];
        } completion:nil];
}//end method

-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    if([[textField text] isEqualToString:@""])
        return NO;

    NSString *properQuery = [NSString stringWithFormat:@"http://www.google.com/search?q=%@", [textField text]];
    NSURL *properURL = [NSURL URLWithString:[properQuery stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    [[UIApplication sharedApplication] openURL:properURL];
    return YES;
}//end method
@end