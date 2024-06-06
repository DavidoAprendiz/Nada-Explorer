extends Control

var menu : PackedScene = load("res://01-Menu/menu.tscn")
var explorer : PackedScene = load("res://02-Explorer/explorer.tscn")

func _ready() -> void:
	match get_parent().name:
		"Menu": prepare_menu("Menu");
		"Explorer": prepare_menu("Explorer");

func prepare_menu(scene_name):
	(get_parent().get_node("MenuLayout/Background") as TextureRect).texture = preload("res://01-Menu/asset/background_night.png");
	match scene_name:
		"Menu":
			get_parent().get_node("MenuLayout/Panel/BackButton").visible = false;
			get_parent().get_node("MenuLayout/Panel/LogoButton").visible = true;
			get_parent().get_node("MenuLayout/Panel/EnterButton").visible = true;
		"Explorer": 
			get_parent().get_node("MenuLayout/Logo").visible = true;
			get_parent().get_node("MenuLayout/Panel/BackButton").visible = true;
			get_parent().get_node("MenuLayout/Panel/LogoButton").visible = false;
			get_parent().get_node("MenuLayout/Panel/EnterButton").visible = false;

# start Explorer scene
func _on_enter_button_pressed() -> void:
	get_tree().change_scene_to_packed(explorer);

func _on_exit_button_pressed() -> void:
	get_tree().quit();

# change scenes
func _on_back_button_pressed() -> void:
	match get_parent().name:
		"Explorer": get_tree().change_scene_to_packed(menu);

# This function starts after the logo is pressed. Update local time, current Ada price, current epoch and the next one.
func _on_logo_button_pressed() -> void:
	get_parent().get_node("Panel").visible = true;
	get_parent().get_node("StartLabels/Welcome").visible = false;
	get_parent().get_node("StartLabels/PressIt").visible = false;
	get_parent().get_node("StartLabels/LetsGo").visible = true;
	if get_parent().get_node("StartLabels/ClickMe").visible:
		get_parent().get_node("StartLabels/ClickMe").visible = false;
	match get_parent().name:
		"Menu": 
			# Update Time
			get_parent().get_node("TimeUtc").text = "[center]Time: " + Time.get_time_string_from_system();
			# TODO: Update Price
			get_parent().get_node("Api").get_cardano_price();
			# TODO: Update Epoch and Transactions (TXs)
			get_parent().get_node("Api").get_epochs();

# Links to socials
func _on_git_hub_button_pressed():
	OS.shell_open("https://github.com/DavidoAprendiz")

func _on_x_button_pressed():
	OS.shell_open("https://x.com/David_oAprendiz")

func _on_itch_io_button_pressed():
	OS.shell_open("https://davidoaprendiz.itch.io")