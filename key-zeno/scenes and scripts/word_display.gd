extends Node2D

@export var atlas: Texture2D
@export var display_scale: int = 3

# conf
const CELL_W: int = 8
const CELL_H: int = 16
const CHAR_ORDER: String = "abcdefghijklmnopqrstuvwxyz"
const LETTER_SPACING: int = 2
const WORD_SPACING: int = 8
const LINE_HEIGHT_EXTRA: int = 10

# colors
const COLOR_UPCOMING: Color = Color("#627a4")
const COLOR_CORRECT: Color = Color("#50fa7b")
const COLOR_WRONG: Color = Color("c50826ff")
const COLOR_CURSOR: Color = Color("faf9e3ff")

# state
var words: Array[String] = []
var typed_text: String = ""
var target_text: String = ""

func setup(word_list: Array[String]) -> void:
	words = word_list
	target_text = " ".join(word_list)
	typed_text = ""
	queue_redraw()

func update_typed(new_typed: String) -> void:
	typed_text = new_typed
	queue_redraw()

func _draw() -> void:
	if atlas == null or target_text == "":
		return
	
	var scaled_w: int = CELL_W * display_scale
	var scaled_h: int = CELL_H * display_scale
	
	var line_h: int = scaled_h + LINE_HEIGHT_EXTRA
	
	var x: float = 0.0
	var y: float = 0.0
	
	for i in target_text.length():
		var ch: String = target_text[i]
		var idx: int = CHAR_ORDER.find(ch)
		
		# pickin color
		var color: Color
		if i < typed_text.length():
			color = COLOR_CORRECT if typed_text[i] == ch else COLOR_WRONG
		elif i == typed_text.length():
			color = COLOR_CURSOR
		else:
			color = COLOR_UPCOMING
		
		# drawing char
		if ch == " ":
			x += scaled_w + WORD_SPACING
		elif idx != -1:
			var src := Rect2(idx * CELL_W, 0, CELL_W, CELL_H)
			var dst := Rect2(Vector2(x, y), Vector2(scaled_w, scaled_h))
			draw_texture_rect_region(atlas, dst, src, color)
			x += scaled_w + LETTER_SPACING
		
		# wrap if we are running out of space (900px<)
		if ch == " " and x > 900:
			x = 0.0
			y += line_h
