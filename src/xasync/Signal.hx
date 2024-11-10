package xasync;

typedef SignalListener<T> = (val:T) -> Void;
typedef SignalListeners<T> = Array<SignalListener<T>>;

abstract Signal<T>(SignalListeners<T>) from SignalListeners<T> {
	public var listeners(get, never):SignalListeners<T>;

	inline function get_listeners() {
		return this;
	}

	public static inline function from<T>(listeners:SignalListeners<T>):Signal<T> {
		return listeners;
	}

	public inline function new() {
		this = [];
	}

	public inline function invoke(val:T) {
		for (cb in this) {
			cb(val);
		}
	}

	@:op(A += B) public inline function addListener(listener:SignalListener<T>) {
		this.push(listener);
	}

	@:op(A + B) public inline function addListenerToNewSignal(listener:SignalListener<T>):Signal<T> {
		return this.concat([listener]);
	}

	@:op(A - B) public inline function removeListenerToNewSignal(listener:SignalListener<T>):Signal<T> {
		var res = new Signal<T>();
		return res;
	}

	@:op(A -= B) public inline function removeListener(listener:SignalListener<T>) {
		this.remove(listener);
	}
}
