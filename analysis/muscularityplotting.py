import matplotlib.pyplot as plt
import seaborn as sns
import pandas as pd

def plot_validation_data(validation_df, dimension):
    
    if dimension == 'size':
        rating = 'size_rating'
        y_lab = 'Average size rating \n (1=not at all bulky, 5=extremely bulky)'
        title = "Model muscle size rating: How bulky are the model's muscles?"
        x_lab = 'Size level'
    elif dimension == 'detail':
        rating = 'detail_rating'
        y_lab = 'Average detail rating \n (1=not at all defined, 5=extremely defined)'
        title = "Model muscle detail rating: How defined are the model's muscles?"
        x_lab = 'Detail level'
    elif dimension == 'emaciation':
        rating = 'emaciation_rating'
        y_lab = 'Average emaciation rating \n (1=not at all visible, 5=extremely visible)'
        title = "Model emaciation rating: How visible is the model's bone structure?"
        x_lab = 'Emaciation level'
    else:
        raise ValueError("Invalid dimension")
    
    validation_grouped = validation_df[[dimension, rating, 'gender']].groupby([dimension, 'gender']).mean().reset_index()

    
    raw_data = {dimension: [0.0, 0.25, 0.50, 0.75],
            'female': list(validation_grouped[validation_grouped['gender']=='Female'][rating].round(2)),
            'male': list(validation_grouped[validation_grouped['gender']=='Male'][rating].round(2)),
           }

    df = pd.DataFrame(raw_data)
    
    pos = list(range(4))#create a list for the levels of s, d, &e
    width = 0.08 
    
    hex_colors = ['#A0AF84', '#634563']

    # Plotting the bars
    fig, ax = plt.subplots(figsize=(8,5))

    # Create a bar with pre_score data,
    # in position pos,
    plt.bar(pos, 
            #using df['pre_score'] data,
            df['male'], 
            # of width
            width, 
            # with alpha 0.5
            alpha=1.0, 
            # with color
            color=hex_colors[0], 
            # with label the first value in first_name
            label='Male') 

    # Create a bar with mid_score data,
    # in position pos + some width buffer,
    plt.bar([p + width for p in pos], 
            #using df['mid_score'] data,
            df['female'],
            # of width
            width, 
            # with alpha 0.5
            alpha=1.0, 
            # with color
            color=hex_colors[1], 
            # with label the second value in first_name
            label='Female') 


    # Set the y axis label
    ax.set_ylabel(y_lab)

    # Set the y axis label
    ax.set_xlabel(x_lab)

    # Set the chart's title
    ax.set_title(title)

    # Set the position of the x ticks
    ax.set_xticks([p + 0.5 * width for p in pos])

    # Set the labels for the x ticks
    ax.set_xticklabels(['0.0', '0.25', '0.5', '0.75'])

    # Setting the x-axis and y-axis limits
    plt.xlim(min(pos)-width, max(pos)+width*4)
    plt.ylim([0, 5])

    # Adding the legend and showing the plot
    plt.legend(['Male', 'Female'], loc='upper left')
    plt.tight_layout()
    #plt.grid()
    plt.show()
    
def plot_hist_by_sport(df, continuous_var, bins):
    df = df.dropna()
    
    run = list(df[df['sport'] == 'Running'][continuous_var])
    rc = list(df[df['sport'] == 'Rock climbing'][continuous_var])
    cf = list(df[df['sport'] == 'CrossFit'][continuous_var])

    # Assign colors for each airline and the names
    colors = ['#A0AF84', '#634563', '#FC7358']
    names = ['Running', 'Rock Climbing', 'CrossFit']

    # Make the histogram using a list of lists
    # Normalize the flights and assign colors and names
    plt.hist([run, rc, cf], bins = bins,
             color = colors, label=names)

    # Plot formatting
    plt.rcParams.update({'figure.figsize':(10,5), 'figure.dpi':100})
    plt.legend()
    plt.xlabel(continuous_var.capitalize())
    plt.ylabel('Count')
    plt.title('Distribution of {cv} by Sport'.format(cv=continuous_var.capitalize()))

def make_sport_pie_chart(df, sport, categorical_var):
    
    var_by_sport = df[['subj', 'sport',categorical_var]].groupby(['sport',categorical_var]).count().reset_index()
    all_levels = set(var_by_sport[categorical_var])
    
    sport_df = var_by_sport[var_by_sport['sport']==sport]
    sport_levels = set(sport_df[categorical_var])
    
    #If the sport does not have all the levels that the other sports have, add in a zero count for the missing levels
    if (all_levels != sport_levels) & (categorical_var != 'percent women'):

        missing_levels = list(all_levels.difference(sport_levels))

        missing_dict = [{'sport':sport, categorical_var:l, 'subj':0} for l in missing_levels]
        missing_df = pd.DataFrame(missing_dict)
        sport_df = pd.concat([sport_df, missing_df], sort=True)


    sport_df = sport_df.sort_values(by=categorical_var)
    
    x=sport_df[categorical_var]
    y=sport_df['subj']

    colors = ["#7d2841","#514626","#007469",
    "#629957",
    "#cf9ead",
    "#a0a252",
    ]
    percent = 100.*y/y.sum()

    patches, texts = plt.pie(y, colors=colors, startangle=90, radius=1.2)
    labels = ['{0} ({1:1.1f}%)'.format(i,j) for i,j in zip(x, percent)]

    sort_legend = True
    if sort_legend:
        patches, labels, dummy =  zip(*sorted(zip(patches, labels, y),
                                              key=lambda x: x[2],
                                              reverse=False))

    plt.legend(patches, labels, bbox_to_anchor=(0.1, 1.02, 1., .102), loc='lower left',
               ncol=2, mode="expand", borderaxespad=0., prop={'size': 12}, frameon=False)

    # View the plot
    plt.tight_layout()
    plt.show()
    #plt.savefig('piechart.png', bbox_inches='tight')