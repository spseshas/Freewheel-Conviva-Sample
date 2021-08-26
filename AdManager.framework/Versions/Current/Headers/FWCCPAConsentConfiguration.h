//
//  FWCCPAConsentConfiguration.h
//  AdManager
//
//  Created by Floam, Scott on 11/6/19.
//  Copyright © 2019 FreeWheel Media Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FWConstants.h"

/**
 A class used for configuring FWConsentConfiguration with user CCPA consent information.
 
 Note, this class is intended for readonly purposes. FWConsentConfiguration will handle its implementation.
 
 See also `FWConsentConfiguration`.
 */
@interface FWCCPAConsentConfiguration : NSObject <NSCopying>

/**
 String used to identify the disclosures made and choices selected by a user regarding consumer data privacy in association with CCPA.
 */
@property (nullable, nonatomic, copy, readonly) NSString* fwUSPrivacy;

@end
