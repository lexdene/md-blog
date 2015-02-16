#include <iostream>

using namespace std;

#include "workers.h"

enum{RENDER_BY_SHOW, RENDER_BY_DISPLAY};

// this code can not really run
template<class Worker, int render_type>
class Adapter1{
public:
    void render(){
        switch(render_type){
        case RENDER_BY_SHOW:
            _worker->show();
            break;
        case RENDER_BY_DISPLAY:
            _worker->display();
            break;
        }
    }
private:
    Worker* _worker;
};

// by function overloading
// if switcher is char, render by show
// if switcher is float, render by display
template<class Worker, typename switcher>
class Adapter2{
public:
    void render(){
        render_dispatch(switcher());
    }
private:
    void render_dispatch(char){
        _worker->show();
    }
    void render_dispatch(float){
        _worker->display();
    }

    Worker* _worker;
};

// by int to type
template<int from_value>
class IntToType{
public:
    enum{value=from_value};
};


template<class Worker, int render_type>
class Adapter3{
public:
    void render(){
        render_dispatch(IntToType<render_type>());
    }
private:
    void render_dispatch(IntToType<RENDER_BY_SHOW>){
        _worker->show();
    }
    void render_dispatch(IntToType<RENDER_BY_DISPLAY>){
        _worker->display();
    }

    Worker* _worker;
};

// bind class to render_type
template<class WorkerType>
class WorkerToRenderType{
};

template<>
class WorkerToRenderType<Worker_A>{
public:
    enum{render_type = RENDER_BY_SHOW};
};
template<>
class WorkerToRenderType<Worker_B>{
public:
    enum{render_type = RENDER_BY_SHOW};
};
template<>
class WorkerToRenderType<Worker_C>{
public:
    enum{render_type = RENDER_BY_DISPLAY};
};
template<>
class WorkerToRenderType<Worker_D>{
public:
    enum{render_type = RENDER_BY_DISPLAY};
};

template<class Worker>
class Adapter4{
public:
    void render(){
        render_dispatch(
            IntToType<
                WorkerToRenderType<Worker>::render_type
            >()
        );
    }
private:
    void render_dispatch(IntToType<RENDER_BY_SHOW>){
        _worker->show();
    }
    void render_dispatch(IntToType<RENDER_BY_DISPLAY>){
        _worker->display();
    }

    Worker* _worker;
};


// main function
int main(){
    // adapter 1
    cout << "adapter 1:" << endl;

    Adapter1<Worker_A, RENDER_BY_SHOW> a1;
    // a1.render();

    cout << endl;

    // adapter 2
    cout << "adapter 2:" << endl;

    Adapter2<Worker_A, char> a2;
    a2.render();

    Adapter2<Worker_C, float> c2;
    c2.render();

    cout << endl;

    // adapter 3
    cout << "adapter 3:" << endl;

    Adapter3<Worker_B, RENDER_BY_SHOW> b3;
    b3.render();

    Adapter3<Worker_D, RENDER_BY_DISPLAY> d3;
    d3.render();

    cout << endl;

    // adapter 4
    cout << "adapter 4:" << endl;

    Adapter4<Worker_A> a4;
    a4.render();

    Adapter4<Worker_B> b4;
    b4.render();

    Adapter4<Worker_C> c4;
    c4.render();

    Adapter4<Worker_D> d4;
    d4.render();

    return 0;
}
