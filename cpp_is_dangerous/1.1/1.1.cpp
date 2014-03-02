#include <iostream>

using namespace std;

class bar
{
public:
    bar(int a)
    {
        data=a;
        bar();
    }

    bar()
    {
        data=4;
    }

    int getData()const
    {
        return data;
    }

private:
    int data;
};

int main()
{
    bar b(3);
    cout<<b.getData()<<endl;
    return 0;
}
