import utest.Assert;
import utest.Test;
import xasync.Future;

class TestFutureBasics extends Test {
	function testHandlerRan() {
		var ran = false;
		new Future({}, (changeState) -> ran = true);
		Assert.isTrue(ran);
	}

	function testHandlerFrom() {
		var ran = false;
		new Future({}, (changeState) -> ran = true);
		Assert.isTrue(ran);
	}
}
