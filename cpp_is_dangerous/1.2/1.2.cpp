#include <iostream>

using namespace std;

class Base
{
public:
    Base()
    {
        data=createNumber();
    }
    int getData()const
    {
        return data;
    }
protected:
    virtual int createNumber()const
    {
        return 3;
    }
private:
    int data;
};

class Derived : public Base
{
protected:
    virtual int createNumber()const
    {
        return 4;
    }
};

int main()
{
    Base *a=new Derived;
    cout<<a->getData()<<endl;
    return 0;
}
