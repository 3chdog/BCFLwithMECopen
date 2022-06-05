import os
from typing import List
import numpy as np
from sklearn.cluster import KMeans

from contractAPI import utils
from flwr.common.parameter import parameters_to_weights

def parameterGetter(modelPaths: List):
    for path in modelPaths:
        params = utils.readJson_to_parameters(path)
        yield params

def parameterCollector(modelPaths: List):
    return [parameters_to_weights(utils.readJson_to_parameters(model)) for model in modelPaths]

def calcNeiborsDistance(targetModel, allModels):
    dist = 0
    for model in allModels:
        for i in range(len(targetModel)):
            dist += np.linalg.norm(targetModel[i] - model[i])
    #print(dist)
    return dist

def calcNeiborsDistance_singlePoint(targetPoint, allPoints):
    dist = 0
    for point in allPoints:
        dist += np.linalg.norm(targetPoint - point)
    #print(dist)
    return dist


def countNumOfClose(targetPoint, centerPoints, threshold=0.3) -> int:
    cnt = 0
    for i in range(len(centerPoints)):
        dist = np.absolute(targetPoint - centerPoints[i])
        if dist/targetPoint < threshold: cnt += 1
    return cnt

def getDominantCenter(centerPoints, threshold=0.3) -> float:
    cnts = []
    for point in centerPoints:
        cnts.append(countNumOfClose(point, centerPoints, threshold))
    #print("cnts", cnts)
    dominantCenterIdx = int(np.argmax(cnts))
    return centerPoints[dominantCenterIdx].item()

def someCenterDists(allPoints, centerPoints, kmeansModel, samecnts_indexes):
    distsOfsomeCenters = []
    for idx in samecnts_indexes:
        centerClass = kmeansModel.predict([centerPoints[idx]])
        points_sameClass = []
        for i, point in enumerate(allPoints):
            if kmeansModel.labels_[i] == centerClass: points_sameClass.append(point)
        dist = calcNeiborsDistance_singlePoint(centerPoints[idx], points_sameClass)
        distsOfsomeCenters.append(dist)
    return distsOfsomeCenters

def getDominantCenter_minDist(allPoints, centerPoints, kmeansModel, threshold=0.3) -> float:
    cnts = []
    for point in centerPoints:
        cnts.append(countNumOfClose(point, centerPoints, threshold))
    #print("cnts", cnts) ##########

    # if there are multiple items with same counts (maximum # of count)
    samecnts_indexes = np.where(cnts == np.max(cnts))[0]
    #print("samecnts_idx", samecnts_indexes) #####
    dists = someCenterDists(allPoints, centerPoints, kmeansModel, samecnts_indexes)
    domainCenterIdx = samecnts_indexes[int(np.argmin(dists))]
    return centerPoints[domainCenterIdx].item()

def getDominantClasses(allPoints, centerPoints, kmeansModel, threshold=0.3) -> List:
    inDominantClasses = []
    #dominantCenter = getDominantCenter(centerPoints, threshold)
    dominantCenter = getDominantCenter_minDist(allPoints, centerPoints, kmeansModel, threshold)
    print("The domiCenter", dominantCenter) ##############
    for i in range(len(centerPoints)):
        dist = np.absolute(dominantCenter - centerPoints[i])
        #print("centerDist:", dist, dominantCenter)
        if dist/dominantCenter < threshold:
            label = kmeansModel.predict([centerPoints[i]])
            inDominantClasses.append(label.item())
    return inDominantClasses

def calcAllDistance(allModels, dataType="model"):
    if dataType == "model": allDist = [calcNeiborsDistance(model, allModels) for model in allModels]
    elif dataType == "point": allDist = [calcNeiborsDistance_singlePoint(model, allModels) for model in allModels]
    else: assert (dataType == "model") or (dataType == "point")
    return allDist

def getTargetIndexes(originLabels, targetLabels) -> List:
    resLabels = []
    for i, label in enumerate(originLabels):
        if label in targetLabels: resLabels.append(i)
    return resLabels

