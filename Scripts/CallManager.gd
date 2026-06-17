extends Node


# -------------------------
# CALL FUNCTION
# -------------------------
func call_node(node: Node, method_name: String, args: Array = []) -> Variant:
	if node == null or not node.has_method(method_name):
		return null

	return node.callv(method_name, args)


# -------------------------
# SET VARIABLE
# -------------------------
func set_var(node: Node, var_name: String, value) -> void:
	if node == null:
		return

	node.set(var_name, value)


# -------------------------
# GET VARIABLE
# -------------------------
func get_var(node: Node, var_name: String) -> Variant:
	if node == null:
		return null

	return node.get(var_name)


# -------------------------
# TOGGLE BOOL VARIABLE
# -------------------------
func toggle_var(node: Node, var_name: String) -> void:
	if node == null:
		return

	var current = node.get(var_name)
	if typeof(current) == TYPE_BOOL:
		node.set(var_name, !current)
