import utest.Assert;
import utest.Test;
import xasync.Promise;

class TestPromise extends Test {
	function testSuccess() {
		Promise.resolve(1).then(v -> Assert.equals(1, v));
	}

	function testReject() {
		Promise.reject(404).error(v -> Assert.equals(404, v));
	}

	@:timeout(30)
	function testBasicAll() {
		var raw = [1, 5, 22, 111];
		var prom = Promise.all(raw.map(Promise.resolve));
		prom.then(v -> Assert.equals(raw, v));
	}
}
