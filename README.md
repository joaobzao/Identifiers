# iOS Accessibility Identifiers ♥️ Swift
#ios-tech
## What is an accessibility identifier 
An accessibility identifier is a string that identifies an UIView element. This identification is crucial to UI testing since it allows us to identify the UIView elements easily.
According to Apple documentation:
> An identifier can be used to uniquely identify an element in the scripts you write using the UI Automation interfaces. Using an identifier allows you to avoid inappropriately setting or accessing an element’s accessibility label.  

## How are we implementing it
Until now, the process to have an accessibility identifier in our project for a **single** UIView component was:
* Create a constant with the static name to be assigned later as an accessibility identifier.
* Assign that to the UIView accessibility identifier property.

**It seems a fairly easy task, and it is indeed. However if we multiply the work above by 100+ UIViews, it starts to feel a bit boring just to think about it.**

## Problem
* Tedious task
* Loads of boilerplate
* Easy to forget, impacts on UITesting
* Error prone: typo, point to wrong constant.

## Reflection to the rescue 🦸‍♂️
Using Mirror, the Swift reflection API, we can generate and assign identifiers automagically 🧙‍♂️

```swift
import UIKit

public protocol Identifiable {
    func generateAccessibilityIdentifiers()
}

public extension Identifiable {
    func generateAccessibilityIdentifiers() {
        let mirror = Mirror(reflecting: self)

        mirror.children.forEach { child in
            if
                let view = child.value as? UIView,
                let identifier = child
                    .label?
                    .replacingOccurrences(of: ".storage", with: "")
                    .replacingOccurrences(of: "$__lazy_storage_$_", with: "") {
                view.accessibilityIdentifier = "\(type(of: self)).\(identifier)"
            }
        }
    }
}

```

### How to use it?
From now on the only thing we need to do is to make our UIViews `Identifiable`  😃

Whenever we call the `generateAccessibilityIdentifiers()`  all `UIView`  objects in this class are going to have its accessibility identifier created and assigned automagically .

We can also override the `generateAccessibilityIdentifiers`  function in case we want to implement our custom accessibility identifiers.

```swift
public class RaceHeaderCollectionViewCell: BaseCollectionViewCell, Identifiable {
    // MARK: - Properties
    
    private let tvChannelImageView = UIImageView()
    private let raceStatusImageView = UIImageView()
    private let classLabel = UILabel(theme: LabelTheme.NextRace.Header.classLabel)
    private let marketLabel = UILabel(theme: LabelTheme.NextRace.Header.marketLabel)
    private let watchLiveButton = UIButton(theme: ButtonTheme.NextRace.Header.watchLive)
    private let startTimeLabel = UILabel(theme: LabelTheme.NextRace.Header.startTimeLabel)
    private let raceStatusLabel = UILabel(theme: LabelTheme.NextRace.Header.raceStatusLabel)
    
    // MARK: - Initialization
    
    override init(frame: CGRect) {
        super.init(frame: frame)

        setupLayout()

        generateAccessibilityIdentifiers()
    }
…
}
```

After `generateAccessibilityIdentifiers()` instruction we will have generated the following accessibility identifiers:
* `RaceHeaderCollectionViewCell.tvChannelImageView`
* `RaceHeaderCollectionViewCell.raceStatusImageView`
* `RaceHeaderCollectionViewCell.classLabel`
* `RaceHeaderCollectionViewCell.marketLabel`
* `RaceHeaderCollectionViewCell.watchLiveButton`
* `RaceHeaderCollectionViewCell.startTimeLabel`
* `RaceHeaderCollectionViewCell.raceStatusLabel`

Pattern 👉 `<class>.<field>`

We are using the class and field names to compose the accessibility identifier name, but we can opt for other pattern.

Check this simple playground with an example of the above [here](https://github.com/joaobzao/Identifiers/blob/master/Identifiable.playground/Contents.swift)

## Advantages
* Easy to use and adapt 
* Much faster to implement 
* Way better to identify if we are missing identifiers or not.
* Boilerplate reduced to a minimum, no need to create all those constants nor assign them for each UIView component.
* Less error prone and consistency. All identifiers will always use the same pattern, ex: class.fieldname

## To be aware
* Reflection has impacts on runtime. But since this is turned off for production builds, we don’t event need to bother.
* Current UITests using accessibility identifiers might have to be updated in case the newly adopted pattern doesn’t match with previous.
* `let labelList = [UILabel(), UILabel()]`   the implementation above won’t  generate identifiers for this use case but it is easy to adapt the identifiable mechanism and make it work by iterating through the list and assigning default incremental names (ex: class.listname.index)

## Coming next?
**Using property wrappers to easily add custom accessibility identifiers 💡**











