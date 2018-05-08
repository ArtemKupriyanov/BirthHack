# In[]:
# Import required libraries
import os
import pickle
import copy
import datetime as dt

import pandas as pd
from flask import Flask
from flask_cors import CORS
import dash
from dash.dependencies import Input, Output, State
import dash_core_components as dcc
import dash_html_components as html

import plotly.plotly as py
from plotly.graph_objs import *
import plotly.figure_factory as ff

import numpy as np
from sklearn.preprocessing import LabelEncoder
import json

from datetime import datetime, timedelta

app = dash.Dash(__name__)
app.css.append_css({'external_url': 'https://gist.githubusercontent.com/ArtemKupriyanov/b07a28331053b5d88296895ea35d5fc1/raw/be44c38bceddff96cf746d2012210baf39c399d4/stylesheet-oil-and-gas.css'})
#app.css.append_css({'external_url': 'styles.css'})
server = app.server
CORS(server)

if 'DYNO' in os.environ:
    app.scripts.append_script({
        'external_url': 'https://cdn.rawgit.com/chriddyp/ca0d8f02a1659981a0ea7f013a378bbd/raw/e79f3f789517deec58f41251f7dbb6bee72c44ab/plotly_ga.js'  # noqa: E501
    })
    
colors = list(reversed(['#481458', '#3c4c86', '#127a8d', '#00a385', '#42c26b', '#bcdb38', '#fbe233']))
          
#------------ Constructing map -----------

# Create global chart template
mapbox_access_token = 'pk.eyJ1IjoiamFja2x1byIsImEiOiJjajNlcnh3MzEwMHZtMzNueGw3NWw5ZXF5In0.fk8k06T96Ml9CLGgKmk81w'

# text of place information
PLACE_INFO_TEXT = '<b>{}</b>\n<br />\
Население: <b>{}</b>\n<br />\
Вместимость стадионов: <b>{}</b>\n<br />\
Максимальная воздушная пропускная способность: <b>{}</b>\n<br />\
Уровень пропускной способности: <b>{}</b>\n<br />'

match_english = {'Казань': 'Kazan', 
                 'Калининград': 'Kaliningrad', 
                 'Самара': 'Samara', 
                 'Ростов-на-Дону': 'Rostov-na-Donu', 
                 'Саранск': 'Saransk', 
                 'Санкт-Петербург': 'SPb',
                 'Волгоград': 'Volgograd', 
                 'Сочи':'Sochi',
                 'Нижний Новгород': 'Nizhny_Novgorod', 
                 'Екатеринбург': 'Ekaterinburg',
                 'Москва': 'Moscow'}
  
# Load data
df = pd.read_csv('./data/info_city.csv')

points = Data([
    Scattermapbox(
        lon=[str(float(df.loc[i]['long']) + 0.1)],
        lat=[str(float(df.loc[i]['lat']) + 0.1)],
        text=[PLACE_INFO_TEXT.format(df.loc[i]['city'],
                                     df.loc[i]['population'],
                                     df.loc[i]['stad_capacity'],
                                     df.loc[i]['capacity'],
                                     df.loc[i]['capacity_level'])],
        name=[str(df.loc[i]['city'])],
        customdata=[df.loc[i]['city']],
        mode='markers',
        marker=Marker(
            symbol='circle',
            size=14,
            color='#bed42c'
        ),
        showlegend=False
    ) for i in range(len(df))
])

# Set layout
map_layout = dict(
    colorscale='Viridis',
    autosize=True,
    height=1000,
    width=1900,
    margin=dict(
        l=0,
        r=0,
        b=0,
        t=0
    ),
    hovermode="closest",
    plot_bgcolor="#191A1A",
    paper_bgcolor="#FFFFFF",
    legend=dict(font=dict(size=10), orientation='h'),
    mapbox=dict(
        accesstoken=mapbox_access_token,
        bearing=0,
        center=dict(
            lat=54.71566,
            lon=45.55532
        ),
        pitch=0,
        zoom=4
    ),
)

#---------- Transform points into Dash style ---------------------

df_flight_paths = pd.read_csv('./data/flight.csv', index_col=None)
        
flight_paths = Data([
    Scattermapbox(
        lon = [ df_flight_paths['from_long'][i], df_flight_paths['to_long'][i] ],
        lat = [ df_flight_paths['from_lat'][i], df_flight_paths['to_lat'][i] ],
        mode = 'lines',
        line = dict(
            width = 1,
            color = 'rgb(190, 212, 44)',
        ),
        opacity = float(1.),
        showlegend=False
    ) for i in range(len(df_flight_paths))
])

