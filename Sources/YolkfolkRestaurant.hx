package;

import kha.Button;
import kha.Configuration;
import kha.Game;
import kha.Loader;
import kha.LoadingScreen;
import kha.Scene;
import kha.Sound;
import kha.Tile;
import kha.Tilemap;

class YolkfolkRestaurant extends Game {
	public function new(): Void {
		super("Yolkfolk Restaurant", false);
		StGameManager.InitGame(this);
		
		StGameManager.InitCookingBook(new CookingBook());
		StGameManager.InitLager(new Lager());
		StGameManager.InitSpriteButtonManager(new SpriteButtonManager(scene));
		
	}
	
	public override function init(): Void {

		Configuration.setScreen(new LoadingScreen());
		Loader.the.loadRoom("restaurant", initLevel);
		
		
	}
	
	private function isCollidable(index: Int): Bool {
		return false;
	}
	
	private function startBackground():Void{
		StGameManager.MyGameManager().CreateBackground();
	}
	
	private function startBook(): Void {
		var sound: Sound = Loader.the.getSound("jump");
		sound.play();
		
		myItem_01 = StGameManager.MyGameManager().addItem(Eitem.TOMATE, 0, 0);
		
		StGameManager.MyCookingBookManager().GUION();
		StGameManager.MyLagerManager().createLager();
		//testphase start
		StGameManager.MySpriteButtonManager().createButton(ESpriteButton.BUTCART, new Position(100,0));
		//StGameManager.MyLagerManager().GUION();
		//ende
	}
	
	private function startCook(): Void {
		
		
		cook = new Cook();
		scene.addHero(cook);
		
		addTable(60, 100);
		addTable(500, 300);
	}
	
	private function initLevel(): Void {
		
		this.startBook();
		this.startCook();
		this.startBackground();
		Configuration.setScreen(this);
	}
	
	public function CreateBackground()
	{
		var tileColissions = new Array<Tile>();
		for (i in 0...(6 * 8)) {
			tileColissions.push(new Tile(i, isCollidable(i)));
		}
		var blob = Loader.the.getBlob("restaurant.map");
		var levelWidth : Int = blob.readInt();
		var levelHeight : Int = blob.readInt();
		var map = new Array<Array<Int>>();
		for (x in 0...levelWidth) {
			map.push(new Array<Int>());
			for (y in 0...levelHeight) {
				map[x].push(blob.readInt());
			}
		}
		var tilemap: Tilemap = new Tilemap("054-Wall02", 16 * 3, 16 * 3, map, tileColissions);
		Scene.the.setColissionMap(tilemap);
		Scene.the.addBackgroundTilemap(tilemap, 1);
		
		
	}

	public function addItem(id: Eitem, x: Float, y: Float): Item {
			
		//var item = new Item().createByID(id);
		var item = Item.createByString(Std.string(id));
		item.x = x;
		item.y = y;
		scene.addEnemy(item);
		return item;
	}
	
	public function addItemByString(id: String, x: Float, y: Float): Item {
			
		var item = Item.createByString(id);
		item.x = x;
		item.y = y;
		scene.addEnemy(item);
		return item;
	}
	public function delItem(paSprite : kha.Sprite)
	{
		scene.removeEnemy(paSprite);
		//paSprite = null;
	}
	private function addTable(x: Float, y: Float): Void {
		var table = new Table();
		table.x = x;
		table.y = y;
		scene.addEnemy(table);
		
		var chair1 = new Chair1();
		chair1.x = x + 50;
		chair1.y = y - 60;
		scene.addEnemy(chair1);
		
		var chair2 = new Chair2();
		chair2.x = x + 50;
		chair2.y = y + 140;
		scene.addEnemy(chair2);
	}
	override public function mouseDown(paX: Int, paY: Int): Void 
	{ 
		
		StGameManager.MySpriteButtonManager().onMouseKlick(paX, paY);
		StGameManager.MyCookingBookManager().checkButtonEventOnMouseDown(paX, paY);//immer erst nach den Spritebuttonmanager(OnMouseKlick) aufrufen sonst werden die befehle nicht ausgeführt
		StGameManager.MyLagerManager().setCurrentRezept(StGameManager.MyCookingBookManager().getCurrentRezept());//Rezept übertragen
		StGameManager.MyLagerManager().checkButtonEventOnMouseDown(paX, paY);
		if (myItem_01 == null)
		{
			myItem_01 = StGameManager.MyGameManager().addItem(Eitem.TOMATE, paX, paY);
		}
		else if (StHelper.IsOverTestBySprite(paX, paY, myItem_01))
		{
			StGameManager.MyGameManager().delItem(myItem_01);
			myItem_01 = null;
		}
		StGameManager.MySpriteButtonManager().resetAssimailatenOrder();
	}
	
	override public function mouseUp  (paX: Int, paY: Int): Void 
	{ 
		
	}
	
	override public function mouseMove(paX: Int, paY: Int): Void
	{
		StGameManager.MySpriteButtonManager().update(paX, paY);
		
	}
	override public function buttonDown(button: Button): Void {
		
		switch (button) {
		case Button.LEFT:
			cook.left = true;
			cook.changeDirection();
		case Button.RIGHT:
			cook.right = true;
			cook.changeDirection();
		case Button.UP:
			cook.up = true;
			cook.changeDirection();
		case Button.DOWN:
			cook.down = true;
			cook.changeDirection();
		default:
		}
	}
	
	override public function buttonUp(button: Button): Void {
		switch (button) {
		case Button.LEFT:
			cook.left = false;
			cook.changeDirection();
		case Button.RIGHT:
			cook.right = false;
			cook.changeDirection();
		case Button.UP:
			cook.up = false;
			cook.changeDirection();
		case Button.DOWN:
			cook.down = false;
			cook.changeDirection();
		default:
		}
	}
	
	private var myItem_01 : Item;
	private var cook: Cook;
	
	
}