//
//  FWOMSDKFriendlyObstructionConfiguration.h
//  AdManager
//
//  Created by Floam, Scott on 5/27/20.
//  Copyright © 2020 FreeWheel Media Inc. All rights reserved.
//
#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "FWConstants.h"

/**
 A class used for creating a FWOMSDKFriendlyObstructionConfiguration.
*/
@interface FWOMSDKFriendlyObstructionConfiguration : NSObject

/**
 The UIView associated with a friendly obstruction.
*/
@property (nonatomic, strong, nonnull) UIView* view;

/**
 FWOMSDKFriendlyObstructionType used to describe the purpose of the friendly obstruction. Allowed values are `FWOMSDKFriendlyObstructionMediaControls`, `FWOMSDKFriendlyObstructionCloseAd`, `FWOMSDKFriendlyObstructionNotVisible`, and `FWOMSDKFriendlyObstructionOther`.  See also: `FWOMSDKFriendlyObstructionType`.
*/
@property (nonatomic) FWOMSDKFriendlyObstructionType purpose;

/**
  The detailed reason provided by the integrator for why the friendly obstruction was needed. The detailed reason can be nil. If not nil, it can be 50 characters or less and only contain characters `A-z`, `0-9`, or spaces.
 */
@property (nonatomic, strong, nullable) NSString* detailedReason;

/**
 An error associated with a friendly obstruction.
*/
@property (nonatomic, strong, nullable) NSError* error;

/**
 A constructor used for instantiating the FWOMSDKFriendlyObstructionConfiguration.

 @param view UIView associated with a friendly obstruction.
 @param purpose FWOMSDKFriendlyObstructionType used to describe the purpose of the friendly obstruction. Allowed values are `FWOMSDKFriendlyObstructionMediaControls`, `FWOMSDKFriendlyObstructionCloseAd`, `FWOMSDKFriendlyObstructionNotVisible`, and `FWOMSDKFriendlyObstructionOther`.  See also: `FWOMSDKFriendlyObstructionType`.
 @param detailedReason NSString used to describe why the friendly obstruction was needed. The detailed reason can be nil. If not nil, it can be 50 characters or less and only contain characters `A-z`, `0-9`, or spaces.

*/
-(nonnull instancetype) initWithView:(nonnull UIView*)view purpose:(FWOMSDKFriendlyObstructionType)purpose detailedReason:(nullable NSString*)detailedReason;

@end
