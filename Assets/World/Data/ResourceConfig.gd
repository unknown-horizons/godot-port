@tool

extends Object
## The resource config is used to store all the item data, maping, and other item information

class_name ResourceConfig

const item_data_folder_path: String = "res://Assets/World/Data/ItemData/"

static var resource_to_icon: Dictionary[StringName, Texture2D] = {
	Resources.GOLD						 : preload("res://Assets/UI/Icons/Resources/32/001.png"),
	Resources.LAMB_WOOL				: preload("res://Assets/UI/Icons/Resources/32/002.png"),
	Resources.TEXTILE					: preload("res://Assets/UI/Icons/Resources/32/003.png"),
	Resources.BOARDS					 : preload("res://Assets/UI/Icons/Resources/32/004.png"),
	Resources.FOOD						 : preload("res://Assets/UI/Icons/Resources/32/005.png"),
	Resources.TOOLS						: preload("res://Assets/UI/Icons/Resources/32/006.png"),
	Resources.BRICKS					 : preload("res://Assets/UI/Icons/Resources/32/007.png"),
	Resources.TREES						: preload("res://Assets/UI/Icons/Resources/32/008.png"),
	Resources.GRASS						: preload("res://Assets/UI/Icons/Resources/32/009.png"),
	Resources.WOOL						 : preload("res://Assets/UI/Icons/Resources/32/010.png"),
	Resources.FAITH						: preload("res://Assets/UI/Icons/Resources/32/011.png"),
	Resources.WILDANIMALFOOD	 : preload("res://Assets/UI/Icons/Resources/32/012.png"),
	Resources.DEER_MEAT				: preload("res://Assets/UI/Icons/Resources/32/013.png"),
	Resources.HAPPINESS				: preload("res://Assets/UI/Icons/Resources/32/014.png"),
	Resources.POTATOES				 : preload("res://Assets/UI/Icons/Resources/32/015.png"),
	Resources.EDUCATION				: preload("res://Assets/UI/Icons/Resources/32/016.png"),
	Resources.RAW_SUGAR				: preload("res://Assets/UI/Icons/Resources/32/017.png"),
	Resources.SUGAR						: preload("res://Assets/UI/Icons/Resources/32/018.png"),
	Resources.COMMUNITY				: preload("res://Assets/UI/Icons/Resources/32/019.png"),
	Resources.RAW_CLAY				 : preload("res://Assets/UI/Icons/Resources/32/020.png"),
	Resources.CLAY						 : preload("res://Assets/UI/Icons/Resources/32/021.png"),
	Resources.LIQUOR					 : preload("res://Assets/UI/Icons/Resources/32/022.png"),
	Resources.CHARCOAL				 : preload("res://Assets/UI/Icons/Resources/32/023.png"),
	Resources.RAW_IRON				 : preload("res://Assets/UI/Icons/Resources/32/024.png"),
	Resources.IRON_ORE				 : preload("res://Assets/UI/Icons/Resources/32/025.png"),
	Resources.IRON_INGOTS			: preload("res://Assets/UI/Icons/Resources/32/026.png"),
	Resources.GET_TOGETHER		 : preload("res://Assets/UI/Icons/Resources/32/027.png"),
	Resources.FISH						 : preload("res://Assets/UI/Icons/Resources/32/028.png"),
	Resources.SALT						 : preload("res://Assets/UI/Icons/Resources/32/029.png"),
	Resources.TOBACCO_PLANTS	 : preload("res://Assets/UI/Icons/Resources/32/030.png"),
	Resources.TOBACCO_LEAVES	 : preload("res://Assets/UI/Icons/Resources/32/031.png"),
	Resources.TOBACCO_PRODUCTS : preload("res://Assets/UI/Icons/Resources/32/032.png"),
	Resources.CATTLE					 : preload("res://Assets/UI/Icons/Resources/32/033.png"),
	Resources.PIGS						 : preload("res://Assets/UI/Icons/Resources/32/034.png"),
	Resources.CATTLE_SLAUGHTER : preload("res://Assets/UI/Icons/Resources/32/035.png"),
	Resources.PIGS_SLAUGHTER	 : preload("res://Assets/UI/Icons/Resources/32/036.png"),
	Resources.HERBS						: preload("res://Assets/UI/Icons/Resources/32/037.png"),
	Resources.MEDICAL_HERBS		: preload("res://Assets/UI/Icons/Resources/32/038.png"),
	Resources.ACORNS					 : preload("res://Assets/UI/Icons/Resources/32/039.png"),
	Resources.CANNON					 : preload("res://Assets/UI/Icons/Resources/32/040.png"),
	Resources.SWORD						: preload("res://Assets/UI/Icons/Resources/32/041.png"),
	Resources.GRAIN						: preload("res://Assets/UI/Icons/Resources/32/042.png"),
	Resources.CORN						 : preload("res://Assets/UI/Icons/Resources/32/043.png"),
	Resources.FLOUR						: preload("res://Assets/UI/Icons/Resources/32/044.png"),
	Resources.SPICE_PLANTS		 : preload("res://Assets/UI/Icons/Resources/32/045.png"),
	Resources.SPICES					 : preload("res://Assets/UI/Icons/Resources/32/046.png"),
	Resources.CONDIMENTS			 : preload("res://Assets/UI/Icons/Resources/32/047.png"),
	Resources.MARBLE_DEPOSIT	 : preload("res://Assets/UI/Icons/Resources/32/001.png"), # 48
	Resources.MARBLE_TOPS			: preload("res://Assets/UI/Icons/Resources/32/001.png"), # 49
	Resources.COAL_DEPOSIT		 : preload("res://Assets/UI/Icons/Resources/32/001.png"), # 50
	Resources.STONE_DEPOSIT		: preload("res://Assets/UI/Icons/Resources/32/051.png"),
	Resources.STONE_TOPS			 : preload("res://Assets/UI/Icons/Resources/32/052.png"),
	Resources.COCOA_BEANS			: preload("res://Assets/UI/Icons/Resources/32/053.png"),
	Resources.COCOA						: preload("res://Assets/UI/Icons/Resources/32/054.png"),
	Resources.CONFECTIONERY		: preload("res://Assets/UI/Icons/Resources/32/055.png"),
	Resources.CANDLES					: preload("res://Assets/UI/Icons/Resources/32/056.png"),
	Resources.VINES						: preload("res://Assets/UI/Icons/Resources/32/057.png"),
	Resources.GRAPES					 : preload("res://Assets/UI/Icons/Resources/32/058.png"),
	Resources.ALVEARIES				: preload("res://Assets/UI/Icons/Resources/32/059.png"),
	Resources.HONEYCOMBS			 : preload("res://Assets/UI/Icons/Resources/32/060.png"),
	Resources.GOLD_DEPOSIT		 : preload("res://Assets/UI/Icons/Resources/32/001.png"), # 61
	Resources.GOLD_ORE				 : preload("res://Assets/UI/Icons/Resources/32/001.png"), # 62
	Resources.GOLD_INGOTS			: preload("res://Assets/UI/Icons/Resources/32/001.png"), # 63
	Resources.GEM_DEPOSIT			: preload("res://Assets/UI/Icons/Resources/32/001.png"), # 64
	Resources.ROUGH_GEMS			 : preload("res://Assets/UI/Icons/Resources/32/001.png"), # 65
	Resources.GEMS						 : preload("res://Assets/UI/Icons/Resources/32/001.png"), # 66
	Resources.SILVER_DEPOSIT	 : preload("res://Assets/UI/Icons/Resources/32/001.png"), # 67
	Resources.SILVER_ORE			 : preload("res://Assets/UI/Icons/Resources/32/001.png"), # 68
	Resources.SILVER_INGOTS		: preload("res://Assets/UI/Icons/Resources/32/001.png"), # 69
	Resources.COFFEE_PLANTS		: preload("res://Assets/UI/Icons/Resources/32/001.png"), # 70
	Resources.COFFEE_BEANS		 : preload("res://Assets/UI/Icons/Resources/32/001.png"), # 71
	Resources.COFFEE					 : preload("res://Assets/UI/Icons/Resources/32/001.png"), # 72
	Resources.TEA_PLANTS			 : preload("res://Assets/UI/Icons/Resources/32/001.png"), # 73
	Resources.TEA_LEAVES			 : preload("res://Assets/UI/Icons/Resources/32/001.png"), # 74
	Resources.TEA							: preload("res://Assets/UI/Icons/Resources/32/001.png"), # 75
	Resources.FLOWER_MEADOWS	 : preload("res://Assets/UI/Icons/Resources/32/001.png"), # 76
	Resources.BLOSSOMS				 : preload("res://Assets/UI/Icons/Resources/32/001.png"), # 77
	Resources.BRINE						: preload("res://Assets/UI/Icons/Resources/32/001.png"), # 78
	Resources.BRINE_DEPOSIT		: preload("res://Assets/UI/Icons/Resources/32/001.png"), # 79
	Resources.WHALES					 : preload("res://Assets/UI/Icons/Resources/32/001.png"), # 80
	Resources.AMBERGRIS				: preload("res://Assets/UI/Icons/Resources/32/001.png"), # 81
	Resources.LAMP_OIL				 : preload("res://Assets/UI/Icons/Resources/32/001.png"), # 82
	Resources.COTTON_PLANTS		: preload("res://Assets/UI/Icons/Resources/32/001.png"), # 83
	Resources.COTTON					 : preload("res://Assets/UI/Icons/Resources/32/001.png"), # 84
	Resources.INDIGO_PLANTS		: preload("res://Assets/UI/Icons/Resources/32/001.png"), # 85
	Resources.INDIGO					 : preload("res://Assets/UI/Icons/Resources/32/001.png"), # 86
	Resources.GARMENTS				 : preload("res://Assets/UI/Icons/Resources/32/001.png"), # 87
	Resources.PERFUME					: preload("res://Assets/UI/Icons/Resources/32/001.png"), # 88
	Resources.HOP_PLANTS			 : preload("res://Assets/UI/Icons/Resources/32/089.png"),
	Resources.HOPS						 : preload("res://Assets/UI/Icons/Resources/32/090.png"),
	Resources.BEER						 : preload("res://Assets/UI/Icons/Resources/32/091.png"),
	# Resources.# 92-99 reserved for services
	Resources.REPRESENTATION	 : preload("res://Assets/UI/Icons/Resources/32/001.png"), # 92
	Resources.SOCIETY					: preload("res://Assets/UI/Icons/Resources/32/001.png"), # 93
	Resources.FAITH_2					: preload("res://Assets/UI/Icons/Resources/32/001.png"), # 94
	Resources.EDUCATION_2			: preload("res://Assets/UI/Icons/Resources/32/001.png"), # 95
	# Resources.HYGIENE					: preload("res://Assets/UI/Icons/Resources/32/96.png"),
	Resources.RECREATION			 : preload("res://Assets/UI/Icons/Resources/32/001.png"), # 97
	# Resources.BLACKDEATH			 : preload("res://Assets/UI/Icons/Resources/32/98.png"),
	# Resources.FIRE						 : preload("res://Assets/UI/Icons/Resources/32/99.png"),
}