map_figure = dict(data=points + flight_paths, layout=map_layout)

#------------------ Different statistics -------------------------

layout_individual = dict(
    autosize=True,
    height=200,
    width=500,
    margin=dict(
        l=35,
        r=35,
        b=35,
        t=35
    ),
    hovermode="closest",
    plot_bgcolor="#FFFFFF",
    paper_bgcolor="#FFFFFF",
)


# In[]:
# Create app layout
app.layout = html.Div(
    [
        html.Div(
            [
                html.H1(
                    ''
                ),
                html.Img(src="http://kupriyanov.me/birth_title.jpg",
                           style={
                               'height': '135px',
                               'float': 'right',
                               'position': 'absolute',
                               'bottom': '795px',
                               'left': '700px'
                           },
                ),
            ],
            style={'font-family': 'MyWebFont', 'text-align': 'center', 'height': '100px'},
            className='row'
        ),
        html.Div(
            [
                html.Div(
                    [
                        dcc.Graph(id='main_graph', 
                                  figure=map_figure),
                    ],
                    style={'margin-top': '20'}
                ),
                html.Div(
                    [
                        html.P('Возможна нехватка летательных средств в течение турнира: нет\n\n\n\n\n\n'),
                        html.P('Город имеет соединение с слишком малым числом городов: нет\n\n\n\n\n\n'),
                        html.P('Погодные условия: хорошие\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n'),
                        html.P('Популярность среди болельщиков: высокая\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n'),
                    ],
                    style={'position': 'absolute', 'bottom': '105px', 'right': '5px', 
                           'background-color': '#FFFFFF', 'width': '505px'}
                    #className='stats'
                ),
                html.Div(
                    [
                        dcc.Dropdown(
                            id='xaxis-column',
                            value='Общая посещаемость'
                        ),
                        dcc.Graph(id='graph_1')
                    ],
                    style={'position': 'absolute', 'bottom': '535px', 'right': '15px', 
                           'background-color': '#FFFFFF'}
                    #className='stats'
                ),
                html.Div(
                    [
                        dcc.Dropdown(
                            id='pie-menu',
                            value='1'
                        ),
                        dcc.Graph(id='graph_2')
                    ],
                    style={'position': 'absolute', 'bottom': '295px', 'right': '15px', 
                           'background-color': '#FFFFFF'}
                    #className='stats'
                ),
                html.Div(
                    [
                        dcc.Graph(id='graph_3'),
                        dcc.Slider(
                            id='flow-slider',
                            min=0,
                            max=7,
                            marks={i: '{} неделя'.format(i) for i in range(1, 7)},
                            value=5,
                        )
                    ],
                    style={'position': 'absolute', 'bottom': '165px', 'right': '1445px', 
                           'background-color': '#FFFFFF'}
                    #className='stats'
                ),
            ],
            className='row'
        ),
    ],
    style={'background-image': 'url(bkg.jpg)'}
)


# In[]:
# Create callbacks

# Main graph -> individual graph
@app.callback(Output('xaxis-column', 'options'),
              [Input('main_graph', 'clickData')])
def make_individual_bar_menu(main_graph_click):

    point = main_graph_click['points'][0]
    df_graph_1 = pd.read_csv('./data/preds_city/{}.csv'.format(match_english[point['customdata']]))
    available_indicators = ['Все страны'] + list(df_graph_1['team'].unique())
    options = [{'label': i, 'value': i} for i in available_indicators]
    return options
    
    
# Main graph -> individual graph
@app.callback(Output('graph_1', 'figure'),
              [Input('xaxis-column', 'value'),
               Input('main_graph', 'clickData')])
