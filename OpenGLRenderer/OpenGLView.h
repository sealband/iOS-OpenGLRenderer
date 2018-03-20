//
//  OpenGLView.h
//  OpenGLRenderer
//
//  Created by 张维朝 on 2018/3/20.
//  Copyright © 2018年 xiaokai.zhan. All rights reserved.
//

#import <UIKit/UIKit.h>
#include <OpenGLES/ES2/gl.h>

@interface OpenGLView : UIView {
    
    CAEAGLLayer* _eaglLayer;
    EAGLContext* _context;
    GLuint _colorRenderBuffer;
    GLuint _frameBuffer;
    
    GLuint _programHandle;
    GLuint _positionSlot;
}

@end
