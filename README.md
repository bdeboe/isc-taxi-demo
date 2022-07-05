# The New York Taxi dataset, columnar style

This repository includes scripts to load New York Taxi trip datasets into InterSystems IRIS and leverages the new 2022.2 Columnar Storage option. 

## Setting up

1. First download one or more YellowCab trip data files from the [City of New York Open Data portal](https://data.cityofnewyork.us/browse?Dataset-Information_Agency=Taxi+and+Limousine+Commission+%28TLC%29&) (use the "export" button and choose CSV) and store them in the `/data` subfolder of this repository. In case you're downloading the files from a different source, please make sure to verify if it has a header and the columns correspond to those in the `NYTaxi.Rides` table.

2. Import the contents of this repository into your InterSystems IRIS 2022.2+ instance. 

3. Run the following command to load:

    ```ObjectScript
    do ##class(NYTaxi.Utils).Load("/path/to/repo/data")
    ```

If you happen to have saved the trip data in a different location, just run the above method for both the trip data and the `/data` folder, which has the Taxi Zones information.

## Running the demo

Open `/src/python/demo.ipynb` in your Jupyter or Jupyter-lab instance and play the paragraphs!
There are several variants of the notebooks trying out different flavours of queries, but most should be self-explanatory after running through the main one. 

Note that the available global buffers (your database cache) may have a significant impact on how the queries behave. The `NYTaxi.RowRides` table (with row orientation) typically requires a lot more data to be read, so performance may fall quickly if the total dataset size loaded doesn't fit your cache (which is precisely one of the pitfalls Columnar Storage tries to address). Most timings you see in the uploaded notebooks were taken when data was fully cached.

## Feedback

Please file a GitHub issue if you run into anything unexpected.