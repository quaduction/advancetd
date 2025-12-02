extends Control;

var stack: Array = [];

func push(menu: Control):
	stack.append(menu);
	add_child(menu);

func pop():
	var menu = stack.pop_back();
	menu.queue_free();
