import 'dart:developer';

import 'package:english_words/english_words.dart';
import 'package:flutter/material.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  static final RouteObserver<PageRoute> routeObserver =
  RouteObserver<PageRoute>();

  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {

    return MaterialApp(
      title: 'Flutter Demo',
      initialRoute: "/",
      theme: ThemeData(

        /// 这是应用程序的主题。 试着用“flutter run”运行你的应用程序。
        /// 您将看到应用程序有一个蓝色的工具栏。
        /// 然后，在不退出应用程序的情况下，尝试将下面的primarySwatch更改为Colors.green，然后调用“hot reload”(在运行“flutter run”的控制台中按“r”，或在flutter IDE中按“run > flutter hot reload”)。
        /// 注意，计数器没有重置为零; 应用程序未重启。
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
      // 默认demo
      // home: const CounterWidget(), // 生命周期
      // home: const GetStateObjectRoute(), // 获取State对象
      // home: const CustomWidget(), // 通过RenderObject自定义Widget
      // home: const DemoWidget(), // 基础组件使用
      // home: const TapBoxA() // 状态管理：Widget管理自身状态
      // home: const ParentWidget() // 状态管理：混合状态管理
      // home: const RouterTestRoute(), // 路由传值
      routes: {
        // "/": (context) => const MyHomePage(title: "Flutter Demo Home Page"),
        // "new_page": (context) => const NewRoute(),
        "lifecycle_page": (context) => const CounterWidget(),
        "echo_page": (context) => const EchoRoute(),
        "get_state_object_page": (context) => const GetStateObjectRoute(),
        "custom_widget_page": (context) => const CustomWidget(),
        "demo_widget_page": (context) => const DemoWidget(),
        "tap_box_page": (context) => const TapBoxA(),
        "parent_page": (context) => const ParentWidget(),
        "router_test_page": (context) => const RouterTestRoute(),
        "tip_page": (context) =>
            TipRoute(
                text: ModalRoute
                    .of(context)!
                    .settings
                    .arguments == null
                    ? "没收到参数"
                    : ModalRoute
                    .of(context)!
                    .settings
                    .arguments as String),
        "unknown_page": (context) => const UnKnownWidget()
      },
      // onGenerateRoute只会对命名路由生效。
      onGenerateRoute: (RouteSettings settings) {
        String routeName = settings.name!;
        // 如果访问的路由 routeName 页需要登录，但当前未登录，则直接返回登录页路由
        debugPrint("判断页面$routeName是否需要登录");

        if (routeName == "new_page") {
          return MaterialPageRoute(builder: (context) {
            // 引导用户登录，其他情况则正常打开路由
            return const NewRoute();
          });
        }
        return MaterialPageRoute(builder: (context) {
          return const UnKnownWidget();
        });
        // return null;
      },
      navigatorObservers: [routeObserver],

      //【MaterialApp】配置顶层【Navigator】按以下顺序搜索路由:
      // 1. 对于'/'路由，如果非null，则使用[home]属性。
      // 2. 否则，如果有路由表项，则使用[routes]表。
      // 3. 否则，[onGenerateRoute]将被调用。 对于没有被[home]和[routes]处理的任何_valid_路由，它应该返回一个非空值。
      // 4. 最后，如果所有这些都失败了，就调用[onUnknownRoute]。

      // 不生效，即使onGenerateRoute返回null，也到不了这里
      onUnknownRoute: (RouteSettings setting) {
        return MaterialPageRoute(builder: (context) {
          return const UnKnownWidget();
        });
      },
    );
  }
}

class RandomWordsWidget extends StatelessWidget {
  const RandomWordsWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final wordPair = WordPair.random();
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Text(wordPair.toString()),
    );
  }
}

/* -------------------------------------------------------- 未知路由 ----------------------------------------------------- */

class UnKnownWidget extends StatelessWidget {
  const UnKnownWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('跳转错误'),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Image.asset("assets/invite_telegram_image.png"),
          const Image(
              image: AssetImage("assets/invite_telegram_bg_image.png")
          ),
          Image.asset("invite_huoxin_image.png"),
          const Image(
              image: AssetImage("invite_myearnings_btn.png")
          ),

        ],
      ),
    );
  }
}

/* -------------------------------------------------------- 打开命名路由 ----------------------------------------------------- */

