template<typename Base, typename Derived>
class ConvertTester{
private:
    struct Small{char data[2];};
    struct Big{char data[4];};
    static Small test_derived(Base);
    static Big test_derived(...);
    static Derived make_derived();
public:
    enum{test = sizeof(test_derived(make_derived())) == sizeof(Small)};
};

#define is_derived_from(Base, Derived) \
    ConvertTester<const Base*, const Derived*>::test

class BarBase{
};
class BarDerived: public BarBase{
private:
    BarDerived();
};
class Foo{
};

// compile time assert
template<bool> struct assert0;
template<> struct assert0<true>{};
void main_part_0(){
    {
        assert0<is_derived_from(BarBase, BarDerived)> _unname;
    }
    {
        assert0<is_derived_from(BarBase, Foo)> _unname;
    }
}
// 错误： 聚合‘assert0<false> _unname’类型不完全，无法被定义

// error msg
template<bool> struct assert1;
template<> struct assert1<true>{
    assert1(...);
};
template<> struct assert1<false>{};

#define assert2(expr, msg) { \
    class Error_##msg{}; \
    assert1<(expr)> _noname = Error_##msg();    \
}

void main_part_1(){
    assert2(
        is_derived_from(BarBase, BarDerived),
        Is_Not_Derived
    );
    assert2(
        is_derived_from(BarBase, Foo),
        Is_Not_Derived
    );
}
// 请求从`main_part_1()::Error_Is_Not_Derived`转换到非标量类型`assert1<false>`
