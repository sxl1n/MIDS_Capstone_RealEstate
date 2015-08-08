#!/usr/bin/python

import sys 

g_zip_feature_scores = []


def ReadPersScores(a_zipPersScoresFilepath):
    global g_zip_feature_scores

    score_file = open(a_zipPersScoresFilepath, "r")
    header_line = score_file.readline().strip()
    header_fields = header_line.split(",")

    header_fields = [ ff.strip() for ff in header_fields ]

    feature_normalized_score_indices = {}

    ii = 0
    for ff in header_fields:
        if ff.startswith("N_"):
            feature_normalized_score_indices[ff[2:]] = ii
        ii += 1

    for one_line in score_file:
        score_fields = one_line.strip().split(",")
        score_fields = [ ff.strip() for ff in score_fields ]

        the_zip = score_fields[0]
        zip_score_map = {}
        for kk in feature_normalized_score_indices.keys():
            feature_index = feature_normalized_score_indices[kk]
            if score_fields[feature_index] == 'NA':
                zip_score_map[kk] = 'NA'
            else:
                zip_score_map[kk] = float(score_fields[feature_index])

        g_zip_feature_scores.append((the_zip, zip_score_map))

    score_file.close()


def CalcPersScore(a_featureWeights):
    zip_scores = {}
    for one_zip in g_zip_feature_scores:
        norm_scores = one_zip[1]
        score_sum   = 0
        score_count = 0
        for ff in a_featureWeights.keys():
            # print "Feature-name: ", ff
            if ff not in norm_scores:
                print "Warning: feature name '%s' not in data file." % ff
                continue

            if norm_scores[ff] != 'NA':
                feature_weight = float(a_featureWeights[ff])
                score_sum   += (feature_weight / 100.0) * norm_scores[ff]
                score_count += 1

        zip_scores[one_zip[0]] = score_sum / score_count if score_count > 0 else 0

    return zip_scores


def ServeRequests():
    user_input = "USER-INPUT"
    while user_input:
        user_input = raw_input("Enter feature-preferences as <feature-name:preference-level,feature-name:preference-level,...>: ").strip()

        if not user_input: continue

        user_fields = [ ff.strip() for ff in user_input.split(",") ]
        user_preferences = {}
        for ff in user_fields:
            feature_fields = ff.split(':')
            user_preferences[feature_fields[0]] = feature_fields[1]

        zip_scores = CalcPersScore(user_preferences)
        # print zip_scores

        scores_list = []
        for zz in zip_scores.keys():
            scores_list.append((zz, zip_scores[zz]))

        scores_list.sort(lambda zip1, zip2: 1 if zip1[1] < zip2[1] else -1)

        ii = 0
        for zz in scores_list:
            if ii > 9: break
            print "ZIP: %s, Score: %0.2f" % (zz[0], zz[1])
            ii += 1


if __name__ == "__main__":
    if len(sys.argv) != 2: 
        print >> sys.stderr, sys.argv[0], ":Usage:", sys.argv[0], "<zip-normalized-pers-score-file>"
        sys.exit(1)

    ReadPersScores(sys.argv[1])
    ServeRequests()

    sys.exit(0)

