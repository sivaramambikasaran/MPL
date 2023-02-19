import numpy as np
import copy
import matplotlib.pyplot as plt

K       =   20;
M       =   200;
D_scale =   20;

class player:
    # Holds the player data
    def __init__(self, name):
        self.name           =   name;
        self.elo            =   1500;
        self.wins           =   0;
        self.loss           =   0;
        self.games          =   0;
        self.wpoints        =   0;  # Points won
        self.wpoints_winning=   0;  # Points won when winning the game
        self.wpoints_losing =   0;  # Points won when losing the game
        self.cpoints        =   0;  # Points conceded
        self.cpoints_winning=   0;  # Points conceded when winning the game
        self.cpoints_losing =   0;  # Points conceded when losing the game
        self.winpercent     =   0;

    def compute_winpercent(self):
        self.winpercent = (100.0*self.wins)/self.games;

    def display(self):
        print(self.name,"\t",int(self.elo),"\t",self.games,"\t",self.wins,"\t",self.loss,"\t",self.wpoints,"\t",self.cpoints,"\t",int(self.winpercent));
# class game:
#     # Game data

def game_update(game,player_object):
    w1 = players.index(game[0]);
    w2 = players.index(game[1]);
    l1 = players.index(game[2]);
    l2 = players.index(game[3]);

    player_object[w1].wins      =   player_object[w1].wins+1;
    player_object[w2].wins      =   player_object[w2].wins+1;
    player_object[l1].loss      =   player_object[l1].loss+1;
    player_object[l2].loss      =   player_object[l2].loss+1;
    
    player_object[w1].games     =   player_object[w1].games+1;
    player_object[w2].games     =   player_object[w2].games+1;
    player_object[l1].games     =   player_object[l1].games+1;
    player_object[l2].games     =   player_object[l2].games+1;
    
    score = int(game[4]);
    player_object[w1].wpoints_winning   =   player_object[w1].wpoints_winning+max(score+2,21);
    player_object[w2].wpoints_winning   =   player_object[w2].wpoints_winning+max(score+2,21);
    player_object[l1].wpoints_losing    =   player_object[l1].wpoints_losing+score;
    player_object[l2].wpoints_losing    =   player_object[l2].wpoints_losing+score;

    player_object[w1].cpoints_winning   =   player_object[w1].wpoints_winning+score;
    player_object[w2].cpoints_winning   =   player_object[w2].wpoints_winning+score;
    player_object[l1].cpoints_losing    =   player_object[l1].wpoints_losing+max(score+2,21);
    player_object[l2].cpoints_losing    =   player_object[l2].wpoints_losing+max(score+2,21)

    player_object[w1].wpoints    =   player_object[w1].wpoints+max(score+2,21);
    player_object[w2].wpoints    =   player_object[w2].wpoints+max(score+2,21);
    player_object[l1].wpoints    =   player_object[l1].wpoints+score;
    player_object[l2].wpoints    =   player_object[l2].wpoints+score;

    player_object[w1].cpoints    =   player_object[w1].cpoints+score;
    player_object[w2].cpoints    =   player_object[w2].cpoints+score;
    player_object[l1].cpoints    =   player_object[l1].cpoints+max(score+2,21);
    player_object[l2].cpoints    =   player_object[l2].cpoints+max(score+2,21);

    T1      =   0.5*(player_object[w1].elo+player_object[w2].elo);
    T2      =   0.5*(player_object[l1].elo+player_object[l2].elo);
    
    
    strong_elo  =   0.5*K*np.exp(-abs(T1-T2)/M)*np.exp(-score/D_scale);

    weak_elo    =   K*np.exp(-score/D_scale)-strong_elo;

    if (T1>T2):
        player_object[w1].elo   =   player_object[w1].elo+strong_elo;
        player_object[w2].elo   =   player_object[w2].elo+strong_elo;
        player_object[l1].elo   =   player_object[l1].elo-strong_elo;
        player_object[l2].elo   =   player_object[l2].elo-strong_elo;
    else:
        player_object[w1].elo   =   player_object[w1].elo+weak_elo;
        player_object[w2].elo   =   player_object[w2].elo+weak_elo;
        player_object[l1].elo   =   player_object[l1].elo-weak_elo;
        player_object[l2].elo   =   player_object[l2].elo-weak_elo;

    
    player_object[w1].compute_winpercent();
    player_object[w2].compute_winpercent();
    player_object[l1].compute_winpercent();
    player_object[l2].compute_winpercent();
