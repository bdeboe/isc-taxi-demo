# The New York Taxi dataset, columnar style

This repository includes scripts to load New York Taxi trip datasets into InterSystems IRIS and leverages the new 2022.2 Columnar Storage option.

Note: Before loading this package, please verify you're running an IRIS release of 2022.2 or above and have a license that enables Columnar Storage (either Community Edition or Advanced Server).

## Setting up with IPM

1. Install the bdb-nytaxi module using [IPM](https://github.com/intersystems/ipm)

```ObjectScript
USER> zpm

zpm:USER> install bdb-nytaxi
```

   This will create the handful of tables used in the demo and populate them with the contents of the `./data` folder, which has a small sample of taxi ride data and the list of taxi zones referenced in the rides data.

2. Now download as many YellowCab trip data files as you'd like from the [City of New York Open Data portal](https://data.cityofnewyork.us/browse?Dataset-Information_Agency=Taxi+and+Limousine+Commission+%28TLC%29&) (use the "export" button and choose CSV). In case you're downloading the files from a different source, please make sure to verify if it has a header and the columns correspond to those in the `NYTaxi.Rides` table.

3. Run the following command to load:

    ```ObjectScript
    do ##class(NYTaxi.Utils).Load("/path/to/your/download")
    ```


## Setting up - oldschool

1. First download one or more YellowCab trip data files from the [City of New York Open Data portal](https://data.cityofnewyork.us/browse?Dataset-Information_Agency=Taxi+and+Limousine+Commission+%28TLC%29&) (use the "export" button and choose CSV) and store them in the `./data` subfolder of this repository. In case you're downloading the files from a different source, please make sure to verify if it has a header and the columns correspond to those in the `NYTaxi.Rides` table.

2. Import the contents of this repository into your InterSystems IRIS 2022.2+ instance. 

3. Run the following command to load:

    ```ObjectScript
    do ##class(NYTaxi.Utils).Load("/path/to/repo/data")
    ```

If you happen to have saved the trip data in a different location, just run the above method for both the trip data and the `./data` folder, which has the Taxi Zones information.

## Running the demo

First download the [DB-API driver for IRIS](https://intersystems-community.github.io/iris-driver-distribution/) (available as a .whl file) and then install it and a few additional Python packages using `pip`:

```shell
pip install /path/to/intersystems_irispython-3.2.0-py3-none-any.whl
pip install pandas numpy matplotlib
```

Now you can open `./src/python/demo.ipynb` in your Jupyter or Jupyter-lab instance and play the paragraphs!

There are several variants of the notebooks trying out different flavours of queries, but most should be self-explanatory after running through the main one. 

Note that the available global buffers (your database cache) may have a significant impact on how the queries behave. The `NYTaxi.RowRides` table (with row orientation) typically requires a lot more data to be read, so performance may fall quickly if the total dataset size loaded doesn't fit your cache (which is precisely one of the pitfalls Columnar Storage tries to address). Most timings you see in the uploaded notebooks were taken when data was fully cached.

## Feedback

Please file a GitHub issue if you run into anything unexpected.