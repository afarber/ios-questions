#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad
{
    // Get the stored data before the view loads
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *firstName = [defaults objectForKey:@"firstName"];
    NSString *lastName = [defaults objectForKey:@"lastname"];
    int age = [defaults integerForKey:@"age"];
    NSString *ageString = [NSString stringWithFormat:@"%i",age];
    NSData *imageData = [defaults dataForKey:@"image"];
    UIImage *contactImage = [UIImage imageWithData:imageData];
    // Update the UI elements with the saved data
    _firstNameTextField.text = firstName;
    _lastNameTextField.text = lastName;
    _ageTextField.text = ageString;
    _contactImageView.image = contactImage;
    [super viewDidLoad];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)save:(id)sender
{
    // Hide the keyboard
    [_firstNameTextField resignFirstResponder];
    [_lastNameTextField resignFirstResponder];
    [_ageTextField resignFirstResponder];
    // Create strings and integer to store the text info
    NSString *firstName = [_firstNameTextField text];
    NSString *lastName  = [_lastNameTextField text];
    int age = [[_ageTextField text] integerValue];
    // Create instances of NSData
    UIImage *contactImage = _contactImageView.image;
    NSData *imageData = UIImageJPEGRepresentation(contactImage, 100);
    // Store the data
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:firstName forKey:@"firstName"];
    [defaults setObject:lastName forKey:@"lastname"];
    [defaults setInteger:age forKey:@"age"];
    [defaults setObject:imageData forKey:@"image"];
    [defaults synchronize];
    NSLog(@"Data saved");
}

- (IBAction)chooseImage:(id)sender
{
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    picker.allowsEditing = YES;
    picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    [self presentViewController:picker animated:YES completion:nil];
}

#pragma mark - Image Picker Delegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingImage:(UIImage *)image editingInfo:(NSDictionary *)editingInfo
{
    //_contactImageView.image = image;
    [picker dismissModalViewControllerAnimated:YES];
}
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [picker dismissViewControllerAnimated:YES completion:nil];
}

@end
