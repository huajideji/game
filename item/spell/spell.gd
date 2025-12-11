extends "res://item/item_base.gd"
class_name Spell

# 法术类型枚举
enum SpellType {
	DAMAGE,    # 伤害
	SUMMON,    # 召唤
	BUFF       # 增益
}

# 施法目标枚举
enum TargetType {
	ENEMY,     # 敌人
	FRIENDLY,  # 友军
	AREA       # 范围
}

# 释放方式枚举
enum CastMethod {
	COST,      # 费用释放
	LOOP       # 循环释放
}

# 法术特有属性
@export var spell_type: SpellType = SpellType.DAMAGE         # 法术类型
@export var target_type: TargetType = TargetType.ENEMY       # 施法目标
@export var cast_method: CastMethod = CastMethod.COST        # 释放方式
@export var cost: int = 1                                    # 法术费用
@export var effect_value: int = 1                            # 效果值
@export var effect_attribute: String = ""                    # 效果属性
@export var summon_id: String = ""                          # 召唤随从ID
@export var additional_effect: String = ""                   # 附加效果
@export var loop_count: int = 1                              # 循环次数
@export var loop_interval: int = 1                           # 循环间隔（回合数）

# 初始化函数
func _init(p_name: String = "", p_description: String = "", p_price: int = 0, 
	   p_rarity: Rarity = Rarity.COMMON, p_icon: Texture2D = null,
	   p_spell_type: SpellType = SpellType.DAMAGE, p_target_type: TargetType = TargetType.ENEMY,
	   p_cast_method: CastMethod = CastMethod.COST, p_cost: int = 1,
	   p_effect_value: int = 1, p_effect_attribute: String = "", p_summon_id: String = "",
	   p_additional_effect: String = "", p_loop_count: int = 1, p_loop_interval: int = 1):
	
	super._init(ItemType.SPELL, p_name, p_description, p_price, p_rarity, p_icon)
	spell_type = p_spell_type
	target_type = p_target_type
	cast_method = p_cast_method
	cost = p_cost
	effect_value = p_effect_value
	effect_attribute = p_effect_attribute
	summon_id = p_summon_id
	additional_effect = p_additional_effect
	loop_count = p_loop_count
	loop_interval = p_loop_interval

# 获取法术详细信息
func get_spell_info() -> String:
	var base_info = get_item_info()
	var spell_type_name = get_spell_type_name()
	var target_type_name = get_target_type_name()
	var cast_method_name = get_cast_method_name()
	
	var spell_details = "\n法术类型: %s\n施法目标: %s\n释放方式: %s\n费用: %d" % [spell_type_name, target_type_name, cast_method_name, cost]
	
	if effect_value > 0:
		spell_details += "\n效果值: %d" % effect_value
		
	if effect_attribute != "":
		spell_details += "\n效果属性: %s" % effect_attribute
		
	if summon_id != "":
		spell_details += "\n召唤随从: %s" % summon_id
		
	if additional_effect != "":
		spell_details += "\n附加效果: %s" % additional_effect
		
	if cast_method == CastMethod.LOOP:
		spell_details += "\n循环次数: %d\n循环间隔: %d回合" % [loop_count, loop_interval]
	
	return "%s%s" % [base_info, spell_details]

# 获取法术类型名称
func get_spell_type_name() -> String:
	match spell_type:
		SpellType.DAMAGE:
			return "伤害"
		SpellType.SUMMON:
			return "召唤"
		SpellType.BUFF:
			return "增益"
		_:
			return "未知"

# 获取施法目标名称
func get_target_type_name() -> String:
	match target_type:
		TargetType.ENEMY:
			return "敌人"
		TargetType.FRIENDLY:
			return "友军"
		TargetType.AREA:
			return "范围"
		_:
			return "未知"

# 获取释放方式名称
func get_cast_method_name() -> String:
	match cast_method:
		CastMethod.COST:
			return "费用释放"
		CastMethod.LOOP:
			return "循环释放"
		_:
			return "未知"

# 检查法术是否可以释放
func can_cast(current_mana: int) -> bool:
	if cast_method == CastMethod.COST:
		return current_mana >= cost
	return true  # 循环释放法术不需要消耗当前法力

# 释放法术
func cast(target: Node = null) -> void:
	# 基础释放逻辑，子类可以重写
	match spell_type:
		SpellType.DAMAGE:
			_on_cast_damage(target)
		SpellType.SUMMON:
			_on_cast_summon(target)
		SpellType.BUFF:
			_on_cast_buff(target)

# 伤害法术释放逻辑
func _on_cast_damage(target: Node = null) -> void:
	# 实现伤害法术逻辑
	pass

# 召唤法术释放逻辑
func _on_cast_summon(target: Node = null) -> void:
	# 实现召唤法术逻辑
	pass

# 增益法术释放逻辑
func _on_cast_buff(target: Node = null) -> void:
	# 实现增益法术逻辑
	pass

# 获取法术的完整状态信息
func get_status_info() -> String:
	return "%s - 类型: %s, 目标: %s, 费用: %d" % [name, get_spell_type_name(), get_target_type_name(), cost]

# 复制法术
func duplicate_spell() -> Spell:
	var new_spell = Spell.new(
		name, description, price, rarity, icon,
		spell_type, target_type, cast_method, cost,
		effect_value, effect_attribute, summon_id,
		additional_effect, loop_count, loop_interval
	)
	return new_spell
