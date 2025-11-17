extends Card

var base_damage := 1


func _ready():
	tooltip_text = "[center]对自己造成 %d 伤害[/center]" 


func get_default_tooltip() -> String:
	return tooltip_text % base_damage

func get_updated_tooltip(_player_modifiers: ModifierHandler, _enemy_modifiers: ModifierHandler) -> String:
	return tooltip_text % base_damage
	
func apply_effects(targets: Array[Node], _modifiers: ModifierHandler) -> void:
	var damage_effect := DamageEffect.new()
	damage_effect.amount = base_damage
	damage_effect.sound = sound
	damage_effect.execute(targets)
