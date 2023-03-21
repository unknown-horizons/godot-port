class_name Utils

static func map_3_to_2(vector_3: Vector3) -> Vector2:
	return Vector2(vector_3.x, vector_3.z)

static func map_2_to_3(vector_2: Vector2) -> Vector3:
	return Vector3(vector_2.x, 0, vector_2.y)

static func map_3i_to_2i(vector_3: Vector3i) -> Vector2i:
	return Vector2i(vector_3.x, vector_3.z)

static func map_2i_to_3i(vector_2: Vector2i) -> Vector3i:
	return Vector3i(vector_2.x, 0, vector_2.y)
