extends Panel

@export var item: Node;
@export var item_arr: Array;

func set_item(new_item):
	print('new_item: ', new_item)
	item_arr = Array();
	item = new_item;
	%Label.text = '';

func set_item_arr(new_item_arr):
	item = null;
	item_arr = new_item_arr;
	%Label.text = str(new_item_arr.size());
	
func clear_slot():
	item = null;
	item_arr = Array();
	%Label.text = '';
