# Refresh

这是一个刷新控件的封装  是参考网上demo书写，有比较好的延展性

    这个刷新控价，有CustomrefreshView和CustomrefreshView1两种类型，两种
型设计思路大致相同：
（1）    创建一个刷新View的基类，以scrollView为背景，用KVO的方式兼听属性contentoffset的变化，接口方法是自定义加载界面，进行布局子界面;开始刷新；结束刷新；当scrollView的contentOffset和contentSize变更时调用的方法。

（2）    创建一个头部和底部刷新的View，写出接口初始化方法，并在.m中调用初始化，主要是设置相应的UI界面，以及根据基类的枚举状态来判断刷新的情况<判断分两种：1、拖拽时，偏移量的大小   2、如果处于拖拽后的刷新状态>
  
（3）    写枚举变量的set方法，通过枚举的状态，来调节UI界面和刷新动画

 (4)    重写开始刷新方法，通过枚举的Loading状态，设置刷新时的动画

 (5)    假如是底部刷新，重写结束刷新方法

 (6)    创建一个scrollview的扩展类，写接口方法   



其中，文件CustomRefreshView中的刷新方法的延展性更加高级
