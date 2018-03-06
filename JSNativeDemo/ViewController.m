//
//  ViewController.m
//  JSNativeDemo
//
//  Created by zhz on 06/03/2018.
//  Copyright © 2018 zhz. All rights reserved.
//

#import "ViewController.h"
@import JavaScriptCore;

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //1. 获取定义在JS中的变量, 并修改
//    [self getJSVar];
    
    // 2. 获取定义在JS中的方法, OC调用JS
        [self ocCallJSFunc];
}

- (void)getJSVar {
    // 1. 创建js运行的环境
    JSContext *context = [[JSContext alloc] init];
    context.exceptionHandler = ^(JSContext *context, JSValue *exception){
        NSLog(@"JS代码执行中的异常信息%@", exception);
    };
    
    // 2. 执行JS代码, 返回js代码执行的最后的一个值 The last value generated by the script
    /*
     注意：evaluateScript只是执行了一段代码，对一段JS代码（转成NSString）估值，如果是函数的情况下，并不代表它会执行函数内容，evaluateScript进行的只是函数名字的声明，以及函数内容的获取，但未执行。evaluateScript后如果执行的不是函数而是一段JS源码，那么就是简单的执行。此时JS代码中的所以函数都被全局对象声明了。
     */
    NSString *jsCode = @"var arr = [1, 2, 3]";
    [context evaluateScript:jsCode];
    
    // 只有执行JS代码才能获取数据
    // 变量定义在JS中, 所以直接通过JSContext获取, 根据变量名称获取, 相当于字典的key
    JSValue *reJsValue = context[@"arr"];
    NSLog(@"%@", reJsValue);
    
    // 修改JS的值
    reJsValue[0] = @9;
    NSLog(@"%@", reJsValue);
    
    // 值转换
    if (reJsValue.isArray) {
        NSLog(@"jsValue to Array %@", reJsValue.toArray);
    }
}

- (void)ocCallJSFunc {
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"index.js" ofType:nil];
    NSString *jsCode = [NSString stringWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error:nil];
    NSLog(@"jsCode: %@", jsCode);
    
    // 创建JS运行环境
    JSContext *context = [[JSContext alloc] init];
    
    // 执行JS代码
    [context evaluateScript:jsCode];
    
    JSValue *hello = context[@"hello"];
    
    // OC 调用JS方法, 获取返回值
    JSValue *reValue = [hello callWithArguments:@[@"javascript"]];
    NSLog(@"reValue: %@", reValue);
}

@end
