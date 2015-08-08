import pandas as pd
from sklearn.metrics.pairwise import euclidean_distances
import numpy as np

def zip_distance(given_zip, given_pref, target_zips):
    fileName = "merged_fat.csv"
    df = pd.read_csv(fileName)
    df = df.dropna(subset=df.columns[-5:])

    given_zip_data = df[df['zip'] == given_zip]

    zip_dist = euclidean_distances(df.values, given_zip_data.values)
    dist_list = zip_dist.reshape(df.shape[0],)
    print dist_list
    zip_list = df.ix[:,0].astype(int)
    zip_dist_dict = dict(zip(zip_list, dist_list.T))
    return zip_dist_dict

if __name__ == "__main__":
    zip_scores = zip_distance(94133, 1, 1)
    print zip_scores

