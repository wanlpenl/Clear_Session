<?php

/**
 * 图片模块
 * @author	lixiangli@w01f.net
 * @since	2016/07/13
 */
class ImageController extends Base_Controller_Abstract
{

    private $_objUserLogin = NULL;
    private $_strLoginUrl = NULL;
    /**
     * 在每个Action执行之前都会执行
     */
    public function init()
    {
        parent::init();
        Yaf_Dispatcher::getInstance()->autoRender(FALSE);
    }


    /**
     * 单图图片查看
     */
    public function aSingleFigurelAction()
    {
        $images = $_GET["images"];
        $num = $_GET["imgnum"];
        $numt = $num-1;
        $url = $images[$numt];
        $this->getView()->assign('images', $images); //图片列表
        $this->getView()->assign('url', $url); //图片列表
        $this->getView()->assign('imagesStr', json_encode($images, true)); //图片列表
        $this->getView()->display('a_single_figurel.tpl');
    }

    /**
     * 多图图片查看
     */
    public function multipleAction()
    {
        $images = $_GET['image']; //图片位置
        $this->getView()->assign('images', $images);
        $this->getView()->display('multiple.tpl');
    }

    /**
     * 闪烁图片查看
     */
    public function flashingAction()
    {
        $images = $_GET['image']; //图片位置
        $this->getView()->assign('images', $images);
        $this->getView()->display('flashing.tpl');
    }


    /**
     * 对比显示图片查看
     */
    public function contrastImagesAction()
    {
        $images = $_GET['image']; //图片位置
        $this->getView()->assign('images', $images);
        $this->getView()->display('contrast_images.tpl');
    }

    /**
     * 对比检查图片查看
     */
    public function contrastCheckPicturesAction()
    {
        $objReadImage = new ZnBiz_Remote_Logic_Remote();
        $oneId = intval($this->getRequest()->getQuery('oneId', 0)); //第一个检查的id
        $twoId = intval($this->getRequest()->getQuery('towId', 0)); //第二个检查的id
        if (empty($oneId) || empty($twoId)) {
            return false;
        }
        /* 第一个检查的图像 */
        $arrOne = $objReadImage->getDoCheckImageById($oneId);
        /* 第二个检查的图像 */
        $arrTwo = $objReadImage->getDoCheckImageById($twoId);
        $info = $objReadImage->getCheckInfo($oneId, $twoId,$this->_login_userhospital);
        $this->getView()->assign('pageType', "对比");
        $this->getView()->assign('info', $info);
        $this->getView()->assign('arrOne', $arrOne);
        $this->getView()->assign('arrTwo', $arrTwo);
        $this->getView()->display('contrast_check_pictures.tpl');
    }
}
