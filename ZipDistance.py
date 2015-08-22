import pandas as pd
from sklearn.metrics.pairwise import euclidean_distances
from sklearn.cluster import KMeans
import csv
import numpy as np

def zip_distance(given_zip, target_zips):
    fileName = "merged_fat.csv"
    df = pd.read_csv(fileName)
    df_targets = df[df.zip.isin(target_zips)]

    given_zip_data = df[df.zip == given_zip]

    zip_dist = euclidean_distances(df_targets.values, given_zip_data.values)
    dist_list = zip_dist.reshape(df_targets.shape[0],)

    zip_list = df_targets.ix[:,0].astype(int)
    zip_dist_dict = dict(zip(zip_list, dist_list.T))
    return zip_dist_dict

def zip_similarity(given_zip, target_zips):
    fileName = "merged_fat.csv"
    df = pd.read_csv(fileName)
    df_targets = df[df.zip.isin(target_zips)]

    given_zip_data = df[df.zip == given_zip]

    zip_dist = euclidean_distances(df_targets.values, given_zip_data.values)
    dist_list = zip_dist.reshape(df_targets.shape[0],)
    sim_list = np.around(1 / ((1 + dist_list)/(1 + dist_list.min())) * 100)

    zip_list = df_targets.ix[:,0].astype(int)
    zip_sim_dict = dict(zip(zip_list, sim_list.T))
    return zip_sim_dict

def zip_clusters(target_zips):
    fileName = "merged_fat.csv"
    df = pd.read_csv(fileName)
    df_targets = df[df.zip.isin(target_zips)]

    model = KMeans()
    labels = model.fit_predict(df_targets.values)
    #print labels

    labels_2 = labels.reshape(df_targets.shape[0],)
    #print labels_2

    zip_list = df_targets.ix[:,0].astype(int)
    zip_cluster_dict = dict(zip(zip_list, labels_2.T))
    #print zip_cluster_dict
    return zip_cluster_dict

if __name__ == "__main__":
    target_zip_data = pd.read_csv("zip_code_database_phx.csv")
    target_zips = target_zip_data.zip.values

    area_clusters = zip_clusters(target_zips)

    #cluster_writer = csv.writer(open('phx_8.csv', 'wb'))
    #for key, value in area_clusters.items():
    #    cluster_writer.writerow([key, value])

    zip_scores = zip_distance(85254, target_zips)

    zip_scores_ordered = sorted(zip_scores.items(), key=lambda z: z[1])
    print zip_scores_ordered

    #writer = csv.writer(open('dtw85254.csv', 'wb'))
    #for key, value in zip_scores.items():
    #    writer.writerow([key, value])

