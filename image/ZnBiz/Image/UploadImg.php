
<?php
/**
 * 文件上传基类
 * @author	zhangdongdong@w01f.net
 * @since	2015/05/19
 */
class ZnBiz_Image_UploadImg {
    /**
	 * 文件存储路径
	 */
    const CONT = 1;
	private $save_path;
	
	/**
	 * 允许上传的文件类型
	 */
	private $allow_type = array('jpg', 'jpeg', 'bmp', 'png', 'gif');
	
	/**
	 * 允许的最大文件大小 | 单位为KB | 默认为2M
	 */
	private $max_size = 2048;
	
	/**
	 * 上传的图片
	 */
	private $upload_file;
	
	/**
	 * 是否生成缩略图
	 */
	private $create_thumb = false;
	
    /**
	 * 改变后的图片宽度
	 */
	private $thumb_width = 100;
	
	/**
	 * 改变后的图片高度
	 */
	private $thumb_height = 100;
	
	/**
	 * 生成缩略图
	 */
	private $thumb_pic = '';
		
	/**
	 * 是否删除原图
	 */
	private $remove_src = false;
	
	/**
	 * 上传文件名
	 */
	public $file_name;
	
	/**
	 * 上传文件后缀名
	 */
	private $ext;
	
	/**
	 * 上传文件新后缀名
	 */
	private $new_ext;
	
	/**
	 * 默认文件存放文件夹
	 */
	private $default_dir = './';
	
	/**
	 * 错误信息
	 */
	public $error = '';
	
	/**
	 * 是否只显示最后一条错误
	 */
	private $show_last_error = false;
	
	/**
	 * 文件名前缀
	 */
	private $fprefix;

	/**
	 * 语言
	 */
	private $_lang = null;
	
	/**
	 * 默认语言
	 */
	private $_language = 'ZH';
	
	/**
	 * 错误信息定义
	 */
	private static $_arrLang = array(
	    'ZH' => array(
	        'cant_find_temporary_files'       => '找不到临时文件，请确认临时文件夹是否存在可写',
		    'upload_file_size_none'           => '禁止上传空文件',
		    'upload_file_size_cant_over'      => '上传文件大小不能超过',
		    'upload_file_fail'                => '文件上传失败:不具有copy操作权限',
		    'upload_file_size_over'           => '文件大小超出系统设置',
		    'upload_file_is_not_complete'     => '文件仅部分被上传',
		    'upload_dir_chmod'                => '找不到临时文件夹',
		    'upload_file_write_fail'          => '文件写入失败',
		    'upload_file_mkdir'               => '创建目录失败',
		    'upload_file_dir_cant_touch_file' => '目录不能创建文件，请修改权限后再进行上传',
		    'upload_image_px'                 => '像素',
		    'image_allow_ext_is'              => '该类型文件不允许上传，允许的文件类型为: ',
		    'upload_image_is_not_image'       => '非法图像文件',
		    'upload_image_mime_error'         => '图像文件类型非法',
		    'upload_file_attack'              => '非法上传文件',
	        'thumb_file_fail'                 => '图片裁剪失败',
	    ),
	    'EN' => array(
	    
	    ),
	);

	/**
	 * 构造函数
	 */
	function __construct(){
	    
		//加载语言包
		$_setlang = strtoupper($this->_language);
		$this->_lang = self::$_arrLang[$_setlang];
	}
	
	/**
	 * 设置属性
	 */
	public function set($key, $value){
		$this->$key = $value;
	}
	
	/**
	 * 读取
	 */
	public function get($key){
		return $this->$key;
	}

	/**
	 * 获取信息描述
	 */
	public function getLang($str){
		return $this->_lang[$str];
	}
	
