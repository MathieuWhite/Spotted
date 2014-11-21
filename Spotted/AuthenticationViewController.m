//
//  AuthenticationViewController.m
//  Spotted
//
//  Created by Mathieu White on 2014-11-17.
//  Copyright (c) 2014 Mathieu White. All rights reserved.
//

#import "AuthenticationViewController.h"
#import "POP.h"

@interface AuthenticationViewController ()

@property (nonatomic, strong) LoginViewController *loginViewController;
@property (nonatomic, strong) SignUpViewController *signUpViewController;

@property (nonatomic, strong) NSArray *backgroundImages;

@property (nonatomic, weak) UIImageView *backgroundImageView;

@property (nonatomic, getter = isShowingSignUp) BOOL showingSignUp;

@end

@implementation AuthenticationViewController

- (void) viewDidLoad
{
    [super viewDidLoad];
    
    // Initialize the array of background images
    NSArray *backgroundImages = @[[UIImage imageNamed: @"loginBackground1"],
                                  [UIImage imageNamed: @"loginBackground2"],
                                  [UIImage imageNamed: @"loginBackground3"],
                                  [UIImage imageNamed: @"loginBackground4"]];
    
    // Initialize the background image view
    UIImageView *backgroundImageView = [[UIImageView alloc] init];
    [backgroundImageView setTranslatesAutoresizingMaskIntoConstraints: NO];
    
    // Add each component to the view
    [self.view addSubview: backgroundImageView];
    
    // Set each component to a property
    [self setBackgroundImages: backgroundImages];
    [self setBackgroundImageView: backgroundImageView];
    
    // Setup the login view controller
    [self setupLoginViewController];
    
    // Auto Layout
    [self setupConstraints];
    
    // Notification for when the user sign up is successful
    [[NSNotificationCenter defaultCenter] addObserver: self
                                             selector: @selector(signUpWasSuccessful)
                                                 name: kUserSignUpWasSuccessfulNotification
                                               object: nil];
    
    // Notification for when the keyboard will appear
    [[NSNotificationCenter defaultCenter] addObserver: self
                                             selector: @selector(keyboardWillShow:)
                                                 name: UIKeyboardWillShowNotification
                                               object: nil];
    
    // Notification for when the keyboard will disappear
    [[NSNotificationCenter defaultCenter] addObserver: self
                                             selector: @selector(keyboardWillHide:)
                                                 name: UIKeyboardWillHideNotification
                                               object: nil];
}

- (void) viewWillAppear: (BOOL) animated
{
    [super viewWillAppear: animated];
    
    [self setRandomBackgroundImage];
}

- (void) didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Private Instance Methods

- (void) setRandomBackgroundImage
{
    UIImage *randomImage = [self.backgroundImages objectAtIndex: arc4random_uniform((u_int32_t)[self.backgroundImages count])];
    [self.backgroundImageView setImage: randomImage];
}

- (void) setupLoginViewController
{
    LoginViewController *loginViewController = [[LoginViewController alloc] init];
    [loginViewController setDelegate: self];
    
    [self.view addSubview: loginViewController.view];
    [self setLoginViewController: loginViewController];
    
    [self addChildViewController: self.loginViewController];
    [self.loginViewController didMoveToParentViewController: self];
    
    [self.loginViewController.view setTranslatesAutoresizingMaskIntoConstraints: NO];
}

- (UIView *) getSignUpView
{
    // Init if it doesn't already exist
    if (self.signUpViewController == nil)
    {
        UIPanGestureRecognizer *recognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self
                                                                                     action:@selector(handlePan:)];
        
        SignUpViewController *signUpViewController = [[SignUpViewController alloc] init];
        [signUpViewController setDelegate: self];
        [signUpViewController.view setTranslatesAutoresizingMaskIntoConstraints: NO];
        [signUpViewController.view addGestureRecognizer: recognizer];
        
        [self.view addSubview: signUpViewController.view];
        [self setSignUpViewController: signUpViewController];
        
        [self addChildViewController: self.signUpViewController];
        [self.signUpViewController didMoveToParentViewController: self];
    }
    
    return [self.signUpViewController view];
}

#pragma mark - UIGestureRecognizer Methods