class EchoRoute extends StatelessWidget {
  const EchoRoute({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // 获取命名路由参数
    var args = ModalRoute
        .of(context)!
        .settings
        .arguments ?? "没收到参数";
    debugPrint("args -> $args");
    return Scaffold(
      appBar: AppBar(
        title: const Text("Echo Route"),
      ),
      body: Center(
        child: Text("参数 $args"),
      ),
    );
  }
}

/* -------------------------------------------------------- 路由传值 ----------------------------------------------------- */

class TipRoute extends StatelessWidget {
  const TipRoute({Key? key, required this.text}) : super(key: key);

  final String text;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("提示"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(18),
        child: Center(
          child: Column(
            children: [
              Text(text),
              ElevatedButton(
                  onPressed: () => Navigator.pop(context, "我是返回值"),
                  child: const Text("返回"))
            ],
          ),
        ),
      ),
    );
  }
}

class RouterTestRoute extends StatelessWidget {
  const RouterTestRoute({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: [
          ElevatedButton(
            onPressed: () async {
              // 打开 TipRoute ,并等待返回结果
              var result = await Navigator.push(context,
                  MaterialPageRoute(builder: (context) {
                    return const TipRoute(text: "我是提示xxxx");
                  }));
              // 输出TipRoute路由的返回结果
              debugPrint("路由返回值：$result");
            },
            child: const Text("打开提示页"),
          ),
          ElevatedButton(
            onPressed: () async {
              // 打开 TipRoute ,并等待返回结果
              var result = await Navigator.of(context)
                  .pushNamed("tip_page", arguments: "hello 我是提示xxxx");
              // 输出TipRoute路由的返回结果
              debugPrint("路由返回值：$result");
            },
            child: const Text("命名路由：打开提示页"),
          )
        ],
      ),
    );
  }
}

/* -------------------------------------------------------- 状态管理：全局状态管理 ----------------------------------------------------- */

/// 1. 实现一个全局事件总线
/// 2. 使用专门用于状态管理的包：Provider、Redux

/* -------------------------------------------------------- 状态管理：混合状态管理 ----------------------------------------------------- */

class ParentWidget extends StatefulWidget {
  const ParentWidget({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _ParentWidgetState();
}

class _ParentWidgetState extends State<ParentWidget> {
  bool _active = false;

  void _handleTapBoxChanged(bool newValue) {
    setState(() {
      _active = newValue;
    });
  }

  @override
  Widget build(BuildContext context) {
    /// 父Widget管理子Widget状态
    // return TapBoxB(
    //   active: _active,
    //   onChanged: _handleTapBoxChanged,
    // );
    /// 混合状态管理：一部分状态由父Widget管理，一部分由自身Widget管理
    return TapBoxC(
      active: _active,
      onChanged: _handleTapBoxChanged,
    );
  }
}

class TapBoxB extends StatelessWidget {
  const TapBoxB({Key? key, required this.active, required this.onChanged})
      : super(key: key);

  final bool active;
  final ValueChanged<bool> onChanged;

  void _handleTap() {
    onChanged(!active);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _handleTap,
      child: Container(
        child: Center(
          child: Text(
            active ? 'Active' : 'Inactive',
            style: const TextStyle(fontSize: 32.0, color: Colors.white),
          ),
        ),
        width: 200.0,
        height: 200.0,
        decoration: BoxDecoration(
            color: active ? Colors.lightGreen[700] : Colors.grey[600]),
      ),
    );
  }
}

class TapBoxC extends StatefulWidget {
  const TapBoxC({Key? key, required this.active, required this.onChanged})
      : super(key: key);

  final bool active;
  final ValueChanged<bool> onChanged;

  @override
  State<StatefulWidget> createState() {
    return _TapBoxCState();
  }
}

class _TapBoxCState extends State<TapBoxC> {
  bool _highlight = false;

  void _handleTapDown(TapDownDetails details) {
    setState(() {
      _highlight = true;
    });
  }

  void _handleTapUp(TapUpDetails details) {
    setState(() {
      _highlight = false;
    });
  }

  void _handleTapCancel() {
    setState(() {
      _highlight = false;
    });
  }

  void _handleTap() {
    widget.onChanged(!widget.active);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: _handleTapDown,
      // 处理按下事件
      onTapUp: _handleTapUp,
      // 处理抬起事件
      onTap: _handleTap,
      // 点击
      onTapCancel: _handleTapCancel,
      // 取消
      child: Container(
        child: Center(
          child: Text(
            widget.active ? 'Active' : 'Inactive',
            style: const TextStyle(fontSize: 32.0, color: Colors.white),
          ),
        ),
        width: 200.0,
        height: 200.0,
        decoration: BoxDecoration(
            color: widget.active ? Colors.lightGreen[700] : Colors.grey[600],
            border: _highlight
                ? Border.all(color: Colors.teal, width: 10.0)
                : null),
      ),
    );
  }
}

