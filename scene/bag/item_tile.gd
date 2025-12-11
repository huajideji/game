extends MarginContainer


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _get_drag_data(at_position: Vector2) -> Variant:
	var icon = $icon
	
	print("点击位置: ", at_position)
	
	# 获取当前插槽和其数据
	var current_slot_data = get_current_slot_data()
	if current_slot_data:
		print("当前插槽数据: ", current_slot_data)
	else:
		print("没有数据")
	if(icon.texture != null):
		var texture = TextureRect.new()
		texture.texture = icon.texture
		print(texture.size)
		texture.expand_mode = TextureRect.EXPAND_FIT_WIDTH
		texture.size = Vector2(64,64)
		texture.custom_minimum_size = Vector2(64,64)
		set_drag_preview(texture)
	
	# 返回当前插槽的数据，这样可以在拖拽操作中使用
	return current_slot_data

# 获取当前插槽的数据
func get_current_slot_data() -> Array:
	# 获取当前item_tile的父节点（应该是item_slot）
	var item_slot = get_parent()
	
	# 检查父节点是否是Item_slot类型
	if item_slot and item_slot is Item_slot:
		# 获取item_slot的父节点（应该是item_wrap）
		var item_wrap = item_slot.get_parent()
		
		# 获取item_slot在item_wrap中的索引
		var slot_index = item_wrap.get_child_count() - 1
		for i in range(item_wrap.get_child_count()):
			if item_wrap.get_child(i) == item_slot:
				slot_index = i
				break
		
		print("插槽索引: ", slot_index)
		
		# 获取背包节点
		var bag = get_bag_node()
		if bag:
			# 从背包获取该插槽的数据
			var slot_data = bag.get_item_at(slot_index)
			if not slot_data.is_empty():
				return [slot_data,slot_index]
		else:
			print("未找到背包节点")
	
	return []

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
