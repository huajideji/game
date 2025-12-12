extends Node2D
@export var selected_role:int = 0 
@onready var first_role = $first
@onready var second_role = $second
@onready var third_role = $third

func _ready() -> void:
	var start = $start 
	var back = $back
	
	# 连接pressed信号
	start.connect("pressed", Callable(self, "_on_start_pressed"))
	# 为角色选项卡添加点击事件
	first_role.connect("gui_input", Callable(self, "_on_role_clicked").bind(1))
	second_role.connect("gui_input", Callable(self, "_on_role_clicked").bind(2))
	third_role.connect("gui_input", Callable(self, "_on_role_clicked").bind(3))
	# 初始化视觉反馈
	_update_selected_visual()

func _on_role_clicked(event, role_id):
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		selected_role = role_id
		_update_selected_visual()

func _update_selected_visual():
	# 重置所有角色选项卡的样式
	first_role.modulate = Color.WHITE
	second_role.modulate = Color.WHITE
	third_role.modulate = Color.WHITE
	
	# 高亮当前选中的角色选项卡
	match selected_role:
		1:
			first_role.modulate = Color(0.8, 0.8, 1.0)
		2:
			second_role.modulate = Color(0.8, 0.8, 1.0)
		3:
			third_role.modulate = Color(0.8, 0.8, 1.0)

func _on_start_pressed():
	if selected_role == 0:
		return
	else:
		var file_path = "res://scene/roleSelect/role_data/jsonData"+str(selected_role) 
		var file = FileAccess.open(file_path, FileAccess.READ)
		if file == null:
			print("没有找到角色文件")
			return {}
		
		var json_text = file.get_as_text()
		
		file.close()
		
		var json = JSON.new()
		var parse_result = json.parse(json_text)
		if parse_result != OK:
			print("JSON解析错误: ", json.get_error_message())
			return {}
		print(json.data)
		json.data.get('initial_followers')
		json.data.get('initial_spells')
		# 将角色初始数据合并到全局物品列表
		for follower in json.data.get('initial_followers', []):
			Global.init_bag.push_back(follower)
		for spell in json.data.get('initial_spells', []):
			Global.init_bag.push_back(spell)
		
		get_tree().change_scene_to_file("res://scene/bag/bag.tscn")
		return
	
