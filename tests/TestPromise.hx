import utest.Assert;
import utest.Test;
import xasync.Promise;

class TestPromise extends Test {
	@:timeout(20)
	function testSuccess() {
		Promise.resolve(1).then(v -> Assert.equals(1, v));
	}

	@:timeout(20)
	function testReject() {
		Promise.reject(404).error(v -> Assert.equals(404, v));
	}
}
