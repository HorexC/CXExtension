//
//  CXConst.h
//  CXExtension
//
//  Created by Horex on 15/9/2.
//  Copyright (c) 2015年 Horex. All rights reserved.
//


#ifdef  DEBUG   // 调试状态

// 打开LOG功能
#define  CXLog(...) NSLog(__VA_ARGS__)
// 打开断言功能
#define  CXAssert(condition, desc) NSAssert(condition, @"\n报错文件：%@\n报错行数：第%d行\n报错方法：%s\n错误描述：%@",[NSString stringWithUTF8String:__FILE__], __LINE__, __FUNCTION__, desc)
#define  CXAssertParamsNoNil(param) CXAssert(param, [[NSString stringWithFormat:@#param] stringByAppendingString:@"参数不能为nil"])
#else  // 发布状态
// 关闭LOG功能
#define  CXLog(...)
// 关闭断言功能
#define  CXAssert(condition, desc)
#define  CXAssertParamsNoNil(param)

// 断言
#define MJAssert2(condition, desc, returnValue) \
if ((condition) == NO) { \
NSString *file = [NSString stringWithUTF8String:__FILE__]; \
MJLog(@"\n警告文件：%@\n警告行数：第%d行\n警告方法：%s\n警告描述：%@", file, __LINE__,  __FUNCTION__, desc); \
return returnValue; \
}

#define MJAssert(condition, desc) MJAssert2(condition, desc, )

#define MJAssertParamNotNil2(param, returnValue) \
MJAssert2(param, [[NSString stringWithFormat:@#param] stringByAppendingString:@"参数不能为nil"], returnValue)

#define MJAssertParamNotNil(param) MJAssertParamNotNil2(param, )

#endif