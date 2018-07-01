package object.ui;

import flixel.*;
import flixel.group.FlxGroup;

import object.ui.Button;

/**
 *  Menu Class
 */
class Menu extends FlxGroup
{
	private var state:PoiState;

	public function new(state:PoiState)
	{
		super(32);
		this.state = state;
	}

	override public function update(elapsed:Float)
	{
		super.update(elapsed);
	}

	public function makeMainMenu():Void
	{
		// initialize menugroups
		var mainMenu:ButtonGroup = new ButtonGroup();
		var startMenu:ButtonGroup = new ButtonGroup();
		var loadMenu:ButtonGroup = new ButtonGroup();

		/* Main Menu */
		var startButton = new StartButton(100, 400, mainMenu, startMenu);
		var quitButton = new QuitButton(100, 430);
		mainMenu.add(startButton);
		mainMenu.add(quitButton);
		mainMenu.init(true);

		/* Start submenu */
		var newGameButton:NewGameButton = new NewGameButton(200, 400, state);
		var loadGameButton:LoadGameButton = new LoadGameButton(200, 430, startMenu, loadMenu);
		var start_backButton:PreviousMenuButton = new PreviousMenuButton(200, 460, startMenu, mainMenu);
		startMenu.add(newGameButton);
		startMenu.add(loadGameButton);
		startMenu.add(start_backButton);
		startMenu.init(false);

		/* Load submenu */
		var load_backButton:PreviousMenuButton = new PreviousMenuButton(200, 490, loadMenu, startMenu);
		loadMenu.add(load_backButton);
		loadMenu.init(false);

		add(loadMenu);
		add(startMenu);
		add(mainMenu);
	}
}
