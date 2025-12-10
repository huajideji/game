extends MarginContainer
class_name Item_slot

# 拖拽相关信号
signal item_dropped(slot_index, item_data)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# 启用拖拽接收
	mouse_default_cursor_shape = Control.CURSOR_CAN_DROP
	
	# 连接信号
	if has_method("_on_item_dropped"):
		item_dropped.connect(_on_item_dropped)

# 检查是否可以接受拖拽数据
func _can_drop_data(at_position: Vector2, data: Variant) -> bool:
	# 检查数据是否为字典（物品数据）
	if data:
		print("可以接受拖拽数据: ", data)
		return true
	return false

# 处理拖拽数据
func _drop_data(at_position: Vector2, data: Variant) -> void:
	# 检查拖拽数据格式
	if data[0] is Dictionary:
		var source_slot_index = data[1]
		
		print("接收到拖拽数据 - 源插槽: ", source_slot_index, " 物品数据: ", data[0])
		
		# 获取当前插槽的索引
		var target_slot_index = get_slot_index()
		
		# 如果拖拽到同一个插槽，不处理
		if source_slot_index == target_slot_index:
			print("拖拽到同一个插槽，忽略")
			return
		
		# 获取背包节点并更新items数组
		var bag = get_bag_node()
		if bag and bag.has_method("transfer_item"):
			# 调用背包的transfer_item方法更新items数组
			bag.transfer_item(source_slot_index, target_slot_index)
		else:
			print("未找到背包节点或transfer_item方法")
		# 发出信号，通知有物品被拖拽到当前插槽（包含源插槽信息）
		item_dropped.emit(source_slot_index, target_slot_index, data[0])
	else:
		print("无效的拖拽数据格式: ", data[0])

# 获取当前插槽的索引
func get_slot_index() -> int:
	var parent = get_parent()
	if parent:
		for i in range(parent.get_child_count()):
			if parent.get_child(i) == self:
				return i
	return -1

# 更新插槽显示
func update_slot_display(item_data: Dictionary) -> void:
	# 清空当前显示
	clear_slot_display()
	
	# 如果有物品数据，显示物品
	if not item_data.is_empty():
		# 设置物品图标
		var icon_path = item_data.get("icon_path", "")
		if icon_path != "" and ResourceLoader.exists(icon_path):
			var texture = load(icon_path)
			var item_tile = get_node_or_null("item_tile")
			if item_tile:
				var icon = item_tile.get_node_or_null("icon")
				if icon:
					icon.texture = texture
		
		# 可以在这里添加其他显示逻辑，如物品名称等

# 清空插槽显示
func clear_slot_display() -> void:
	var item_tile = get_node_or_null("item_tile")
	if item_tile:
		var icon = item_tile.get_node_or_null("icon")
		if icon:
			icon.texture = null

# 获取背包节点
func get_bag_node() -> Node:
	# 向上遍历节点树找到背包节点
	var current_node = self
	while current_node:
		if current_node.has_method("get_item_at"):
			return current_node
		current_node = current_node.get_parent()
	
	# 如果没找到，尝试通过场景树查找
	var scene_tree = get_tree()
	if scene_tree:
		var root = scene_tree.get_root()
		# 查找包含背包功能的节点
		for child in root.get_children():
			if child.has_method("get_item_at"):
				return child
	
	return null

# 子类可以重写这个方法来自定义拖拽处理
func _on_item_dropped(slot_index: int, item_data: Dictionary) -> void:
	print("物品被拖拽到插槽 ", slot_index, ": ", item_data)
	# 子类可以在这里添加特定的处理逻辑
