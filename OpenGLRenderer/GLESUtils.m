//
//  GLESUtils.m
//  OpenGLRenderer
//
//  Created by 张维朝 on 2018/3/20.
//  Copyright © 2018年 xiaokai.zhan. All rights reserved.
//

#import "GLESUtils.h"

@implementation GLESUtils

+(GLuint)loadShader:(GLenum)type withFilepath:(NSString *)shaderFilepath {
    NSError* error;
    NSString* shaderString = [NSString stringWithContentsOfFile:shaderFilepath
                                                       encoding:NSUTF8StringEncoding
                                                          error:&error];
    if (!shaderString) {
        NSLog(@"Error: loading shader file: %@ %@", shaderFilepath, error.localizedDescription);
        return 0;
    }
    
    return [self loadShader:type withString:shaderString];
}

+(GLuint)loadShader:(GLenum)type withString:(NSString *)shaderString {
    //创建shader
    GLuint shader = glCreateShader(type);
    if (shader == 0) {
        NSLog(@"Error: failed to create shader.");
        return 0;
    }
    
    //装载shader
    const char * shaderStringUTF8 = [shaderString UTF8String];
    glShaderSource(shader, 1, &shaderStringUTF8, NULL);
    
    //编译shader
    glCompileShader(shader);
    
    //查询变异状态
    GLint compiled = 0;
    glGetShaderiv(shader, GL_COMPILE_STATUS, &compiled);
    
    if (!compiled) {
        GLint infoLen = 0;
        glGetShaderiv ( shader, GL_INFO_LOG_LENGTH, &infoLen );
        
        if (infoLen > 1) {
            char * infoLog = malloc(sizeof(char) * infoLen);
            glGetShaderInfoLog (shader, infoLen, NULL, infoLog);
            NSLog(@"Error compiling shader:\n%s\n", infoLog );
            
            free(infoLog);
        }
        
        glDeleteShader(shader);
        return 0;
    }
    
    return shader;
}

@end
