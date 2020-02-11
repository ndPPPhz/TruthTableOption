import Foundation

/// Enum to represent the inputs of a truth table.
/// The result for each row of the table is defined statically with `passingScenarios`
public protocol TruthTableOption: Option, RawRepresentable {
	typealias Row = Set<Self> // A row is a Set of Elements
	typealias Table = Set<Row> // A table is a set of rows

	typealias Scenario = Set<TruthTableOptionDescriptor<Self>>
	static var passingScenarios: [Scenario] { get }
}

// A Set whose Element is a TruthTableOption is equivalent to a single row of a Table of Truth
public extension Set where Element: TruthTableOption {
	/// It returns true if the current row of the table of truth is part of the passing scenario
	var result: Bool {
		// All the rows where the test should pass. It converts the Set<TruthTableOptionDescriptor<Element>> to Set<Set<Element>>
		let passingOptionRows = Element.optionRows(from: Element.passingScenarios)
		// If the current one is contained within the array it means it should return true. False otherwise
		return passingOptionRows.contains(self)
	}
}

public extension TruthTableOption {
	/// All the possible option set combinations
	static var fullOptionTable: Table {
		let fullOptionTable = Set(Self.allCases).allOptionSetCombinations
		return fullOptionTable
	}

	/// Returns the option sets that correspond to the described scenarios
	static func optionRows(from scenarios: [Scenario]) -> Table {
		var optionRows: Set<Set<Self>> = []

		for scenario in scenarios {

			// Extract all the true and dontCare options
			var trueOptionSet: Set<Self> = []
			var trueOrFalseOptionSet: Set<Self> = []
			for optionDescriptor in scenario {
				switch optionDescriptor {
				case .true(let option):
					trueOptionSet.update(with: option)
				case .false:
					break
				case .dontCare(let option):
					trueOrFalseOptionSet.update(with: option)
				}
			}

			// Combine the true and dontCare options to create a complete option row
			for trueOrFalseOptionSetCombination in trueOrFalseOptionSet.allOptionSetCombinations {
				let completeOptionRow = trueOptionSet.union(trueOrFalseOptionSetCombination)
				optionRows.update(with: completeOptionRow)
			}
		}

		return optionRows
	}
}

extension Set where Element: TruthTableOption {
	/// A description of the truth table row, including its result
	public var debugDescription: String {
		var descriptionArray: [String] = []
		for option in Element.allCases {
			let optionName = option.rawValue
			let optionValue = contains(option)
			let optionDescription = "\(optionName): \(optionValue)"
			descriptionArray.append(optionDescription)
		}
		descriptionArray.append("Result: \(result)")
		let description = descriptionArray.joined(separator: ", ")
		return description
	}
}

/// Used with `TruthTableOption` to describe a truth table scenario
public enum TruthTableOptionDescriptor<T> {
	case `true`(T)
	case `false`(T) // By default if an element isn't mentioned withing a Row is false.
	case dontCare(T) // Don't Care is a useful way to inform the algorithm that we don't care either if an element is true or false. It's being used in scenario where you can semplify one or more rows in one. For example: [a] and [a,b] rows may be expressed as [[.true(a), .false(b)], [.true(a), .true(b)] or [[.true(a), .dontCare(b)]]
}

extension TruthTableOptionDescriptor: Equatable where T: Equatable {}
extension TruthTableOptionDescriptor: Hashable where T: Equatable & Hashable {}
