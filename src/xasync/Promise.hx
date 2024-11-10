package xasync;

abstract Promise<T, TErr>(Future<PromiseState<T, TErr>>) {
	public static inline function resolve<T>(value:T):Promise<T, Void> {
		return cast Future.from(PromiseState.Fulfilled(value));
	}

	public static inline function reject<TErr>(value:TErr):Promise<Void, TErr> {
		return cast Future.from(PromiseState.Rejected(value));
	}

	public inline function new(handler:(resolve:T->Void, reject:TErr->Void)->Void) {
		this = new Future(PromiseState.Pending, futureHandler -> {
			handler(val -> futureHandler(PromiseState.Fulfilled(val)), err -> futureHandler(PromiseState.Rejected(err)));
		});
	}

	public function then(cb:T->Void) {
		this.onStateChanged((state:PromiseState<T, TErr>) -> {
			switch (state) {
				case PromiseState.Fulfilled(v):
					cb(v);
				default:
			}
		});
	}

	public function error(cb:TErr->Void) {
		this.onStateChanged((state:PromiseState<T, TErr>) -> {
			switch (state) {
				case PromiseState.Rejected(v):
					cb(v);
				default:
			}
		});
	}

	public function finally(cb:() -> Void) {
		this.onStateChanged((state:PromiseState<T, TErr>) -> {
			switch (state) {
				case PromiseState.Pending:
				default:
					cb();
			}
		});
	}
}
