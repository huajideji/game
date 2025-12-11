extends Node2D
# 在父节点的脚本中
func _ready():
	 # 获取视口的可见区域大小
	var viewport_size = get_viewport().get_visible_rect().size
	
	# 计算Label的居中位置
	var label_size = $Label.get_size()
	$Label.position.x = (viewport_size.x - label_size.x) / 2
	$Label.position.y = (viewport_size.y - label_size.y - 200) / 2
	
	#计算按钮的位置
	var start_size = $start.get_size()
	$start.position.x = (viewport_size.x - start_size.x) / 2
	$start.position.y = (viewport_size.y - start_size.y - 100) / 2

	var end_size = $end.get_size()
	$end.position.x = (viewport_size.x - end_size.x) / 2
	$end.position.y = (viewport_size.y - end_size.y ) / 2
	# 获取按钮节点引用
	var button = $start  # 假设按钮是直接子节点
	
	# 连接pressed信号
	button.connect("pressed", Callable(self, "_on_button_pressed"))
func _on_button_pressed():
	# 转换场景
	get_tree().change_scene_to_file("res://scene/roleSelect/role_select.tscn")
