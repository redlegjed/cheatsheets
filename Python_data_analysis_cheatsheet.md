Python data analysis cheatsheet
======================================

A collection of python snippets for analysing and plotting data



Matplotlib plotting
---------------------

Basic plotting


    from matplotlib import pyplot as plt
    import numpy as np

    # Dark theme
    plt.style.use('dark_background')


    fpath = 'data.csv'
    data = np.recfromcsv(fpath, delimiter='\t')

    # Show array dimensions
    data.shape

    # show array columns
    data.dtype.names


    plt.figure(1)
    plt.plot(data['timestamp'],data['thermo'])

    plt.xlabel('Timestamp')
    plt.ylabel('Temperature sensor')
    plt.title('Graph of temperature over time')
    plt.show()
    
    
Customising the plot style

    plt.style.use({'axes.labelcolor':'58FAF4',
                    'axes.edgecolor': '58FAF4',
                    'axes.labelcolor': '58FAF4',
                'figure.facecolor': '2F2F2F',
                'figure.edgecolor': '58FAF4',
                'savefig.facecolor': '2F2F2F',
                    'savefig.edgecolor': '2F2F2F',
                'lines.color': '58FAF4',
                'patch.edgecolor': '58FAF4',
                'text.color':'red',
                'grid.color': '31343b',
                'xtick.color': '58FAF4',
                    'ytick.color': '58FAF4'})

    x = np.linspace(0,20)
    y1 = 0.75*np.sin(x) + 0.25 + 0.1*np.random.rand(x.size)
    y2 = 0.5*np.sin(x + 0.6*np.random.rand(x.size)) + 0.25 + 0.1*np.random.rand(x.size)
    y3 = 0.9*np.sin(x + 0.8*np.random.rand(x.size)) + 0.25 + 0.1*np.random.rand(x.size)
        

    fig,ax = plt.subplots()
    ax.plot(x,y1,'.-')
    ax.plot(x,y2,'*-')
    ax.plot(x,y3,'*-')
    ax.grid(True)
    ax.set_xlabel('x axis')
    ax.set_ylabel('y axis')
    ax.set_title('Custom style')

    plt.show(fig)

    
    
    
Bokeh plotting
------------------

Basic bokeh


    import numpy as np
    import pandas as pd

    from bokeh.plotting import figure, output_notebook, show
    from bokeh.models import ColumnDataSource

    output_notebook()

    source = ColumnDataSource(data=data[['dt_hrs','Thermo']])

    p = figure()
    p.circle(x='time', y='Temperature', source=source)

    show(p)
    
    
Holoviews
-----------------

Basic setup and theming

    import holoviews as hv

    hv.extension('bokeh', 'matplotlib')

    from bokeh.themes.theme import Theme

    theme = Theme(
        json={
    'attrs' : {
        'Figure' : {
            'background_fill_color': '#2F2F2F',
            'border_fill_color': '#2F2F2F',
            'outline_line_color': '#444444',
        },
        'Grid': {
            'grid_line_dash': [6, 4],
            'grid_line_alpha': .3,
        },
        
        'Axis': {
            'major_label_text_color': 'white',
            'axis_label_text_color': 'white',
            'major_tick_line_color': 'white',
            'minor_tick_line_color': 'white',
            'axis_line_color': "white"
        },
        'Legend':{
            'background_fill_color': 'black',
            'background_fill_alpha': 0.5,
            'location' : "center_right",
            'label_text_color': "white"
        }
    }
    })

    hv.renderer('bokeh').theme = theme

    
    
Example of plotting 3 curves

    %%output size=150 # Set output to 150% of normal size
    %%opts Curve  [height=300 width=600, show_grid=True, tools=['hover']] # plot options

    freezer  = hv.Curve( data, ('Timestamp'), ('freezer','Temperature [degC]'),label='Freezer')
    wall  = hv.Curve( data, ('Timestamp'), ('freezer_wall','Temperature [degC]'),label='Freezer wall')
    ambient  = hv.Curve( data, ('Timestamp'), ('ambient','Temperature [degC]'),label='Ambient')

    # Make the plot with 3 curves
    freezer*wall*ambient
    
    
