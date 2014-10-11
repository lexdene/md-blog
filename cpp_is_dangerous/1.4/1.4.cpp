#include <iostream>
using namespace std;

class Foo{
public:
    Foo()
    {
        cout << 1 << endl;
    }
    Foo(int a=4){
        cout<<a<<endl;
    }
};

int main(){
    Foo a(3);
    Foo b();
    return 0;
}