def make_individual_bar(xaxis_column_name, main_graph_click):

    point = main_graph_click['points'][0]
    
    if point['customdata'] == 'Москва':
        moscow_stat = [
            'moscow_broadcasting',
            'прилет/улет',
            np.array([8000, 14000, 43000, 22000, 43000, 21000, 46000, 23000, 41000, 21000, 48000, 31000, 50000, 21000, 59000, 
                      41000, 20000, 18000, 42000, 63000, 5000, 42000, 9000, 11000, 55000, 6000, 4000, 14000, 57000, 17000, 
                      17000, 16000, 18000, 56000, 8000]),
            'транзит',
            np.array([8000, 20000, 66000, 64000, 90000, 72000, 98000, 78000, 84000, 66000, 99000, 81000, 94000, 79000, 
                      124000, 90000, 70000, 52000, 70000, 90000, 37000, 60000, 20000, 40000, 81000, 23000, 16000, 
                      19000, 60000, 20000, 19000, 18000, 20000, 57000, 8000])
        ]

        start_d = np.datetime64(datetime(year=2018, month=6, day=12))
        stop_d = datetime(year=2018, month=7, day=18)

        trace1 = Bar(
            x=np.arange(start_d, stop_d, step=timedelta(days=1)),
            y=moscow_stat[2],
            name=moscow_stat[1],
            marker=dict(color='rgb(171,217,61)')
        )

        trace2 = Bar(
            x=np.arange(start_d, stop_d, step=timedelta(days=1)),
            y=moscow_stat[4] - moscow_stat[2],
            name=moscow_stat[3],
            marker=dict(color='#fbe233')
        )

        data = [trace1, trace2]
        layout_individual['barmode'] = 'stack'
    elif point['customdata'] == 'Санкт-Петербург':
        spb_data = np.array([
            0, 0, 4, 5, 14, 16, 26, 31, 26, 32, 18, 24, 18, 24, 26, 33, 26, 32, 18, 24, 18, 24, 26, 33, 26, 32, 17, 24, 17, 
            25, 26, 33, 26, 33, 14, 17, 9, 12, 14, 16, 26, 30, 26, 29, 14, 15, 5, 7, 0, 3, 0, 2, 4, 5, 14, 14.5, 26, 
            26.5, 26, 26.5, 16, 16.5, 13, 13.5, 26.5, 27, 26, 26.5, 14, 14
        ])

        start_d = np.datetime64(datetime(year=2018, month=6, day=12))
        stop_d = datetime(year=2018, month=7, day=18)

        piter_stat = [
            'piter_broadcasting',
            'прилет/улет',
            spb_data[::2],
            'транзит',
            spb_data[1::2]
        ]

        trace1 = Bar(
            x=np.arange(start_d, stop_d, step=timedelta(days=1)),
            y=piter_stat[2],
            name=piter_stat[1],
            marker=dict(color='rgb(171,217,61)')
        )

        trace2 = Bar(
            x=np.arange(start_d, stop_d, step=timedelta(days=1)),
            y=piter_stat[4] - piter_stat[2],
            name=piter_stat[3],
            marker=dict(color='#fbe233')
        )

        data = [trace1, trace2]
        layout_individual['barmode'] = 'stack'
    else:
        df_graph_1 = pd.read_csv('./data/preds_city/{}.csv'.format(match_english[point['customdata']]))
        
        available_indicators = ['Все страны'] + list(df_graph_1['team'].unique())
        if xaxis_column_name == 'Все страны' or xaxis_column_name not in available_indicators:
            x = df_graph_1['date']
            y = df_graph_1['val']
        else:
            x = df_graph_1[df_graph_1['team'] == xaxis_column_name]['date']
            y = df_graph_1[df_graph_1['team'] == xaxis_column_name]['val']
            
        data = [Bar(
            x=x,
            y=y,
            text=xaxis_column_name,
            marker=dict(color='rgb(171,217,61)')
        )]
        
    layout_individual['title'] = 'Количество людей в городе ' + point['customdata']

    figure = dict(data=data, layout=layout_individual)
    return figure


# Main graph -> individual graph
@app.callback(Output('pie-menu', 'options'),
              [Input('main_graph', 'clickData')])
def make_individual_pie_menu(main_graph_click):

    point = main_graph_click['points'][0]
    df_graph_2 = pd.read_csv('./data/preds_city/{}.csv'.format(match_english[point['customdata']]))
    available_indicators = list(df_graph_2['week'].unique())
    options = [{'label': '{} неделя'.format(i+1), 'value': i} for i in available_indicators]
    return options


# Main graph -> individual graph
@app.callback(Output('graph_2', 'figure'),
              [Input('pie-menu', 'value'),
               Input('main_graph', 'clickData')])
def make_individual_pie(week_num, main_graph_click):

    point = main_graph_click['points'][0]
    df_graph_2 = pd.read_csv('./data/preds_city/{}.csv'.format(match_english[point['customdata']]))
    if point['customdata'] != 'Москва':
        df_graph_2.drop('Unnamed: 0', axis=1, inplace=True)
    layout_individual['title'] = 'Национальный состав в городе ' + point['customdata']
    
    available_indicators = df_graph_2['week'].unique()
    
    dff = df_graph_2.groupby(['team', 'week']).val.sum().reset_index()
    if week_num not in available_indicators:
            week_num = 1

    labels=dff[dff['week'] == week_num]['team']
    data = [Pie(
        labels=dff[dff['week'] == week_num]['team'],
        values=dff[dff['week'] == week_num]['val'],
        text=week_num,
        marker=dict(colors=colors[:len(labels)])
    )]

    figure = dict(data=data, layout=layout_individual)
    return figure

    
