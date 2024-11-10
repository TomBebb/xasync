package xasync;

enum PromiseState<TOk, TErr> {
	Pending;
	Fulfilled(value:TOk);
	Rejected(error:TErr);
}
