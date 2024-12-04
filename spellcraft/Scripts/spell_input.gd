extends TextureRect

const ROW_AMOUNT = 17
var GRID_SIZE: int = get_size().x

var _click_pos: Array = []
var color = Color.BLACK

# To store the bit array representation of the grid
var bit_array: Array = []

func _input(event: InputEvent) ->void:
	if not Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
		return
	if not get_global_rect().has_point(event.global_position):
		return
	_click_pos.append(get_local_mouse_position())
	queue_redraw()
	
func _draw() -> void:
	var CELL_SIZE = GRID_SIZE / ROW_AMOUNT
	print("here")
	print(CELL_SIZE)
	set_size(Vector2(GRID_SIZE, GRID_SIZE))
	var index = []
	for i in ROW_AMOUNT:
		var from := Vector2(i * CELL_SIZE, 0)
		var to := Vector2(from.x, GRID_SIZE)
		draw_line(from, to, Color.LIGHT_GRAY)
		from = Vector2(0, i * CELL_SIZE)
		to = Vector2(GRID_SIZE, from.y)
		draw_line(from, to, Color.LIGHT_GRAY)
	for point in _click_pos:
		var rect_pos = Vector2(floor(point.x / CELL_SIZE) * CELL_SIZE, floor(point.y / CELL_SIZE) * CELL_SIZE)
		print(GRID_SIZE)
		if not rect_pos.x < 0 or rect_pos.y < 0:
			if not rect_pos.y >= GRID_SIZE or rect_pos.x >= GRID_SIZE:
				print(rect_pos.y)
				var rect_pos_x = rect_pos.x / CELL_SIZE
				var rect_pos_y = rect_pos.y / CELL_SIZE
				index.append(rect_pos_y * ROW_AMOUNT + rect_pos_x)
				draw_rect(Rect2(rect_pos, Vector2(CELL_SIZE,CELL_SIZE)), color, true, CELL_SIZE, false)
	generate_bit_array(index)

func _on_ready() -> void:
	var TARGET_SIZE = GRID_SIZE - GRID_SIZE % ROW_AMOUNT
	if TARGET_SIZE != 0:
		print(GRID_SIZE)
		GRID_SIZE = TARGET_SIZE
		set_size(Vector2(TARGET_SIZE, TARGET_SIZE))

func generate_bit_array(index):
	var CELL_SIZE = GRID_SIZE / ROW_AMOUNT
	var bit_array = []
	
	for bits in range(ROW_AMOUNT * ROW_AMOUNT):
		bit_array.append(0)
	
		
