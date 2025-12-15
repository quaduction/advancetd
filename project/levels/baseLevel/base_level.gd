class_name Level;
extends Node2D;

signal levelEnd(won: bool);

signal dataChange();

@export var baseHealth := 20;

@export var cash := 0;
@export var cashFlow := {
	"time": 5,
	"amount": 10
};
@export var cahsMult := 1.0;

@export var creditsReward := 100;

var creditsEarned = 0;

@onready var towerBuilder = $TowerBuilder;
@onready var projectiles = $Projectiles;

func _ready() -> void:
	$SalaryTimer.wait_time = cashFlow.time;

func damageBase(damage: int):
	baseHealth -= damage;

	dataChange.emit();

	if baseHealth <= 0:
		gameOver(false);

func gameOver(win: bool):
	levelEnd.emit(win);

func _on_salary_timer_timeout() -> void:
	mutBal(cashFlow.amount);

func mutBal(mut: int):
	cash += mut;
	dataChange.emit();