/* -------------------------------------------------------- 状态管理：Widget管理自身状态 ----------------------------------------------------- */

class TapBoxA extends StatefulWidget {
  const TapBoxA({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _TapBoxAState();
  }
}

class _TapBoxAState extends State<TapBoxA> {
  bool _active = false;

  void _handleTap() {
    setState(() {
      _active = !_active;
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _handleTap,
      child: Container(
        child: Center(
          child: Text(
            _active ? 'Active' : 'Inactive',
            style: const TextStyle(fontSize: 32.0, color: Colors.white),
          ),
        ),
        width: 200,
        height: 200,
        decoration: BoxDecoration(
            color: _active ? Colors.lightGreen[700] : Colors.grey[600]),
      ),
    );
  }
}

/* -------------------------------------------------------- 基础组件使用 ----------------------------------------------------- */

class DemoWidget extends StatelessWidget {
  const DemoWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    const TextStyle testStyle = TextStyle(fontSize: 12, color: Colors.blue);

    const TextStyle testStyle1 =
    TextStyle(fontSize: 13, color: Color(0xFFFFEEDD));

    const TextStyle testStyle2 =
    TextStyle(fontSize: 20, color: Color(0xFFFFEEDD));

    return Container(
      padding: const EdgeInsets.all(40),
      child: Column(
        children: [
          Row(
            children: const [
              Text("我是第一行第一个", style: testStyle),
              Text("我是第一行第二个", style: testStyle),
              Text("我是第一行第三个", style: testStyle),
            ],
          ),
          Row(
            children: const [
              Text("我是第二行第一个", style: testStyle1),
              Text("我是第二行第二个", style: testStyle1),
            ],
          ),
          Container(
            // key: const Key("container"),
            foregroundDecoration: const BoxDecoration(
              image: DecorationImage(
                  image: NetworkImage(
                      "https://p0.meituan.net/erp/6c92998b8b82a6363f4a648a81375e049045.png")),
            ),

            padding: const EdgeInsets.all(8.0),
            margin: const EdgeInsets.all(30.0),
            // width: 100,
            // height: 200,
            // 背景色
            color: const Color(0x77FFFFFF),
            // 约束：最大最小宽高
            constraints: const BoxConstraints(
                maxWidth: 200, maxHeight: 200, minWidth: 100, minHeight: 100),
            // transform: Matrix4.skewX(0.1),
            // alignment: Alignment.center,
            // transformAlignment: Alignment.bottomRight,
            child: const Text("hello world", style: testStyle2),
          )
        ],
      ),
      decoration: const BoxDecoration(
          shape: BoxShape.rectangle,
          // color: Colors.red,
          // border: Border.all(color: Colors.green, width: 5),
          // borderRadius: BorderRadius.only(
          //     topLeft: Radius.circular(5),
          //     topRight: Radius.circular(10.0),
          //     bottomLeft: Radius.circular(15.0),
          //     bottomRight: Radius.circular(20.0)),
          gradient: LinearGradient(colors: [
            Color(0xFFFFDEAD),
            Color(0xFF98FB98),
            Color(0xFF6495ED)
          ]),
          // 阴影效果
          boxShadow: [BoxShadow(color: Color(0xFFFF0000), blurRadius: 5.0)],
          // 背景混合模式
          backgroundBlendMode: BlendMode.color,
          // 图片
          image: DecorationImage(
              image: NetworkImage(
                  "https://p0.meituan.net/erp/6c92998b8b82a6363f4a648a81375e049045.png"),
              fit: BoxFit.scaleDown)),
    );
  }
}

/* -------------------------------------------------------- 通过RenderObject自定义Widget ----------------------------------------------------- */

/// 如果组件不会包含子组件，可以直接继承LeafRenderObjectWidget
class CustomWidget extends LeafRenderObjectWidget {
  const CustomWidget({Key? key}) : super(key: key);

  @override
  RenderObject createRenderObject(BuildContext context) {
    debugPrint("createRenderObject");
    return RenderCustomObject();
  }

