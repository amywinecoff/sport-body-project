# The Sport Body Project 
## An analysis of sport-specific body preferences

The data, stimuli, and analysis contained in this repo are a part of a research effort to understand if participation in sports
with different functional demands--running, rock climbing, and CrossFit--is associated with different body preferences. Specifically,
this research addresses whether female participants' ideal bodies (or ideal female partners, for men) vary in thinness (emaciation),
leanness (muscular detail), and muscularity (muscular size) between sports. 

Male and female participants answered questions about their sports participation and demographics then participanted in 
a body decision task. In this task, participants were asked to choose which of two bodies more closely resembled their
ideal body (or ideal body for a female partner, for men). In all decisions, one of the bodies had a baseline level
of emaciation, musuclar detail, and muscular size. The "baseline" body looked like this:

![Image of Baseline Model](https://github.com/amywinecoff/sport-body-project/blob/master/methods/stimuli/decision_stimuli/baseline_example.jpg)

In each choice, the other body varied along the dimensions of emaciation, muscular detail, and size. Each dimension could assume one of four levels (0.0, 0.25, 0.50, and 0.75). Here's an example of a "test" body with an emaciation level of 0.5, a detail level of 0.5, and a size level of 0.5:

![Image of Test Model](https://github.com/amywinecoff/sport-body-project/blob/master/methods/stimuli/decision_stimuli/test_example.jpg)

After completing the body decision task, participants responded to survey questions to assess their level of disordered eating, drive for muscularity, drive for leanness, and functional versus asthetic body image values.

Results indicate that women who participate in CrossFit were more likely to choose bodies with higher levels of muscular size and detail than runners or rock climbers. In contrast, runners and rock climbers were more likely to choose bodies with higher levels of emaciation than CrossFitters. 

Using the trained model parameters, here's how the level of each of the three body dimensions affected the predicted probability of choosing the "test" image within each of the sports:

![Image of Baseline Model](https://github.com/amywinecoff/sport-body-project/blob/master/analysis/women_dim_pred.png)

All the data for this project, including survey responses, sport participation responses, and other body ratings data are located in the [data folder](https://github.com/amywinecoff/sport-body-project/tree/master/data) in this repo. The [stimuli folder](https://github.com/amywinecoff/sport-body-project/tree/master/methods/stimuli) contains the questionnaires as well as all the body images. The [description folder](https://github.com/amywinecoff/sport-body-project/tree/master/methods/description) contains a more detailed description of the study methodology and the survey instruments. 

