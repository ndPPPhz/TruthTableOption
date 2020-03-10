public protocol MarioStateManagerInterface {
	var hasCompletedLevel1: Bool { get }
	var hasCompletedLevel2: Bool { get }
	var hasNeverLostLife: Bool { get }
}

public final class MarioBonusManager {
	private let stateManager: MarioStateManagerInterface
	public init(stateManager: MarioStateManagerInterface) {
		self.stateManager = stateManager
	}

	public var shouldBonusLevelBeShwon: Bool {
		let hasCompletedLevel1WithoutLosingLife = stateManager.hasCompletedLevel1 && stateManager.hasNeverLostLife
		let hasCompletedLevel2WithoutLosingLife = stateManager.hasCompletedLevel1 && stateManager.hasCompletedLevel2 && stateManager.hasNeverLostLife
		return hasCompletedLevel1WithoutLosingLife || hasCompletedLevel2WithoutLosingLife
	}
}
