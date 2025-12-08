extends MarginContainer
@export var items = []
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	for i in range(40):
		items.append({})
	var item_wrap =$MarginContainer/VBoxContainer/MarginContainer2/NinePatchRect/MarginContainer2/ScrollContainer/MarginContainer/item_wrap
	# 实例化 item_slot 场景
	var item_slot_scene = preload("res://scene/item_slot.tscn")
	for i in items:
		var slot = item_slot_scene.instantiate()
		item_wrap.add_child(slot)
	add_item_by_id("follower_006","FOLLOWER")

# 加载随从数据
func load_followers_data() -> Dictionary:
	var file_path = "res://item/followers_data.json"
	
	if not FileAccess.file_exists(file_path):
		print("随从数据文件不存在")
		return {}
	
	var file = FileAccess.open(file_path, FileAccess.READ)
	if file == null:
		print("无法打开随从数据文件")
		return {}
	
	var json_text = file.get_as_text()
	file.close()
	
	var json = JSON.new()
	var parse_result = json.parse(json_text)
	
	if parse_result != OK:
		print("JSON解析错误: ", json.get_error_message())
		return {}
	
	return json.data

# 根据ID获取特定随从
func get_follower_by_id(follower_id: String) -> Dictionary:
	var data = load_followers_data()
	var followers = data.get("followers", [])
	
	for follower in followers:
		if follower.get("id") == follower_id:
			return follower
	
	return {}

func add_item(name: String, type: String) -> void:
	# 查找第一个空槽位
	var empty_slot_index = -1
	for i in range(items.size()):
		if items[i].is_empty():
			empty_slot_index = i
			break
	
	# 如果没有空槽位，返回错误
	if empty_slot_index == -1:
		print("背包已满，无法添加物品")
		return
	
	# 根据类型创建物品数据
	var item_data = {}
	match type:
		"FOLLOWER":
			item_data = get_follower_data_by_name(name)
		_:
			item_data = {"name": name, "type": type}
	
	# 如果物品数据为空，返回错误
	if item_data.is_empty():
		print("物品数据获取失败: ", name)
		return
	
	# 添加到背包
	items[empty_slot_index] = item_data
	
	# 更新UI显示
	update_slot_display(empty_slot_index)
	
	print("成功添加物品: ", name, " 到槽位 ", empty_slot_index)

# 根据名称获取随从数据
func get_follower_data_by_name(follower_name: String) -> Dictionary:
	var data = load_followers_data()
	var followers = data.get("followers", [])
	
	for follower in followers:
		if follower.get("name") == follower_name:
			return follower
	
	return {}

# 更新指定槽位的显示
func update_slot_display(slot_index: int) -> void:
	var item_wrap = $MarginContainer/VBoxContainer/MarginContainer2/NinePatchRect/MarginContainer2/ScrollContainer/MarginContainer/item_wrap
	var slot = item_wrap.get_child(slot_index)
	
	# 获取物品数据
	var item_data = items[slot_index]
	
	
	# 设置物品图标（如果有）
	var icon_path = item_data.get("icon_path", "")
	if icon_path != "" and ResourceLoader.exists(icon_path):
		var texture = load(icon_path)
		var node = slot.get_node("item_tile/icon")
		node.texture = texture
	
	# 设置物品名称（可选）
	var item_name = item_data.get("name", "")
	if item_name != "":
		# 可以在这里添加名称显示逻辑
		pass

# 检查背包是否已满
func is_bag_full() -> bool:
	for item in items:
		if item.is_empty():
			return false
	return true

# 获取空槽位数量
func get_empty_slot_count() -> int:
	var count = 0
	for item in items:
		if item.is_empty():
			count += 1
	return count

# 根据ID添加物品（更方便的方法）
func add_item_by_id(item_id: String, type: String) -> void:
	match type:
		"FOLLOWER":
			var follower_data = get_follower_by_id(item_id)
			if not follower_data.is_empty():
				add_item(follower_data.get("name", ""), type)
			else:
				print("未找到ID为 ", item_id, " 的随从")
		_:
			add_item(item_id, type)

# 移除指定槽位的物品
func remove_item(slot_index: int) -> void:
	if slot_index < 0 or slot_index >= items.size():
		print("无效的槽位索引: ", slot_index)
		return
	
	items[slot_index] = {}
	update_slot_display(slot_index)
	print("已移除槽位 ", slot_index, " 的物品")

# 获取指定槽位的物品数据
func get_item_at(slot_index: int) -> Dictionary:
	if slot_index < 0 or slot_index >= items.size():
		print("无效的槽位索引: ", slot_index)
		return {}
	
	return items[slot_index]
