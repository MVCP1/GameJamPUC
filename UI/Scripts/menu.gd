extends Control
@onready var tituloMenu = $VBoxContainer/Titulo
@export var arrowMarginFromCenter = 200
@export var centerOffSet = 100
@onready var botoesMenu = $VBoxContainer/HBoxContainer/BotoesMenu
@onready var botoesCreditos = $VBoxContainer/HBoxContainer/BotoesCreditos
@onready var playbutton = $VBoxContainer/HBoxContainer/BotoesMenu/Play
@onready var voltabutton = $VBoxContainer/HBoxContainer/BotoesCreditos/volta
@onready var voltaOpcoesbutton = $VBoxContainer/HBoxContainer/BotoesOpcoes/voltaOpcoes
@onready var botoesOpcoes = $VBoxContainer/HBoxContainer/BotoesOpcoes


@onready var musicSound = $AudioStreamPlayer

# Called when the node enters the scene tree for the first time.
func _ready():
	Game.current_level = 0
	$AnimationPlayer.play("Fade In")
	playbutton.grab_focus()
	_setMenuNameArrow()
	botoesMenu.show()
	botoesCreditos.hide()
	botoesOpcoes.hide()
	tituloMenu.show()
	
	pass


func _setMenuNameArrow():
	for arrow in [$LeftArrow,$RightArrow]:
		arrow.visible = true
		arrow.global_position.y = tituloMenu.global_position.y + 65
	var _centerMenuX = tituloMenu.global_position.x
	
	$RightArrow.global_position.x = _centerMenuX + arrowMarginFromCenter + centerOffSet
	$LeftArrow.global_position.x = _centerMenuX - arrowMarginFromCenter + centerOffSet
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


	


func _on_play_pressed():
	Game.next_level()
	pass # Replace with function body.


func _on_options_pressed():
	tituloMenu.hide()
	botoesMenu.hide()
	botoesOpcoes.show()
	for arrow in [$LeftArrow,$RightArrow]:
		arrow.visible = false
	voltaOpcoesbutton.grab_focus()
	pass # Replace with function body.


func _on_credits_pressed():
	tituloMenu.hide()
	botoesMenu.hide()
	botoesCreditos.show()
	for arrow in [$LeftArrow,$RightArrow]:
		arrow.visible = false
	voltabutton.grab_focus()
	
	pass # Replace with function body.


func _on_exit_pressed():
	get_tree().quit()
	pass # Replace with function body.


func _on_volta_pressed():
	tituloMenu.show()
	botoesMenu.show()
	botoesCreditos.hide()
	botoesOpcoes.hide()
	for arrow in [$LeftArrow,$RightArrow]:
		arrow.visible = true
	playbutton.grab_focus()
	pass # Replace with function body.


func _on_asset_creditos_pressed():
	var _creditoAssets = OS.shell_open("https://www.kenney.nl/")
	pass # Replace with function body.


func _on_volta_opcoes_pressed():
	tituloMenu.show()
	botoesMenu.show()
	botoesCreditos.hide()
	botoesOpcoes.hide()
	for arrow in [$LeftArrow,$RightArrow]:
		arrow.visible = true
	playbutton.grab_focus()
	pass # Replace with function body.


func _on_asset_creditos_isaac_pressed():
	var _creditoAssets = OS.shell_open("https://www.linkedin.com/in/isaac-lima")
	pass # Replace with function body.


func _on_asset_creditos_marcos_pressed():
	var _creditoAssets = OS.shell_open("https://www.linkedin.com/in/marcos-vinicp")
	pass # Replace with function body.


func _on_asset_creditos_aragão_pressed():
	var _creditoAssets = OS.shell_open("https://www.linkedin.com/in/aragaog")
	pass # Replace with function body.


func _on_asset_creditos_campos_pressed():
	var _creditoAssets = OS.shell_open("https://www.linkedin.com/in/pinkywillgcr")
	pass # Replace with function body.
