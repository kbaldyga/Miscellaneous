namespace Models

open Microsoft.Xna.Framework
open Microsoft.Xna.Framework.Graphics
open Microsoft.Xna.Framework.Content
open System
open Helpers

    module Players =

        type Player = class
            [<DefaultValue>] val mutable public Position : Point
            [<DefaultValue>] val mutable public Delta : Point
            [<DefaultValue>] val mutable playerTexture : Texture2D array
            [<DefaultValue>] val mutable currentTexture : int
            [<DefaultValue>] val mutable public Score : int
            val mutable public Lives : int
            val mutable movement : Movement
            
            new() = { movement = Helpers.Right; Lives = Constants.INITIAL_LIVES }
                
            member this.RenderPoint
                with get() = new Vector2(float32(this.Position.X * Constants.FieldWidth + this.Delta.X), float32(this.Position.Y * Constants.FieldHeight + this.Delta.Y))
  
             member this.Initialize(position):unit =
                this.Position <- position
                this.Delta <- Point.Zero
               
             member this.LoadContent(content:ContentManager) = 
                this.playerTexture <- [|
                                        content.Load(Constants.PLAYER_TEXTURE1);
                                        content.Load(Constants.PLAYER_TEXTURE2);
                                        content.Load(Constants.PLAYER_TEXTURE3) 
                                     |]
             
             member this.Update() = ()
             
             member this.Draw(spriteBatch:SpriteBatch) =
                this.currentTexture <- this.currentTexture + 1 % 30
                let drawingTexture = int(this.currentTexture/10) % 3
                let rotationOrigin = Helpers.getRotationAndOrigin(this.movement)
                let rotation = fst rotationOrigin
                let origin = snd rotationOrigin
                spriteBatch.Draw(this.playerTexture.[drawingTexture], this.RenderPoint, 
                                    Nullable<Rectangle>(), Color.White, rotation, origin, 
                                    Constants.SCALE, SpriteEffects.None, float32(0.0))

        end
