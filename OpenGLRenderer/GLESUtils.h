//
//  GLESUtils.h
//  OpenGLRenderer
//
//  Created by 张维朝 on 2018/3/20.
//  Copyright © 2018年 xiaokai.zhan. All rights reserved.
//

#import <Foundation/Foundation.h>
#include <OpenGLES/ES2/gl.h>

@interface GLESUtils : NSObject

// Create a shader object, load the shader source string, and compile the shader.

+(GLuint)loadShader:(GLenum)type withString:(NSString *)shaderString;

+(GLuint)loadShader:(GLenum)type withFilepath:(NSString *)shaderFilepath;

@end
