package xasync;

import haxe.Timer;

class Future<TState> {
	public static final LOADING_STATES = [];

	public static function all<TState>(resolvingState:TState, iterable:Iterable<Future<TState>>):Future<Array<TState>> {
		return new Future(LOADING_STATES, stateChange -> {
			var results:Array<TState> = [];
			var totalLoaded = 0;

			var index = 0;
			for (item in iterable) {
				results.push(resolvingState);

				var itemIndex = index++;
				Timer.delay(() -> item.onStateChanged(v -> {
					if (v == resolvingState)
						return;

					results[itemIndex] = v;
					if (++totalLoaded >= results.length) {
						stateChange(results);
					}
				}), 2);
			}
		});
	}

	/** The current state of the future **/
	public var state(default, null):TState;

	/** Track state changes **/
	public var stateChanged = new Signal<TState>();

	public inline function onStateChanged(changed:TState->Void):Future<TState> {
		changed(state);
		stateChanged += changed;
		return this;
	}

	@:from public static inline function from<TState>(value:TState):Future<TState> {
		return new Future<TState>(value, _ -> {});
	}

	/** Create a new future with the given resolving state and function to pass callback to **/
	public function new(resolvingState:TState, handler:(stateChange:(state:TState) -> Void) -> Void) {
		state = resolvingState;
		handler(newState -> {
			state = newState;
			stateChanged.invoke(newState);
		});
	}

	public function map<R>(mapper:TState->R):Future<R> {
		return new Future(mapper(state), handler -> {
			stateChanged += (v) -> {
				return handler(mapper(v));
			};
		});
	}
}
