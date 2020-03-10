import Foundation

/// A type that can be used in a set to presents an interface to a bit set.
/// Used in `Set<Option>`, it is meant to be a simpler, enum-based alternative to Foudation's `OptionSet`.
/// Inspired by https://nshipster.com/optionset/.
/// Hashable is required for being stored as Set element
/// CaseIterable in order to iterate through all the possible values
public protocol Option: Hashable, CaseIterable {}

// Extension for a Set of 'Option's
// Since Element conforms to Options and then is CaseIterable, we can get all the cases and enumerate them
public extension Set where Element: Option {

	/// Returns the rawValue of an option which is based on its content
	var rawValue: Int {
		var rawValue = 0
		for (index, element) in Element.allCases.enumerated() {
			// Eg. all cases = A B C.
			// In case the current options contains only A and C, it will return 101 because
			// Inital RawValue = 000
			// A, 0th-index element. If it is contained ----> 000 XOR 1<<0 = 000 XOR 001 == 001
			// B is missing.
			// C, 2nd-index element. If it is contained ----> 001 XOR 1<<2 = 001 XOR 100
			if self.contains(element) {
				rawValue |= (1 << index)
			}
		}
		return rawValue
	}

	// Given a rawValue, it returns a Set of Elements whose rawValue represents a combination of Elements.
	// E.g: Elements are a, b and c
	// EG. 6 is 110. The init will return [b,c]
	private static func create<T: Collection>(fromRawValue rawValue: Int, allOptions: T) -> Set<Element> where T.Iterator.Element == Element {
		var elements: Set<Element> = []

		var bitValues = rawValue
		for element in allOptions {
			let currentBit = bitValues & 1
			if currentBit != 0 {
				elements.update(with: element)
			}
			bitValues >>= 1
		}

		return elements
	}

	/// Returns all the possible combinations of the current content of the Set
	/// E.g.: If the Set contains an element a and an element b, it will return = [ [], [a], [b] [a,b] ]
	var allOptionSetCombinations: Set<Set<Element>> {
		// Since it's a set of options, self will return all the unique element contained within the Set
		// Array(self) will convert the Set as an Array
		let allOptions = Array(self)

		// n possible inputs -> 2^n combinations. If there are only two unique elements,
		// it will return 2^2 = 4 combinations
		let combinationsCount = NSDecimalNumber(decimal: pow(2, count)).intValue

		// Consume the combinationsCount to generate all the possible combinations
		let allCombinationsArray = (0..<combinationsCount).map({
			// 0 = []
			// 1 = [a]
			// 2 = [b]
			// 3 = [a,b]
			Set<Element>.create(fromRawValue: $0, allOptions: allOptions)
		})

		// Transform it from an Array of Set of Elements to Set of Set of Elements
		let allOptionSetCombinations = Set<Set<Element>>(allCombinationsArray)
		return allOptionSetCombinations
	}
}
