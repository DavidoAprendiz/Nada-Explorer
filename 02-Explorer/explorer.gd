extends Control

const  MENU_LAYOUT_PATH : PackedScene = preload("res://03-Shared/menu_layout.tscn");

func _ready() -> void:
	call_menu_layout();

func call_menu_layout():
	var prepare : Control = MENU_LAYOUT_PATH.instantiate();
	add_child(prepare);
	move_child(prepare,0);

func _on_line_edit_text_submitted(user_text):
	$Api.get_cardano_transaction(user_text)