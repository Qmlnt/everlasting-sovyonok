extends KinematicBody2D

var dir = Vector2(0, 0)
var vel = 0

var state = "idle"
var target = null
var stopon = 0
var startat = 0
var signal_to_parent = ""

var whoami : String

func _ready():
	$AnimatedSprite.frames = load("res://characters/"+whoami+"/SpriteSheet.tres")
	$AnimatedSprite.animation = "left"
	$AnimatedSprite.frame = 0

# warning-ignore:unused_argument
func _process(delta):
	
	# Движение по тупому - в сторону игрока
	# Здусь нужен алгоритм поиска пути!
	if target != null and state == "pursuit":
		dir = target.position - self.position
	elif target != null and state == "move":
		dir = target - self.position
	
	# Остановка на растоянии от игрока
	if state == "pursuit":
		if dir.length() < startat:
			vel = 10
		if dir.length() < stopon:
			get_parent().NPCs_signals[whoami] = signal_to_parent
			state = "idle"
			vel = 0
	
	if state == "move":
		vel = 10
		if dir.lenght() < 5:
			state = "idle"
			vel = 0
	
	$AnimatedSprite.speed_scale = vel / 6
	
	
	# Анимации ходьбы
	if dir == Vector2(0,0):
		$AnimatedSprite.frame = 0
		$AnimatedSprite.playing = false
	else:
		if dir.x > 0.3:
			$AnimatedSprite.play("right")
		elif dir.x < -0.3:
			$AnimatedSprite.play("left")
		else:
			if dir.y > 0:
				$AnimatedSprite.play("down")
			elif dir.y < 0:
				$AnimatedSprite.play("up")
		if vel == 0:
			$AnimatedSprite.frame = 0
			$AnimatedSprite.playing = false

# warning-ignore:unused_argument
func _physics_process(delta):
	dir = self.move_and_slide(dir.normalized()*vel*16)
