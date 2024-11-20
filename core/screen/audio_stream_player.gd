extends AudioStreamPlayer

var trecks = [
	"res://assets/Music/1.mp3",
	"res://assets/Music/2.mp3",
	"res://assets/Music/3.mp3",
	"res://assets/Music/4.mp3",
	"res://assets/Music/5.mp3",
	"res://assets/Music/6.mp3",
]

func _ready() -> void:
	change_track()
	#create_tween().tween_property(self, "volume_db", -15, 3.0)
	finished.connect(change_track)


func change_track():
	stream = load(trecks.pick_random())
	play()
