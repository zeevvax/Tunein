# Tunein
Install:

>>> pod install
Open workspace

Structure:

The model has 3 types of elements:
Audio - End node that has audio URL
List - list of links
Children - an element with a list of elements

The UI:

MainViewController - has a top list of links (starting URL)
The MainViewController either add a ListViewController or CollectionViewController as child VC

ListViewController - A table view controller with a list of links or audio elements
CollectionViewController - Show three collection views with up to 5 entries, and a show all  button to see the full list (I only saw up to 3 children elements in all the links I looked at so I assumed that the max possible)
When clicking an audio link it shows a message with the URL

Known issues (Sorry, run out of time to debug them):
There are constraints warnings on the stack views, but the views display correctly.