  @override
  void updateRenderObject(BuildContext context,
      covariant RenderObject renderObject) {
    super.updateRenderObject(context, renderObject);
    debugPrint("updateRenderObject");
  }
}

/// 如何实现：涉及到的知识点会贯穿本书
class RenderCustomObject extends RenderBox {
  @override
  void performLayout() {
    super.performLayout();
    debugPrint("performLayout 实现布局逻辑");
  }

  @override
  void paint(PaintingContext context, Offset offset) {
    super.paint(context, offset);
    debugPrint("paint 实现绘制");
  }
}

/* -------------------------------------------------------- 获取State对象 ----------------------------------------------------- */

class GetStateObjectRoute extends StatefulWidget {
  const GetStateObjectRoute({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _GetStateObjectRoute();
}

class _GetStateObjectRoute extends State<GetStateObjectRoute> {
  /// GlobalKey开销较大，尽量避免使用
  /// 同一个GlobalKey在整个widget树中必须唯一，不能重复
  final GlobalKey<ScaffoldState> _globalKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _globalKey,
      appBar: AppBar(
        title: const Text("子树中获取State对象"),
      ),
      body: Center(
        child: Column(
          children: [
            Builder(builder: (context) {
              return ElevatedButton(
                  onPressed: () {
                    ScaffoldState _state =
                    context.findAncestorStateOfType<ScaffoldState>()!;
                    _state.openDrawer();
                  },
                  child: const Text("打开抽屉菜单1"));
            }),
            Builder(builder: (context) {
              return ElevatedButton(
                  onPressed: () {
                    // 通过of方法获取到期望暴露出来的State
                    ScaffoldState _state = Scaffold.of(context);
                    _state.openDrawer();
                  },
                  child: const Text("打开抽屉菜单2"));
            }),
            Builder(builder: (context) {
              return ElevatedButton(
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text("我是SnackBar")));
                    ScaffoldMessenger.of(context).showMaterialBanner(
                        const MaterialBanner(
                            content: Text("我是MaterialBanner"),
                            actions: [Text("发当升科技")]));
                  },
                  child: const Text("显示SnackBar"));
            }),
            Builder(builder: (context) {
              return ElevatedButton(
                  onPressed: () {
                    ScaffoldMessenger.of(context).hideCurrentSnackBar();
                    ScaffoldMessenger.of(context).hideCurrentMaterialBanner();
                  },
                  child: const Text("隐藏SnackBar"));
            }),
            Builder(builder: (context) {
              return ElevatedButton(
                  onPressed: () {
                    _globalKey.currentState!.openDrawer();
                  },
                  child: const Text("使用GlobalKey"));
            })
          ],
        ),
      ),
      drawer: const Drawer(),
    );
  }
}

/* -------------------------------------------------------- State 生命周期 ----------------------------------------------------- */

class CounterWidget extends StatefulWidget {
  const CounterWidget({Key? key, this.initValue = 0}) : super(key: key);

  final int initValue;

  @override
  State<CounterWidget> createState() => _CounterWidgetState();
}

class _CounterWidgetState extends State<CounterWidget> {
  int _counter = 0;

  /// widget第一次插入到widget树时会被调用，每个State对象只会调用一次
  /// 不能在此调用BuildContext.dependOnInheritedWidgetOfExactType
  /// 原因：初始化完成后，widgets树的InheritedFrom widget可能会发生变化，所以正确的做法应该在
  @override
  void initState() {
    super.initState();
    _counter = widget.initValue;
    debugPrint("lifecycle initState $_counter");
  }

