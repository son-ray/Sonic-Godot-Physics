extends Node

class_name HUD

onready var score_label = $Score/Score
onready var rings_label = $Score/Rings
onready var lifes_label = $Lifes/Counter
onready var lifes_mobile = $MobileLifes/Counter

onready var lifes = $Lifes
onready var mob_lifes = $MobileLifes

onready var minutes_label = $Score/Timer/Minutes
onready var seconds_label = $Score/Timer/Seconds
onready var milliseconds_label = $Score/Timer/Milliseconds

onready var score_manager = get_node("/root/ScoreManager") as ScoreManager

func _ready():
	if OS.get_name() == "Android" or OS.get_name() == "iOS":
		lifes.visible = false
		mob_lifes.visible = true
	else:
		lifes.visible = true
		mob_lifes.visible = false
	connect_signals()
	initialize_labels()

func _process(_delta):
	var time = score_manager.time
	var minutes = int(time / 60)
	var seconds = int(time) % 60
	var milliseconds = int(time * 100) % 100
	
	minutes_label.text = str(minutes)
	seconds_label.text = "%02d" % seconds
	milliseconds_label.text = "%02d" % milliseconds

func connect_signals():
	score_manager.connect("score_added", self, "on_score_added")
	score_manager.connect("ring_added", self, "on_ring_added")
	score_manager.connect("life_added", self, "on_life_added")

func initialize_labels():
	score_label.text = str(score_manager.score)
	if sign(score_manager.lifes) == -1:
		lifes_label.text = str("0%s"%score_manager.lifes)
		lifes_mobile.text = str("0%s"%score_manager.lifes)
	else:
		lifes_label.text = str(score_manager.lifes)
		lifes_mobile.text = str(score_manager.lifes)
	rings_label.text = str(score_manager.rings)

func on_score_added(score: int):
	score_label.text = str(score)

func on_ring_added(rings: int):
	rings_label.text = str(rings)

func on_life_added(lifes: int):
	lifes_label.text = str(lifes)
	lifes_mobile.text = str(lifes)
