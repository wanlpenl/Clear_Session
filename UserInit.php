<?php
/**
 * 用户权限控制插件
 * @author	zhangdongdong@w01f.net
 * @since	2014/11/12
 */
class UserInitPlugin extends Yaf_Plugin_Abstract {
    
    public function routerShutdown(Yaf_Request_Abstract $request) {
        $module = $request->getModuleName();
		$controller = $request->getControllerName();
		$action = $request->getActionName();

		//不做登录验证的Module和controller
		if(in_array(strtolower($module), array('index', 'api', 'login', 'error',))){
		    return TRUE;
		}
		if(in_array(strtolower($controller), array())){
			return TRUE;
		}
		if (in_array(strtolower($module),array("remotetalk","prompt")) && in_array(strtolower($controller),array("index","gettingsartedguide")) && in_array($action,array("remoteapplyapi","getguide"))){
		    return TRUE;
        }
		
		//登录页跳转地址
        $strLoginUrl = ZnBiz_Ini_Parser::getLoginUrl();

		//判断用户登录状态
		$_objUserLogin = new ZnBiz_Login_Logic_Login();
        $bolUserLogin = $_objUserLogin->isUserLogin();
		if(!$bolUserLogin){
			header("Location:{$strLoginUrl}");
			exit();
		}
        $_objLogicUserInfo  = new ZnBiz_Login_Logic_UserInfo();
        $intUserid          = $_objUserLogin->getLoginUserid();
        $arrUserInfo        = $_objLogicUserInfo->getInfoByUserId($intUserid);
        $arrLoginUser = array(
            'userid'    => $intUserid,//用户ID
            'username'  =>$arrUserInfo[0]['doctor_name'],//用户名
        );
        Yaf_Registry::set("user", $arrLoginUser);
    }
    
	public function dispatchLoopStartup(Yaf_Request_Abstract $request) {
        $arrUserinfo = Yaf_Registry::get("user");
        Yaf_Dispatcher::getInstance()->initView(NULL)->assign("sitename", Base_Config::getConfig('sitename'));
        Yaf_Dispatcher::getInstance()->initView(NULL)->assign("sitedomain", Base_Config::getConfig('sitedomain'));
        Yaf_Dispatcher::getInstance()->initView(NULL)->assign("userlist", $arrUserinfo);
    }
}
