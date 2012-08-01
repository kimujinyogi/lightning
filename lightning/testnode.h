//
//  testnode.h
//  lightning
//
//  Created by 金 珍奕 on 12/08/01.
//
//

#import "cocos2d.h"

@interface testnode : CCNode
{
	CCTexture2D *_texture;
    GLuint _positionSlot;
    GLuint _colorSlot;
    CCGLProgram* shader_;
    int col_;
}
@property(retain) CCTexture2D *texture;

+ (testnode*) testnode;

@end

















