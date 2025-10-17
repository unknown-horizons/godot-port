class_name CamUtils

static func center_if_no_camera(node: Node):
  var cur_cam = node.get_viewport().get_camera_2d()
  if cur_cam == null:
    var cam = preload("res://Assets/World/MainCamera.gd").new()
    node.add_child(cam)
    var rect = node.get_rect()
    cam.global_position = node.global_position + rect.size / 2
    cam.make_current()
