//
//  testnode.m
//  lightning
//
//  Created by 金 珍奕 on 12/08/01.
//
//

#define kBM_START(name) NSDate* name##_start = [NSDate new]
#define kBM_END(name)   NSDate* name##_end = [NSDate new];\
NSLog(@"%s interval: %f", #name, [name##_end timeIntervalSinceDate: name##_start]);\
[name##_start release];\
[name##_end release]

#import "testnode.h"

@implementation testnode

@synthesize texture = _texture;

- (id) init
{
    if ((self = [super init]))
    {
        self.texture =
        [[CCTextureCache sharedTextureCache] addImage:
         [NSString stringWithFormat: @"streak%d.png", 3]];
        
        shader_ = [[CCShaderCache sharedShaderCache] programForKey:kCCShader_Position_uColor];
        col_ = glGetUniformLocation( shader_->program_, "u_color");
//		colorLocation_ = glGetUniformLocation( shader_->program_, "u_color");
//		pointSizeLocation_ = glGetUniformLocation( shader_->program_, "u_pointSize");

    }
    
    return self;
}

- (void) dealloc
{
    self.texture = nil;
    [super dealloc];
}

+ (testnode*) testnode
{
    return [[[testnode alloc] init] autorelease];
}

const GLfloat squareVertices[] = {
    100, 100,    // position v0
    200, 100,    // position v1
    100, 200,    // position v2
    200, 200,    // position v3
};

const GLubyte squareColors[] = {
    255, 255,   0, 255,    // yellow color
    0, 255, 255, 255,    // cyan color
    0,   0,   0,   0,    // black color
    255,   0, 255, 255,    // magenta color
};

- (void) rect
{    
    CGPoint origin, destination;
    origin = ccp(100, 100);
    destination = ccp(250, 200);

	CGPoint vertices[] = {
		origin,
		{destination.x, origin.y},
		destination,
		{origin.x, destination.y},
	};

	ccDrawSolidPoly(vertices, 4, ccc4f(1, 0, 1, 1) );
}

-(void) draw
{
    CGPoint vertices[4];
    vertices[0] = ccp(0, 20);
    vertices[1] = ccp(100, 100);
    vertices[2] = ccp(200, 100);
    vertices[3] = ccp(300, 20);
    
    
//    kBM_START(ff);
//    ccDrawColor4F(1, 1, 1, 1);
////    glColor4ub(255, 255, 255, 255);
//    ccDrawPoly(vertices, 4, NO);
//    kBM_END(ff);
    
//    return;
    
    
    [shader_ use];
	[shader_ setUniformForModelViewProjectionMatrix];
    ccColor4F color_ = {1,1,0.3,0.3};
    glBlendFunc(GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA);
	[shader_ setUniformLocation: col_
                        with4fv:(GLfloat*) &color_.r count:1];
    
//    ccVertex2F vertices[4] = {
//		{100, 100},
//		{200, 200},
//        {200, 300},
//        {300, 200}
//	};
    
    ccGLEnableVertexAttribs( kCCVertexAttribFlag_Position );
	glVertexAttribPointer(kCCVertexAttrib_Position, 2, GL_FLOAT, GL_FALSE, 0, vertices);
	glDrawArrays(GL_LINE_STRIP, 0, 4);
    
}


@end