- (void) handlePan: (UIPanGestureRecognizer *) recognizer
{
    [recognizer.view endEditing: YES];
    
    CGPoint translation = [recognizer translationInView: self.view];
    CGPoint velocity = [recognizer velocityInView: recognizer.view];

    if([recognizer state] == UIGestureRecognizerStateEnded)
    {
        if (velocity.x > 0)
        {
            // The Sign Up View Animation
            POPSpringAnimation *signUpViewAnimation = [POPSpringAnimation animationWithPropertyNamed: kPOPLayerPositionX];
            [signUpViewAnimation setToValue: @(CGRectGetMaxX([self.view bounds]) * 1.5)];
            [signUpViewAnimation setVelocity: @(velocity.x)];
            
            // The Login View Animation
            POPSpringAnimation *loginViewAnimation = [POPSpringAnimation animationWithPropertyNamed: kPOPLayerPositionX];
            [loginViewAnimation setToValue: @(CGRectGetMidX([self.view bounds]))];
            [loginViewAnimation setVelocity: @(velocity.x)];
            [loginViewAnimation setCompletionBlock: ^(POPAnimation *anim, BOOL finished)
            {
                // Bring the login view to front
                [self.view bringSubviewToFront: [self.loginViewController view]];
                 
                [self setShowingSignUp: NO];
            }];
            
            [self.signUpViewController.view.layer pop_addAnimation: signUpViewAnimation forKey: @"hideSignUpViewControllerAnimation"];
            [self.loginViewController.view.layer pop_addAnimation: loginViewAnimation forKey: @"showLoginViewControllerAnimation"];
        }
        
        else if (velocity.x < 0)
        {
            // Get the sign up view
            UIView *childView = [self getSignUpView];
            [self.view bringSubviewToFront: childView];
            [self setupConstraintsForSignUpView];
            
            // The Login View Animation
            POPSpringAnimation *loginViewAnimation = [POPSpringAnimation animationWithPropertyNamed: kPOPLayerPositionX];
            [loginViewAnimation setToValue: @(-CGRectGetMidX([self.view bounds]))];
            [loginViewAnimation setVelocity: @(velocity.x)];
            [loginViewAnimation setCompletionBlock: ^(POPAnimation *anim, BOOL finished)
            {
                [self setShowingSignUp: YES];
            }];
            
            // The Sign Up View Animation
            POPSpringAnimation *signUpViewAnimation = [POPSpringAnimation animationWithPropertyNamed: kPOPLayerPositionX];
            [signUpViewAnimation setToValue: @(CGRectGetMidX([self.view bounds]))];
            [signUpViewAnimation setVelocity: @(velocity.x)];
            
            [self.loginViewController.view.layer pop_addAnimation: loginViewAnimation forKey: @"hideLoginViewControllerAnimation"];
            [self.signUpViewController.view.layer pop_addAnimation: signUpViewAnimation forKey: @"showSignUpViewControllerAnimation"];
        }
    }
    
    if([recognizer state] == UIGestureRecognizerStateChanged)
    {
        if (velocity.x > 0)
        {
            [self.loginViewController.view setCenter: CGPointMake(self.loginViewController.view.center.x + translation.x, self.loginViewController.view.center.y)];
            [recognizer.view setCenter: CGPointMake(recognizer.view.center.x + translation.x, recognizer.view.center.y)];
            [recognizer setTranslation: CGPointMake(0, 0) inView: self.view];
        }
        
        else if (velocity.x < 0)
        {
            if ([recognizer view].center.x <= self.view.center.x)
                return;
            
            [self.loginViewController.view setCenter: CGPointMake(self.loginViewController.view.center.x - abs(translation.x), self.loginViewController.view.center.y)];
            [recognizer.view setCenter: CGPointMake(recognizer.view.center.x - abs(translation.x), recognizer.view.center.y)];
            [recognizer setTranslation: CGPointMake(0, 0) inView: self.view];
        }
    }
}

#pragma mark - Auto Layout Method

