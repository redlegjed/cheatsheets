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