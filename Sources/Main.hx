package;

import kha.Starter;

class Main {
	public static function main() {
		#if js
		new Starter().start(new YolkfolkRestaurant2());
		#else
		//new Starter().start(new YolkfolkRestaurant());
		new Starter().start(new memory.Memory());
		#end
	}
}