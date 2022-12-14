#include<iostream>
#include<fstream>
#include<string>

using namespace std;

int max(int a, int b) {
	if (a>b) return a;
	else return b;
}

struct {
	string name;
	int played, won, lost;
	double win_ratio, total_points_won, total_points_lost, total_points;
	double average_points, average_points_won, average_points_conceded;
	double current_elo;
} player;

void assign_player_names() {
	players[0].name = AS;
	players[1].name = AT;
	players[2].name = GB;
	players[3].name = KN;
	players[4].name = KR;
	players[5].name = PJ;
	players[6].name = SA;
	players[7].name = SK;
	players[8].name = SS;
	players[9].name = SV;
}

int main() {

	player players[9];
	
	assign_player_names();

	ofstream myfile;

	myfile.open("raw_data.csv",ios::app);
	int p[4];
	int date;
	int team2_points;
	for (int i=0; i<4; ++i) {
		cin >> p[i];
	}
	cin >> date;
	cin >> team2_points;
	int team1_points = max(21, team2_points+2);
	myfile << "\n" << date << " "<< name1 << " " << name2 << " " << name3 << " " << name4 << " " << team2_points;
	myfile.close();

	int partner[4] = {1,0,3,2};
	int opponent1[4] = {3,3,1,1};
	int opponent2[4] = {4,4,2,2}
	
	oppon
	
	for (int i=0; i<4; ++i) {
		ifstream playerfile;
		playerfile.open(p[i],ios::app)
		playerfile.seekg(0,ios::end);
		if (playerfile.tellg() == 0) {
			current_elo = 1000;
		}
		playerfile << "\n";
		if (i==0) {
			playerfile << players[1].name
		}
	}
}
