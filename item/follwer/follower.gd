extends "res://item/item_base.gd"
class_name Follower

# 随从关键词枚举
enum Keyword {
	TAUNT,          # 嘲讽 - 敌方必须先攻击具有嘲讽的随从
	CHARGE,         # 冲锋 - 可以在召唤的回合立即攻击
	DIVINE_SHIELD,  # 圣盾 - 免疫第一次受到的伤害
	LIFESTEAL,      # 吸血 - 造成的伤害会治疗你的英雄
}

# 随从特有属性
@export var health: int = 1                     # 血量
@export var attack: int = 1                     # 攻击力
@export var cost: int = 1                       # 费用
@export var keywords: Array[Keyword] = []       # 关键词数组

# 初始化函数
func _init(p_name: String = "", p_description: String = "", p_price: int = 0, 
		   p_rarity: Rarity = Rarity.COMMON, p_icon: Texture2D = null,
		   p_health: int = 1, p_attack: int = 1, p_cost: int = 1, 
		   p_keywords: Array[Keyword] = []):
	
	super._init(ItemType.FOLLOWER, p_name, p_description, p_price, p_rarity, p_icon)
	health = p_health
	attack = p_attack
	cost = p_cost
	keywords = p_keywords.duplicate()

# 获取随从详细信息
func get_follower_info() -> String:
	var base_info = get_item_info()
	var keyword_names = get_keyword_names()
	
	return "%s\n血量: %d\n攻击力: %d\n费用: %d\n关键词: %s" % [base_info, health, attack, cost, keyword_names]

# 获取关键词名称
func get_keyword_names() -> String:
	if keywords.is_empty():
		return "无"
	
	var keyword_strings: Array[String] = []
	for keyword in keywords:
		match keyword:
			Keyword.TAUNT:
				keyword_strings.append("嘲讽")
			Keyword.CHARGE:
				keyword_strings.append("冲锋")
			Keyword.DIVINE_SHIELD:
				keyword_strings.append("圣盾")
			Keyword.LIFESTEAL:
				keyword_strings.append("吸血")
			_:
				keyword_strings.append("未知")
	
	return ", ".join(keyword_strings)

# 检查是否具有特定关键词
func has_keyword(keyword: Keyword) -> bool:
	return keywords.has(keyword)

# 添加关键词
func add_keyword(keyword: Keyword) -> void:
	if not keywords.has(keyword):
		keywords.append(keyword)

# 移除关键词
func remove_keyword(keyword: Keyword) -> void:
	keywords.erase(keyword)


# 检查随从是否存活
func is_alive() -> bool:
	return health > 0

# 受到伤害
func take_damage(damage: int) -> void:
	health -= damage
	if health < 0:
		health = 0

# 治疗随从
func heal(heal_amount: int) -> void:
	health += heal_amount

# 增加攻击力
func increase_attack(amount: int) -> void:
	attack += amount

# 增加血量
func increase_health(amount: int) -> void:
	health += amount

# 获取随从的完整状态信息
func get_status_info() -> String:
	var status = "存活" if is_alive() else "死亡"
	return "%s - 攻击力: %d, 血量: %d/%d, 关键词: %s" % [name, attack, health, get_original_health(), get_keyword_names()]

# 获取原始血量（需要子类重写）
func get_original_health() -> int:
	return health  # 基础实现，子类可以重写以跟踪原始血量

# 复制随从
func duplicate_follower() -> Follower:
	var new_follower = Follower.new(
		name, description, price, rarity, icon,
		health, attack, cost, keywords
	)
	return new_follower