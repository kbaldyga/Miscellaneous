namespace Models

open Microsoft.Xna.Framework
open Microsoft.Xna.Framework.Graphics
open Microsoft.Xna.Framework.Content
open System
open Helpers
    
    module Ghost =
        
        //[<AbstractClass>]
        type Ghost = class
            [<DefaultValue>] val mutable public Position : Point
            [<DefaultValue>] val mutable public Delta : Point
            [<DefaultValue>] val mutable texture : Texture2D
            [<DefaultValue>] val mutable public Aim : Point
            val mutable movement : Movement
            
            new() = { movement = Helpers.Right; }
            
            member this.RenderPoint 
                with get() = new Vector2(float32(this.Position.X * Constants.FieldWidth + this.Delta.X), float32(this.Position.Y * Constants.FieldHeight + this.Delta.Y))
    
            member this.Initialize(position):unit = 
                this.Position <- position
                this.Delta <- Point.Zero
                
                let random = new Random()
                this.Aim <- new Point(random.Next(0,Constants.MAP_SIZE_WIDTH / 2), random.Next(0,Constants.MAP_SIZE_WIDTH))
                
            member this.LoadContent(content:ContentManager) = 
                this.texture <- content.Load(Constants.GHOST_TEXTURE)
                
            member this.update() = ()
            
            member this.Draw(spriteBatch:SpriteBatch) = 
                spriteBatch.Draw(this.texture, this.RenderPoint, 
                                    Nullable<Rectangle>(), Color.White, float32(0.0), Vector2.Zero, 
                                    Constants.SCALE, SpriteEffects.None, float32(0.0))

            
        end
