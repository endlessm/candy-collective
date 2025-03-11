extends Control

signal world_selected(world: String)
signal back

const WORLDS_DIR := "res://Worlds/"
const SAMPLE_WORLD := "World One"

@onready var Scroll: ScrollContainer = %Scroll
@onready var ExtraWorldsBox: VBoxContainer = %ExtraWorldsBox
@onready var BackButton: Button = %BackButton


func _find_worlds(path) -> Array[String]:
	var worlds_dir = DirAccess.open(path)
	var worlds: Array[String]
	if worlds_dir:
		worlds_dir.list_dir_begin()
		var child := worlds_dir.get_next()
		while child:
			if worlds_dir.current_is_dir():
				worlds.append(child)
			child = worlds_dir.get_next()

	worlds.sort_custom(func (a: String, b: String): return a.naturalnocasecmp_to(b) < 0)

	# Move the sample world to the end
	var ix := worlds.find(SAMPLE_WORLD)
	if ix >= 0:
		worlds.remove_at(ix)
		worlds.push_back(SAMPLE_WORLD)

	return worlds


func _ready() -> void:
	var worlds := _find_worlds(WORLDS_DIR)
	var first_button: Button
	var button: Button

	for world in worlds:
		button = Button.new()
		button.text = world
		button.pressed.connect(_on_world_button_pressed.bind(WORLDS_DIR.path_join(world).path_join("World.tscn")))
		ExtraWorldsBox.add_child(button)
		
		if not first_button:
			first_button = button

		# Tab or Ctrl+Tab from a button jumps to the Back button
		button.focus_next = BackButton.get_path()
		button.focus_previous = BackButton.get_path()

	# Ensure that, when the back button is focused, pressing "up" goes to the
	# last world in the list, rather than the last world visible in the current
	# scroll viewport
	BackButton.focus_neighbor_top = button.get_path()
	button.focus_neighbor_bottom = BackButton.get_path()
	
	# Make the list wrap around so that pressing "up" from the first world
	# focuses the Back button below the list, and pressing "down" on the Back
	# button focuses the first world.
	first_button.focus_neighbor_top = BackButton.get_path()
	BackButton.focus_neighbor_bottom = first_button.get_path()

func _on_world_button_pressed(world: String) -> void:
	world_selected.emit(world)


func _on_back_button_pressed() -> void:
	back.emit()


func _input(event: InputEvent) -> void:
	if self.visible and event.is_action_pressed("ui_cancel"):
		back.emit()


func _on_visibility_changed() -> void:
	if self.visible and BackButton:
		BackButton.grab_focus()
		Scroll.scroll_vertical = 0
