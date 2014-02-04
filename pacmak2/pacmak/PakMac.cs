//using Microsoft.Xna.Framework;
//using Microsoft.Xna.Framework.Graphics;
//using Microsoft.Xna.Framework.Content;
//using System;
//using System.Diagnostics;
//using Models;
//
//
//namespace pacmak
//{
//	public class PakMac 
//	{
//		public PakMac ()
//		{
//		}
//
//		public void Initialize(Point position) {
//			Position = position;
//			Active = true;
//			Delta = Point.Zero;
//		}
//
//		public void LoadContent(ContentManager content) {
//			PlayerTexture = content.Load<Texture2D> (Constants.PLAYER_TEXTURE);
//		}
//
//		public void Update() {
//		}
//
//		public void Draw(SpriteBatch spriteBatch) {
//			spriteBatch.Draw (PlayerTexture, RenderPoint, null, Color.White, 0f, Vector2.Zero, 1f, SpriteEffects.None, 0f);
//			//Debug.Write(string.Format("position: {0} {1}", RenderPoint.X, RenderPoint.Y));
//		}
//
//		public Texture2D PlayerTexture { get; private set; }
//
//		public Point Position;
//
//		public bool Active { get; set; }
//
//		public int Width { get { return PlayerTexture.Width; } }
//
//		public int Height { get { return PlayerTexture.Height; } }
//
//		public Point Delta;
//
//		public bool DeltaHitsLimitX(int x) {
//			return Delta.X + x >= Constants.FieldWidth || Delta.X -x <= Constants.FieldWidth * -1;
//		}
//
//		public bool DeltaHitsLimitY(int y) {
//			return Delta.Y + y >= Constants.FieldHeight || Delta.Y - y <= Constants.FieldHeight * -1; 
//		}
//
//		public Vector2 RenderPoint {
//			get {
//				return new Vector2 (Position.X * Constants.FieldWidth + Delta.X, Position.Y * Constants.FieldHeight + Delta.Y);
//			}
//		}
//	}
//
//}
//
