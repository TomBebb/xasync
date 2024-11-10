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
}
