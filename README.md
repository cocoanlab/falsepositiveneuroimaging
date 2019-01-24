## Data and code sharing for Hong et al., in press

Through this github repository, we will share data and code that support "False-positive neuroimaging: Undisclosed flexibility in testing spatial hypotheses allows presenting anything as a replicated finding" upon its publication. 

You can access preprint manuscript from [here](https://www.biorxiv.org/content/10.1101/514521v1)

## Overview
Scripts are separated by function, not by figures. To better understand the script, we have tabulated the scripts needed for each figure, and we added the results of each figure.


## Figure composition

Figure1  | Figure2 | Figure3 | Figure4 | Figure5 | 
---------| ------- | ------- | ------- | --------|
meta emotion maps.m| survey pie chart.m|peak pattern SNR sim.m|replication simulation scatter plot.m|permutation test for single peak.m|
example of issues in region level inference.m | survey result box violin plots.m | | illustration 3bar original replication.m |peaksconfidence region.m|
illustration 3bar original replication.m| cdfplot peak distances.m | | | multiple peaks MANOVA.m|
|||||pattern similarity test.m|
|||||classification test.m|


**Figure1**: Issues in testing replication using region-level and coordinate-based spatial models. 
![image](Figure1.png)



**Figure2**: Survey results.
![image](Figure2.png)



**Figure3**: Simulation 1.
![image](Figure3.png)



**Figure4**: Simulation 2. 
![image](Figure4.png)



**Figure5**: Recommendations.
![image](Figure5.png)





## Dependency


- [Matlab](https://www.mathworks.com)

- CANLab core tools

You can download the CANLab core tools using the following command line. 

	$ git_clone https://github.com/canlab/CanlabCore.git