# namefile    =   open("player_name.csv", "r");
# names       =   namefile.read().split(',');

def create_plot():
    plotcolor = ['blue', 'green', 'red', 'magenta', 'black'];
    f, axes     = plt.subplots(1,2,dpi=1000);
    plt.subplots_adjust(left=0.1, bottom=0.1, right=0.9, top=0.9, wspace=0.4, hspace=0.4);
    topnames    = [];
    botnames    = [];
    counttop    = 0;
    countbot    = 0;

    for k in range(n+1):
        game_analytics = game_history[k];
        for j in range(2,12):
            if player_object[j].elo > 1500:
                axes[0].plot(k,game_analytics[j].elo,color=plotcolor[counttop%5], marker='.');
                counttop = counttop+1;
            else:
                axes[1].plot(k,game_analytics[j].elo,color=plotcolor[countbot%5], marker='.');
                countbot = countbot+1;
    
    for j in range(2,12):
        if player_object[j].elo > 1500:
            topnames.append(players[j]);
        else:
            botnames.append(players[j]);
    
    axes[0].legend(topnames);
    axes[1].legend(botnames);
    
    plt.show();

    
    plotcolor = ['blue', 'green', 'red', 'magenta', 'black'];
    g, axes     = plt.subplots(1,2,dpi=1000);
    plt.subplots_adjust(left=0.1, bottom=0.1, right=0.9, top=0.9, wspace=0.4, hspace=0.4);
    topnames    = [];
    botnames    = [];
    counttop    = 0;
    countbot    = 0;

    for k in range(n+1):
        game_analytics = game_history[k];
        for j in range(2,12):
            if player_object[j].winpercent > 50:
                axes[0].plot(k,game_analytics[j].winpercent,marker='.',color=plotcolor[counttop%5]);
                counttop = counttop+1;
            else:
                axes[1].plot(k,game_analytics[j].winpercent,marker='.',color=plotcolor[countbot%5]);
                countbot = countbot+1;
    
    for j in range(2,12):
        if player_object[j].elo > 1500:
            topnames.append(players[j]);
        else:
            botnames.append(players[j]);
    
    axes[0].legend(topnames);
    axes[1].legend(botnames);
    
    plt.show();

data_file   =   open("data.txt", "r");
data_array  =   data_file.read().split('\n');
n           =   len(data_array);
game        =   [];
for k in range(n):
    current_game    =   [data_array[k][0:2],data_array[k][3:5],data_array[k][6:8],data_array[k][9:11],data_array[k][12:14]];
    game.append(current_game);
players     =   [];     # Contains the name of initials of players
players.append(game[0][0]);
players.append(game[0][1]);
players.append(game[0][2]);
players.append(game[0][3]);
for j in range(1,n):
    for k in range(4):
        result = players.count(game[j][k]);
        if (result==0):
            players.append(game[j][k]);

players.sort();

nplayers = len(players);    # Number of players

player_object   = [];   # Stores the most recent players data, i.e., after the last game

game_history    = [];   # Stores each game history,
                        # i.e., game_history[j] contains
                        # all the players data after game 'j'

for k in range(nplayers):
    player_object.append(player(players[k]));   # Starts by storing the initial players data

game_history.append(copy.deepcopy(player_object));

for k in range(n):
    game_update(game[k],player_object);
    game_history.append(copy.deepcopy(player_object));

for k in range(nplayers):
    player_object[k].display();

create_plot();

f = open("elo.csv", "w");

for k in range(nplayers):
    f.write(players[k]);
    f.write(",");
f.write("\n");

for j in range(n+1):
    for k in range(nplayers):
        f.write(str(game_history[j][k].elo));
        f.write(",");
    f.write("\n");

f.close()

f = open("winpercent.csv", "w");

for k in range(nplayers):
    f.write(players[k]);
    f.write(",");
f.write("\n");

for j in range(n+1):
    for k in range(nplayers):
        f.write(str(game_history[j][k].winpercent));
        f.write(",");
    f.write("\n");

f.close()

print(n)