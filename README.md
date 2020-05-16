# PathfindingPlatformingAI
Welcome!

This is a Platforming Pathfinding AI for the GODOT game engine.

INSTALLATION:
first copy and paste the .gd and .tscn into a folder called "objs" in your game project file.

add as many "bad guy" (platform bot) scene instances in the project as you wish, group them under one node2D, and insert this code into your player's physics_process/process script:

=====================================================================================

for i in (node2d name here).get_children():
  i.targetBody = self
  i.isPlayer = true #depending on whether this is your controllable player

=====================================================================================

Lastly, these are some important things you will need to do in order for this to work!

set your player node's collision layer to 2!

there are also some other nifty features to this as well!

If you have any Trouble with installing or want to know more, please watch my tutorial video below:
https://www.youtube.com/watch?v=ZnAqY6mp1aI&feature=youtu.be

if you have any queries on how to customize your bot, please ask me through the comments!

and you can support me by checking out my yt channel:

https://www.youtube.com/channel/UCGRCAJNhxAB7maEn_PLWj5g

Thanks,

Ron0Studios
