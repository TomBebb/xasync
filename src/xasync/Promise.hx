package xasync;

import xasync.PromiseState;

abstract Promise<T, TErr>(Future<PromiseState<T, TErr>>) from Future<PromiseState<T, TErr>> {
	/** Returns a promise that is succeeded with a given value **/
	public static inline function resolve<T>(value:T):Promise<T, Any> {
		return cast Future.from(PromiseState.Fulfilled(value));
	}

	/** Returns a promise that is rejected with a given error **/
	public static inline function reject<TErr>(value:TErr):Promise<Any, TErr> {
		return cast Future.from(PromiseState.Rejected(value));
	}

	public inline function new(handler:(resolve:T->Void, reject:TErr->Void)->Void) {
		this = new Future(PromiseState.Pending, futureHandler -> {
			handler(val -> futureHandler(PromiseState.Fulfilled(val)), err -> futureHandler(PromiseState.Rejected(err)));
		});
	}

	public static inline function all<T, TErr>(iterable:Iterable<Promise<T, TErr>>):Promise<Array<T>, TErr> {
		var raw:Future<Array<PromiseState<T, TErr>>> = Future.all(PromiseState.Pending, cast iterable);

		return new Promise((resolve, reject) -> raw.onStateChanged(value -> {
			if (value == cast Future.LOADING_STATES)
				return;
			var res:Array<T> = [];
			for (item in value) {
				switch (item) {
					case Fulfilled(v): res.push(v);
					case Rejected(v):
						reject(v);
						return;
					case Pending:
				}
			}
		}));
	}

	/** Run a callback if this resolves successfully **/
	public function then(cb:T->Void):Promise<T, TErr> {
		return this.onStateChanged((state:PromiseState<T, TErr>) -> {
			switch (state) {
				case Fulfilled(v):
					cb(v);
				default:
			}
		});
	}

	/** Run a callback if this is rejected with an error **/
	public function error(cb:TErr->Void):Promise<T, TErr> {
		return this.onStateChanged((state:PromiseState<T, TErr>) -> {
			switch (state) {
				case Rejected(v):
					cb(v);
				default:
			}
		});
	}

	/** Run a callback if this is resolved in any way**/
	public function finally(cb:() -> Void):Promise<T, TErr> {
		return this.onStateChanged((state:PromiseState<T, TErr>) -> {
			switch (state) {
				case Pending:
				default:
					cb();
			}
		});
	}
}
