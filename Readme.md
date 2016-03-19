** CoolShots on iOS *
=====================

A miniature client for Imgur that fetches images based on a given search query.

Features:
————————

1. Thumbnail pre-loading when fetching a large number of images (25+)
2. Asynchronous image fetching to not stall the main thread and damage UI responsivity
3. Paging as the user scrolls (You can scroll forever. Literally.)
3. Cool loading animation of the full image
4. Caching (with the user’s ability to decide not to cache a downloaded image)
5. Search History
6. Crash-less (Maybe add Crashlytics if I had more time?)
7. Kept the UI as minimalistic as possible (yes white is my fav color).

—

Given more time (another 24 hours) I would have:

1. Fixed the bug where sometimes the UICollectionViewCell may not be 100% responsive. 
2. Added a section to display all cached images and uncache desired ones
3. Display more data alongside image
4. !Analytics! (upload history to my server and analyze trends to show suggested images by default).

-

Enjoy!