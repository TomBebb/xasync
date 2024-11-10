package xasync;

class Future<TState> {
	/** The current state of the future **/
	public var state(default, null):TState;

	public var stateChanged = new Signal<TState>();

	@:from public static inline function from<TState>(value:TState):Future<TState> {
		return new Future<TState>(value, _ -> {});
	}

	public function new(resolvingState:TState, handler:(stateChange:(state:TState) -> Void) -> Void,) {
		state = resolvingState;
		handler(newState -> {
			state = newState;
			stateChanged.invoke(newState);
		});
	}
}