	/**
	 * 上传图片
	 * @return true | false
	 */
	public function uploadPic(){
	    
	    $this->upload_file = $_FILES['file'];
	    
	    if($this->upload_file['tmp_name'] == ""){
			$this->setError($this->getLang('cant_find_temporary_files'));
			return false;
		}
		
		//对上传文件错误码进行验证
		$bolError = $this->fileInputError();
		if (!$bolError){
			return false;
		}
		
		//验证是否是合法的上传文件
		if(!is_uploaded_file($this->upload_file['tmp_name'])){
			$this->setError($this->getLang('upload_file_attack'));
			return false;
		}

		//验证文件大小
		if ($this->upload_file['size'] == 0){
			$error = $this->getLang('upload_file_size_none');
			$this->setError($error);
			return false;
		}
		if($this->upload_file['size'] > ($this->max_size * 1024)){
			$error = $this->getLang('upload_file_size_cant_over') . $this->max_size . 'KB';
			$this->setError($error);
			return false;
		}

		//文件后缀名	
		$tmp_ext = explode('.', $this->upload_file['name']);
		$tmp_ext = $tmp_ext[count($tmp_ext) - 1];
		$this->ext = strtolower($tmp_ext);

		//验证文件格式是否为系统允许
		if(!in_array($this->ext, $this->allow_type)){
			$error = $this->getLang('image_allow_ext_is') . implode(',' , $this->allow_type);
			$this->setError($error);
			return false;
		}

		//检查是否为有效图片
		if(!$image_info = @getimagesize($this->upload_file['tmp_name'])) {
			$error = $this->getLang('upload_image_is_not_image');
			$this->setError($error);
			return false;
		}

		//设置图片路径
		$this->save_path = $this->setPath();

		//设置文件名称
		if(empty($this->file_name)){
			$this->setFileName();
		}
		
		//移动文件
		$bolMove = @move_uploaded_file($this->upload_file['tmp_name'], BASE_UPLOAD_PATH . DS . $this->save_path . DS . $this->file_name);
		if(!$bolMove){
		    $error = $this->getLang('upload_file_fail');
			$this->setError($error);
			return false;
		}
		
		return BASE_UPLOAD_PATH . DS . $this->save_path . DS . $this->file_name;
	}
	
	/**
	 * 缩放图片
	 */
	public function resizePic(){
		//是否生成缩略图
		if($this->create_thumb && $this->thumb_width && $this->thumb_height){
		    $objZebraImage = new Base_ZebraImage();
		    
		    //缩放
		    $objZebraImage->source_path = BASE_UPLOAD_PATH . DS . $this->save_path . DS . $this->file_name;
		    $ext = substr($objZebraImage->source_path, strrpos($objZebraImage->source_path, '.') + 1);
		    $objZebraImage->target_path = BASE_UPLOAD_PATH . DS . $this->save_path . DS . 'thumb' . DS . mt_rand(1, 9999) . $this->file_name;
		    $this->setThumbPath(BASE_UPLOAD_PATH . DS . $this->save_path . DS . 'thumb');
		    $bolThumb = $objZebraImage->resize($this->thumb_width, $this->thumb_height, Base_ZebraImage::ZEBRA_IMAGE_BOXED, -1);
		    if(!$bolThumb){
		        $error = $this->getLang('thumb_file_fail');
			    $this->setError($error);
			    return false;
		    }
		    $this->thumb_pic = $objZebraImage->target_path;
		}
		return $this->thumb_pic;
	}
	
	/**
	 * 删除原图
	 */
	public function delSrcPic(){
		if($this->remove_src && is_file(BASE_UPLOAD_PATH . DS . $this->save_path . DS . $this->file_name)){
		    @unlink(BASE_UPLOAD_PATH . DS . $this->save_path . DS . $this->file_name);
		}
		return true;
	}
	
	/**
	 * 获取图片上传路径
	 * @param $type 返回文件类型 | src 原图片 | thumb 缩放后
	 */
	public function getPath($type = 'src'){
	    if($type == 'src'){
	        return BASE_UPLOAD_PATH . DS . $this->save_path . DS . $this->file_name;
	    }
	    elseif ($type == 'thumb'){
	        return $this->thumb_pic;
	    }
	    return null;
	}

	/**
	 * 设置错误信息
	 * @param string $error
	 * @return true | false
	 */
	private function setError($error){
		$this->error = $error;
	}
	