- (void) setupConstraints
{
    // Background Width
    [self.view addConstraint: [NSLayoutConstraint constraintWithItem: self.backgroundImageView
                                                           attribute: NSLayoutAttributeWidth
                                                           relatedBy: NSLayoutRelationEqual
                                                              toItem: self.view
                                                           attribute: NSLayoutAttributeWidth
                                                          multiplier: 1.0f
                                                            constant: 0.0f]];
    
    // Background Height
    [self.view addConstraint: [NSLayoutConstraint constraintWithItem: self.backgroundImageView
                                                           attribute: NSLayoutAttributeHeight
                                                           relatedBy: NSLayoutRelationEqual
                                                              toItem: self.view
                                                           attribute: NSLayoutAttributeHeight
                                                          multiplier: 1.0f
                                                            constant: 0.0f]];
    
    // Background Top
    [self.view addConstraint: [NSLayoutConstraint constraintWithItem: self.backgroundImageView
                                                           attribute: NSLayoutAttributeTop
                                                           relatedBy: NSLayoutRelationEqual
                                                              toItem: self.view
                                                           attribute: NSLayoutAttributeTop
                                                          multiplier: 1.0f
                                                            constant: 0.0f]];
    
    // Background Left
    [self.view addConstraint: [NSLayoutConstraint constraintWithItem: self.backgroundImageView
                                                           attribute: NSLayoutAttributeLeft
                                                           relatedBy: NSLayoutRelationEqual
                                                              toItem: self.view
                                                           attribute: NSLayoutAttributeLeft
                                                          multiplier: 1.0f
                                                            constant: 0.0f]];
    
    // Login Width
    [self.view addConstraint: [NSLayoutConstraint constraintWithItem: self.loginViewController.view
                                                           attribute: NSLayoutAttributeWidth
                                                           relatedBy: NSLayoutRelationEqual
                                                              toItem: self.view
                                                           attribute: NSLayoutAttributeWidth
                                                          multiplier: 1.0f
                                                            constant: 0.0f]];
    
    // Login Height
    [self.view addConstraint: [NSLayoutConstraint constraintWithItem: self.loginViewController.view
                                                           attribute: NSLayoutAttributeHeight
                                                           relatedBy: NSLayoutRelationEqual
                                                              toItem: self.view
                                                           attribute: NSLayoutAttributeHeight
                                                          multiplier: 1.0f
                                                            constant: 0.0f]];
    
    // Login Top
    [self.view addConstraint: [NSLayoutConstraint constraintWithItem: self.loginViewController.view
                                                           attribute: NSLayoutAttributeTop
                                                           relatedBy: NSLayoutRelationEqual
                                                              toItem: self.view
                                                           attribute: NSLayoutAttributeTop
                                                          multiplier: 1.0f
                                                            constant: 0.0f]];
    
    // Login Left
    [self.view addConstraint: [NSLayoutConstraint constraintWithItem: self.loginViewController.view
                                                           attribute: NSLayoutAttributeLeft
                                                           relatedBy: NSLayoutRelationEqual
                                                              toItem: self.view
                                                           attribute: NSLayoutAttributeLeft
                                                          multiplier: 1.0f
                                                            constant: 0.0f]];
}

- (void) setupConstraintsForSignUpView
{
    // Sign Up Width
    [self.view addConstraint: [NSLayoutConstraint constraintWithItem: self.signUpViewController.view
                                                           attribute: NSLayoutAttributeWidth
                                                           relatedBy: NSLayoutRelationEqual
                                                              toItem: self.view
                                                           attribute: NSLayoutAttributeWidth
                                                          multiplier: 1.0f
                                                            constant: 0.0f]];
    
    // Sign Up Height
    [self.view addConstraint: [NSLayoutConstraint constraintWithItem: self.signUpViewController.view
                                                           attribute: NSLayoutAttributeHeight
                                                           relatedBy: NSLayoutRelationEqual
                                                              toItem: self.view
                                                           attribute: NSLayoutAttributeHeight
                                                          multiplier: 1.0f
                                                            constant: 0.0f]];
    
    // Sign Up Top
    [self.view addConstraint: [NSLayoutConstraint constraintWithItem: self.signUpViewController.view
                                                           attribute: NSLayoutAttributeTop
                                                           relatedBy: NSLayoutRelationEqual
                                                              toItem: self.view
                                                           attribute: NSLayoutAttributeTop
                                                          multiplier: 1.0f
                                                            constant: 0.0f]];
    
    // Sign Up Left
    [self.view addConstraint: [NSLayoutConstraint constraintWithItem: self.signUpViewController.view
                                                           attribute: NSLayoutAttributeLeft
                                                           relatedBy: NSLayoutRelationEqual
                                                              toItem: self.view
                                                           attribute: NSLayoutAttributeRight
                                                          multiplier: 1.0f
                                                            constant: 0.0f]];
}

#pragma mark - LoginViewControllerDelegate Methods

