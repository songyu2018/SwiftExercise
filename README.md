# SwiftExercise
GasBuddy Mobile Take Home Exercise - Swift


How to run:

The App is using a temporary Flickr API KEY. Most likely it is expired when the App is being reviewed. Please follow the below steps 
to re-generate the API KEY.

1. Go to https://www.flickr.com/services/api/explore/flickr.photos.search
2. Put a keyword into the 'text' filed and make a search.
3. Once the request complete, go to the very bottom of the page and find the line starts with 'URL'
4. Copy the parameter 'api_key' from the URL.
5. Open the workspace 'GasBuddyTechInterview'
6. Search for the 'PhotoManager' class.
7. On the top of the file, replace the 'apiKey' with the copied 'api_key'


App functionality:

1. one the initial page, there is a text filed in the nevigation bar with placeholder text 'Search'. Type in keyworkds you want to
search for. The return size is limited to 100 from the API call.
2. Once the collection view populated, you can click on an image to bring up the detailed image view. An iPhone XS simulater is suggested
to use as other devices are not tested.
3. Rotate the screen to verify the layout change on the detailed iamge view.
