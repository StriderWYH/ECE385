ISO：
first tank panel: w.a.s.d for motion, 3 for shooting
second tank panel: left,right,up,down for motion, 0 for shooting

schedule:
1. Based on lab8, realize the wasd for the first tank, create ROM to store the sprite sheet, and read sprite from the SpriteROM when drawing the tank. Note we need to specify the direction of the tank.
2. Add background sprite ROM and read sprite from the BackgroundROM when drawing the background.
3. Construct wall blocks to the screen, and realize the obstruction when the tank heads for the wall. The wall module might also serve as a generator of some signals indicating the collision determination. The drawing of the wall is also realized by reading from SpriteROM. 
4. add bullet...
5. add bullet hit determination, tanks&nexus&wall blocks destruction.
6. Add enemy tank
7. extend the keycode byte
8.  menu page... mode selection... game over page...
....