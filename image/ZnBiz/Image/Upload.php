<?php
/**
 * 图片上传逻辑处理
 * @author	zhangdongdong@w01f.net
 * @since	2015/05/19
 */
class ZnBiz_Image_Upload {


    private static $_arrDirType = array(
        'product', 'head'
    );

    public function __construct(){
        $this->_path = APPLICATION_PATH."/public/images/resourceImg/";
        $this->_pathPublic = APPLICATION_PATH.'/public/';
    }

    public function upImg($strType, $bolThumb = false, $arrSize = array(), $delete_src = false){
        
        $arrReturn = array();
        
        //判断上传的路径和类型
        if(!in_array(strtolower($strType), self::$_arrDirType)){
            $arrReturn = array(
                'status' => 1,
                'msg' => ZnBiz_Msg_Error::getMessage(ZnBiz_Msg_Error::UPLOAD_FILE_TYPE_ERR),
            );
            return $arrReturn;
        }
        
        //存储图片
        $objImage = new Base_UploadImg();
        $objImage->set('default_dir', $strType . '/' . date('Ymd'));
        $objImage->set('max_size', Base_Config::getConfig('uploadfilesize'));
        
        $strUpUrl = $objImage->uploadPic();
        if(empty($strUpUrl)){
            $arrReturn = array(
                'status' => 1,
                'msg' => $objImage->error,
            );
            return $arrReturn;
        }
        
        $arrReturn = array(
            'status' => 0,
            'url' => array(
                'src' => $strUpUrl,
            )
        );
        
        //是否需要缩放
        if($bolThumb && is_array($arrSize) && !empty($arrSize)){
            foreach ($arrSize as $_key => $_arrV)
            {
                $objImage->set('create_thumb', true);
                $objImage->set('thumb_width', intval($_arrV[0]));
                $objImage->set('thumb_height', intval($_arrV[1]));
                $strResizePic = $objImage->resizePic();
                if(empty($strResizePic)){
                    $arrReturn = array(
                		'status' => 1,
                		'msg' => $objImage->error,
                    );
                    return $arrReturn;
                }
                $size_key = 'pic' . ($_key + 1);
                $arrReturn['url'][$size_key] = $strResizePic;
            }
        }
        
        //是否需要删除原图片
        if($delete_src){
            $objImage->set('remove_src', $delete_src);
            $objImage->delSrcPic();
        }

        //处理返回路径
        if(empty($arrReturn)){
            $arrReturn = array(
            	'status' => 1,
            	'msg' => ZnBiz_Msg_Error::getMessage(ZnBiz_Msg_Error::UPLOAD_FILE_FAILED),
            );
            return $arrReturn;
        }
        $strPrefix = Base_Config::getConfig('uploadfilepath');
        foreach ($arrReturn['url'] as $_name => $_value)
        {
            $arrReturn['url'][$_name] = str_replace($strPrefix, '/upload', $arrReturn['url'][$_name]);
        }
        
        Base_Log::notice($arrReturn);
        
        return $arrReturn;
    }


    /**
     * 上传图片 图片未进行格式大小限制
     * @param $img
     * @param $imgPath
     * @return bool|string
     */
    public function uploadFile($img, $imgPath){
        //接收文件目录
        $typeArr = array(
            'jpg' => 'image/jpeg',
            'png' => 'image/png',
            'gif' => 'image/gif',
	    'pdf' => 'application/pdf',
        );
        if($img['type'] == "application/octet-stream"){
            $imageMime = getimagesize($img['tmp_name']);
            $type = strtolower($imageMime['mime']);
	    if(!$type){
                $type = end(explode('.', $img['name']));
                if(strtolower($type) == 'pdf'){
                    $type = 'application/pdf';
                }
            }
        }else {
            $type = strtolower($img['type']);
        }
        $searchType = array_search($type,$typeArr);
        if($searchType){
//            $filesName = $this->randpw(6).'.'.$searchType;
            $target_path = rtrim($imgPath,"/"). '/' .$img['name'];
            if(move_uploaded_file($img['tmp_name'], $target_path)) {
                $path =  $img['name'];
                return $path;
            }else{
                return false;
            }
        }
        return false;//图片格式不正确
    }

    /**
     * 上传图片 图片未进行格式大小限制
     * @param $img
     * @param $imgPath
     * @return bool|string
     */
    public function uploadFilePublic($img, $imgPath){
        //接收文件目录
        $typeArr = array(
            'jpg' => 'image/jpeg',
            'png' => 'image/png',
            'gif' => 'image/gif',
        );
        if($img['type'] == "application/octet-stream"){
            $imageMime = getimagesize($img['tmp_name']);
            $type = strtolower($imageMime['mime']);
        }else {
            $type = strtolower($img['type']);
        }
        $searchType = array_search($type,$typeArr);
        if($searchType){
            $filesName = $this->randpw(6).'.'.$searchType;
            $target_path = $this->_pathPublic .$imgPath.$filesName;
            if(move_uploaded_file($img['tmp_name'], $target_path)) {
                $path =  $imgPath.$filesName;
                return $path;
            }else{
                return false;
            }
        }
        return false;//图片格式不正确
    }

    /**
     * 产生随机数
     * @param int $len
     * @return string
     */
    public function randpw($len=8){
        $password = '';
        $tmp = '';
        $chars='ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789';
        while(strlen($password)<$len){
            $tmp =substr($chars,(rand()%strlen($chars)),1);
            $password.= $tmp;
        }
        return $password;
    }
}
