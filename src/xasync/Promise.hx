package xasync;

import xasync.PromiseState;

abstract Promise<T, TErr>(Future<PromiseState<T, TErr>>) from Future<PromiseState<T, TErr>> {
	/** Returns a promise that is succeeded with a given value **/
	public static inline function resolve<T>(value:T):Promise<T, Void> {
		return cast Future.from(PromiseState.Fulfilled(value));
	}

	/** Returns a promise that is rejected with a given error **/
	public static inline function reject<TErr>(value:TErr):Promise<Void, TErr> {
		return cast Future.from(PromiseState.Rejected(value));
	}

	public inline function new(handler:(resolve:T->Void, reject:TErr->Void)->Void) {
		this = new Future(PromiseState.Pending, futureHandler -> {
			handler(val -> futureHandler(PromiseState.Fulfilled(val)), err -> futureHandler(PromiseState.Rejected(err)));
		});
	}

	/** Run a callback if this resolves successfully **/
	public function then(cb:T->Void):Promise<T, TErr> {
		return this.onStateChanged((state:PromiseState<T, TErr>) -> {
			switch (state) {
				case PromiseState.Fulfilled(v):
					cb(v);
				default:
			}
		});
	}

	/** Run a callback if this is rejected with an error **/
	public function error(cb:TErr->Void):Promise<T, TErr> {
		return this.onStateChanged((state:PromiseState<T, TErr>) -> {
			switch (state) {
				case PromiseState.Rejected(v):
					cb(v);
				default:
			}
		});
	}

	/** Run a callback if this is resolved in any way**/
	public function finally(cb:() -> Void):Promise<T, TErr> {
		return this.onStateChanged((state:PromiseState<T, TErr>) -> {
			switch (state) {
				case PromiseState.Pending:
				default:
					cb();
			}
		});
	}
}
