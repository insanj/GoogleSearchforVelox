//Google Search for Velox
//Created by Julian Weiss
//Only use this code if you credit me!

#import "VeloxFolderViewProtocol.h"

@interface GoogleVeloxFolderView : UIView <VeloxFolderViewProtocol, UITextFieldDelegate> {
    UITextField *searchField;
}

-(void)textFieldDidBeginEditing:(UITextField *)textField;
-(BOOL)textFieldShouldReturn:(UITextField *)textField;
@end

@implementation GoogleVeloxFolderView

+(int)folderHeight{
    return 35;
}

-(UIView *)initWithFrame:(CGRect)aFrame{
	self = [super initWithFrame:aFrame];
    if (self) {

        searchField = [[UITextField alloc] initWithFrame:CGRectMake(10, aFrame.size.height/4.25, aFrame.size.width, aFrame.size.height - 10)];
        [searchField setReturnKeyType:UIReturnKeyGoogle];
        [searchField setTextColor:[UIColor whiteColor]];
        [searchField setPlaceholder:@"Search Google"];
        [searchField setDelegate:self];
        [self addSubview:searchField];
        [searchField becomeFirstResponder];
    }

    return self;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField{
    //[textField setPlaceholder:@""];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    if([[textField text] isEqualToString:@""])
        return YES;

    NSString *searchQuery = [[textField text] stringByReplacingOccurrencesOfString:@" " withString:@"+"];
    NSString *properQuery = [NSString stringWithFormat:@"http://www.google.com/search?q=%@", searchQuery];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:properQuery]];
    return YES;
}
@end