# Flickstagram

A photo viewing app for Flickr styled after Instagram.
An experiment with RxSwift.

You can view recent photos or search Flickr for photos.
All network calls and cache access is done on background threads. It uses both in memory and disk cache for the images. My iPhone 6 gets a pretty consistent 55-60 fps. 
The UI is a bit lacking, but it has the essential UX elements such as hiding the keyboard while scrolling and screen rotation support with Auto Layout.

## Setup
[Apply for a Flickr API key](https://www.flickr.com/services/apps/create/apply)

    Install Cocoapods
    Run `pod install` in directory
    open Flickr.xcworkspace
    Run project

### MVMM
I prefer the MVVM pattern to the standard MVC pattern. The view controller gets all the information needed to power the UI from the view model. In this simple case I pass the 
model from the view model into the view controller, but usually the viewcontroller does not interact with the model layer.
This helps solve the problem of large view controllers by moving everything not directly related to the view out of the view controller and into the view model.

### RxSwift
RxSwift helps us to write applications that are more composable and declarative by removing transient state. For the search in my project, my API provider watches the text field and my table view watches my api provider. When the text changes everything is automatically updated.

### Protocol Oriented Programming
Protocol oriented programming emphasizes the use of protocols as contracts and the use of value types over objects and inheritance. All non view elements are simple structs in this project. The Flickr photos api is backed by an protocol with methods that return observables. This gives us a lot of flexibility in providing the photos and makes the client agnostic about where they're coming from. They could be from the network, cache, database, or even mock data. The observable paradigm lets us easily combine multiple sources into one if needed and unifies error handling.
