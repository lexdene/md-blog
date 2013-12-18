#include <iostream>

class Printer{
public:
    Printer(int n):
        _n(n){
        using namespace std;
        cout << "part " << _n << ":" << endl;
    }

    ~Printer(){
        using namespace std;
        cout << endl;
    }

    void p(bool b){
        using namespace std;

        if(b){
            cout << "yes!" << endl;
        }else{
            cout << "no!" << endl;
        }
    }
private:
    int _n;
};

// is derived from base
class Base1{
};
class Derived1: public Base1{
};
class Foo{
};
bool is_derived_from_base(Base1){
    return true;
}
bool is_derived_from_base(...){
    return false;
}
void main_part_0(){
    Printer p(0);
    p.p(
        is_derived_from_base(Derived1())
    );
    p.p(
        is_derived_from_base(Foo())
    );
}

// is derived from
template<typename Base, typename Derived>
class ConvertTester1{
public:
    static bool is_derived(){
        is_derived_from(Derived());
    }
private:
    static bool is_derived_from(Base){
        return true;
    }
    static bool is_derived_from(...){
        return false;
    }
};
void main_part_1(){
    Printer p(1);
    p.p(
        ConvertTester1<Base1, Derived1>::is_derived()
    );
    p.p(
        ConvertTester1<Base1, Foo>::is_derived()
    );
    p.p(
        ConvertTester1<int, double>::is_derived()
    );
}

// compile time check
struct Small{
    char data[2];
};
struct Big{
    char data[4];
};
template<typename Base, typename Derived>
class ConvertTester2{
private:
    static Small test_derived(Base);
    static Big test_derived(...);
public:
    enum{test =
        sizeof(
            test_derived(
                Derived()
            )
        ) == sizeof(
            Small
        )
    };
};

void main_part_2(){
    Printer p(2);
    p.p(
        ConvertTester2<Base1, Derived1>::test
    );
    p.p(
        ConvertTester2<Base1, Foo>::test
    );
    p.p(
        ConvertTester2<int, double>::test
    );
}

// private constructor
class Base3{
};
class Derived3: public Base3{
private:
    Derived3();
};
template<typename Base, typename Derived>
class ConvertTester3{
private:
    static Small test_derived(Base);
    static Big test_derived(...);
    static Derived make_derived();
public:
    enum{test = sizeof(test_derived(make_derived())) == sizeof(Small)};
};

void main_part_3(){
    Printer p(3);
    // this will make a compile error
    // p.p(
    //     ConvertTester2<Base3, Derived3>::test
    // );
    p.p(
        ConvertTester3<Base3, Derived3>::test
    );
    p.p(
        ConvertTester3<Base3, Foo>::test
    );
    p.p(
        ConvertTester3<int, double>::test
    );
}

// make a macro
#define is_derived_from4(Base, Derived) \
    ConvertTester3<const Base*, const Derived*>::test
void main_part_4(){
    Printer p(4);
    p.p(
        is_derived_from4(Base3, Derived3)
    );
    p.p(
        is_derived_from4(Base3, Foo)
    );
    p.p(
        is_derived_from4(int, double)
    );
}

int main(){
    main_part_0();
    main_part_1();
    main_part_2();
    main_part_3();

    return 0;
}
