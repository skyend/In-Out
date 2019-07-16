//
//  GameConfig.h
//  Memory0_0
//
//  Created by JinUng Han on 11. 3. 8..
//  Copyright Student 2011. All rights reserved.
//

#ifndef __GAME_CONFIG_H
#define __GAME_CONFIG_H

//
// Supported Autorotations:
//		None,
//		UIViewController,
//		CCDirector
//
#define kGameAutorotationNone 0
#define kGameAutorotationCCDirector 1
#define kGameAutorotationUIViewController 2

//NSLog 무효화 코드
#define DEBUG_MODE 0

#ifdef DEBUG_MODE
#define DLog( s, ... ) NSLog( @"<%p %@:(%d)> %@", self, [[NSString stringWithUTF8String:__FILE__] lastPathComponent], __LINE__, [NSString stringWithFormat:(s), ##__VA_ARGS__] )
#else
#define DLog( s, ... ) 
#endif

#define NSLog(s, ...)
#define printf(s, ...)
//


#define GAME_FPS 60
//
// Define here the type of autorotation that you want for your game
//
#define GAME_AUTOROTATION kGameAutorotationUIViewController

//*****주의******
//순서 중간에 변경하지 않기 DB에 반영되므로 추후 업데이트시 문제가 될수있음 중간에 삽입은 절때 안되고 뒤에 추가하는 식으로 업데이트하기
#define C_Rectangle 0
#define C_Triangle 1
#define C_Circle 2
#define C_Pentagon 3
#define C_Rectangle2 4
#define C_Triangle2 5
#define C_Circle2 6
#define C_Pentagon2 7

#define PREVSTEP_ONE 0
#define PREVSTEP_TWO 1
#define PREVSTEP_THREE 2


typedef enum{
	DOWN_BUTTON
}G_EVENT;
typedef enum{
	IN,
	OUT,
	HINT
}BUTTON_NAME;

typedef enum {
	MAIN_ANMATION,
	GAME_PLAY
}PM_MODE;

typedef enum {
	GAME_FINALIZE,
	GAME_OVER,
	GAME_PLAYING,
	GAME_PAUSING,
    GAME_FROM_TUTORIAL_PUASE,
	GAME_EXIT
}GAME_STATE;

//StagePlacement & Stage Display Scenes & GameCondition
typedef enum {
	STAGE_0,
	STAGE_1,
	STAGE_2,
	STAGE_3,
	STAGE_4,
	STAGE_5,
    STAGE_6
}StageCode;

typedef enum {
	MISSION_RESCUE_CHARACTER,
	MISSION_TOTAL_COMBO_RECORD,
	MISSION_PLAYTIME_RECORD,
	MISSION_SCORE_RECORD,
	MISSION_COMBO_TECHNIQUE,
	MISSION_HIGH_COMBO_RECORD
}MissionList;

typedef struct {
	MissionList mCode;
	int			clearedCount;
	int			overClearedCount;
}struct_missionCleardTable;

//Character & ProgressManager
typedef enum{
	WALKING,
	STOPING,
	ARRIVED,
	DISAPPEAR,
	APPEAR,
	STANDBY, //판별전에 대기함
	COMEIN,
	GOOUT,
	DIED
}State;

typedef enum {
	RANK_ZERO,
	RANK_SSSp,
	RANK_SSS,
	RANK_SSp,
	RANK_SS,
	RANK_Sp,
	RANK_S,
	RANK_Ap,
	RANK_A,
	RANK_Bp,
	RANK_B,
	RANK_Cp,
	RANK_C,
	RANK_Dp,
	RANK_D,
	RANK_F
}RANK;

//Mission

typedef enum {
	CODE_NAN,
	CODE_ORRANGE,
	CODE_PURPLE,
	CODE_RED,
	CODE_YELLOW,
	CODE_GREEN,
	CODE_BLUE,
	CODE_OCEAN,
	CODE_DEEPYELLOW
}ParticleImgCode;

typedef enum {
	PLAYMODE_INFINITE,
	PLAYMODE_NORMAL,
	PLAYMODE_OVERCLEAR
}GamePlayMODE;

typedef struct {
    float red;
    float green;
    float blue;
    float alpha;
}GLColorSet;

typedef enum{
    Language_ko,
    Language_en,
}LanguageCase;

//float floatMarkOut(float v) {
//	if (v < 0) {
//		return v * -1;
//	}else {
//		return v;
//	}
//}

#endif // __GAME_CONFIG_H