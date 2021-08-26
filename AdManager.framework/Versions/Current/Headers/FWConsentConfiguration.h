//
//  FWConsentConfiguration.h
//  AdManager
//
//  Created by Floam, Scott on 4/11/19.
//  Copyright © 2019 FreeWheel Media Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FWGDPRConsentConfiguration.h"
#import "FWCCPAConsentConfiguration.h"

/**
 A class used for configuring the ad request with user consent information.
 
 Note: Upon instantiation, FWConsentConfiguration will attempt to automatically retrieve GDPR and CCPA consent information from [NSUserDefaults standardUserDefaults].
 
 See also:
	- `[FWRequestConfiguration setConsentConfiguration:]`
	- `FWGDPRConsentConfiguration`
	- `FWCCPAConsentConfiguration`
 */
@interface FWConsentConfiguration : NSObject

/**
 Used for holding GDPR consent configuration information.
 
 See also `FWGDPRConsentConfiguration`.
 */
@property (nullable, nonatomic) FWGDPRConsentConfiguration *gdprConsentConfiguration;

/**
 Used for holding CCPA consent configuration information.

 Note:
	- FWConsentConfiguration will automatically set ccpaConsentConfiguration from [NSUserDefaults standardUserDefaults] using the key, FWParameterIABUSPrivacyStringKey.
	- This property cannot be manually set by the user and will be set to nil if the US privacy string value is not found in [NSUserDefaults standardUserDefaults].

 See also:
	- `FWParameterIABUSPrivacyStringKey`
	- `FWRequestConfiguration`
	- `FWCCPAConsentConfiguration`
 */
@property (nullable, nonatomic, readonly) FWCCPAConsentConfiguration *ccpaConsentConfiguration;


@end
