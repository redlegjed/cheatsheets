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