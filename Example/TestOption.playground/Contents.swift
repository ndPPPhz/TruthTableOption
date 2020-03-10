import XCTest

final class MarioStateMock: MarioStateManagerInterface {
	var _hasCompletedLevel1: Bool = false
	var _hasCompletedLevel2: Bool = false
	var _hasNeverLostLife: Bool = false

	var hasCompletedLevel1: Bool {
		return _hasCompletedLevel1
	}

	var hasCompletedLevel2: Bool {
		return _hasCompletedLevel2
	}

	var hasNeverLostLife: Bool {
		return _hasNeverLostLife
	}
}

class MarioBonusManagerTest: XCTest {
	let stateMock = MarioStateMock()
	var manager: MarioBonusManager!

	override func setUp() {
		super.setUp()
		manager = MarioBonusManager(stateManager: stateMock)
	}

	private func configureState(with optionRow: MarioBonusLevel.Row) {
		stateMock._hasNeverLostLife = optionRow.contains(.noLostLife)
		stateMock._hasCompletedLevel1 = optionRow.contains(.completedStage1)
		stateMock._hasCompletedLevel2 = optionRow.contains(.completedStage2)
	}

	func testBonusLevel() {
		for optionRow in MarioBonusLevel.fullOptionTable {
			configureState(with: optionRow)
			testScenario(with: optionRow)
		}
	}

	private func testScenario(with optionRow: MarioBonusLevel.Row) {
		let expectedResult = manager.shouldBonusLevelBeShwon
		let result = optionRow.result
		XCTAssertEqual(result, expectedResult, "Expected result \(expectedResult) instead \(result)")
	}
}

let test = MarioBonusManagerTest()
test.setUp()
test.testBonusLevel()
