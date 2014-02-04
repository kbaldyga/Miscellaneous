namespace Models
open System
open Microsoft.Xna.Framework
    
module Helpers =

    type Movement = 
        | None | Down | Right | Up | Left

    let toDegree radians : float32 = float32(180.0 / Math.PI) * radians
    let toRadians degrees : float32 = float32(Math.PI / 180.0) * degrees
    let f = float32
    
    let getRotationAndOrigin (rotation:Movement) = 
        let pow = Math.Pow(float(Constants.SCALE),-1.0)
        match rotation with
            | Down -> (toRadians 90.0f, new Vector2(0.0f, f(Constants.FieldWidth)*float32(pow)))
            | Right -> (0.0f, Vector2.Zero)
            | Up -> (toRadians 270.0f, new Vector2(f(Constants.FieldHeight) * float32(pow), 0.0f))
            | Left -> (toRadians 180.0f, new Vector2(f(Constants.FieldHeight) * float32(pow), f(Constants.FieldWidth) * float32(pow)))
            | _ -> raise(new ArgumentException())
            
    let oppositeMovement (movement:Movement) = 
        match movement with
            | None -> None
            | Down -> Up
            | Right -> Left
            | Left -> Right
            | Up -> Down
            
    let movementToVector (movement:Movement) y x = 
        match movement with
            | Down -> (y+1,x)
            | Left -> (y,x-1)
            | Right -> (y,x+1)
            | Up -> (y-1,x)
            | None -> (y,x)
            
    let vectorToMovement (v1:Vector2) (v2:Vector2) :Movement =
        if (v2.Y, v2.X) = (v1.Y + 1.0f, v1.X) then Down
        elif (v2.Y, v2.X) = (v1.Y - 1.0f, v1.X) then Up
        elif (v2.Y, v2.X) = (v1.Y, v1.X - 1.0f) then Left
        elif (v2.Y, v2.X) = (v1.Y, v1.X + 1.0f) then Right
        else None
        
    let movementToString (movement:Movement):string =
        match movement with
            | Up -> "UP"
            | Down -> "DOWN"
            | Left -> "LEFT"
            | Right -> "RIGHT"
            | _ -> ""
            