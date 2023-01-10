# The New York Taxi dataset, columnar style

This repository includes scripts to load New York Taxi trip datasets into InterSystems IRIS and leverages the new [Columnar Storage](https://learning.intersystems.com/course/view.php?id=2112) option.

## Running the Docker containers

The Docker build scripts in this repository will load NY Taxi trip data for a single month (January 2020), after with the image reaches about 20GB. If you have enough disk space and patience (the single-month build easily takes 15mins on a decent laptop, assuming mine is decent), you can edit `Dockerfile` to download more data by uncommenting a few lines, or do it afterwards using the manual installation instructions below.

```Shell
docker-compose build
docker-compose up
```

Running the container will publish the Jupyter server on port 8888, so you can access it at http://localhost:8888/. See [below](#demo-notebooks) for more on the demo notebooks.


## Loading into your own instance

Note: Before loading this package, please verify you're running an IRIS release of 2022.2 or above and have a license that enables Columnar Storage (either Community Edition or Advanced Server).

### Setting up with IPM

Install the bdb-nytaxi module using [IPM](https://github.com/intersystems/ipm)

```ObjectScript
USER> zpm

zpm:USER> install bdb-nytaxi
```

This will create the handful of tables used in the demo and populate them with the contents of the `./data` folder, which has a tiny sample of taxi ride data and the list of taxi zones referenced in the rides data.


### Setting up - oldschool

1. Import the contents of this repository into your InterSystems IRIS 2022.2+ instance using `$SYSTEM.OBJ.Load()`. 

2. Run the following command to load:

    ```ObjectScript
    do ##class(NYTaxi.Utils).Load("/path/to/repo/data")
    ```

    If you happen to have saved the trip data in a different location, just make sure to also run the above method for both the trip data and the `./data` folder, which has the Taxi Zones information.

### Adding more data

You can download as many YellowCab trip data files as you'd like from the [City of New York Open Data portal](https://data.cityofnewyork.us/browse?Dataset-Information_Agency=Taxi+and+Limousine+Commission+%28TLC%29&) (use the "export" button and choose CSV). In case you're downloading the files from a different source, please make sure to verify if it has a header and the columns correspond to those in the `NYTaxi.Rides` table.

Alternatively, you can use the `src/python/download-trips-to-csv.py` script to download the files directly, passing the year and month for each file you'd like to load. The following commands download the data for January through March in 2020, which is what the demo notebooks are based on:

   ```Shell
   python download-trips-to-csv.py 2020 1 /path/to/your/download/
   python download-trips-to-csv.py 2020 2 /path/to/your/download/
   python download-trips-to-csv.py 2020 3 /path/to/your/download/
   ```

After downloading more CSV files, un the following command to load them into IRIS using `LOAD DATA`:

```ObjectScript
do ##class(NYTaxi.Utils).Load("/path/to/your/download")
```



### Setting up the Jupyter notebooks

First download the [DB-API driver for IRIS](https://intersystems-community.github.io/iris-driver-distribution/) (available as a .whl file) and then install it and a few additional Python packages using `pip`:

```shell
pip install /path/to/intersystems_irispython-3.2.0-py3-none-any.whl
pip install pandas numpy matplotlib
```

Then copy or point your notebook folder at the contents of the `./src/python/` directory of this repository.

## The demo notebooks

By now you should be ready to open `demo.ipynb` in your Jupyter or Jupyter-lab instance, edit your connection settings and play the paragraphs!

There are several variants of the notebooks trying out different flavours of queries, but most should be self-explanatory after running through the main one. 

:warning: The queries assume you loaded NY Taxi trip data for January through March 2020. If you loaded a different set of files, your results may differ from what's in the bundled notebooks.

Note that the available global buffers (your database cache) may have a significant impact on how the queries behave. The `NYTaxi.RowRides` table (with row orientation) typically requires a lot more data to be read, so performance may fall quickly if the total dataset size loaded doesn't fit your cache (which is precisely one of the pitfalls Columnar Storage tries to address). Most timings you see in the uploaded notebooks were taken when data was fully cached.

## Feedback

Please file a GitHub issue if you run into anything unexpected.