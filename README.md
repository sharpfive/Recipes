### Summary: Include screen shots or a video of your app highlighting its features
This is a test project to grab a list of recipes. It uses SwiftUI, SwiftConcurrency, & Swift Testing. It shows a list of recipes. 

![image](https://github.com/user-attachments/assets/15bdfa76-1f52-48f4-8484-3282458bc02e)

### Focus Areas: What specific areas of the project did you prioritize? Why did you choose to focus on these areas?

I focused on making the app testable, by injecting more of each classes dependencies. I also made sure there were no duplicated file or network access.

### Time Spent: Approximately how long did you spend working on this project? How did you allocate your time?
~8 hours 

- 1 hour to get a working network response displayed
- 1 hour setting up Previews based on json files
- 1 hour refactoring Views 
- 1 hour hardening to remove duplicated file and network access
- 4 hours creating the unit tests, and refactors to support testability

### Trade-offs and Decisions: Did you make any significant trade-offs in your approach?

Given the time constraints, there there are plenty of areas to improve before calling this production ready. Here are some significant areas to improve.

#### Json files in the main bundle
The Previews for RecipeView display based on the json provided. There is a lot of power in giving immediate feedback by showing json-to-view during development. But we don't want to ship json files in our main bundle. Potential fixes:
1. Create stub objects in code. Simple, but too time consuming for this exercise.
2. Convert json to strings that can be conditionally compiled (#IF DEBUG)
3. Host json files in a separate bundle that can be conditionally included while developing.

#### Error handling from image network failures
We are returning nil in the cases where something goes wrong with an image request. This may be acceptable. But it is not clear what a better approach would be. Retries are probably overkill. Displaying an error image isn't an obvious improvement either.

#### Move Recipe mapping logic out of ViewModel
`makeRecipeFromDTO`
This could be done elsewhere. But with such a simple project, there isn't a clear location. And involved mapping logic can be a source of brittle boilerplate.

#### Performance improvement by returning the image from ImageCache before persisting to disk. 
As mentioned in the comments the performance is currently fast on an iPhone 12 mini. Options considered:
1. Create a Task for the file persistence. This leads to potential concurrency issues. We don't have control on the order Tasks are run. In this case, I don't think there is an immediate bug (MainActor isolation of ImageCache should prevent that). But it is something that could be introduced down the road, and would be difficult to detect. Firing off a Task in a method also introduces more complexity in the unit tests.
2. Create a queue for file persistence. This would enforce the operations were handled in the correct order. This would also make testing more difficult.


### Weakest Part of the Project: What do you think is the weakest part of your project?

#### UI
UI is bare bones. But gets the job done. Anything I tried with padding made it look worse, so I kept it simple. There are many duplicated elements that could be extracted into a more coherent design system.

### Additional Information: Is there anything else we should know? Feel free to share any insights or constraints you encountered.
#### DI
We are using manual DI techniques. But not done at a comprehensive level. These scale pretty far. These implementations were done to get us to an acceptable level of test readiness. More could be done. Most of the ugly setup code is moved to Factory classes. But there is more setup than I'd like in the RecipesViewModel, due to the small nature of the project. I may have jumped through too many hoops to avoid explicitly unwrapping optionals (!) in the main bundle. But I allowed some in the test project.

#### MainActor
There are a number of types that are isolated to MainActor. Including some types that could be used off MainActor in other applications (e.g. ImageChache). This is intentional. Many devs introduce performance problems by jumping through hoops to avoid doing work on the Main thread. Switching threads is often more resource consuming than just doing the work on the main thread. That said, everything that occurs on the main thread should be fast. File system access was isolated to the FileSystemActor.


#### Test Coverage
Test coverage is 84%, but not comprehensive. I've added comments to some places where more tests could be written. Along with ideas on what would be needed. The tests are not expected to be difficult, but would take more time than would make sense for a simple project.

The ViewModel test are a good example of Detroit style tests that test interactions of a number of classes. Only the lowest level of dependencies are stubbed. The resulting tests focus on business level concepts. The goal is to test outcomes rather than interactions.

There are tests using the test data provided. They are in the main bundle to allow sharing with the View Previews. This is another of improvement.

In most cases I've tried to have one assertion/expect per test. This is uncommon in iOS test suites. But it a long standing best practice that improves visibility on what is failing. Especially when viewing test logs in CI. In any case, it's a good practice to encourage more refactoring of test setup code. Test code quality matters too.

I'm still getting a feel for how to write comprehensive unit tests suites with Swift Testing, especially when using actor isolated types. I like the Swift Testing encourages smaller, focused test files. But Apple's recommendations of hydrating the objects in the initializer doesn't seem scalable. In any case, I tried a number of techniques that seem promising. Both lazy initialization of dependencies, and hydrating the System Under Test (sut) in a method worked well with dependencies that have different isolation.

In some cases, I've gotten tests to compile by isolating the stub classes differently than the classes they represent. This is an area to investigate for improvements. These types of hack may be unnecessary by isolating the Test classes differently. But I haven't explored that fully.
