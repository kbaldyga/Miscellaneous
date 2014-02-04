namespace Models

open Microsoft.Xna.Framework
open Microsoft.Xna.Framework.Graphics
open Microsoft.Xna.Framework.Content
open System
open System.Diagnostics

    module Engine =

        type Engine() = class
            let player = new Players.Player()
            let map = new Map.Map(Constants.MAP_SIZE_HEIGHT, Constants.MAP_SIZE_WIDTH)
            let ghost = new Ghost.Ghost()
            let playerMoveSpeed = Constants.PLAYER_MOVE_SPEED
            let ghostMoveSpeed = Constants.PLAYER_MOVE_SPEED
            
            [<DefaultValue>] val mutable previousMove : Vector2
            [<DefaultValue>] val mutable font : SpriteFont
            
            let canMove = map.CanMoveTo
            
            member private this.calculatePosition (currentMove:Vector2) =
                this.MoveGhost()
            
                let mutable moveY = int(currentMove.Y)
                let mutable moveX = int(currentMove.X)
                let mutable currentMove = currentMove
                let mutable movedBigStep = false
                if not(canMove player.Position moveY moveX) then currentMove <- this.previousMove ; moveY <- int(currentMove.Y) ; moveX <- int(currentMove.X)
                let mutable moved = false
                let modifyPositionX f = f(player.Position.X) ; player.Delta.X <- 0 ; 
                let modifyPositionY f = f(player.Position.Y) ; player.Delta.Y <- 0 ; 
                
                if (player.Delta.X <> 0 || player.Delta.Y <> 0 || canMove player.Position moveY moveX) then 
                    moved <- true
                    if player.Delta.X = 0 && player.Delta.Y = 0 then this.previousMove <- currentMove
                    
                    if Math.Abs(currentMove.X - 0.0f) > Constants.EPSILON then
                        if player.Delta.Y % Constants.FieldHeight = 0 then player.Delta.X <- player.Delta.X + moveX
                        else player.Delta.Y <- player.Delta.Y + ((int)playerMoveSpeed * Math.Sign(int(player.Delta.Y)))
                    if Math.Abs(currentMove.Y - 0.0f) > Constants.EPSILON then
                        if player.Delta.X % Constants.FieldWidth = 0 then player.Delta.Y <- player.Delta.Y + moveY
                        else player.Delta.X <- player.Delta.X + ((int)playerMoveSpeed * Math.Sign(int(player.Delta.X)))
                
                if moved then
                    if player.Delta.X >= Constants.FieldWidth then modifyPositionX (fun currentX -> player.Position.X <- currentX + 1; player.movement <- Helpers.Right) ; movedBigStep <- true
                    elif player.Delta.X <= Constants.FieldWidth * -1 then modifyPositionX (fun currentX -> player.Position.X <- currentX - 1; player.movement <- Helpers.Left) ; movedBigStep <- true
                    if player.Delta.Y >= Constants.FieldHeight then modifyPositionY(fun currentY -> player.Position.Y <- currentY + 1; player.movement <- Helpers.Down) ; movedBigStep <- true
                    elif player.Delta.Y <= Constants.FieldHeight * -1 then modifyPositionY(fun currentY -> player.Position.Y <- currentY - 1; player.movement <- Helpers.Up) ; movedBigStep <- true
                       
                    if player.Position.X < 0 then player.Position.X <- Constants.MAP_SIZE_WIDTH - 1
                    elif player.Position.X >= Constants.MAP_SIZE_WIDTH then player.Position.X <- 0
                    
                    if player.Position.Y < 0 then player.Position.Y <- Constants.MAP_SIZE_HEIGHT - 1
                    elif player.Position.Y >= Constants.MAP_SIZE_HEIGHT then player.Position.Y <- 0
                    
                    if movedBigStep then 
                        let collision = map.Collision player.Position.Y player.Position.X in 
                            match collision with
                                | Map.Food -> player.Score <- player.Score + Constants.FOOD_POINTS ; map.ClearField player.Position.Y player.Position.X
                                | _ -> ()
          
                    //Debug.Write(player.Score) 
                    
            member private this.MoveGhost() = 
                let currentMove = ghost.movement
                let aim = new Vector2(float32(ghost.Aim.X), float32(ghost.Aim.Y))
                let currentPosition = new Vector2(float32(ghost.Position.X), float32(ghost.Position.Y))
                let xx = ghost.Position.X
                let yy = ghost.Position.Y
                let possibleMoves = [Helpers.Up; Helpers.Down ; Helpers.Right ; Helpers.Left] |> 
                                    List.filter(fun m -> Helpers.oppositeMovement ghost.movement <> m) |> 
                                    List.map(fun m -> Helpers.movementToVector m yy xx) |> 
                                    List.filter(fun (y,x) -> x >= 0 && x < Constants.MAP_SIZE_WIDTH && y >= 0 && y < Constants.MAP_SIZE_HEIGHT) |>  
                                    List.filter(fun (y,x) -> map.CanStepOver y x)
                let nextMove = if possibleMoves.Length = 0 then (0,0) else possibleMoves |> List.minBy(fun (y,x) -> Vector2.Distance(new Vector2(float32(x),float32(y)),aim))
                    
                in
                let nextVector = if nextMove = (0,0) then Vector2.Zero else new Vector2(float32(snd nextMove), float32(fst nextMove))
                let nextMovement = Helpers.vectorToMovement currentPosition nextVector
