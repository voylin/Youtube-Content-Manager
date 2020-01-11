extends Tabs

var location
var file_data = {
		"name" : "",
		"thumb" : "",
		"playlist" : "",
		"description" : "",
		"tags" : "",
		"cards" : "",
		"endscreen" : "",
		"finished" : false,
		"upload_date" : "",
		"storyboard" : ""
		}

func _ready():
	location = check_location(self.name)
	if self.name != "new":
		load_data()
	$Delete_Window.visible = false
	$Close_Window.visible = false

func save_button():
	#### Setting variables in file_data according to the field
	var name = $VBoxContainer/HBoxContainer2/VBoxContainer/HBoxContainer/Name.text
	var done = $VBoxContainer/HBoxContainer2/VBoxContainer/HBoxContainer6/CheckBox.pressed 
	if (done != file_data["finished"]) and self.name != "new":
		delete_button()
	elif file_data["name"] != name:
		self.name = name
		delete_button()
	
	file_data["name"] = name
	file_data["thumb"] = $VBoxContainer/HBoxContainer2/VBoxContainer/HBoxContainer2/Thumb.text
	file_data["playlist"] = $VBoxContainer/HBoxContainer2/VBoxContainer/HBoxContainer3/Playlist.text
	file_data["description"] = $VBoxContainer/HBoxContainer2/VBoxContainer/Description.text
	file_data["tags"] = $VBoxContainer/HBoxContainer2/VBoxContainer/Tags.text
	file_data["cards"] = $VBoxContainer/HBoxContainer2/VBoxContainer/HBoxContainer4/Cards.text
	file_data["endscreen"] = $VBoxContainer/HBoxContainer2/VBoxContainer/HBoxContainer5/Endscreen.text
	file_data["finished"] = done
	file_data["upload_date"] = $VBoxContainer/HBoxContainer2/VBoxContainer/HBoxContainer6/Upload_Date.text
	file_data["storyboard"] = $VBoxContainer/HBoxContainer2/VBoxContainer2/Storyboard.text
	
	if file_data["finished"]:
		location = "user://finished/" + file_data["name"]
	else:
		location = "user://wip/" + file_data["name"]
	
	var file = File.new()
	file.open(location, File.WRITE)
	file.store_line(to_json(file_data))
	file.close()

func load_data():
	check_location(self.name)
	var file = File.new()
	file.open(location, File.READ)
	file_data = parse_json(file.get_line())
	file.close()
	
	$VBoxContainer/HBoxContainer2/VBoxContainer/HBoxContainer/Name.text = file_data["name"]
	$VBoxContainer/HBoxContainer2/VBoxContainer/HBoxContainer2/Thumb.text = file_data["thumb"]
	$VBoxContainer/HBoxContainer2/VBoxContainer/HBoxContainer3/Playlist.text = file_data["playlist"]
	$VBoxContainer/HBoxContainer2/VBoxContainer/Description.text = file_data["description"]
	$VBoxContainer/HBoxContainer2/VBoxContainer/Tags.text = file_data["tags"]
	$VBoxContainer/HBoxContainer2/VBoxContainer/HBoxContainer4/Cards.text = file_data["cards"]
	$VBoxContainer/HBoxContainer2/VBoxContainer/HBoxContainer5/Endscreen.text = file_data["endscreen"]
	$VBoxContainer/HBoxContainer2/VBoxContainer/HBoxContainer6/CheckBox.pressed = file_data["finished"]
	$VBoxContainer/HBoxContainer2/VBoxContainer/HBoxContainer6/Upload_Date.text = file_data["upload_date"]
	$VBoxContainer/HBoxContainer2/VBoxContainer2/Storyboard.text = file_data["storyboard"]


func close_button():
	self.queue_free()

func close_menu(value):
	check_location(self.name)
	var temp_data = {}
	temp_data["name"] = $VBoxContainer/HBoxContainer2/VBoxContainer/HBoxContainer/Name.text
	temp_data["thumb"] = $VBoxContainer/HBoxContainer2/VBoxContainer/HBoxContainer2/Thumb.text
	temp_data["playlist"] = $VBoxContainer/HBoxContainer2/VBoxContainer/HBoxContainer3/Playlist.text
	temp_data["description"] = $VBoxContainer/HBoxContainer2/VBoxContainer/Description.text
	temp_data["tags"] = $VBoxContainer/HBoxContainer2/VBoxContainer/Tags.text
	temp_data["cards"] = $VBoxContainer/HBoxContainer2/VBoxContainer/HBoxContainer4/Cards.text
	temp_data["endscreen"] = $VBoxContainer/HBoxContainer2/VBoxContainer/HBoxContainer5/Endscreen.text
	temp_data["finished"] = $VBoxContainer/HBoxContainer2/VBoxContainer/HBoxContainer6/CheckBox.pressed
	temp_data["upload_date"] = $VBoxContainer/HBoxContainer2/VBoxContainer/HBoxContainer6/Upload_Date.text
	temp_data["storyboard"] = $VBoxContainer/HBoxContainer2/VBoxContainer2/Storyboard.text
	var close = true
	for hit in temp_data:
		if file_data[hit] != temp_data[hit]:
			close = false
	if !close:
		$Close_Window.visible = value
	else:
		close_button()

func delete_button():
	if location != null: 
		var dir = Directory.new()
		dir.remove(location)

func delete_menu(value):
	$Delete_Window.visible = value

func check_location(name):
	for folder in ["finished", "wip"]:
		var dir = Directory.new()
		dir.open("user://" + folder)
		if dir.file_exists(name):
			location = "user://" + folder + "/" + name

