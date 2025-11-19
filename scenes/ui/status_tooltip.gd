class_name StatusTooltip
extends HBoxContainer

@export var status: Status : set = set_status

@onready var icon: TextureRect = $Icon
@onready var label: Label = $Label


func set_status(new_status: Status) -> void:
	if not is_node_ready():
		await ready
	
	# Disconnect previous status if any
	if status and status.status_changed.is_connected(_on_status_changed):
		status.status_changed.disconnect(_on_status_changed)
	
	status = new_status
	icon.texture = status.icon
	
	# Connect to status_changed to update tooltip when stacks/duration change
	if not status.status_changed.is_connected(_on_status_changed):
		status.status_changed.connect(_on_status_changed)
	
	_update_tooltip()


func _on_status_changed() -> void:
	_update_tooltip()


func _update_tooltip() -> void:
	if status:
		label.text = status.get_tooltip()