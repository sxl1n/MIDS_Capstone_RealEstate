from urllib2 import Request, urlopen, URLError
from xml.etree import ElementTree
import csv

zip = (94010,94018,94019,94020,94021,94022,94027,94030,94037,94038,94041,94043,94044,94061,94063,94066,94070,94074,94085,94086,94102,94103,94107,94114,94116,94117,94122,94124,94127,94128,94132,94158,94301,94304,94305,94306,94401,94501,94502,94505,94506,94508,94509,94513,94514,94515,94517,94518,94519,94520,94523,94526,94527,94528,94531,94536,94538,94541,94544,94545,94548,94550,94551,94555,94558,94559,94560,94561,94562,94566,94567,94569,94573,94574,94576,94577,94579,94580,94581,94587,94588,94599,94603,94607,94612,94614,94617,94621,94662,94703,94704,94708,94709,94720,94804,94805,94901,94922,94923,94929,94931,94939,94951,94954,94957,94960,95001,95005,95007,95008,95010,95018,95019,95020,95021,95023,95024,95030,95032,95033,95037,95038,95041,95045,95046,95050,95052,95053,95062,95063,95065,95066,95073,95075,95077,95110,95112,95121,95124,95135,95138,95148,95154,95206,95207,95213,95215,95231,95240,95241,95242,95253,95258,95267,95269,95297,95304,95336,95376,95378,95401,95402,95403,95404,95405,95406,95419,95421,95430,95431,95433,95436,95439,95441,95444,95448,95450,95465,95471,95472,95473,95486,95487,95492)

api = 'APIKeyHere'

overallSchoolDict = {}
for i in zip:
  url_str = 'http://api.greatschools.org/schools/nearby?key=' + str(api) + '&state=CA&zip=' + str(i)
  request = Request(url_str)
  response = urlopen(request)
  output = response.read()
  tree = ElementTree.fromstring(output)
  for school in tree:
    schoolDict = {}
    schoolDict['gsId'] = school.find('gsId').text
    schoolDict['name'] = school.find('name').text
    schoolDict['gradeRange'] = school.find('gradeRange').text
    schoolDict['type'] = school.find('type').text
    schoolDict['address'] = school.find('address').text
    overallSchoolDict[school.find('name').text] = schoolDict
  print i


print len(overallSchoolDict.keys())

for key in overallSchoolDict.keys():
  print overallSchoolDict[key]['gsId']
  print len(overallSchoolDict[key]['gsId'])

with open('schools.csv', 'w') as csvfile:
  fieldnames = overallSchoolDict['San Antonio Elementary School'].keys()
  writer = csv.DictWriter(csvfile, fieldnames=fieldnames)
  writer.writeheader()
  for key in overallSchoolDict.keys():
    writer.writerows(overallSchoolDict[key])


for key in overallSchoolDict.keys():
  zipcode = overallSchoolDict[key]['address'][-5:]
  print overallSchoolDict[key]['gsId'] + ',' + overallSchoolDict[key]['name'] + ',' + overallSchoolDict[key]['gradeRange'] + ',' + overallSchoolDict[key]['type'] + ',' + zipcode


for key in overallSchoolDict.keys():
  print overallSchoolDict[key]['address'][-5:]