def getItems(srcList, targetIndexs) -> List:
    resList = []
    for idx in range(len(srcList)):
        if idx in targetIndexs: resList.append(srcList[idx])
    return resList

def Krum(path:str=None, modelsList:List=None, thresholdRatio:float=0.2) -> List:
    if path is None and modelsList is None: return None
    elif path is not None and modelsList is not None: return None
    if path is not None and modelsList is None:
        folderPath = path #'flower/models/batch0258'
        modelNames = os.listdir(folderPath)
        modelPaths = map(lambda mName: os.path.join(folderPath,mName), modelNames)
        modelPaths = list(modelPaths)
        modelsList = parameterCollector(modelPaths)
        print("There are {} models collected.".format(len(modelsList)))

    if len(modelsList)>10: n_clusters = 5
    elif len(modelsList)>1: n_clusters = 2
    else: n_clusters = 1

    distOfEachModels = np.array(calcAllDistance(modelsList))
    print("Each model's distance to other models:")
    print(distOfEachModels)
    distNpArray = distOfEachModels.reshape(-1,1)
    kmeans = KMeans(n_clusters=n_clusters, random_state=0).fit(distNpArray)
    print("kmean centers:\n", kmeans.cluster_centers_) ###########
    targetLabels = getDominantClasses(distOfEachModels, kmeans.cluster_centers_, kmeans, thresholdRatio)
    originLabels = kmeans.labels_
    targetLabels = np.array(targetLabels)
    targetIndexes = getTargetIndexes(originLabels, targetLabels)
    #targetIndexes = np.where(originLabels < 3)[0] ############## TODO
    print("Indexes of model left:", targetIndexes)
    dominantModels = getItems(modelsList, targetIndexes)
    print("There are {} models collected.".format(len(modelsList)))
    print("I Got those models left:",len(dominantModels))
    return dominantModels



if __name__=='__main__':
    folderPath = 'flower/models/batch1714'
    modelNames = os.listdir(folderPath)
    modelPaths = map(lambda mName: os.path.join(folderPath,mName), modelNames)
    modelPaths = list(modelPaths)
    #print(modelPaths)
    #print("\n\n")
    #modelGetter = parameterGetter(modelPaths)
    # for model in modelPaths[:1]:
    #     oneParams = parameters_to_weights(next(modelGetter))
    #     print(type(oneParams[0]))
    modelsCollected = parameterCollector(modelPaths)
    print(len(modelsCollected))
    print(modelsCollected[0][0].shape)

    calcNeiborsDistance(modelsCollected[0], modelsCollected)
    distList = calcAllDistance(modelsCollected)
    print(distList)
    distNpArray = (np.array(distList)).reshape(-1,1)
    kmeans = KMeans(n_clusters=5, random_state=0).fit(distNpArray)
    classes = kmeans.labels_
    _, counts = np.unique(classes, return_counts=True)
    print(counts)
    print(kmeans.labels_)

    print("All centers:")
    print(kmeans.cluster_centers_)

    centerNum = getDominantCenter(kmeans.cluster_centers_, 0.1)
    print("Dominant Center")
    print(centerNum)
    centerNumNP = (np.array([centerNum])).reshape(-1,1)
    # get the data with same label as theCenterIdx
    mylabel = kmeans.predict(centerNumNP)
    print(mylabel)
    print("Give me domain classes")
    targetLabels = getDominantClasses(distList, kmeans.cluster_centers_, kmeans, 0.1)
    originLabels = kmeans.labels_
    print(targetLabels)
    print(len(originLabels))
    print(originLabels)
    targetLabels = np.array(targetLabels)
    print(np.where(originLabels < 2)[0])
    newArray1 = distNpArray[np.where(originLabels < 3)[0]]
    print(newArray1)
    print("gaggggggggggggggg")
    
    
    modelFiltered = Krum('flower/models/batch1714')
    #print(modelFiltered)
    print("There are {} models collected.".format(len(modelsCollected)))
    print("I Got those models left:",len(modelFiltered))



