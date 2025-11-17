class_name Card
extends Resource

enum Type {ATTACK, SKILL, POWER}
enum Rarity {BASE, COMMON, UNCOMMON, RARE}
enum Colour {RED, GREEN, BLUE, PURPLE, COLORLESS, CURSES}
enum Target {SELF, SINGLE_ENEMY, ALL_ENEMIES, EVERYONE}

const RARITY_COLORS := {
	Card.Rarity.BASE: Color.WHITE,
	Card.Rarity.COMMON: Color.GREEN,
	Card.Rarity.UNCOMMON: Color.BLUE,
	Card.Rarity.RARE: Color.GOLD,
}

const COLOUR_COLORS := {
	Card.Colour.RED: Color.RED,
	Card.Colour.GREEN: Color.GREEN,
	Card.Colour.BLUE: Color.BLUE,
	Card.Colour.PURPLE: Color.PURPLE,
	Card.Colour.COLORLESS: Color.WHITE,
	Card.Colour.CURSES: Color.BLACK,
}


@export_group("Card Attributes")
@export var id: String
@export var type: Type
@export var target: Target
@export var cost: int
@export var rarity: Rarity
@export var colour: Colour
@export var power: int
@export var exhausts: bool = false

@export_group("Card Visuals")
@export var icon: Texture
@export_multiline var tooltip_text: String
@export var sound: AudioStream


func is_single_targeted() -> bool:
	return target == Target.SINGLE_ENEMY


func _get_targets(targets: Array[Node]) -> Array[Node]:
	if not targets:
		return []		
	var tree := targets[0].get_tree()	
	match target:
		Target.SELF:
			return tree.get_nodes_in_group("player")
		Target.ALL_ENEMIES:
			return tree.get_nodes_in_group("enemies")
		Target.EVERYONE:
			return tree.get_nodes_in_group("player") + tree.get_nodes_in_group("enemies")
		_:
			return []


func play(targets: Array[Node], char_stats: CharacterStats, modifiers: ModifierHandler) -> void:
	Events.card_played.emit(self)
	char_stats.mana -= cost
	if is_single_targeted():
		apply_effects(targets, modifiers)
	else:
		apply_effects(_get_targets(targets), modifiers)


func apply_effects(_targets: Array[Node], _modifiers: ModifierHandler) -> void:
	pass
	

func get_default_tooltip() -> String:
	return tooltip_text


func get_updated_tooltip(_player_modifiers: ModifierHandler, _enemy_modifiers: ModifierHandler) -> String:
	return tooltip_text
	