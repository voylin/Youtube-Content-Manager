extends Control

func _ready():
	#### Hiding Tab_selector
	$Tab_Selector.visible = false
	#### Creating save folders if they don't exist yet
	var dir = Directory.new()
	if !dir.dir_exists("user://finished"):
		dir.make_dir("user://finished")
	if !dir.dir_exists("user://wip"):
		dir.make_dir("user://wip")

func open_tab_selector(value = false):
	if value:
		for child in $Tab_Selector/VBoxContainer/HBoxContainer2/ScrollContainer/WIP_Container.get_children():
			child.queue_free()
		for child in $Tab_Selector/VBoxContainer/HBoxContainer2/ScrollContainer2/Finished_Container.get_children():
			child.queue_free()
		
		$Tab_Selector.visible = true
		
		var dir = Directory.new()
		var files = {"finished" : [], "wip" : []}
		for folder in ["finished", "wip"]:
			dir.open("user://" + folder)
			dir.list_dir_begin()
			var tabs = []
			for child in $VBox/TabContainer.get_children():
				tabs.append(child.name)
			while true:
				var file = dir.get_next()
				if file == "": break
				elif not file.begins_with(".") and not file in tabs:
					files[folder].append(file)
		files["wip"].sort()
		files["finished"].sort()
		for file in files["finished"]:
			var button = Button.new()
			button.name = file
			button.text = file
			button.align = Button.ALIGN_LEFT
			button.connect("pressed", self, "open_tab", [file]) 
			$Tab_Selector/VBoxContainer/HBoxContainer2/ScrollContainer2/Finished_Container.add_child(button)
		for file in files["wip"]:
			var button = Button.new()
			button.name = file
			button.text = file
			button.align = Button.ALIGN_LEFT
			button.connect("pressed", self, "open_tab", [file])
			$Tab_Selector/VBoxContainer/HBoxContainer2/ScrollContainer/WIP_Container.add_child(button)
	else:
		$Tab_Selector.visible = false

func open_tab(name):
	var tabs = []
	for child in $VBox/TabContainer.get_children():
		tabs.append(child.name)
	if name in tabs:
		pass
	var tab = load("res://Scenes/Tabs.tscn").instance()
	tab.name = name
	$VBox/TabContainer.add_child(tab)
	open_tab_selector(false)
	$VBox/TabContainer.current_tab = $VBox/TabContainer.get_child_count() - 1
