Python data analysis cheatsheet
======================================

A collection of python snippets for analysing and plotting data



# Matplotlib plotting


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

    
    
    
# Bokeh plotting


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
    
    

    
    


    
    
# Holoviews


Basic setup and theming

    
    import hvplot.pandas
    import holoviews as hv
    from bokeh.themes import built_in_themes
    hv.renderer('bokeh').theme = built_in_themes['dark_minimal']

    
    
Example of plotting 3 curves

    %%output size=150 # Set output to 150% of normal size
    %%opts Curve  [height=300 width=600, show_grid=True, tools=['hover']] # plot options
    
    # data is a pandas dataframe with 3 columns: Timestamp, freezer, freezer_wall

    freezer  = hv.Curve( data, ('Timestamp'), ('freezer','Temperature [degC]'),label='Freezer')
    wall  = hv.Curve( data, ('Timestamp'), ('freezer_wall','Temperature [degC]'),label='Freezer wall')
    ambient  = hv.Curve( data, ('Timestamp'), ('ambient','Temperature [degC]'),label='Ambient')

    # Make the plot with 3 curves
    freezer*wall*ambient
    
    
Example of plotting arrays

Here two arrays: x and y are used. They are referred to as 'x' and 'y', but the axis labels are 'x axis' and 'y axis'

    def f(x):
        return (x - 2) * x * (x + 2)**2

    x = np.linspace(-3,3)
    y = f(x)

    fx = hv.Curve((x, y), ('x','x axis'), ('y','y axis'))

    fx
    
    
Scatter plot specifying  marker, marker size, plot height & width, tools and y range. Assumes data source is a dataframe with columns 'x' and 'y'
    
    # Define scatter options
    # - marker is square shaped ('s')
    scatter_opts = hv.Options('Scatter',height=400, width=1000, tools=['hover'],size=5,marker='s')
    
    # Define y-axis to be from 0 to 10
    y_dim = hv.Dimension('y', label='Y values', range=(0,10))
    
    # Create plot 
    scatter_plot = hv.Scatter( df, ('x'), y_dim,label='My curve' ) 
    scatter_plot.opts(scatter_opts)
    
    

# Using FFT


Taking FFT of a cosine wave:

    import numpy as np
    import matplotlib.pyplot as plt

    plt.style.use('ggplot')
    
    # Setup parameters
    # =========================
    frequency_required_Hz = 2.0
    amplitude_linear = 1.0
    phase_angle_deg = 0.0
    N = 256
    dt_s = 0.01

    # Calculated paramaters
    # =========================
    df_Hz = 1/(N*dt_s)
    t_s = np.arange(N)*dt_s
    freq_Hz = np.round(frequency_required_Hz/df_Hz)*df_Hz
    print('Frequency = %.3f Hz' % freq_Hz)


    # Calculate signals
    # ===========================
    h = amplitude_linear*np.cos(2*np.pi*freq_Hz*t_s + phase_angle_deg*np.pi/180)

    # Take FFT and manually normalise by the sample number
    H = np.fft.fft(h)/N

    # Calculate mag and phase
    Hmag = np.abs(H)
    Hphase_deg = np.angle(H)*180/np.pi

    # Make frequency scale
    freq = np.fft.fftfreq(t_s.shape[-1],d=dt_s)

    print('Max magnitude = %.3f' % Hmag.max())


    # Plot time and freq domain
    # =================================

    fig, ax = plt.subplots(2,2,figsize=(12,10))

    # Time domain
    ax[0][0].plot(t_s,h)
    ax[0][0].set(xlabel='time (s)', ylabel='voltage (mV)',
	  title='Time domain')


    # Frequency domain magnitude
    ax[0][1].plot(np.fft.fftshift(freq), np.fft.fftshift(Hmag))
    ax[0][1].set(xlabel='frequency [Hz]', ylabel='Magnitude [linear]',
	  title='Frequency domain [Magnitude]')
    ax[0][1].set_xlim(-5,5)


    # Frequency domain phase
    ax[1][1].plot(np.fft.fftshift(freq), np.fft.fftshift(Hphase_deg))
    ax[1][1].set(xlabel='frequency [Hz]', ylabel='Phase [deg]',
	  title='Frequency domain [Phase]')
    ax[1][1].set_xlim(-5,5)


    plt.show()

    
    
# Pandas
-


Convert column to datetime object: If dates are in a column as strings/object

    df['date'] = pd.to_datetime(df['date'])
    

## SettingWithCopy Warning

This warning comes up when you have a statement like this:

    df.loc[label1][col1] = 3
    
It is better to use .loc for the complete assignment like this:

    df.loc[label1,col1] = 3
    
See 
https://pandas.pydata.org/pandas-docs/stable/user_guide/indexing.html#returning-a-view-versus-a-copy


