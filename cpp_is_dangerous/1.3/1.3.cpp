#include <iostream>

using namespace std;

class Object
{
public:
    Object(int a=0)
    {
        cout<<"Hello world!"<<endl;
    }
};

class CA
{
public:
    CA()
        :o(1)
    {
    }
private:
    Object o;
};

class CB
{
public:
    CB()
    {
        o=1;
    }
private:
    Object o;
};

int main()
{
    CA ca;
    CB cb;
    return 0;
}