//                match nextMovement with
//                    | Helpers.Down -> 
//                    
                ghost.movement <- nextMovement
                ghost.Position.X <- snd nextMove
                ghost.Position.Y <- fst nextMove
                  
            member this.LoadContent(contentManager:ContentManager) = 
                map.LoadContent(contentManager)
                player.LoadContent(contentManager)
                player.Initialize(new Point(fst Constants.INITIAL_POSITION,snd Constants.INITIAL_POSITION)) |> ignore
                this.font <- contentManager.Load(Constants.FONT)
                
                ghost.LoadContent(contentManager)
                ghost.Initialize(new Point(14,11))
        
            member this.Draw(spriteBatch:SpriteBatch) = 
                map.Draw(spriteBatch)
                player.Draw(spriteBatch)
                ghost.Draw(spriteBatch)
                this.DrawPoints(spriteBatch)
                
            member this.Update(currentMove:Vector2) = 
                this.calculatePosition (if currentMove = Vector2.Zero then this.previousMove else currentMove)
                
                
            member private this.DrawPoints(spriteBatch:SpriteBatch) =
                spriteBatch.DrawString(this.font, "SCORE: " + player.Score.ToString(), new Vector2(10.0f, Helpers.f(Constants.MapHeight) + 10.0f), Color.White);
//            
//            let modifyDeltaAndPosition (delta:Point) (position:Point) (movement:Helpers.Movement) (speed:int) = 
//                match movement with
//                    | Helpers.Down -> (delta.Y + speed % Constants.FieldHeight, position.Y + Math.Floor((delta.Y + speed) / Constants.FieldHeight))
//                    | Helpers.Right -> (delta.X + speed % Constants.FieldWidth, position.X + Math.Floor((delta.X + speed) / Constants.FieldWidth))
//                    | Helpers.Up -> (delta.Y - speed % Constants.FieldHeight, position.Y - Math.Ceiling((delta.Y - speed) / Constants.FieldHeight))
//                    | Helpers.Left -> (delta.X - speed % Constants.FieldWidth, position.X - Math.Floor((delta.X - speed) / Constants.FieldHeight))
//                    
//                    
//             let test = 
//                let moveLeftOnlyDelta = modifyDeltaAndPosition (new Point(10,10)) (new Point(5,5)) Helpers.Left 5 = (
        end
