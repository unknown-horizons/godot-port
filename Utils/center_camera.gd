class_name CamUtils

static func center_if_no_camera(node: Node):
  var cur_cam = node.get_viewport().get_camera_2d()
  if cur_cam == null:
    var cam = Camera2D.new()
    node.add_child(cam)
    cam.global_position = Vector2.ZERO
    cam.make_current()
    cam.zoom = Vector2(2, 2)
