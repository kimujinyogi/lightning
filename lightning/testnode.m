//
//  testnode.m
//  lightning
//
//  Created by 金 珍奕 on 12/08/01.
//
//

#import "testnode.h"

static CCGLProgram* _shader = nil;
static int _colorLocation = 0;

@implementation testnode

- (id) init
{
    if ((self = [super init]))
    {
        if (_shader == nil)
        {
            _shader = [[CCShaderCache sharedShaderCache] programForKey: kCCShader_Position_uColor];
            _colorLocation = glGetUniformLocation(_shader->program_, "u_color");
        }
    }
    
    return self;
}

+ (testnode*) testnode
{
    return [[[testnode alloc] init] autorelease];
}

- (void) draw
{
    CGPoint vertices[4];
    vertices[0] = ccp(0, 20);
    vertices[1] = ccp(100, 280);
    vertices[2] = ccp(200, 220);
    vertices[3] = ccp(300, 120);
    
    [_shader use];
    [_shader setUniformForModelViewProjectionMatrix];
    ccColor4F color_ = {1, 1, 0.3f, 1.0f};
    if (color_.a != 1)
        glBlendFunc(GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA);
    [_shader setUniformLocation: _colorLocation
                        with4fv: (GLfloat*)&color_.r
                          count: 1];
    ccGLEnableVertexAttribs(kCCVertexAttribFlag_Position);
    glVertexAttribPointer(kCCVertexAttrib_Position, 2, GL_FLOAT, GL_FALSE, 0, vertices);
    glDrawArrays(GL_LINE_STRIP, 0, 4);
}

@end






