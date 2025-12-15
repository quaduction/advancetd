extends Node;

# Become Global

var main: Main;
var states
var levelManager: LevelManager;
var menuManager: MenuManager;
var data: Data;

const consts := {
	"highlight": {
		"range": Color(0, 0, 1, 0.2),
		"valid": Color(0, 1, 0, 0.5),
		"invalid": Color(1, 0, 0, 0.5)
	}
};