  /// State对象的依赖发生变化时被调用
  /// 注意：组件首次被创建后挂载时（包括重创建）对应组件的didChangeDependencies也会被调用
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    debugPrint('lifecycle didChangeDependencies $_counter');
  }

  /// 用于开发调试热重载，不会用于release模式
  @override
  void reassemble() {
    super.reassemble();
    debugPrint('lifecycle reassemble $_counter');
  }

  /// widget重新构建时，框架调用widget.canUpdate检测同一位置的新旧节点；
  /// widget.canUpdate依赖的新旧widget的key和runtimeType同时相等时(返回true时）didUpdateWidget回调
  /// 触发build调用
  @override
  void didUpdateWidget(covariant CounterWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    debugPrint('lifecycle didUpdateWidget $_counter');
  }

  /// 主要用于构建widget子树
  /// 被调用的场景
  /// (1) initState() 后
  /// (2) didUpdateWidget() 后
  /// (3) setState() 后
  /// (4) didChangeDependencies() 后
  /// (5) 在State对象从树中一个位置移除后又重新插入到树的其他位置 后
  @override
  Widget build(BuildContext context) {
    debugPrint("lifecycle build $_counter");
    return Scaffold(
      body: Center(
        child: TextButton(
          child: Column(
            children: [
              Text('计数器1：$_counter'),
              Text('计数器2：$_counter'),
              TextButton(
                  onPressed: () {
                    Navigator.of(context)
                        .pushNamed("echo_page", arguments: "hello echo");
                  },
                  child: const Text("跳转EchoPage"))
            ],
          ),
          onPressed: () => setState(() => ++_counter),
        ),
      ),
    );
  }

  /// 当State对象从树中被移除时回调
  @override
  void deactivate() {
    super.deactivate();
    debugPrint('lifecycle deactivate $_counter');
  }

  /// 当State对象从树中被永久移除时调用；通常在此释放资源
  @override
  void dispose() {
    super.dispose();
    debugPrint('lifecycle dispose $_counter');
  }
}

/* -------------------------------------------------------- 默认demo ----------------------------------------------------- */

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

/// 新路由（新页面）
class NewRoute extends StatelessWidget {
  const NewRoute({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("New route"),
      ),
      body: Center(
        child: Column(
          children: [
            const Text("This is new route"),
            MaterialButton(
              onPressed: () {
                Navigator.pushNamed(context, "lifecycle_page");
              },
              color: Colors.green,
              child: const Text("跳转：CounterWidget生命周期验证页"),
            )
          ],
        ),
      ),
    );
  }
}

class _MyHomePageState extends State<MyHomePage> with RouteAware {
  int _counter = 0;

  void _incrementCounter() {
    // debugDumpApp();
    // debugger(when: _counter > 10);

    setState(() {
      // This call to setState tells the Flutter framework that something has
      // changed in this State, which causes it to rerun the build method below
      // so that the display can reflect the updated values. If we changed
      // _counter without calling setState(), then the build method would not be
      // called again, and so nothing would appear to happen.
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),
      body: Center(
        // Center is a layout widget. It takes a single child and positions it
        // in the middle of the parent.
        child: Column(
          // Column is also a layout widget. It takes a list of children and
          // arranges them vertically. By default, it sizes itself to fit its
          // children horizontally, and tries to be as tall as its parent.
          //
          // Invoke "debug painting" (press "p" in the console, choose the
          // "Toggle Debug Paint" action from the Flutter Inspector in Android
          // Studio, or the "Toggle Debug Paint" command in Visual Studio Code)
          // to see the wireframe for each widget.
          //
          // Column has various properties to control how it sizes itself and
          // how it positions its children. Here we use mainAxisAlignment to
          // center the children vertically; the main axis here is the vertical
          // axis because Columns are vertical (the cross axis would be
          // horizontal).
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'You have pushed the button this many times:',
            ),
            Text(
              '$_counter',
              style: Theme
                  .of(context)
                  .textTheme
                  .headline4,
            ),
            TextButton(
                onPressed: () {
                  // 导航到新路由
                  var push = Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) {
                            return const NewRoute();
                          },
                          settings: const RouteSettings(name: "new_route"),
                          maintainState: true,
                          fullscreenDialog: false));
                  debugPrint("push $push 页面");
                },
                child: const Text("open new route")),
            TextButton(
                onPressed: () {
                  // 导航到新路由
                  var push = Navigator.of(context).pushNamed("unknown_page");
                  debugPrint("push $push 页面");
                },
                child: const Text("去未知页面")),
            const RandomWordsWidget()
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }

  @override
  void didPush() {
    /// 当当前路由被推送时调用。
    super.didPush();
    debugPrint("didPop");
  }

  @override
  void didPop() {
    /// 当当前路由被弹出时调用。
    super.didPop();
    debugPrint("didPop");
  }

  @override
  void didPushNext() {
    /// 当新路由被推送，且当前路由不再可见时调用。
    super.didPushNext();
    debugPrint("didPushNext");
  }

  @override
  void didPopNext() {
    /// 当顶部路由被弹出时调用，当前路由显示出来
    super.didPopNext();
    debugPrint("didPopNext");
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    MyApp.routeObserver
        .subscribe(this, ModalRoute.of(context) as PageRoute<dynamic>);
  }

  @override
  void dispose() {
    super.dispose();
    MyApp.routeObserver.unsubscribe(this);
  }
}