- (void) transitionFromLoginView
{
    // Get the sign up view
    UIView *childView = [self getSignUpView];
    [self.view bringSubviewToFront: childView];
    [self setupConstraintsForSignUpView];
    
    // The Login View Animation
    POPBasicAnimation *loginViewAnimation = [POPBasicAnimation animationWithPropertyNamed: kPOPLayerPositionX];
    [loginViewAnimation setFromValue: @(CGRectGetMidX([self.view bounds]))];
    [loginViewAnimation setToValue: @(-CGRectGetMidX([self.view bounds]))];
    [loginViewAnimation setDuration: 0.6];
    [loginViewAnimation setCompletionBlock: ^(POPAnimation *anim, BOOL finished)
     {
         [self setShowingSignUp: YES];
     }];
    
    // The Sign Up View Animation
    POPBasicAnimation *signUpViewAnimation = [POPBasicAnimation animationWithPropertyNamed: kPOPLayerPositionX];
    [signUpViewAnimation setFromValue: @(CGRectGetMaxX([self.view bounds]) * 1.5)];
    [signUpViewAnimation setToValue: @(CGRectGetMidX([self.view bounds]))];
    [signUpViewAnimation setDuration: 0.6];
    
    [self.loginViewController.view.layer pop_addAnimation: loginViewAnimation forKey: @"hideLoginViewControllerAnimation"];
    [self.signUpViewController.view.layer pop_addAnimation: signUpViewAnimation forKey: @"showSignUpViewControllerAnimation"];
}

#pragma mark - SignUpViewControllerDelegate Methods

- (void) transitionFromSignUpView
{
    // The Sign Up View Animation
    POPBasicAnimation *signUpViewAnimation = [POPBasicAnimation animationWithPropertyNamed: kPOPLayerPositionX];
    [signUpViewAnimation setFromValue: @(CGRectGetMidX([self.view bounds]))];
    [signUpViewAnimation setToValue: @(CGRectGetMaxX([self.view bounds]) * 1.5)];
    [signUpViewAnimation setDuration: 0.6];
    
    // The Login View Animation
    POPBasicAnimation *loginViewAnimation = [POPBasicAnimation animationWithPropertyNamed: kPOPLayerPositionX];
    [loginViewAnimation setFromValue: @(-CGRectGetMidX([self.view bounds]))];
    [loginViewAnimation setToValue: @(CGRectGetMidX([self.view bounds]))];
    [loginViewAnimation setDuration: 0.6];
    [loginViewAnimation setCompletionBlock: ^(POPAnimation *anim, BOOL finished)
    {
        // Bring the login view to front
        [self.view bringSubviewToFront: [self.loginViewController view]];
        
        [self setShowingSignUp: NO];
    }];
    
    [self.signUpViewController.view.layer pop_addAnimation: signUpViewAnimation forKey: @"hideSignUpViewControllerAnimation"];
    [self.loginViewController.view.layer pop_addAnimation: loginViewAnimation forKey: @"showLoginViewControllerAnimation"];
}

#pragma mark - Notification Methods

- (void) signUpWasSuccessful
{
    [self transitionFromSignUpView];
}

- (void) keyboardWillShow: (NSNotification *) notification
{
    NSDictionary *info = [notification valueForKey: @"userInfo"];
    
    UIView *currentView;
    
    if ([self isShowingSignUp])
        currentView = [self.signUpViewController view];
    
    else
        currentView = [self.loginViewController view];
    
    [UIView animateWithDuration: [[info valueForKey: @"UIKeyboardAnimationDurationUserInfoKey"] doubleValue]
                          delay: 0
                        options: [[info valueForKey: @"UIKeyboardAnimationCurveUserInfoKey"] integerValue]
                     animations: ^{
                         [currentView setCenter: CGPointMake(self.view.center.x, self.view.center.y - 90.0f)];
                     }
                     completion: NULL];
}

- (void) keyboardWillHide: (NSNotification *) notification
{
    NSDictionary *info = [notification valueForKey: @"userInfo"];

    UIView *currentView;
    
    if ([self isShowingSignUp])
        currentView = [self.signUpViewController view];
    
    else
        currentView = [self.loginViewController view];
    
    [UIView animateWithDuration: [[info valueForKey: @"UIKeyboardAnimationDurationUserInfoKey"] doubleValue]
                          delay: 0
                        options: [[info valueForKey: @"UIKeyboardAnimationCurveUserInfoKey"] integerValue]
                     animations: ^{
                         [currentView setCenter: [self.view center]];
                     }
                     completion: NULL];
}

- (void) dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver: self];
}

@end
