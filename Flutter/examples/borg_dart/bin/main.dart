mixin TestMixin on BaseClass {
  void init() {
    print('TestMixin init start');
    super.init();
    print('TestMixin init end');
  }
}

mixin TestMixin2 on BaseClass {
  void init() {
    print('TestMixin2 init start');
    super.init();
    print('TestMixin2 init end');
  }
}

class BaseClass {
  void init() {
    print('Base init');
  }
  BaseClass() {
    init();
  }
}

class A{
  void init(){
        print('A init');
  }
}

class B{
  void init(){
        print('B init');
  }
}

class TestClass extends BaseClass with TestMixin, TestMixin2 {

  @override
  void init() {
    print('TestClass init start');
    super.init();
    print('TestClass init end');

  }
}

class AB extends BaseClass with A,B{

}

class BA extends BaseClass with A,B{}

void main() {
  TestClass();

  AB ab = AB();
  ab.init();

  BA ba = BA();
  ba.init();

  /// TestClass init start
  /// TestMixin2 init start
  /// TestMixin init start
  /// Base init
  /// TestMixin init end
  /// TestMixin2 init end
  /// TestClass init end
}