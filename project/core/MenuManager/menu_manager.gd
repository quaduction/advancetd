class_name MenuManager;
extends Control;

signal menu_pushed(menu);
signal menu_popped(menu);

var stack: Array[Control] = [];


func push_menu(menuSoup) -> Control:
	var menu = SceneManager.newNodeFromSoup(menuSoup);
	stack.append(menu);
	add_child(menu);
	menu_pushed.emit(menu);
	return menu;


func pop():
	if stack.is_empty(): return;

	var menu = stack.pop_back();
	menu_popped.emit(menu);
	menu.queue_free();