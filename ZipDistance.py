import pandas as pd
from sklearn.metrics.pairwise import euclidean_distances

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

if __name__ == "__main__":
    bay_zip_data = pd.read_csv("zip_code_database_bay_area.csv")
    bay_zips = bay_zip_data.zip.values
    zip_scores = zip_distance(92663, bay_zips)

    zip_scores_ordered = sorted(zip_scores.items(), key=lambda z: z[1])
    print zip_scores_ordered

zip_scores = zip_distance(92663, filtered_zips)