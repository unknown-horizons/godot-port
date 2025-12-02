class_name Utils

static func map_3_to_2(vector_3: Vector3) -> Vector2:
  return Vector2(vector_3.x, vector_3.z)

static func map_2_to_3(vector_2: Vector2) -> Vector3:
  return Vector3(vector_2.x, 0, vector_2.y)

static func map_3i_to_2i(vector_3: Vector3i) -> Vector2i:
  return Vector2i(vector_3.x, vector_3.z)

static func map_2i_to_3i(vector_2: Vector2i) -> Vector3i:
  return Vector3i(vector_2.x, 0, vector_2.y)

## Makes sure the given signal is connected to the given callable and connects it otherwise.
static func ensure_connected(_signal: Signal, callable: Callable):
  assert(callable.is_valid())
  if not _signal.is_connected(callable):
    _signal.connect(callable)

## Makes sure the given signal is not connected to the given callable and disconnects it otherwise.
static func ensure_disconnected(_signal: Signal, callable: Callable):
  assert(callable.is_valid())
  if _signal.is_connected(callable):
    _signal.disconnect(callable)

static func intersect_dicts(dict_a: Dictionary, dict_b: Dictionary) -> Dictionary:
  var result: Dictionary = {}
  for key in dict_a:
    if key in dict_b:
      result[key] = true
  return result

static func distance_to_rect_L1(p: Vector2i, rect: Rect2i) -> int:
  var dx := 0
  if p.x < rect.position.x:
    dx = rect.position.x - p.x
  elif p.x >= rect.end.x:
    dx = p.x - (rect.end.x - 1)

  var dy := 0
  if p.y < rect.position.y:
    dy = rect.position.y - p.y
  elif p.y >= rect.end.y:
    dy = p.y - (rect.end.y - 1)

  return dx + dy
