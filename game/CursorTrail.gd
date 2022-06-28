extends Spatial

export(float) var offset = 0.1

var started:bool = false
var t:float = 0

onready var cursor = get_node("../Cursor")
onready var cursormesh = get_node("../Cursor/Mesh")

var last_origin = Vector3(-100,0,0)
var before
var transp_multi = 1

func respawn():
	visible = cursor.transform.origin != last_origin
	transform.origin = cursor.transform.origin
	if SSP.smart_trail:
		if before and visible:
			visible = transform.origin != before.transform.origin
		last_origin = transform.origin
		transp_multi = clamp((transform.origin - before.transform.origin).length() / 0.1,0.0,1.0)
	$Mesh.get("material/0").albedo_color = cursormesh.get("material/0").albedo_color
	$Mesh.rotation = cursormesh.rotation

func _process(delta):
	if started:
		t += (delta/SSP.trail_time)
		var a = clamp((1-t),0,1)
		$Mesh.get("material/0").albedo_color.a = a * 0.6 * transp_multi
		$Mesh.scale = Vector3(a*SSP.cursor_scale,1,a*SSP.cursor_scale)
		if t >= 1:
			t -= 1
			respawn()

func start():
	var mat:SpatialMaterial = $Mesh.get("material/0").duplicate()
	$Mesh.set("material/0",mat)
	t = -offset
	started = true