	/**
	 * 获取上传文件的错误信息
	 *
	 * @param string $field 上传文件数组键值
	 * @return string 返回字符串错误信息
	 */
	private function fileInputError(){
		switch($this->upload_file['error']) {
			case 0:
			    return true; //文件上传成功
			    break;
			case 1:
				//上传的文件超过了 php.ini 中 upload_max_filesize 选项限制的值
			    $this->setError($this->getLang('upload_file_size_over'));
			    return false;
			    break;
			case 2:
				//上传文件的大小超过了 HTML 表单中 MAX_FILE_SIZE 选项指定的值
			    $this->setError($this->getLang('upload_file_size_over'));
			    return false;
			    break;
			case 3:
				//文件只有部分被上传
			    $this->setError($this->getLang('upload_file_is_not_complete'));
			    return false;
			    break;
			case 4:
				//没有文件被上传
			    $this->setError($this->getLang('upload_file_is_not_uploaded'));
			    return false;
			    break;
			case 6:
				//找不到临时文件夹
			    $this->setError($this->getLang('upload_dir_chmod'));
			    return false;
			    break;
			case 7:
				//文件写入失败  
			    $this->setError($this->getLang('upload_file_write_fail'));
			    return false;
			    break;
			default:
			    return true;
		}
	}
	
	/**
	 * 设置图片存储路径
	 *
	 * @return string 字符串形式的返回结果
	 */
	private function setPath(){
        //判断目录是否存在，如果不存在 则生成
		if (!is_dir(BASE_UPLOAD_PATH . DS . $this->default_dir)){
			$dir = $this->default_dir;
			$dir_array = explode(DS, $dir);
			$tmp_base_path = BASE_UPLOAD_PATH;
			foreach ($dir_array as $k => $v){
				$tmp_base_path = $tmp_base_path . DS . $v;
				if(!is_dir($tmp_base_path)){
					if (!@mkdir($tmp_base_path, 0755)){
						$this->setError($this->getLang('upload_file_mkdir') . $tmp_base_path . $this->getLang('upload_file_mkdir_fail'));
						return false;
					}
				}
			}
			unset($dir, $dir_array, $tmp_base_path);
		}
		
		//设置权限
		@chmod(BASE_UPLOAD_PATH . DS . $this->default_dir, 0755);

		//判断文件夹是否可写
		if(!is_writable(BASE_UPLOAD_PATH . DS . $this->default_dir)) {
			$this->setError($this->getLang('upload_file_dir') . $this->default_dir . $this->getLang('upload_file_dir_cant_touch_file'));
			return false;
		}
		
		return $this->default_dir;
	}
	
	/**
	 * 设置裁剪图片存储路径
	 *
	 * @return string 字符串形式的返回结果
	 */
	private function setThumbPath($strPath){
        //判断目录是否存在，如果不存在 则生成
		if (!is_dir($strPath)){
		    if (!@mkdir($strPath, 0755)){
			    $this->setError($this->getLang('upload_file_mkdir') . $strPath . $this->getLang('upload_file_mkdir_fail'));
				return false;
			}
			unset($strPath);
		}
		
		//设置权限
		@chmod($strPath, 0755);

		//判断文件夹是否可写
		if(!is_writable($strPath)) {
			$this->setError($this->getLang('upload_file_dir') . $strPath . $this->getLang('upload_file_dir_cant_touch_file'));
			return false;
		}
		
		return $strPath;
	}

	/**
	 * 设置文件名称 不包括 文件路径
	 * 
	 * 生成(从2000-01-01 00:00:00 到现在的秒数+微秒+四位随机)
	 */
	private function setFileName(){
		$tmp_name = sprintf('%010d', time() - 946656000) . sprintf('%03d', microtime() * 1000) . sprintf('%04d', mt_rand(0,9999));
		$this->file_name = (empty($this->fprefix) ? '' : $this->fprefix . '_') . $tmp_name . '.' . ($this->new_ext == '' ? $this->ext : $this->new_ext);
	}
}