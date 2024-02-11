extends Control

signal stopped_printing()

enum Modes {NONE, DICTIONARY, HELP}

var mode: Modes = Modes.NONE
var is_printing: bool = false

var definitions: PackedStringArray

@onready var book_button: Button = get_node("Message/MarginContainer/VBoxContainer/BookButton")
@onready var help_button: Button = get_node("Message/MarginContainer/VBoxContainer/HelpButton")
@onready var return_button: Button = get_node("Message/MarginContainer/VBoxContainer/ReturnButton")

@onready var label: RichTextLabel = get_node("Message/ScrollContainer/Label")

@onready var message = get_node("Message")
@onready var warning = get_node("Warning")

@onready var message_animation_player: AnimationPlayer = get_node("MessageAnimationPlayer")
@onready var warning_animation_player: AnimationPlayer = get_node("WarningAnimationPlayer")
@onready var edit_animation_player: AnimationPlayer = get_node("EditAnimationPlayer")
@onready var animation_player: AnimationPlayer = get_node("AnimationPlayer")


func _ready():
	animation_player.play("show")
	# Open dictionary
	if OS.get_name() == "Windows":
		var file = FileAccess.open("res://assets/data/dictionary.txt", FileAccess.READ)
		var dictionary: String = file.get_as_text()
		var definition: String = ""
		
		var is_start: bool = true
		for ch in dictionary:
			if ch == "&":
				definitions.push_back(definition)
				definition = ""
				is_start = true
			else:
				if is_start:
					match ch:
						"\n", "\r", "\r\n":
							continue
						_:
							is_start = false
				definition += ch
		file.close()
		
		while animation_player.is_playing() == true:
			await get_tree().create_timer(1).timeout
		animation_player.play("idle")

func _on_lua_toggled(toggled_on):
	if toggled_on:
		warning_animation_player.play_backwards("show")
		message_animation_player.play("show")
		if mode == Modes.DICTIONARY or mode == Modes.HELP:
			edit_animation_player.play("show")
		if mode == Modes.NONE:
			print_message("Привет, я Луа, виртуальный помощник твоей лаборатории!")
	else:
		message_animation_player.play_backwards("show")
		warning_animation_player.play("show")
		if mode == Modes.DICTIONARY or mode == Modes.HELP:
			edit_animation_player.play_backwards("show")


func _on_book_button_pressed():
	print_message("Задай мне вопрос о физических определениях! " +
			"Например, 'масса', 'скорость', 'сила'.")
	book_button.set_visible(false)
	help_button.set_visible(false)
	return_button.set_visible(true)
	mode = Modes.DICTIONARY
	edit_animation_player.play("show")

func _on_return_button_pressed():
	print_message("Привет, я Луа, виртуальный помощник твоей лаборатории!")
	book_button.set_visible(true)
	help_button.set_visible(true)
	return_button.set_visible(false)
	mode = Modes.NONE
	edit_animation_player.play_backwards("show")

func _on_line_edit_text_submitted(new_text):
	if mode == Modes.DICTIONARY:
		open_dictionary(new_text)

func print_message(text: String):
	if is_printing:
		is_printing = false
		await stopped_printing
	is_printing = true
	label.text = ""
	for l in text:
		label.text += l
		await get_tree().create_timer(0.01).timeout
		if not is_printing:
			emit_signal("stopped_printing")
			return
	is_printing = false

func open_dictionary(new_text):
	var file = FileAccess.open("res://assets/data/dictionary.txt", FileAccess.READ)
	var dictionary: String = file.get_as_text()
	for def in definitions:
		var name: String = ""
		for ch in def:
			if ch == "(" or ch == ")":
				if name.to_lower() == new_text.to_lower():
					print_message(def)
					file.close()
					return
				else:
					name = ""
			elif ch == "-":
				if name.erase(name.length() - 1).to_lower() == new_text.to_lower():
					print_message(def)
					file.close()
					return
				else:
					name = ""
			else:
				name += ch
	file.close()
	
	
