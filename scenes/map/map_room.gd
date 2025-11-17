class_name MapRoom
extends Area2D

signal clicked(room: Room)
signal selected(room: Room)

const ICONS := {
	Room.Type.NOT_ASSIGNED: [null, Vector2(0.5,0.5)],
	Room.Type.MONSTER: [preload("res://art/icons/enemy.png"), Vector2(0.2, 0.2)],
	Room.Type.TREASURE: [preload("res://art/icons/treasure.png"), Vector2(0.25, 0.25)],
	Room.Type.CAMPFIRE: [preload("res://art/icons/tent.png"), Vector2(0.25, 0.25)],
	Room.Type.SHOP: [preload("res://art/icons/shop.png"), Vector2(0.25, 0.25)],
	Room.Type.BOSS: [preload("res://art/icons/boss.png"), Vector2(0.4, 0.4)],
	Room.Type.ELITE: [preload("res://art/icons/elite.png"), Vector2(0.3, 0.3)],
	Room.Type.EVENT: [preload("res://art/icons/event.png"), Vector2(0.2, 0.2)],
}

@onready var sprite_2d: Sprite2D = $Visuals/Sprite2D
@onready var line_2d: Line2D = $Visuals/Line2D
@onready var animation_player: AnimationPlayer = $AnimationPlayer

var available := false : set = set_available
var room: Room : set = set_room


func set_available(new_value: bool) -> void:
	available = new_value	
	if available:
		animation_player.play("highlight")
	elif not room.selected:
		animation_player.play("RESET")


func set_room(new_data: Room) -> void:
	room = new_data
	position = room.position
	line_2d.rotation_degrees = randi_range(0, 360)
	sprite_2d.texture = ICONS[room.type][0]
	sprite_2d.scale = ICONS[room.type][1]


func show_selected() -> void:
	line_2d.modulate = Color.WHITE

func _on_input_event(_viewport:Node, event:InputEvent, _shape_idx:int) -> void:
	if not available or not event.is_action_pressed("left_mouse"):
		return
	room.selected = true
	clicked.emit(room)
	animation_player.play("select")

# Called by the AnimationPLayer when the 
# "select" animation finishes.
func _on_map_room_selected() -> void:
	selected.emit(room)
