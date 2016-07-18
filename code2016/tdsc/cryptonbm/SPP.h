#include <iostream>
#include <fstream>
#include <vector>

#include "seal.h"

#include <ctime>


using namespace std;
using namespace seal;


#define Tm 1 
#define Tu 10 
#define Fu 70 
#define n 1682 
#define T 5 //rating size 0-5
#define alpha 8 
#define beta 2 

void print_example_banner(string title);

void Cryptonets();
void SPP(int item_num);
void LoadM(int MTu[Tu][n], int MFu[Fu][n], int sim[Fu]);

