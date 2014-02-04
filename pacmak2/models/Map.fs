namespace Models

open Microsoft.Xna.Framework
open Microsoft.Xna.Framework.Graphics
open Microsoft.Xna.Framework.Content
open System

    module Map =
           
        let prepareMap (map:string) = 
            let mapT = map.Trim()
            in mapT.Split([| Environment.NewLine |], StringSplitOptions.None)
        
        type MapState = 
            | None
            | Empty
            | Wall
            | Food
            | HQ

        type Map(height0, width0) = class
            let mutable height = height0
            let mutable width = width0
            let mutable state = [| for h in 1 .. height do yield [| for w in 1 .. width do yield MapState.None |]  |]
            [<DefaultValue>] val mutable public Position : Vector2
            
            [<DefaultValue>] val mutable backgroundTexture : Texture2D
            [<DefaultValue>] val mutable wallTexture : Texture2D
            [<DefaultValue>] val mutable foodTexture : Texture2D

            member this.LoadContent(content:ContentManager) =
                this.backgroundTexture <- content.Load Constants.BOARD_TEXTURE
                this.foodTexture <- content.Load Constants.FOOD_TEXTURE
                this.wallTexture <- content.Load Constants.WALL_TEXTURE
                
                state <- Constants.map1 |> prepareMap |> this.LoadMap

            member this.LoadMap(mapContent:string[]) = 
                mapContent |> 
                    Array.map (fun row -> Seq.toArray (row |> Seq.map (function 
                                | '█' -> MapState.Wall
                                | '○' -> MapState.Food
                                | '.' -> MapState.HQ
                                | _ -> MapState.Empty
                                ))) 
                               
            member this.Draw(spriteBatch:SpriteBatch) =
                spriteBatch.Draw(this.backgroundTexture, 
                                new Rectangle(0,0,Constants.FieldWidth * Constants.MAP_SIZE_WIDTH, Constants.FieldHeight * Constants.MAP_SIZE_HEIGHT),
                                Color.White)
                let mutable currentTexture = null
                let mutable color = Color.Transparent
                in
                for y = 0 to height-1 do
                    for x = 0 to width-1 do
                        match state.[y].[x] with 
                            | MapState.Food -> currentTexture <- this.foodTexture ; color <- Color.White
                            | MapState.Wall -> currentTexture <- null// this.wallTexture ; color <- Color.White
                            | MapState.Empty -> currentTexture <- null//this.wallTexture ; color <- Color.Blue
                            | MapState.HQ -> currentTexture <- null
                            | _ -> raise(NotSupportedException())
                        let recX = x * Constants.FieldWidth
                        let recY = y * Constants.FieldHeight
                        if currentTexture <> null then spriteBatch.Draw(currentTexture, new Vector2(float32(recX), float32(recY)), Nullable<Rectangle>(), color, float32(0.0), 
                                                                            Vector2.Zero, Constants.SCALE, SpriteEffects.None, float32(0.0))
               
            member this.CanStepOver y x = state.[y].[x] <> MapState.Wall && state.[y].[x] <> MapState.HQ
            
            member this.CanMoveTo(position:Point) (y:int) (x:int) :bool =
                let mapX = position.X + Math.Sign x
                let mapY = position.Y + Math.Sign y
                in
                    if position.X >= Constants.MAP_SIZE_WIDTH - 1 && x > 0 then
                        this.CanStepOver mapY 0
                    elif position.X = 0 && x < 0 then
                        this.CanStepOver mapY (Constants.MAP_SIZE_WIDTH-1)
                    elif position.Y >= Constants.MAP_SIZE_HEIGHT-1 && y > 0 then
                        this.CanStepOver 0 mapX 
                    elif position.Y = 0 && y < 0 then
                        this.CanStepOver (Constants.MAP_SIZE_HEIGHT-1) mapX
                    else this.CanStepOver mapY mapX
                    
            member this.Collision (y:int) (x:int) : MapState = state.[y].[x]
            member this.ClearField (y:int) (x:int) = state.[y].[x] <- MapState.Empty
        end
        