## The enum representing the resources
const Resources = {
	NONE							= &"NONE",
	GOLD							= &"GOLD",
	LAMB_WOOL				 = &"LAMB_WOOL",
	TEXTILE					 = &"TEXTILE",
	BOARDS						= &"BOARDS",
	FOOD							= &"FOOD",
	TOOLS						 = &"TOOLS",
	BRICKS						= &"BRICKS",
	TREES						 = &"TREES",
	GRASS						 = &"GRASS",
	WOOL							= &"WOOL",
	FAITH						 = &"FAITH",
	WILDANIMALFOOD		= &"WILDANIMALFOOD",
	DEER_MEAT				 = &"DEER_MEAT",
	HAPPINESS				 = &"HAPPINESS",
	POTATOES					= &"POTATOES",
	EDUCATION				 = &"EDUCATION",
	RAW_SUGAR				 = &"RAW_SUGAR",
	SUGAR						 = &"SUGAR",
	COMMUNITY				 = &"COMMUNITY",
	RAW_CLAY					= &"RAW_CLAY",
	CLAY							= &"CLAY",
	LIQUOR						= &"LIQUOR",
	CHARCOAL					= &"CHARCOAL",
	RAW_IRON					= &"RAW_IRON",
	IRON_ORE					= &"IRON_ORE",
	IRON_INGOTS			 = &"IRON_INGOTS",
	GET_TOGETHER			= &"GET_TOGETHER",
	FISH							= &"FISH",
	SALT							= &"SALT",
	TOBACCO_PLANTS		= &"TOBACCO_PLANTS",
	TOBACCO_LEAVES		= &"TOBACCO_LEAVES",
	TOBACCO_PRODUCTS	= &"TOBACCO_PRODUCTS",
	CATTLE						= &"CATTLE",
	PIGS							= &"PIGS",
	CATTLE_SLAUGHTER	= &"CATTLE_SLAUGHTER",
	PIGS_SLAUGHTER		= &"PIGS_SLAUGHTER",
	HERBS						 = &"HERBS",
	MEDICAL_HERBS		 = &"MEDICAL_HERBS",
	ACORNS						= &"ACORNS",
	CANNON						= &"CANNON",
	SWORD						 = &"SWORD",
	GRAIN						 = &"GRAIN",
	CORN							= &"CORN",
	FLOUR						 = &"FLOUR",
	SPICE_PLANTS			= &"SPICE_PLANTS",
	SPICES						= &"SPICES",
	CONDIMENTS				= &"CONDIMENTS",
	MARBLE_DEPOSIT		= &"MARBLE_DEPOSIT",
	MARBLE_TOPS			 = &"MARBLE_TOPS",
	COAL_DEPOSIT			= &"COAL_DEPOSIT",
	STONE_DEPOSIT		 = &"STONE_DEPOSIT",
	STONE_TOPS				= &"STONE_TOPS",
	COCOA_BEANS			 = &"COCOA_BEANS",
	COCOA						 = &"COCOA",
	CONFECTIONERY		 = &"CONFECTIONERY",
	CANDLES					 = &"CANDLES",
	VINES						 = &"VINES",
	GRAPES						= &"GRAPES",
	ALVEARIES				 = &"ALVEARIES",
	HONEYCOMBS				= &"HONEYCOMBS",
	GOLD_DEPOSIT			= &"GOLD_DEPOSIT",
	GOLD_ORE					= &"GOLD_ORE",
	GOLD_INGOTS			 = &"GOLD_INGOTS",
	GEM_DEPOSIT			 = &"GEM_DEPOSIT",
	ROUGH_GEMS				= &"ROUGH_GEMS",
	GEMS							= &"GEMS",
	SILVER_DEPOSIT		= &"SILVER_DEPOSIT",
	SILVER_ORE				= &"SILVER_ORE",
	SILVER_INGOTS		 = &"SILVER_INGOTS",
	COFFEE_PLANTS		 = &"COFFEE_PLANTS",
	COFFEE_BEANS			= &"COFFEE_BEANS",
	COFFEE						= &"COFFEE",
	TEA_PLANTS				= &"TEA_PLANTS",
	TEA_LEAVES				= &"TEA_LEAVES",
	TEA							 = &"TEA",
	FLOWER_MEADOWS		= &"FLOWER_MEADOWS",
	BLOSSOMS					= &"BLOSSOMS",
	BRINE						 = &"BRINE",
	BRINE_DEPOSIT		 = &"BRINE_DEPOSIT",
	WHALES						= &"WHALES",
	AMBERGRIS				 = &"AMBERGRIS",
	LAMP_OIL					= &"LAMP_OIL",
	COTTON_PLANTS		 = &"COTTON_PLANTS",
	COTTON						= &"COTTON",
	INDIGO_PLANTS		 = &"INDIGO_PLANTS",
	INDIGO						= &"INDIGO",
	GARMENTS					= &"GARMENTS",
	PERFUME					 = &"PERFUME",
	HOP_PLANTS				= &"HOP_PLANTS",
	HOPS							= &"HOPS",
	BEER							= &"BEER",
	REPRESENTATION		= &"REPRESENTATION",
	SOCIETY					 = &"SOCIETY",
	FAITH_2					 = &"FAITH_2",
	EDUCATION_2			 = &"EDUCATION_2",
	HYGIENE					 = &"HYGIENE",
	RECREATION				= &"RECREATION",
	BLACKDEATH				= &"BLACKDEATH",
	FIRE							= &"FIRE",
}
