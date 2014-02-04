namespace Models

    module Constants =
        let BOARD_TEXTURE = "background.png"
        let PLAYER_TEXTURE1 = "pacman1.png"
        let PLAYER_TEXTURE2 = "pacman2.png"
        let PLAYER_TEXTURE3 = "pacman3.png"
        let FOOD_TEXTURE = "food.png"
        let WALL_TEXTURE = "ghost.png"
        let GHOST_TEXTURE = "ghost.png"
        
        let FONT = "Font"

        let FieldHeight = 32 // 16
        let FieldWidth = FieldHeight
        let SCALE = float32(float32(FieldHeight) / 32.0f)

        let MAP_SIZE_HEIGHT = 29
        let MAP_SIZE_WIDTH = 28
        let EPSILON = 0.1f
        let PLAYER_MOVE_SPEED = 6.0f * SCALE
        let INITIAL_POSITION = (1,1)
        let INITIAL_LIVES = 3
        let FOOD_POINTS = 5
        let BOTTOM_BANNER_HEIGHT = int(150.0f * SCALE)
        
        let MapHeight = MAP_SIZE_HEIGHT * FieldHeight
        
        let map1 = @"
████████████████████████████
█○○○○○○○○○○○○██○○○○○○○○○○○○█
█○████○█████○██○█████○████○█
█○████○█████○██○█████○████○█
█○████○█████○██○█████○████○█
█○○○○○○○○○○○○○○○○○○○○○○○○○○█
█○████○██○████████○██○████○█
█○████○██○████████○██○████○█
█○○○○○○██○○○○██○○○○██○○○○○○█
██████○█████○██○█████○██████
     █○█████○██○█████○█     
     █○██○○○○○○○○○○██○█     
     █○██○██....██○██○█     
██████○██○█......█○██○██████
○○○○○○○○○○█......█○○○○○○○○○○
██████○██○█......█○██○██████
     █○██○████████○██○█     
     █○██○○○○○○○○○○██○█     
     █○█████○██○█████○█     
██████○█████○██○█████○██████
█○○○○○○██○○○○██○○○○██○○○○○○█
█○████○██○████████○██○████○█
█○████○██○████████○██○████○█
█○○○○○○○○○○○○○○○○○○○○○○○○○○█
█○████○█████○██○█████○████○█
█○████○█████○██○█████○████○█
█○████○█████○██○█████○████○█
█○○○○○○○○○○○○██○○○○○○○○○○○○█
████████████████████████████
"
