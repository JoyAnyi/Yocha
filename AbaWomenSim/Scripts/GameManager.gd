extends Control
@export var timeline: Array[HistoricalEvent]
#$ used to find nodes. It's like a map address.
# UI REFERENCES: It grabs the nodes I made
@onready var event_image = $MarginContainer/MainLayout/StagePanel/EventImage
@onready var title_label = $MarginContainer/MainLayout/StagePanel/EventTitle
@onready var desc_label = $MarginContainer/MainLayout/StagePanel/StoryScroll/EventDescription
@onready var event_image2 = $MarginContainer/MainLayout/StagePanel/EventImage
@onready var feedback_label = $MarginContainer/MainLayout/StagePanel/FeedbackLabel
@onready var restart_button = $MarginContainer/MainLayout/StagePanel/RestartButton
@onready var btn_a = $MarginContainer/MainLayout/StagePanel/ButtonContainer/ButtonOptionA
@onready var btn_b = $MarginContainer/MainLayout/StagePanel/ButtonContainer/ButtonOptionB
@onready var money_label = $MarginContainer/MainLayout/DashboardPanel/MoneyLabel
@onready var goods_label = $MarginContainer/MainLayout/DashboardPanel/GoodsLabel
@onready var market_manager = $MarketManager

# Note to self: use the grid later for the visual boxes
@onready var inventory_grid = $MarginContainer/MainLayout/DashboardPanel/InventoryGrid
@onready var story_audio = $StoryAudio
@onready var background_audio = $BackgroundAudio
# INTERNAL STATE: Memory
var player: PlayerStats
var current_event_index: int = 0
var current_event_data: HistoricalEvent
#var market: MarketManager

# STARTUP SESSION
func _ready():
#Creates the Player Logic
	player = PlayerStats.new()
	add_child(player)
	# CONNECT THE RADIO! 
	 # When player says "stats_updated", run the function "_on_stats_updated"
	player.stats_updated.connect(_on_stats_updated)
	# Connect Buttons
	btn_a.pressed.connect(_on_button_a_pressed)
	btn_b.pressed.connect(_on_button_b_pressed)
	restart_button.pressed.connect(_on_restart_pressed)
	#Draws the starting stats (Money: 100,000)
	_on_stats_updated()
	# Market Logic
	#market = MarketManager.new()
	#add_child(market)
	#Start the first event
	# ADD THIS DEBUG SECTION:
	print("Timeline Size: ", timeline.size())
	if timeline.size() > 0:
		print("Item 0 is:", timeline[0])
		load_event(0)
	else:
		print("Timeline is empty!")
		

# GAME LOOP
func load_event(index: int):
	# If the game ran out of events, stop.
	#if index >=timeline.size():
		#title_label.text ="Game Over"
		#desc_label.text = "You finished the run!"
		#btn_a.visible = false
		#btn_b.visible = false
		#restart_button.visible = true
		#return
	
	if index >= timeline.size():
		title_label.text = "End of Historical Chapter"
		desc_label.text = "You have completed the Aba Women's Riot storyline.\n\nYou may restart and make different economic choices."
		btn_a.visible = false
		btn_b.visible = false
		restart_button.visible = true
		return
	
	current_event_index = index
	current_event_data = timeline[index]
 # UPDATE UI: Show the new story
	title_label.text = current_event_data.title
	desc_label.text = current_event_data.description
	
	# Update Buttons text
	btn_a.text = current_event_data.option_a_text
	btn_b.text = current_event_data.option_b_text
	
# Image logic.
	if current_event_data.event_image != null:
		event_image.texture = current_event_data.event_image
	#else:
		#event_image.texture = load("res://icon.svg")
	
#Audio logic
	if current_event_data.event_audio !=null:
		story_audio.stream = current_event_data.event_audio
		story_audio.play()
	# Silence if this event has no sound
	else:
		story_audio.stop()
		
#Background narration
	if current_event_data.background_audio != null:
		background_audio.stream = current_event_data.background_audio
		background_audio.play()
	
	else:
		background_audio.stop()

	
   # Reset Feedback
	feedback_label.text = "Make a choice"
	# Re-enable buttons
	btn_a.disabled = false
	btn_b.disabled = false

