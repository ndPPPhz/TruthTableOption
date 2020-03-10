public enum MarioBonusLevel: String, TruthTableOption {
	public static var passingScenarios: [Set<TruthTableOptionDescriptor<MarioBonusLevel>>] = [
		[.true(.noLostLife), .true(.completedStage1)],
		[.true(.noLostLife), .true(.completedStage1), .true(.completedStage2)]
	]

	case noLostLife
	case completedStage1
	case completedStage2
}
