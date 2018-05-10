<?php
class Bootstrap extends Yaf_Bootstrap_Abstract{
    /**
     * 注册本地类 | 文件在library中
     */
	public function _initLocalNames() {
		$loader = Yaf_Loader::getInstance();
		$loader->registerLocalNamespace(array('Base', 'Smarty', 'ZnBiz','Bos'));
	}
    
    /**
     * 配置
     * @param Yaf_Dispatcher $dispatcher
     */
    public function _initConfig(Yaf_Dispatcher $dispatcher) {
		Base_Config::setOption(array('section' => ini_get('yaf.environ')));
    }
    
	/**
	 * 设置默认的Controller | Module | Action
	 * @param Yaf_Dispatcher $dispatcher
	 */
    public function _initDefaultName(Yaf_Dispatcher $dispatcher) {
        $dispatcher->setDefaultModule("Index")->setDefaultController("Index")->setDefaultAction("msg");
    }
    
    /**
     * 视图
     * @param Yaf_Dispatcher $dispatcher
     */
    public function _initView(Yaf_Dispatcher $dispatcher) {
        $smarty = new Smarty_Adapter(null, Base_Config::getConfig("smarty"));
	    Yaf_Dispatcher::getInstance()->setView($smarty);
    }

    /**
     * 路由协议栈，后入先验证，默认已添加Ap_Route_Static自动划分module/controller/action
     * Yaf_Dispatcher $dispatcher
     */
    public function _initRoute(Yaf_Dispatcher $dispatcher) {
        $router = Yaf_Dispatcher::getInstance()->getRouter();
        $router->addConfig(Base_Config::getConfig('routes', CONF_PATH . '/route.ini'));
    }

    /**
     * 初始化Cache配置
     */
    public function _initCacheName(Yaf_Dispatcher $dispatcher){
        
    }
}
