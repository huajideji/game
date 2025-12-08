extends Resource
class_name ItemBase

# 道具类型枚举
enum ItemType {
	FOLLOWER,  # 随从
	SPELL,     # 法术
	RELIC,     # 遗物
	FIELD      # 场地
}

# 稀有度枚举
enum Rarity {
	COMMON,    # 普通
	UNCOMMON,  # 稀有
	RARE,      # 史诗
	LEGENDARY  # 传说
}

# 公共属性
@export var item_type: ItemType
@export var name: String = ""
@export var description: String = ""
@export var price: int = 0
@export var rarity: Rarity = Rarity.COMMON
@export var icon: Texture2D

# 初始化函数
func _init(p_item_type: ItemType = ItemType.FOLLOWER, p_name: String = "", p_description: String = "", 
		   p_price: int = 0, p_rarity: Rarity = Rarity.COMMON, p_icon: Texture2D = null):
	item_type = p_item_type
	name = p_name
	description = p_description
	price = p_price
	rarity = p_rarity
	icon = p_icon

# 获取道具信息
func get_item_info() -> String:
	var rarity_names = ["普通", "稀有", "史诗", "传说"]
	var type_names = ["随从", "法术", "遗物", "场地"]
	
	return "名称: %s\n类型: %s\n稀有度: %s\n价格: %d\n描述: %s" % [name, type_names[item_type], rarity_names[rarity], price, description]

# 获取稀有度颜色
func get_rarity_color() -> Color:
	match rarity:
		Rarity.COMMON:
			return Color.WHITE
		Rarity.UNCOMMON:
			return Color.GREEN
		Rarity.RARE:
			return Color.BLUE
		Rarity.LEGENDARY:
			return Color.PURPLE
		_:
			return Color.WHITE