@app.callback(Output('graph_3', 'figure'),
              [Input('flow-slider', 'value'),
               Input('main_graph', 'clickData')])
def make_individual_flow_graph(num_week, main_graph_click):
    
    point = main_graph_click['points'][0]['customdata']
    
    flow = json.load(open('./data/flow.json'))
    flow_passenger = flow[point]
    
    city_l = flow_passenger['city_l']
    city_r = flow_passenger['city_r']
    city = [point]
    dim_l = len(city_l)
    dim_r = len(city_r)
    flow_l = np.array(flow_passenger['flow_r']).T[int(num_week)-1].astype(np.int)
    flow_r = np.array(flow_passenger['flow_l']).T[int(num_week)-1].astype(np.int)
    flow = np.concatenate([flow_l, flow_r])
    
    enc = LabelEncoder()
    colors = enc.fit_transform(city_l + city + city_r)

    left_text = list(map(lambda i: [-3, -(dim_l-1)/2. + i], range(dim_l)))
    left_city = list(map(lambda i: [-2, -(dim_l-1)/2. + i], range(dim_l)))
    left_flow = list(map(lambda i: [-1, -(dim_l-1)/4. + i/2.], range(dim_l)))
    center = [[0, 0]]
    right_flow = list(map(lambda i: [1, -(dim_r-1)/4. + i/2], range(dim_r)))
    right_city = list(map(lambda i: [2, -(dim_r-1)/2. + i], range(dim_r)))
    right_text = list(map(lambda i: [3, -(dim_r-1)/2. + i], range(dim_r)))

    layt_text = np.array(left_text + right_text)    
    layt_city = np.array(left_city + center + right_city)
    layt_flow = np.array(left_flow + right_flow)

    left_edge = list(map(lambda i: [i, dim_l], range(dim_l)))
    right_edge = list(map(lambda i: [dim_l, i], range(dim_l+1, dim_l+dim_r+1)))
    E = left_edge + right_edge

    shapes = []
    for i, e in enumerate(E):
        shapes += [ dict(type='line',
                         x0=layt_city[e[0]][0],
                         y0=layt_city[e[0]][1],
                         x1=layt_city[e[1]][0],
                         y1=layt_city[e[1]][1],
                         line=dict(color='rgb(55, 128, 191)',
                                   width=flow[i]/flow.max()*5))]   
    
    trace0 = dict(x=[-2, 2],
                   y=[np.max(left_city) + 1, np.max(left_city) + 1],
                   text=['Из', 'В'],
                   mode='text',
                   textfont=dict(
                       family='sans serif',
                       size=20))
    
    trace1 = dict(x=layt_text.T[0],
                  y=layt_text.T[1],
                  text=city_l + city_r,
                  mode='text',
                 textfont=dict(
                       family='sans serif',
                       size=10))
    
    trace2 = dict(x=layt_city.T[0],
               y=layt_city.T[1],
               mode='markers',
               name='actors',
               marker=dict(symbol='dot',
                             size=15,
                             color=colors,
                             colorscale='Viridis',
                             line=Line(color='rgb(50,50,50)', width=0.5)
                             ),
               hoverinfo='none'
               )
    
    trace3 = dict(x=layt_flow.T[0],
                  y=layt_flow.T[1],
                  mode='markers',
                  name='actors',
                  marker = dict(symbol='dot',
                                size=1,
                                color='#FFFFFF',
                                line=Line(color='rgb(50,50,50)', width=0.5)
                               ),
                  text=flow,
                  hoverinfo='text')
    
    axis=dict(showbackground=False,
          showline=False,
          zeroline=False,
          showgrid=False,
          showticklabels=False,
          title=''
          )
    
    layout_flow = dict(
        title='Пассажиропоток в городе {}'.format(city[0]),
        autosize=True,
        height=600,
        width=425,
        showlegend=False,
        xaxis=axis,
        yaxis=axis,
        margin=dict(
            l=55,
            r=55,
            b=35,
            t=45
        ),
        shapes=shapes,
        hovermode="closest",
        plot_bgcolor="#FFFFFF",
        paper_bgcolor="#FFFFFF",
    )


    data = Data([trace0, trace1,  trace2, trace3])
    fig = Figure(data=data, layout=layout_flow)
    return fig

              
# In[]:
# Main
if __name__ == '__main__':
    app.server.run(debug=True, threaded=True)