func _on_button_a_pressed():
	handle_decision("A")
	
func _on_button_b_pressed():
	handle_decision("B")
	
	btn_a.text = current_event_data.option_a_text
	btn_b.text = current_event_data.option_b_text	


func handle_decision(choice: String):
	btn_a.disabled = true
	btn_b.disabled = true
	
	var good_name: String
	var quantity: int
	var is_buy: bool
	var risk_change: int
	
	if choice == "A":
		good_name = current_event_data.option_a_good_name
		quantity = current_event_data.option_a_quantity
		is_buy = current_event_data.option_a_is_buy
		risk_change = current_event_data.option_a_risk_change
	else:
		good_name = current_event_data.option_b_good_name
		quantity = current_event_data.option_b_quantity
		is_buy = current_event_data.option_b_is_buy
		risk_change = current_event_data.option_b_risk_change
	
	# Calculate dynamic price
	var price = market_manager.calculate_price(
		good_name,
		current_event_data.price_multiplier,
		player.risk
	)
	
	var total_cost = price * abs(quantity)
	
	var action_taken = false  # Track if any trade actually happens
	
	# BUYING
	if is_buy and quantity > 0:
		if player.money < total_cost:
			feedback_label.text = "Not enough money."
			btn_a.disabled = false
			btn_b.disabled = false
			return
		
		player.update_money(-total_cost)
		player.change_inventory(good_name, quantity)
		action_taken = true
	
	# SELLING
	elif not is_buy and quantity != 0:
		if player.inventory.get(good_name, 0) < abs(quantity):
			feedback_label.text = "Not enough goods to sell."
			btn_a.disabled = false
			btn_b.disabled = false
			return
		
		player.update_money(total_cost)
		player.change_inventory(good_name, -abs(quantity))
		action_taken = true
	
	# Option B effect when nothing is bought/sold
	if not action_taken:
		feedback_label.text = "You note the price trends."
		player.risk += risk_change
		player.stats_updated.emit()
	else:
		feedback_label.text = "Trade completed."
		player.risk += risk_change
		player.stats_updated.emit()
	
	await get_tree().create_timer(2.0).timeout
	load_event(current_event_index + 1)
	
# UI UPDATES
func _on_stats_updated():

	money_label.text = "₦" + str(player.money)
	goods_label.text = "INVENTORY\nCount: " + str(player.goods)

	# Clear old slots
	for child in inventory_grid.get_children():
		child.queue_free()

	var current_slot = 0

	# Loop through each good type
	for good_name in player.inventory.keys():
		var quantity = player.inventory[good_name]

		for i in range(quantity):
			if current_slot >= 9:
				break

			var slot = ColorRect.new()
			slot.custom_minimum_size = Vector2(60, 60)

			match good_name:
				"palm_oil":
					slot.color = Color.RED
				"garri":
					slot.color = Color.YELLOW
				"salt":
					slot.color = Color.WHITE
				_:
					slot.color = Color.GRAY

			slot.tooltip_text = good_name.replace("_", " ").capitalize()
			inventory_grid.add_child(slot)

			current_slot += 1

	# Fill remaining empty slots
	for i in range(current_slot, 9):
		var slot = ColorRect.new()
		slot.custom_minimum_size = Vector2(60, 60)
		slot.color = Color(0.2, 0.2, 0.2)
		inventory_grid.add_child(slot)
		
func _on_restart_pressed():
	#player.money = 100000
	#player.goods = 0
	#current_event_index = 0
	#restart_button.visible = false
	#btn_a.visible = true
	#btn_b.visible = true
	#_on_stats_updated()
	#load_event(0)
	player.money = 100000
	for key in player.inventory.keys():
		player.inventory[key] = 0
	
	player.goods = 0
	player.risk = 0
	
	current_event_index = 0
	restart_button.visible = false
	btn_a.visible = true
	btn_b.visible = true
	
	player.stats_updated.emit()
	load_event(0)
