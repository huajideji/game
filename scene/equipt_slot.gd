extends MarginContainer
class_name Equipt_slot
signal item_dropped(slot_index, item_data)
# 检查是否可以接受拖拽数据
func _ready() -> void:
	# 启用拖拽接收
	mouse_default_cursor_shape = Control.CURSOR_CAN_DROP
	
	# 连接信号
	if has_method("_on_item_dropped"):
		item_dropped.connect(_drop_data)

# 检查是否可以接受拖拽数据
func _can_drop_data(at_position: Vector2, data: Variant) -> bool:
	# 检查数据是否为字典（物品数据）
	if data:
		print("可以接受拖拽数据: ", data)
		return true
	return false

# 处理拖拽数据
func _drop_data(at_position: Vector2, data: Variant) -> void:
	print('装备')
