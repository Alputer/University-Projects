//#include <bits/stdc++.h>
#include <iostream>
#include <iomanip>  // std::setprecision()
#include <fstream>
#include <vector>
#include <queue>
#include <set>
#include <unordered_set>
#include <iterator>
#include <map>
#include <utility> //For pair
#include <string>
#include <sstream>
#include <pthread.h>
#include <unistd.h>

using namespace std;

ofstream outfile; //Output file
pthread_mutex_t mutex; //Our mutex.
int T,A,N; // T is number of threads in our program. A is number of abstracts. N is expected number of output.
vector<string> keywords; //This vector will keep the keywords.
unordered_set<string> keywords_set;
queue<string> abstract_file_paths; //This vector keeps the abstract files' paths so that we can process them.
priority_queue<pair<double, pair<string,string>>> result; //score, file_name, summary


//Below function simply calculates the scores. 
// I give the words in the abstracts and keywords 
// given in the input file. By iterating through words
// and doing some algebra, I calulate the score.


double calculateScore(vector<string>& words, vector<string>& keywords){

	unordered_set<string> words_set;
	for(int i=0;i<words.size();i++){
		words_set.insert(words[i]);
	}

	
	int count = 0;

	for (string curr_word : words_set){
		for(string curr_keyword : keywords_set){
			if(!curr_word.compare(curr_keyword))
				count++;
		}
	}

		for(int i=0;i<keywords.size();i++){
		words_set.insert(keywords[i]);
		}

	int total = words_set.size();

	return ((double)count) / ((double)total);
}


//Below function finds the sommary for the given abstract.
//First input is tke tokenized version of the abstract. I
// I iterate through the tokens until I encounter a dot. When
// encountering dot, I decide to add or not to add depending on 
// the boolean variable "found" which is set to true if I have 
// seen a keywords priorly.

string findSummary(vector<string> words, vector<string> keywords){
	string summary = "";

	string curr = "";
	bool found = false;

	for(int i=0;i<words.size();i++){



		curr += words[i];
		curr += " ";

		for(int j=0;j<keywords.size();j++){
			if(!words[i].compare(keywords[j]))
				found = true;
		}

		if(!words[i].compare(".")){
			if(found){
				found = false;
				summary += curr;
				curr = "";
			}
			else{
				curr = "";
			}

		}
	}

	return summary;
}


//Below function is a utility function.
//It returns the all tokens in the abstract file.
//Its logic is pretty simple, I check until the end
//of the file and add strings splitting by space.
vector<string> tokenizeAbstract(string path_of_abstract){

	vector<string> tokens;

	path_of_abstract = "../abstracts/" + path_of_abstract;
	ifstream in(path_of_abstract);

	vector<string> sentences; 
	string curr_sentence;

	while (getline (in, curr_sentence)) {
  	sentences.push_back(curr_sentence);
}

for(int i=0;i<sentences.size();i++){
	stringstream ss(sentences[i]);
	string next_token;

	while (getline(ss, next_token, ' ')) {
 	tokens.push_back(next_token);
	}
}

	return tokens;
}


//Below function is the main function for threads. All thredas are bound to this function. 
//As its name implies, all threads process one abstract at a time.

void* processAbstract(void *arg) {

	int thread_id = *(int*)arg;
	thread_id += 65; //I will convert it to char and want it to represent the ASCII value of 'A'.

	while(1){


//I check the emptiness of the queue via mutex. It is necessary, otherwise I may encouncter a race condition.
	pthread_mutex_lock(&mutex);
	bool isQueueEmpty = abstract_file_paths.empty();
	pthread_mutex_unlock(&mutex);

	if(isQueueEmpty)
		break;

	// I use mutex before popping the next abstract since race condition may mess up everything!
	pthread_mutex_lock(&mutex);
	string curr_abstract = abstract_file_paths.front();
	abstract_file_paths.pop();
	outfile << "Thread " << (char)thread_id << " is calculating " << curr_abstract << endl;
	pthread_mutex_unlock(&mutex);


	// I divided the jobs into several steps.
	vector<string> words = tokenizeAbstract(curr_abstract); //Its a utility function. Just tokenize words in the abstract.
	double score = calculateScore(words, keywords); //This function calculates the scores.
	//outfile << score << endl;
	string summary = findSummary(words, keywords); //This function finds the summary for a given abstract and keywords.
	usleep(5);
	//outfile << summary << endl;
	pthread_mutex_lock(&mutex);
	result.push(make_pair(score,make_pair(curr_abstract,summary))); //I push the result into my result queue.
	pthread_mutex_unlock(&mutex);

	}

	free(arg); // Free up the space!
}

int main(int argc, char *argv[]){

pthread_mutex_init(&mutex, NULL); // Initialize our mutex.

string input_file_path = argv[1];
string output_file_path = argv[2];


outfile.open(argv[2]); //Output file
ifstream infile(argv[1]); //Input file

infile >> T >> A >> N; // T is number of threads in our program. A is number of abstracts. N is expected number of output.


/////////////*****************          *****************/////////////
// This code segment is taken from https://stackoverflow.com/questions/53849/how-do-i-tokenize-a-string-in-c /////////
string keyword_sentence, dummy;
getline(infile, dummy); // dummy string is to finish the first line.
getline(infile, keyword_sentence); // All the line of keywords are put in string. Now we should tokenize it.

stringstream ss(keyword_sentence);
string next_keyword;

while (getline(ss, next_keyword, ' ')) {
 keywords.push_back(next_keyword);
 keywords_set.insert(next_keyword);
}
/////////////*****************          *****************/////////////



//I get the abstracts from input file in this for loop. 
for(int i=0;i<A;i++){
    string next_path;
    infile >> next_path;
    abstract_file_paths.push(next_path);
}

// I got the help of the tutorial to write the below code segment -->    https://www.youtube.com/watch?v=xoXzp4B8aQk&list=PLfqABt5AS4FmuQf70psXrsMLEDQXNkLq2&index=6

pthread_t threads[T];

// I create threads in this loop. 

for(int i=0;i<T;i++){

	int* thread_id = (int *)malloc(sizeof(int)); 
	*thread_id = i;
	if(pthread_create(threads + i, NULL, &processAbstract, thread_id)){
		perror("Failed to create thread");
		return 1;
	}

}

// I need to join threads to main, otherwise main can terminate and all threads may die.
// Pay attention to that joining and creating threads are done in different loops!!
// Otherwise, we would have one thread and wait for that one only!

for(int i=0;i<T;i++){
	if(pthread_join(threads[i], NULL)){
		perror("Failed to join thread");
		return 2;
	}
}


outfile << "###" << endl; //We need this signature in output files.

//Finally, I print out the results using the global
//priority queue named "result" I have created globally 
//during the execution of the program.

for(int i=0;i<N;i++){

	pair<double, pair<string,string>> curr_result = result.top();
	result.pop();

	double score = curr_result.first;
	string file_name = curr_result.second.first;
	string summary = curr_result.second.second; 

	outfile << std::fixed << setprecision(4);
	outfile << "Result " << i+1 << ":" << endl;
	outfile << "File: " << file_name << endl;
	outfile << "Score: " << score << endl;
	outfile << "Summary: " << summary << endl;
	outfile << "###" << endl;
}


//Following three lines just clean up the resources we have used.
outfile.close();
infile.close();
pthread_mutex_destroy(&mutex); 
    
}