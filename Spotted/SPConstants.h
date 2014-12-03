//
//  SPConstants.h
//  Spotted
//
//  Created by Mathieu White on 2014-11-26.
//  Copyright (c) 2014 Mathieu White. All rights reserved.
//

#pragma mark - Notifications

static NSString * const kSPKeyboardAnimationDurationKey = @"UIKeyboardAnimationDurationUserInfoKey";
static NSString * const kSPKeyboardAnimationCurveKey = @"UIKeyboardAnimationCurveUserInfoKey";
static NSString * const kSPUserLoginWasSuccessfulNotification = @"kSPUserLoginWasSuccessfulNotification";
static NSString * const kSPUserWantsLogoutNotification = @"kSPUserWantsLogoutNotification";
static NSString * const kSPUserDidDeleteAccountNotification = @"kSPUserDidDeleteAccountNotification";
static NSString * const kSPPostProcessingNotification = @"kSPPostProcessingNotification";
static NSString * const kSPPostSuccessfulNotification = @"kSPPostSuccessfulNotification";

#pragma mark - PFObject User Class

// Keys
static NSString * const kSPUserNameKey = @"name";
static NSString * const kSPUserSchoolKey = @"school";
static NSString * const kSPUserEmailVerifiedKey = @"emailVerified";
static NSString * const kSPUserErrorKey = @"error";

#pragma mark - PFObject School Class

// Keys
static NSString * const kSPSchoolClassName = @"School";
static NSString * const kSPSchoolNameKey = @"name";
static NSString * const kSPSchoolDomainKey = @"domain";
static NSString * const kSPSchoolRedColorKey = @"red";
static NSString * const kSPSchoolGreenColorKey = @"green";
static NSString * const kSPSchoolBlueColorKey = @"blue";

#pragma mark - PFObject Post Class

// Keys
static NSString * const kSPPostClassName = @"Post";
static NSString * const kSPPostContentKey = @"content";
static NSString * const kSPPostUserKey = @"user";
static NSString * const kSPPostSchoolKey = @"school";
static NSString * const kSPPostCreatedAtKey = @"createdAt";