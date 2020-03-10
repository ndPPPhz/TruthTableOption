# TruthTableOption
![](https://img.shields.io/badge/swift-unit%20test-green)

The TruthTableOption is a Swift protocol which helps both Devs and QAs on writing human-readable and easy editable tests.
It's applicable anywhere you can synthesize your logic with a [Table Of The Truth](https://en.wikipedia.org/wiki/Truth_table).

## Example and applicable scenario
Imagine a scenario like the following one:
You have to write and test a new feature which tells you whether you need to display a new banner containing a discount code to the users.
You have been told from your business analyst that you only have to show the new banner in your app when:
1) The customer gender is female
2) Is a new customer or is the international women's day

After discussing with your QAs you end up with the following ACs

| newCustomer | isInternationalWomensDay | isFemale | Result |
|-------------|--------------------------|----------|--------|
| false       | false                    | false    | false  |
| false       | false                    | true     | false  |
| false       | true                     | false    | false  |
| false       | true                     | true     | true   |
| true        | false                    | false    | false  |
| true        | false                    | true     | true   |
| true        | true                     | false    | false  |
| true        | true                     | true     | true   |

Developing a feature like that, requires different layers of logic which have to be fully tested.
Pretty sure you'd like to avoid writing single tests for each scenario. Moreover, in future, you should be able to extend this feature
without trying to understand how the logic works.
Debugging gets harder as big as the table and the requirement grows

This can be reduced to something like this:
<img width="781" alt="Screenshot 2020-03-10 at 20 04 03" src="https://user-images.githubusercontent.com/6486741/76354467-6693b380-630a-11ea-9062-f97eb1b4bd18.png">

and here's where the TruthTableOption comes to rescue.

## Usage
- Create an enum which has a `String` as RawValue and conforms to `TruthTableOption`.
- Add a case for each column of the table.
- Implement `passingScenarios` in the following manner:
  - For each row where the result is true
    - `.true` when the condition should be true
    - `.false` when the condition should be false
    - `.dontCare` when the condition could be both `true` or `false`

```swift
enum PromoBanner: String, TruthTableOption {
static var passingScenarios: [Set<TruthTableOptionDescriptor<PromoBanner>>] = [
	[.true(.isFemale), .true(.newCustomer)],
	[.true(.isFemale), .true(.isInternationalWomensDay)],
	[.true(.isFemale), .true(.newCustomer), .true(.isInternationalWomensDay)]
]

	case newCustomer
	case isInternationalWomensDay
	case isFemale
}
```

### Test file


Let's assume the following mock object
```swift
final class PromoBannerMock: PromoBannerInterface {
	var _isNewCustomer: Bool = false
	var _isInternationalWomensDay: Bool = false
	var _isFemale: Bool = false

	var isNewCustomer: Bool {
		return _isNewCustomer
	}

	var isInternationalWomensDay: Bool {
		return _isInternationalWomensDay
	}

	var isFemale: Bool {
		return _isFemale
	}
}
```

and the following test
```swift
func testPromoBanner() {
	// Get the full table of truth and iterate for each row
	for optionRow in PromoBanner.fullOptionTable {
		// Set up the mock object with the current row
		configureState(with: optionRow)
		testScenario(with: optionRow)
	}
}

private func configureState(with optionRow: PromoBanner.Row) {
	promoMock._isNewCustomer = optionRow.contains(.newCustomer)
	promoMock._isInternationalWomensDay = optionRow.contains(.isInternationalWomensDay)
	promoMock._isFemale = optionRow.contains(.isFemale)
}

private func testScenario(with optionRow: MarioBonusLevel.Row) {
	// The result from the manager
	let expectedResult = manager.shouldShowBanner
	// The result from the table of the truth
	let result = optionRow.result
	XCTAssertEqual(result, expectedResult, "Expected result \(expectedResult) instead \(result)")
}
  ```
  
## Inspiration
If you are interested in the followed approach, take a look at
- [Table Of The Truth](https://en.wikipedia.org/wiki/Truth_table)
- [Karnaugh map](https://en.wikipedia.org/wiki/Karnaugh_map)

---

## License

[![License](http://img.shields.io/:license-mit-blue.svg?style=flat-square)](http://badges.mit-license.org)

**[MIT license](http://opensource.org/licenses/mit-license.php)**
- Copyright 2018 © Annino De Petra
