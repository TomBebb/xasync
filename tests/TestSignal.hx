import utest.Assert;
import utest.Test;
import xasync.Signal;

class TestSignal extends Test {
	function testRuns() {
		var ran = false;
		var signal = new Signal<Bool>();
		signal.addListener((v) -> ran = v);
		signal.invoke(true);
		Assert.isTrue(ran);
	}

	function testMultiBasic() {
		var totalRuns = 10;
		var execRuns = 0;
		var signal = new Signal<Int>();
		for (i in 0...totalRuns) {
			signal.addListener((v) -> execRuns++);
		}
		signal.invoke(-1);
		Assert.equals(totalRuns, execRuns);
	}

	function testMultiWithRemove() {
		var totalRuns = 10;
		var execRuns = 0;
		var signal = new Signal<Int>();
		for (i in 0...totalRuns) {
			signal.addListener((v) -> execRuns++);
		}
		signal.removeListener(signal.listeners[0]);
		signal.invoke(-1);
		Assert.equals(totalRuns - 1, execRuns);
	}
}
