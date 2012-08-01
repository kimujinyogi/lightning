//
//  Lightning.m
//  Trundle
//
//  Created by Robert Blackwood on 12/1/09.
//  Copyright 2009 Mobile Bros. All rights reserved.
//

#import "CCDrawingPrimitives.h"
#import "ccMacros.h"
#import "ccGLStateCache.h"
#import "CCShaderCache.h"
#import "CCGLProgram.h"
#import "CCActionCatmullRom.h"

#import "Lightning.h"
#import "CCActionInterval.h"
#import "CCActionInstant.h"



void lightningDrawLines( CGPoint* points, uint numberOfPoints );

static CCGLProgram* _shader = nil;
static int _colorLocation = 0;

@implementation Lightning

@synthesize strikePoint = _strikePoint;
@synthesize strikePoint2 = _strikePoint2;
@synthesize color = _color;
@synthesize opacity = _opacity;
@synthesize displacement = _displacement;
@synthesize minDisplacement = _minDisplacement;
@synthesize seed = _seed;
@synthesize split = _split;

+(id) lightningWithStrikePoint:(CGPoint)strikePoint
{
	return [[[Lightning alloc] initWithStrikePoint:strikePoint] autorelease];
}

+(id) lightningWithStrikePoint:(CGPoint)strikePoint strikePoint2:(CGPoint)strikePoint2
{
	return [[[Lightning alloc] initWithStrikePoint:strikePoint strikePoint2:strikePoint2] autorelease];
}

-(id) initWithStrikePoint:(CGPoint)strikePoint
{
	return [self initWithStrikePoint:strikePoint strikePoint2:ccp(0,0)];
}

-(id) initWithStrikePoint:(CGPoint)strikePoint strikePoint2:(CGPoint)strikePoint2
{
	[super init];
    
    if (_shader == nil)
    {
        _shader = [[CCShaderCache sharedShaderCache] programForKey: kCCShader_Position_uColor];
        _colorLocation = glGetUniformLocation(_shader->program_, "u_color");
    }
	_strikePoint = strikePoint;
	_strikePoint2 = strikePoint2;
	_color = ccWHITE;
	_opacity = 255;
    
	_seed = rand();
	_split = NO;
    
	_displacement = 160;
	_minDisplacement = 8;
    
	numPoints_ = 0;
    
	lightningPoints_ = (CGPoint*) malloc(sizeof(CGPoint)*kMaxPoints);
    
	[self strike];
    
	return self;
}

- (void) dealloc
{
	[super dealloc];
}

-(void) draw
{
	numPoints_=0;
    
    [_shader use];
	[_shader setUniformForModelViewProjectionMatrix];
	[_shader setUniformLocation: _colorLocation
                        with4fv:(GLfloat*) &_color.r count:1];
    
	glLineWidth(3.0f);
//	glEnable(GL_LINE_SMOOTH);
    
	if (_opacity != 255)
		glBlendFunc(GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA);
    
	CGPoint mid = drawLightning(ccp(0,0), _strikePoint, _displacement, _minDisplacement, _seed,lightningPoints_, &numPoints_);
    
	if (_split)
		drawLightning(mid, _strikePoint2, _displacement/2, _minDisplacement, _seed, lightningPoints_, &numPoints_);
    
	lightningDrawLines(lightningPoints_,numPoints_);
    
	if (_opacity != 255)
		glBlendFunc(CC_BLEND_SRC, CC_BLEND_DST);
    
}

-(void) strikeRandom
{
	_seed = rand();
	[self strike];
}

-(void) strikeWithSeed:(unsigned long)seed
{
	_seed = seed;
	[self strike];
}

- (void) strike
{
	self.visible = NO;
	self.opacity = 255;

	[self runAction:[CCSequence actions:
                     // [DelayTime actionWithDuration:1.0],
					 [CCShow action],
					 [CCFadeOut actionWithDuration:0.5],
                     // [CallFunc actionWithTarget:self selector:@selector(strikeRandom)],
					 nil]];
}

@end

void lightningDrawLines( CGPoint* points, uint numberOfPoints )
{
	
    //layout of points [0] = origin, [1] = destination and so on
	ccVertex2F vertices[numberOfPoints];
	if (CC_CONTENT_SCALE_FACTOR() != 1 )
	{
		for (int i=0;i<numberOfPoints;i++)
		{
			vertices[i].x=points[i].x * CC_CONTENT_SCALE_FACTOR();
			vertices[i].y=points[i].y * CC_CONTENT_SCALE_FACTOR();
		}
        glVertexAttribPointer(kCCVertexAttrib_Position, 2, GL_FLOAT, GL_FALSE, 0, vertices);
//		glVertexPointer(2, GL_FLOAT, 0, vertices);
	}
//	else glVertexPointer(2, GL_FLOAT, 0, points);
    else
        glVertexAttribPointer(kCCVertexAttrib_Position, 2, GL_FLOAT, GL_FALSE, 0, points);
    
	// Default GL states: GL_TEXTURE_2D, GL_VERTEX_ARRAY, GL_COLOR_ARRAY, GL_TEXTURE_COORD_ARRAY
	// Needed states: GL_VERTEX_ARRAY,
	// Unneeded states: GL_TEXTURE_2D, GL_TEXTURE_COORD_ARRAY, GL_COLOR_ARRAY
//	glDisable(GL_TEXTURE_2D);
//	glDisableClientState(GL_TEXTURE_COORD_ARRAY);
//	glDisableClientState(GL_COLOR_ARRAY);
    
//	glDrawArrays(GL_LINES, 0, numberOfPoints);
    glDrawArrays(GL_LINE_STRIP, 0, 4);
    
	// restore default state
//	glEnableClientState(GL_COLOR_ARRAY);
//	glEnableClientState(GL_TEXTURE_COORD_ARRAY);
//	glEnable(GL_TEXTURE_2D);
}

int getNextRandom(unsigned long *seed)
{
	//taken off a linux site (linux.die.net)
	(*seed) = (*seed) * 1103515245 + 12345;
	return ((unsigned)((*seed)/65536)%32768);
}

CGPoint drawLightning(CGPoint pt1, CGPoint pt2, int displace, int minDisplace, unsigned long randSeed, CGPoint *points, uint *numPoints)
{
//	CCLOG(@"arguments pt1 %f %f pt2 %f %f dis %i minDis %i",pt1.x,pt1.y,pt2.x,pt2.y,displace,minDisplace);
	CGPoint mid = ccpMult(ccpAdd(pt1,pt2), 0.5f);
    
	if (displace < minDisplace)
	{
		//ccDrawLine(pt1, pt2);
		if (*numPoints == kMaxPoints - 1) CCLOG(@"increase kMaxPoints");
        
		points[*numPoints]=pt1;
		points[*numPoints+1]=pt2;
		*numPoints+=2;
        
	}
	else
	{
		int r = getNextRandom(&randSeed);
		mid.x += (((r % 101)/100.0)-.5)*displace;
		r = getNextRandom(&randSeed);
		mid.y += (((r % 101)/100.0)-.5)*displace;
        
		drawLightning(pt1,mid,displace/2,minDisplace,randSeed,points,numPoints);
		drawLightning(pt2,mid,displace/2,minDisplace,randSeed,points,numPoints);
	}
    
	return mid;
}