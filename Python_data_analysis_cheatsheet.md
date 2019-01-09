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
    

Using FFT
-----------

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
