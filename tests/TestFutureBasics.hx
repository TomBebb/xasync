import utest.Async;
import haxe.Timer;
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

	@:timeout(200)
	function testSignalRan(async:Async) {
		var future = new Future(-1, (stateChange) -> Timer.delay(() -> {
			stateChange(1);
			async.done();
		}, 100));
		future.stateChanged += curr -> {
			Assert.pass();
		};
	}
}
