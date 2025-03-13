# MazeRunner

## Project goals

The goal of this project is to fetch a list of mazes, download images associated with each maze object, and then solve the maze. In doing so, the user will be presented with an updated image showing the solution path.

## Project Priorities

The top priorities in developing this application are reliability and responsiveness. These outcomes were achieved in a few ways:

* Unit and integration tests were written alongside the code. This enabled the ability to make sure foundational elements of the application were not broken by later refactors and iterations of the codebase.
* An actor was used to process the images and solve the mazes, assuring that long processes did not hang the UI or prevent the user from continuing to interact with the app.
* The application meets Swift 6 Concurrency standards, helping eliminate data races at compile time.

## Time spent

This product was built over a period of about 10-11 hours. Time was split as follows:

* Initial network layer, image downloading, and models to process json were built, along with tests to assure their basic functionality would work through continued iteration of the application. ~1 hour.
* View code and navigation: Showing the fetched data and images in a list, navigating to a detail view, and showing a final solved image that gave the user the ability to zoom/pan the image in order to see the solution better on larger images. Tests were put in place to create assurance around data driven portions of the UI. ~2.5 hours.
* Error handling, localization, and accessibility: I wanted to make sure that users were properly alerted to when anything went unexpectedly, such as a network operation failing, or image data failing to load, so alerts were added to give users feedback. I also added string localization, so the app would be ready for internationalization. Though accessibility was not completely explored or implemented, all text uses dynamic type and will respond to accessibility sizes, while light/dark mode settings are also respected. A network monitor was also added, showing a banner at the top of the list view when the user has no network connectivity. ~1 hour.
* Image parsing and maze solving: this is where most of the time was spent. Images needed to be decomposed into pixel level data, analyzed for their color properties, and then a breadth-first search was performed on the data to solve the maze. A UIGraphicsImageRenderer was then used to draw the solution onto the maze image to present the final solution to the user. ~6 hours.

## Decisions and tradeoffs

* A breadth-first search (BFS) approach was taken. Some algorithms were ruled out earlier, since there was no weighting to any path within the maze, but BFS was chosen over depth-first search (or other approach) as it was more assured to find the shortest solution. Other approaches may have been more efficient or processed faster, but I chose the optimal solution path in this case.
* I chose to implement image processing task cancellation on a higher level, within the view model that called the processing code of the actor. This allowed for simpler code while still providing a functional application. In an application meant to run in a production environment, I would have employed the more complicated and fine-grained approach of adding task cancellation within the actor itself, to allow for cancellation of the task without having to finish a previous operation first. The cost to my approach is a long running task will have to finish before the process of a new maze can start if the user backs out of the maze solution page and opens another maze.
* The decision to use an actor gave me concurrency assurance mostly for free. It did, however, limit the possibility of concurrent operations (solving multiple mazes at once), and also contributes to the issues mentioned in my task cancellation approach above. The actor does provide simple and safe access to possible future features, though, such as persisting maze solutions within the actor, so mazes could be "re-solved" without re-processing.
* The app supports iOS 17+. This decision was made because current adoption of iOS 17 and 18 is [roughly 91% worldwide](https://mixpanel.com/trends/#report/ios_18), and allows the use of the newer `@Observation` methodology with SwiftUI. The tradeoff is that ~9% of users would not be able to run the application.

## Resources used

While writing this application, I referenced a few resources along the way.

* **Previously written code** - I have copied some code in from previous applications I have written, namely `NetworkViewModel.swift` and `Bundle+Extension.swift`. These are files I have used for years, to provide the basic functionality of detecting an active network connection and loading json files from the bundle for testing, respectively.
* **Past projects** - Years ago I worked on an application where an image of a leaf needed to be processed into pixel data, and each pixel was analyzed to determine its "green-ness" and advise on the health of the plant. I referenced this code to help me deconstruct the maze image as well as draw the solution on top of the image.
* [**Swift Algorithm Club**](https://github.com/kodecocodes/swift-algorithm-club) - This site is a collection of algorithms and data structures all written in Swift, and with explanations about the methodology of each. I consulted this when deciding on and implementing my path finding algorithm.
* [**Hacking with Swift**](https://hackingwithswift.com) - When Apple documentation, previous knowledge, or past projects doesn't provide me with the "how did I do this thing before", I leverage some of the info on this site to fill in the gaps. In this project, it was used to help resolve a panning issue with the zoom/pan functionality for my maze solution.
* **ChatGPT** - This was only used for generating testing data. When testing my image processing data, I wanted to create json to import for each separate phase. I used ChatGPT to take structured dictionary data printed out in the debug console and convert it to json.