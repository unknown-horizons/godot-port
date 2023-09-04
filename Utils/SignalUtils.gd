class_name SignalUtils

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
