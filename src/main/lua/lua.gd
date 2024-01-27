extends Control

enum Modes {NONE, DICTIONARY, HELP}

var mode: Modes = Modes.NONE

@onready var book_button: Button = get_node("Message/MarginContainer/VBoxContainer/BookButton")
@onready var help_button: Button = get_node("Message/MarginContainer/VBoxContainer/HelpButton")
@onready var return_button: Button = get_node("Message/MarginContainer/VBoxContainer/ReturnButton")

@onready var label: Label = get_node("Message/Label")

@onready var message = get_node("Message")
@onready var warning = get_node("Warning")

@onready var message_animation_player: AnimationPlayer = get_node("MessageAnimationPlayer")
@onready var warning_animation_player: AnimationPlayer = get_node("WarningAnimationPlayer")

func _on_lua_toggled(toggled_on):
	if toggled_on:
		warning_animation_player.play("hide")
		await get_tree().create_timer(0.5).timeout
		message_animation_player.play("show")
	else:
		message_animation_player.play("hide")
		await get_tree().create_timer(0.5).timeout
		warning_animation_player.play("show")


func _on_book_pressed():
	print_message("Задай мне вопрос о физических определениях!
			Например, 'масса', 'скорость', 'сила'.")
	book_button.set_visible(false)
	help_button.set_visible(false)
	mode = Modes.DICTIONARY


func print_message(text: String):
	label.text = text
