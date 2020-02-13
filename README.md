# Swift News App:

* This demo is built using MVVM architecture and use delegation design patten for message passing

* For Article list, I am using tableview with self sizing cells to display the news list. I have considered ‘title’ key for title and ‘thumbnail’ key for image. I also considered that if thumbnail width and height is not available than there is no image

* I have used SDWebImage for async image loading and caching and managed the dependancies using cocoapod.

* For details, I have used ‘selftext’ param to show article description and displayed it in textview. And used the thumbnail image for article image.

* I tried to modularised the code in a way that each layer has dependency injection and can be tested separately with minor change and mocking objects, however as of now, haven’t included any unit or integration testing in the project.

