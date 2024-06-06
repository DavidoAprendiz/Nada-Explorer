extends Control

const  MENU_LAYOUT_PATH : PackedScene = preload("res://03-Shared/menu_layout.tscn");

func _ready() -> void:
	call_menu_layout();

func call_menu_layout():
	var prepare : Control = MENU_LAYOUT_PATH.instantiate();
	add_child(prepare);
	move_child(prepare,0);

func _on_click_me_mouse_entered():
	$StartLabels/ClickMe.visible = false;
	$StartLabels/Welcome.visible = true;
	$StartLabels/PressIt.visible = true;