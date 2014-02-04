#region File Description
//-----------------------------------------------------------------------------
// pacmakGame.cs
//
// Microsoft XNA Community Game Platform
// Copyright (C) Microsoft Corporation. All rights reserved.
//-----------------------------------------------------------------------------
#endregion
#region Using Statements
using System;
using Microsoft.Xna.Framework;
using Microsoft.Xna.Framework.Audio;
using Microsoft.Xna.Framework.Graphics;
using Microsoft.Xna.Framework.Input;
using Microsoft.Xna.Framework.Input.Touch;
using Microsoft.Xna.Framework.Storage;
using Microsoft.Xna.Framework.Content;
using Microsoft.Xna.Framework.Media;
using Models;

#endregion
namespace pacmak
{
	/// <summary>
	/// Default Project Template
	/// </summary>
	public class Game1 : Game
	{

		#region Fields
		GraphicsDeviceManager graphics;
		SpriteBatch spriteBatch;
		Engine.Engine engine;
		// keyboard states used to determin key presses
		KeyboardState currentKeyboardState;
		// movement speed for the player
		float playerMoveSpeed;
		#endregion
		#region Initialization
		public Game1 ()
		{

			graphics = new GraphicsDeviceManager (this);
			
			Content.RootDirectory = "Content";

			graphics.IsFullScreen = false;
			graphics.PreferredBackBufferHeight = Constants.MAP_SIZE_HEIGHT * Constants.FieldHeight + Constants.BOTTOM_BANNER_HEIGHT;
			graphics.PreferredBackBufferWidth = Constants.MAP_SIZE_WIDTH * Constants.FieldWidth;
		}

		/// <summary>
		/// Overridden from the base Game.Initialize. Once the GraphicsDevice is setup,
		/// we'll use the viewport to initialize some values.
		/// </summary>
		protected override void Initialize ()
		{
			engine = new Engine.Engine ();
			//pakmak = new Player.Player ();

			//map = new Map.Map (Constants.MAP_SIZE_HEIGHT, Constants.MAP_SIZE_WIDTH);
			playerMoveSpeed = Constants.PLAYER_MOVE_SPEED;

			base.Initialize ();
		}

		/// <summary>
		/// Load your graphics content.
		/// </summary>
		protected override void LoadContent ()
		{
			spriteBatch = new SpriteBatch (graphics.GraphicsDevice);
			engine.LoadContent (this.Content);
		}
		#endregion
		#region Update and Draw

		private void UpdatePlayer (GameTime gameTime)
		{
			var currentMove = GetVectorByKeystate (currentKeyboardState);
			engine.Update (currentMove);
		}

		private Vector2 GetVectorByKeystate (KeyboardState keystate)
		{
			Vector2 movement = new Vector2 ();
			if (keystate.IsKeyDown (Keys.Left)) {
				movement = new Vector2 (- playerMoveSpeed, 0);
			}
			if (keystate.IsKeyDown (Keys.Right)) {
				movement = new Vector2 (playerMoveSpeed, 0);
			}
			if (keystate.IsKeyDown (Keys.Up)) {
				movement = new Vector2 (0, -playerMoveSpeed);
			}
			if (keystate.IsKeyDown (Keys.Down)) {
				movement = new Vector2 (0, playerMoveSpeed);
			}
			return movement;
		}

		/// <summary>
		/// Allows the game to run logic such as updating the world,
		/// checking for collisions, gathering input, and playing audio.
		/// </summary>
		/// <param name="gameTime">Provides a snapshot of timing values.</param>
		protected override void Update (GameTime gameTime)
		{
			currentKeyboardState = Keyboard.GetState ();
			base.Update (gameTime);
			UpdatePlayer (gameTime);
		}

		/// <summary>
		/// This is called when the game should draw itself. 
		/// </summary>
		/// <param name="gameTime">Provides a snapshot of timing values.</param>
		protected override void Draw (GameTime gameTime)
		{
			// Clear the backbuffer
			graphics.GraphicsDevice.Clear (Color.Black);
			spriteBatch.Begin ();

			engine.Draw (spriteBatch);

			spriteBatch.End ();

			base.Draw (gameTime);
		}
		#endregion
	}
}
