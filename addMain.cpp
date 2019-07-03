#include <iostream>
#include <iomanip>
using namespace std;

struct TimeInfor {
	unsigned int hour, min, sec;
	char amPm;
};

void interpretTime(struct TimeInfor *tmPtr, const char *time) {
	int i;
	// strtol
	tmPtr->hour = time[1] - '0';
	i = (time[0] - '0') * 10;
	tmPtr->hour += i;

	tmPtr->min = time[4] - '0';
	i = (time[3] - '0') * 10;
	tmPtr->min += i;

	tmPtr->sec = time[7] - '0';
	i = (time[6] - '0') * 10;
	tmPtr->sec += i;

	tmPtr->amPm = time[8];
}

void printClock(const char clock[])	{
	cout << "Current Time: " << setw(2) << setfill('0') << hex << int(clock[0]);
	cout << ":" << setw(2) << setfill('0') << hex << int(clock[1]);
	cout << ":" << setw(2) << setfill('0') << hex << int(clock[2]);
	cout << clock[3] << endl;
}

//extern "C" int addem(int p1, int p2, int p3);
extern "C" {
	void setClock(char clock[], const struct TimeInfor *tmPtr);
	void tickClock(char clock[]);
	void getCurrentTime(char time[]);
	//unsigned char incrementClockValue(char BCDbits, const unsigned int maxValue);

	long IndexOf(long n, long array[], unsigned count);
	// Assembly language module
}

int main()	{
	//TimeInfor *tmPtr = new TimeInfor;
	
	TimeInfor tmPtr;
	int s;
	char time[30];
	char clock[5];
	/*getCurrentTime(time);
	cout << hex << int(time[0]) << hex << int(time[1]) << endl;
	cout << hex << int(time[2]) << hex << int(time[3]) << endl;
	cout << hex << int(time[4]) << hex << int(time[5]) << endl;
	interpretTime(&tmPtr, time);
	cout << int(tmPtr.hour) << endl;
	cout << int(tmPtr.min) << endl;
	cout << int(tmPtr.sec) << endl;
	cout << tmPtr.amPm << endl;
	setClock(clock, &tmPtr);
	printClock(clock);
	tickClock(clock);
	printClock(clock);
	*/
	
	int option;
	cout << "Menu\n";
	cout << "1. Enter the time\n";
	cout << "2. Get current time\n";
	cout << "3. Quit\n";
	cout << "Please enter an option --> ";
	cin >> option;
	while (option != 3) {
		if (option == 1) {
			cout << "\nEnter the time: ";
			cin >> time;
		}
		else if (option == 2) {
			getCurrentTime(time);
			cout << endl;
		}
		interpretTime(&tmPtr, time);
		setClock(clock, &tmPtr);
		printClock(clock);
		cout << "Enter seconds to advance: ";
		cin >> s;
		for (int i = 0; i < s; i++) 
			tickClock(clock);
		printClock(clock);
		cout << "\nMenu\n";
		cout << "1. Enter the time\n";
		cout << "2. Get current time\n";
		cout << "3. Quit\n";
		cout << "Please enter an option --> ";
		cin >> option;
	}
	return 0;
}


