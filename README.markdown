Kal - a calendar component for the iPhone
-----------------------------------------

This project aims to provide an open-source implementation of the month view in Apple's mobile calendar app (MobileCal). When the user taps a day on the calendar, any associated data for that day will be displayed in a table view directly below the calendar. As a client of the Kal component, you have 2 responsibilities:

1. Tell Kal which days need to be marked with a dot because they have associated data.
2. Provide UITableViewCells which display the details (if any) for the currently selected day.

In order to use Kal in your application, you will need to provide an implementation of the KalDataSource protocol to satisfy these responsibilities. Please see KalDataSource.h and the included demo app for more details.

![http://cl.ly/image/1Q1E1M3z2R0h](http://f.cl.ly/items/3J2m0H2G3f2y3B45243F/monthView.png "Month View Image")
![http://cl.ly/image/0v2P002G3b18](http://f.cl.ly/items/291j073i1u0O3O0K0v1G/weekView.png "Week View Image")