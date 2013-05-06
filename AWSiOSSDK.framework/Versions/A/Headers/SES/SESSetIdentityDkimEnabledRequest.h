/*
 * Copyright 2010-2013 Amazon.com, Inc. or its affiliates. All Rights Reserved.
 *
 * Licensed under the Apache License, Version 2.0 (the "License").
 * You may not use this file except in compliance with the License.
 * A copy of the License is located at
 *
 *  http://aws.amazon.com/apache2.0
 *
 * or in the "license" file accompanying this file. This file is distributed
 * on an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either
 * express or implied. See the License for the specific language governing
 * permissions and limitations under the License.
 */


#import "../AmazonServiceRequestConfig.h"



/**
 * Set Identity Dkim Enabled Request
 */

@interface SESSetIdentityDkimEnabledRequest:AmazonServiceRequestConfig

{
    NSString *identity;
    bool     dkimEnabled;
    bool     dkimEnabledIsSet;
}




/**
 * Default constructor for a new  object.  Callers should use the
 * property methods to initialize this object after creating it.
 */
-(id)init;

/**
 * The identity for which DKIM signing should be enabled or disabled.
 */
@property (nonatomic, retain) NSString *identity;

/**
 * Sets whether DKIM signing is enabled for an identity. Set to
 * <code>true</code> to enable DKIM signing for this identity;
 * <code>false</code> to disable it.
 */
@property (nonatomic) bool           dkimEnabled;

@property (nonatomic, readonly) bool dkimEnabledIsSet;

/**
 * Returns a string representation of this object; useful for testing and
 * debugging.
 *
 * @return A string representation of this object.
 */
-(NSString *)description;


@end