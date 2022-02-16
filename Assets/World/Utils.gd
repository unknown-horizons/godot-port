class_name Utils

static func map_3_to_2(vector_3: Vector3) -> Vector2:
	return Vector2(vector_3.x, vector_3.z)

static func map_2_to_3(vector_2: Vector2) -> Vector3:
	return Vector3(vector_2.x, 0, vector_2.y)
