class_name AcceptDialogManager
extends AcceptDialog

@export var label: RichTextLabel

func display_dialog(text: String) -> void:
	label.text = text
	popup_centered()
