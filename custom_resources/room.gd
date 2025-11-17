class_name Room
extends Resource

enum Type {NOT_ASSIGNED, MONSTER, TREASURE, CAMPFIRE, SHOP, BOSS, EVENT, ELITE}

@export var type: Type
@export var row: int
@export var column: int
@export var position: Vector2
@export var next_rooms: Array[Room]
@export var selected := false
# Only for battle rooms
@export var battle_stats: BattleStats
@export var value: int


func _to_string() -> String:
	return "%s,%s (%s)" % [row, column, Type.keys()[type][0]]