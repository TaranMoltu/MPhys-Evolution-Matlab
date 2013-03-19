//============================================================================
// Name        : MPhys-evolution-datasort.cpp
// Author      : Michael Williams
// Version     : 0.1
// Copyright   : 2012
// Purpose     : Duplicates the first part of previously written MATLAB script
//				 sorting things into "bucketmatrix" based on a user input
//				 of how many buckets they want. Outputs this to csv so it can
//				 then be read into MATLAB and plotted.
//============================================================================

#include<iostream>
#include<fstream>
#include<cmath>
#include<vector>
#include<algorithm>
#include<string>
#include<sstream>
using namespace std;

const double pi = acos(-1.0);

int bucketchoice(double &bucketsize, double &value); //Function which advises the bucket to take and returns it
void log(const string &outfilename, const vector<int> &values);

int main() {
	//Start with maintenance: open file, ask how many buckets there are
	//and then work out the size of a bucket
	unsigned int buckets; //Number of buckets user which we will request
	const char infilename[]="log.dat"; //Assume file to be read is in same folder and is called log.dat
	const string outfilename="bucketmatrix.dat";
	ifstream in(infilename); //Open ifstream called in
	cout<<"How many buckets would you like to use?: ";
	cin>>buckets;

	//From the number of buckets, work out the size of a bucket
	double bucketsize((2*pi)/buckets);
	//Some variable declarations
	double number; //Value under inspection at any one time
	int buckettoincrement; //As returned by

	string line;
	//We now want to start reading in the file. This is based on http://www.daniweb.com/software-development/cpp/threads/204808/parsing-a-csv-file-separated-by-semicolons
	vector<int> array;

	while(getline(in, line))
	{
		array.assign(buckets,0);
		stringstream strstr(line);
		istringstream stm;
		string numberasastring="";
		//Create our array which is as long as the number of buckets and pre-populate every value to be 0. Have to do in this loop so we can clear it every time
		//array = new int[buckets];
		//fill_n((array),buckets,0);
		//cout<<"debug message is that *array[10] at random has value: "<<*(array+10);
		//Change of plan, lets use vectors!

		while (getline(strstr, numberasastring, ','))
			{
				//cout<<"string: "<<numberasastring<<endl;

				//We now have a value as a string. We use the following three lines to convert it to a double
				istringstream i(numberasastring);
				i >> number;
				//cout<<"double: "<<number<<endl;

				//Now check what bucket number falls in.
				buckettoincrement = bucketchoice(bucketsize, number);
				//cout << buckettoincrement<<endl;
				//(*(array+buckettoincrement))++;
				array[buckettoincrement]++;
			}
		log(outfilename, array);
		array.clear();
		//Print first line to console
		//cout<<values[3]<<endl;

	}
	cout<<"end of loop";
	//Now we need to print. To the function!
	//log(outfilename, values, buckets);
	//Close with a rare example of good programming practice (for this script) and return 0;
	return 0;
}

int bucketchoice(double &bucketsize, double &value)
{
	return floor((value+pi)/bucketsize);
}

void log(const string &outfilename, const vector<int> &values){
	fstream logStream;
	logStream.open(outfilename.c_str(), ios::out | ios::app);
	vector<int>::const_iterator current,end;
	end = values.end();

	for (current=values.begin(); current!=values.end(); ++current){
			if (current==values.begin()) logStream << *current;
			else logStream << ","<< *current;
		}
		logStream << endl;


	logStream.close();
}
