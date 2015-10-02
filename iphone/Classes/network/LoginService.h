//
//  LoginService.h
//  hurrit
//
//  Created by Juanjo Molinero on 15/11/10.
//  Copyright 2010 BIFI. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface LoginService : NSObject {

}

+ (NSDictionary*) registerWithEmail:(NSString*) email nickname:(NSString*)nickname andPassword:(NSString*) password;
+ (NSDictionary*) loginWithEmail:(NSString*) email andPassword:(NSString*) password;
+ (NSDictionary*) logout;

@end
