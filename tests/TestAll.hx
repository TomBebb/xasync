class TestAll {
	public static function main() {
		utest.UTest.run([new TestFutureBasics(), new TestSignal(), new TestPromise()]);
	}
}
