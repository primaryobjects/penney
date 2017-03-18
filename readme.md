JCPenny Store Closings - March 2017
-------------------------------

A simple data analysis and plot of 138 JCPenny store closings for March, 2017.

This project reads the official JCPenny store closing PDF file, extracts the list of store locations, and plots the results on a US state map.

## The Dataset

Data was collected from the official JCPenny store closing [PDF](http://www.jcpnewsroom.com/news-releases/2017/assets/0317_list_of_store_closures.pdf) file. A local copy is also [available](https://raw.githubusercontent.com/primaryobjects/penny/master/data/store_closures.pdf).

The dataset contains the following fields:

Mall/Shopping Center
City
State

Geo-location coordinates for latitude and longitude are obtained from a Google geo-coding API, based upon the store City and State. The number of store closures per state are shaded on the US map, with darker colors representing more closures within that state.

## Results

![March 2017 JCPenny Store Closures - Overview](https://raw.githubusercontent.com/primaryobjects/penny/master/images/jcpenny.png)

![March 2017 JCPenny Store Closures - Detailed](https://raw.githubusercontent.com/primaryobjects/penny/master/images/jcpenny-detail.png)

## References

[Yahoo Finance](http://finance.yahoo.com/news/138-jc-penney-stores-close-130436124.html)

[JCP Newsroom](http://www.jcpnewsroom.com/news-releases/2017/assets/0317_list_of_store_closures.pdf)

## Copyright

Copyright (c) 2017 Kory Becker http://primaryobjects.com/kory-becker

## Author

Kory Becker
http://www.primaryobjects.com