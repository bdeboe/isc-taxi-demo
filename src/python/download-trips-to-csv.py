import pandas as pd
import sys, requests, os

def download_and_convert(year : int, month : int, directory : str = "/opt/irisbuild/data/"):
    filename = "yellow_tripdata_"+str(year)+"-"+(str(month) if (month >= 10) else ("0"+str(month)))
    url = "https://d37ci6vzurychx.cloudfront.net/trip-data/"+filename+".parquet"
    print('Downloading from URL: '+url)
    get_response = requests.get(url, stream=True)
    if (get_response.status_code != 200):
        print('Error retrieving file: HTTP '+str(get_response.status_code))
        return
    parquet_file  = directory + filename + ".parquet"
    with open(parquet_file, 'wb') as f:
        for chunk in get_response.iter_content(chunk_size=1024):
            if chunk: # filter out keep-alive new chunks
                f.write(chunk)
    print('Converting Parquet to CSV...')
    df = df = pd.read_parquet(directory+filename+".parquet")
    df.to_csv(directory+filename+".csv", index = False)
    print('Done with '+directory+filename+".csv")
    os.remove(parquet_file)

if __name__ == "__main__":
    if (len(sys.argv) > 3):
        download_and_convert(int(sys.argv[1]), int(sys.argv[2]), str(sys.argv[3]))
    else:
        download_and_convert(int(sys.argv[1]), int(sys.argv[2]))
        