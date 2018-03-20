//
//  OpenGLView.m
//  OpenGLRenderer
//
//  Created by 张维朝 on 2018/3/20.
//  Copyright © 2018年 xiaokai.zhan. All rights reserved.
//

#import "OpenGLView.h"
#import "GLESUtils.h"

@interface OpenGLView()

- (void)setupLayer;
- (void)setupContext;
- (void)setupProgram;

- (void)setupBuffers;
- (void)destoryBuffers;

- (void)render;

@end

#pragma mark LifeCycle

@implementation OpenGLView

- (id)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setUpLayer];
        [self setUpContext];
        
        [self setupProgram];
    }
    return self;
}

- (void)layoutSubviews {
    [EAGLContext setCurrentContext:_context];
    
//    [self destoryBuffers];
    
    [self setUpBuffers];
    [self render];
    
}

#pragma mark setup
+ (Class)layerClass {
    return [CAEAGLLayer class];
}

- (void)setUpLayer {
    _eaglLayer = (CAEAGLLayer *)self.layer;
    _eaglLayer.opaque = YES;
    _eaglLayer.drawableProperties = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithBool:NO],kEAGLDrawablePropertyRetainedBacking,kEAGLColorFormatRGBA8,kEAGLDrawablePropertyColorFormat, nil];
}

- (void)setUpContext {
    _context = [[EAGLContext alloc] initWithAPI:kEAGLRenderingAPIOpenGLES2];
    if (!_context) {
        exit(1);
    }
    
    if (![EAGLContext setCurrentContext:_context]) {
        _context = nil;
        exit(1);
    }
}

- (void)setUpBuffers {
    glGenFramebuffers(1, &_frameBuffer);
    glBindFramebuffer(GL_FRAMEBUFFER, _frameBuffer);
    
    glGenRenderbuffers(1, &_colorRenderBuffer);
    glBindRenderbuffer(GL_RENDERBUFFER, _colorRenderBuffer);
    [_context renderbufferStorage:GL_RENDERBUFFER fromDrawable:_eaglLayer];
    
    glFramebufferRenderbuffer(GL_FRAMEBUFFER, GL_COLOR_ATTACHMENT0, GL_RENDERBUFFER, _colorRenderBuffer);
}

- (void)destroyBuffers {
    
    glDeleteRenderbuffers(1, &_colorRenderBuffer);
    _colorRenderBuffer = 0;
    
    glDeleteFramebuffers(1, &_frameBuffer);
    _frameBuffer = 0;
    
}


- (void)setupProgram {
    // Load shaders
    NSString * vertexShaderPath = [[NSBundle mainBundle] pathForResource:@"VertexShader"
                                                                  ofType:@"glsl"];
    NSString * fragmentShaderPath = [[NSBundle mainBundle] pathForResource:@"FragmentShader"
                                                                    ofType:@"glsl"];
    GLuint vertexShader = [GLESUtils loadShader:GL_VERTEX_SHADER
                                   withFilepath:vertexShaderPath];
    GLuint fragmentShader = [GLESUtils loadShader:GL_FRAGMENT_SHADER
                                     withFilepath:fragmentShaderPath];
    
    // Create program, attach shaders.
    _programHandle = glCreateProgram();
    if (!_programHandle) {
        NSLog(@"Failed to create program.");
        return;
    }
    
    glAttachShader(_programHandle, vertexShader);
    glAttachShader(_programHandle, fragmentShader);
    
    // Link program
    
    glLinkProgram(_programHandle);
    
    // Check the link status
    GLint linked;
    glGetProgramiv(_programHandle, GL_LINK_STATUS, &linked );
    if (!linked) {
        GLint infoLen = 0;
        glGetProgramiv (_programHandle, GL_INFO_LOG_LENGTH, &infoLen );
        
        if (infoLen > 1) {
            char * infoLog = malloc(sizeof(char) * infoLen);
            glGetProgramInfoLog (_programHandle, infoLen, NULL, infoLog );
            NSLog(@"Error linking program:\n%s\n", infoLog );
            
            free (infoLog );
        }
        
        glDeleteProgram(_programHandle);
        _programHandle = 0;
        return;
    }
    
    glUseProgram(_programHandle);
    
    // Get attribute slot from program
    _positionSlot = glGetAttribLocation(_programHandle, "vPosition");
}

- (void)render {
    glClearColor(0.5, 1.0, 0.5, 1.0);
    glClear(GL_COLOR_BUFFER_BIT);
    
    // Setup viewport
    glViewport(0, 0, self.frame.size.width, self.frame.size.height);
    
    GLfloat vertices[] = {
        0.0f,  0.5f, 0.0f,
        -0.5f, -0.5f, 0.0f,
        0.5f,  -0.5f, 0.0f };
    
    // Load the vertex data
    glVertexAttribPointer(_positionSlot, 3, GL_FLOAT, GL_FALSE, 0, vertices );
    glEnableVertexAttribArray(_positionSlot);
    
    // Draw triangle
    glDrawArrays(GL_TRIANGLES, 0, 3);
    
    [_context presentRenderbuffer:GL_RENDERBUFFER];
}

@end
