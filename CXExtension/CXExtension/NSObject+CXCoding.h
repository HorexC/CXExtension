//
//  NSObject+CXCoding.h
//  CXExtension
//
//  Created by Horex on 15/9/2.
//  Copyright (c) 2015年 Horex. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSObject (CXCoding)

/**     解码     */
- (void)decode:(NSCoder *)decoder;

/**     编码     */
- (void)encode:(NSCoder *)encoder;

@end

/**     归档实现     */
#define CXCodingImplementation \
- (id)initWithCoder:(NSCoder *)decoder \
{ \
if (self = [super init]) { \
[self decode:decoder]; \
} \
return self; \
} \
\
- (void)encodeWithCoder:(NSCoder *)encoder \
{ \
[self encode:encoder]; \
}
