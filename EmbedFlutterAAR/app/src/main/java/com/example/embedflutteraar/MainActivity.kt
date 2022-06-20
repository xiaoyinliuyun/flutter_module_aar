package com.example.embedflutteraar

import androidx.appcompat.app.AppCompatActivity
import android.os.Bundle
import android.view.View
import io.flutter.embedding.android.FlutterActivity

class MainActivity : AppCompatActivity() {
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.activity_main)
    }

    /**
     * 启动一个dart代码入口为main()， 并且Flutter初始路由是'/'。
     */
    fun jumpFlutter(view: View) {
        startActivity(FlutterActivity.createDefaultIntent(this))
    }

    /**
     * 启动一个自定义Flutter初始路由的页面
     */
    fun jumpRouteFlutter(view: View) {
        startActivity(FlutterActivity.withNewEngine().initialRoute("new_page").build(this))
    }

    /**
     * 跳转demo页
     */
    fun jumpDemoWidgetFlutter(view: View) {
        startActivity(FlutterActivity.withNewEngine().initialRoute("demo_widget_page").build(this))
    }

    /**
     * 怎么传参？
     */
    fun jumpTipWidgetFlutter(view: View) {
        startActivity(FlutterActivity.withNewEngine().initialRoute("tip_page").build(this))
    }

    /**
     * 路由测试页
     */
    fun jumpRouterTestRoute(view: View) {
        startActivity(FlutterActivity.withNewEngine().initialRoute("router_test_page").build(this))
    }

    /**
     * 其他
     */
    fun jumpOtherTestRoute(view: View) {
        startActivity(FlutterActivity.withNewEngine().initialRoute("router_page").build(this))
    }
}