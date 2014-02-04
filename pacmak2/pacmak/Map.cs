//using Microsoft.Xna.Framework;
//using Microsoft.Xna.Framework.Graphics;
//using Microsoft.Xna.Framework.Content;
//using System;
//using Models;
//
//namespace pacmak
//{
//	public class Map {
//		private int height;
//		private int width;
//		MapState[,] state;
//
//		public Texture2D BackgroundTexture { get; private set; }
//		public Texture2D WallTexture { get; private set; }
//		public Texture2D FoodTexture { get; private set; }
//		public Vector2 Position;
//
//		public Map(int height, int width) {
//			this.height = height;
//			this.width = width;
//
//			state = new MapState[height, width];
//		}
//
//		public void LoadMap() {
//			state = ClassFaker.LoadMap (ClassFaker.Map1.Trim ().Split (new[] { Environment.NewLine }, StringSplitOptions.None));
//		}
//
//		public void LoadContent(ContentManager content) {
//			BackgroundTexture = content.Load<Texture2D> (Constants.BOARD_TEXTURE);
//			WallTexture = content.Load<Texture2D> (Constants.WALL_TEXTURE);
//			FoodTexture = content.Load<Texture2D> (Constants.FOOD_TEXTURE);
//
//			LoadMap ();
//		}
//
//		public void Draw(SpriteBatch spriteBatch) {
//			for(int y = 0 ; y < height ; y ++) {
//				for(int x = 0 ; x < width ; x ++) {
//					Texture2D currentTexture = null;
//					switch(state[y,x]) {
//						case MapState.None:
//							throw new NotSupportedException ();
//						case MapState.Empty:
//							break;
//						case MapState.Food:
//							currentTexture = FoodTexture;
//							break;
//						case MapState.Wall:
//							currentTexture = WallTexture;
//							break;
//						}
//					spriteBatch.Draw (currentTexture, new Rectangle (x*Constants.FieldWidth, y*Constants.FieldHeight, 
//					                                                 Constants.FieldWidth, Constants.FieldHeight), Color.Black);
//				}
//			}
//		}
//
//		private bool canStepOver(int y, int x) {
//			return state [y, x] != MapState.Wall;
//		}
//
//		public bool CanMoveTo (Point position, int y, int x) {
//			var mapX = position.X + Math.Sign (x);
//			var mapY = position.Y + Math.Sign (y);
//
//			if (position.X >= Constants.MAP_SIZE_WIDTH - 1 && x > 0) { 
//				if(canStepOver(mapY,0)) {
//					return true;
//				}
//				return false;
//			}
//			else if (position.X == 0 && x < 0) {
//				if (canStepOver(mapY, Constants.MAP_SIZE_WIDTH - 1)) {
//					return true;
//				}
//				return false;
//			}
//			if (position.Y >= Constants.MAP_SIZE_HEIGHT - 1 && y > 0) {
//				if (canStepOver(0, mapX)) {
//					return true;
//				}
//				return false;
//			}
//			else if (position.Y == 0 && y < 0) {
//				if (canStepOver(Constants.MAP_SIZE_HEIGHT - 1, mapX)) {
//					return true;
//				}
//				return false;
//			}
//
//			return canStepOver (mapY, mapX);		
//		}
//	}
//
//	public enum MapState {
//		None,
//		Empty,
//		Wall,
//		Food
//	}
//
//	public static class ClassFaker {
//		public static MapState[,] LoadMap(string[] mapContent) {
//			var height = mapContent.Length;
//			var width = mapContent[0].Length;
//			if (height != Constants.MAP_SIZE_HEIGHT)
//				throw new ArgumentException (string.Format ("map needs to be {0} height", Constants.MAP_SIZE_HEIGHT));
//			if (width != Constants.MAP_SIZE_WIDTH)
//				throw new ArgumentException (string.Format ("map needs to be {0} width", Constants.MAP_SIZE_WIDTH));
//
//			var map = new MapState[height,width];
//			for (int ii = 0; ii < height; ii ++) {
//				for (int jj = 0 ; jj < width; jj ++) {
//					switch (mapContent [ii] [jj]) {
//					case '█':
//						map [ii,jj] = MapState.Wall;
//						break;
//					case ' ':
//						map [ii, jj] = MapState.Food;
//						break;
//					default:
//						map [ii, jj] = MapState.Empty;
//						break;
//					}
//				}
//			}
//			return map;
//		}
//
//
//		// 20 width
//		// 12 + 2 + 12 height = 26
//		public const string Map1 = @"
//████████████████████████████
//█            ██            █
//█ ████ █████ ██ █████ ████ █
//█ ████ █████ ██ █████ ████ █
//█ ████ █████ ██ █████ ████ █
//█                          █
//█ ████ ██ ████████ ██ ████ █
//█ ████ ██ ████████ ██ ████ █
//█      ██    ██    ██      █
//██████ █████ ██ █████ ██████
//     █ █████ ██ █████ █     
//     █ ██          ██ █     
//     █ ██          ██ █     
//██████ ██          ██ ██████
//                            
//██████ ██          ██ ██████
//     █ ██          ██ █     
//     █ ██          ██ █     
//     █ █████ ██ █████ █     
//██████ █████ ██ █████ ██████
//█      ██    ██    ██      █
//█ ████ ██ ████████ ██ ████ █
//█ ████ ██ ████████ ██ ████ █
//█                          █
//█ ████ █████ ██ █████ ████ █
//█ ████ █████ ██ █████ ████ █
//█ ████ █████ ██ █████ ████ █
//█            ██            █
//████████████████████████████
//";
//	}
//
//}
//
