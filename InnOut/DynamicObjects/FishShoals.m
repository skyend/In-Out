//
//  FishShoals.m
//  KeepInTheMind
//
//  Created by JinWoong Han on 11. 7. 5..
//  Copyright 2011 -. All rights reserved.
//

#import "FishShoals.h"


@implementation FishShoals

-(id)FishShoalsWithSize:(CGSize)scope_{
    if ( (self = [super init] ) ) {
        scope = scope_;

        //한 무리에 10마리씩
        fishNum = 10;
        fishSpeed = 2;
        fish = malloc(sizeof(FishArray)*fishNum);
        
        //rootPoint = ccp(rand()%(int)(scope.width),rand()%(int)(scope.height));
        rootPoint = ccp(scope.width,rand()%(int)(scope.height));
        
        FollowRootP = rootPoint;
        
        for (int i = 0; i < fishNum; i++) {
            CCSprite * fishO = [CCSprite spriteWithFile:@"stage3_Fish1.png"];
            fishO.anchorPoint = ccp(0.5f,0.5f);
            [self addChild:fishO];
            fish[i].sprite = fishO;
            
            fish[i].interval = ccp(rand()%(fishNum*10) - fishNum*5 , rand()%(fishNum*6) - fishNum*3);
            fish[i].speed = 0.02f + (rand()%8) * 0.01f;
            fishO.position = ccp(FollowRootP.x + fish[i].interval.x , FollowRootP.y + fish[i].interval.y);
        }
        
        
        
    }
    return self;
}

-(void)update:(ccTime)delta{
    for (int i = 0; i < fishNum; i++) {
        fish[i].sprite.position = ccp(fish[i].sprite.position.x + fishSpeed * ((FollowRootP.x + fish[i].interval.x) - fish[i].sprite.position.x)*delta,fish[i].sprite.position.y + fishSpeed * (( FollowRootP.y + fish[i].interval.y) - fish[i].sprite.position.y)*delta);
        
        //fish[i].sprite.position = ccp(self.position.x + fish[i].sprite.position.x,self.position.y + fish[i].sprite.position.y);
        //fish[i].sprite.rotation;
         
    }
    
    FollowRootP = ccp(FollowRootP.x + (fishSpeed *(rootPoint.x - FollowRootP.x))*delta,FollowRootP.y + (fishSpeed * (rootPoint.y - FollowRootP.y))*delta);
    
    if (fabs(FollowRootP.x - rootPoint.x) < 1) {
        rootPoint = ccp((rootPoint.x == scope.width)? 0:scope.width,rand()%(int)(scope.height));
        
        for (int i = 0; i < fishNum; i++) {
            CCSprite * fishO = fish[i].sprite;
            
            fish[i].interval = ccp(rand()%(fishNum*8) - fishNum*4 , rand()%(fishNum*4) - fishNum*2);
            //fish[i].speed = 0.2f+ (rand()%8) * 0.1f;
            fishO.position = ccp(FollowRootP.x + fish[i].interval.x , FollowRootP.y + fish[i].interval.y); 
            
            fish[i].sprite.scaleX = (FollowRootP.x < rootPoint.x)? 1:-1; 
            
        }
    }
    
}

-(void)dealloc{
    free(fish);
    [super dealloc];
}
@end
