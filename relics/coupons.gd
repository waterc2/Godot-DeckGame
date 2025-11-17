class_name CouponsRelic
extends Relic

@export_range(1, 100) var discount := -0.25


func initialize_relic(owner: RelicUI) -> void:
	Events.shop_entered.connect(add_shop_modifier.bind(owner))

func deactivate_relic(_owner: RelicUI) -> void:
	Events.shop_entered.disconnect(add_shop_modifier)


func add_shop_modifier(shop: Shop, owner: RelicUI = null) -> void:
	if owner:
		owner.flash()
		
	var shop_cost_modifier := shop.modifier_handler.get_modifier(Modifier.Type.SHOP_COST)
	assert(shop_cost_modifier, "No shop cost modifier in shop!")

	var coupons_modifier_value := shop_cost_modifier.get_value("coupons")

	if not coupons_modifier_value:
		coupons_modifier_value = ModifierValue.create_new_modifier("coupons", ModifierValue.Type.PERCENT)
		coupons_modifier_value.percent_value = discount
		shop_cost_modifier.add_new_value(coupons_modifier_value)

