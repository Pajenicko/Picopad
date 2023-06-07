
// ****************************************************************************
//
//                                 Scene
//
// ****************************************************************************

#ifndef _SCENE_H
#define _SCENE_H

extern int SceneSetInx;	// current scene set index (0..)
extern int SceneSetNum;	// number of levels in current scene set
extern int SceneInx;	// current scene index (0..)
extern int SceneBase; // number of first scene in current scene set
extern const sSceneSet* SceneSet; // current scene set
extern const u8* Scene;	// current scene

// ckeck wall in scene definition
Bool ParseSceneWall(u8 x, u8 y);

// parse scene and display game screen
void ParseScene();

// initialize new game of current scene
void NewGame(Bool init);

#endif // _SCENE_H
