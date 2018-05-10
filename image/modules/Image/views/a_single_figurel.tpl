<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/html">
<head>
    <meta name="renderer" content="webkit"/>
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
    <title>{%$pageType%}</title>
    <link rel="stylesheet" type="text/css" href="/css/bootstrap.min.css"/>
    <link rel="stylesheet" type="text/css" href="/css/font-awesome.css" />
    <link rel="stylesheet" type="text/css" href="/css/diagosis.css" />
    <script src="/js/jquery-1.11.3.min.js"></script>
    <script src="/js/diagosis.js"></script>
    <script src="/js/jquery.mousewheel.min.js"></script>
    <script src="/js/jquery.iviewer.js"></script>
    <script src="/js/changeCookie.js"></script>
    <script src="/js/Storage.js"></script>
    <style>
        .btnImgUp>.fa{ color:#ff7372}
        .btnImgDown>.fa{ color:#ffc741}
        .btnImgPlus>.fa{ color:#42c231}
        .btnImgMinus>.fa{ color:#42c231}
        .btnImgLoad>.fa{ color:#047bf9}
        .border-b7d3ee{ border:1px solid #b7d3ee;}
        .img-window{ position: relative;display:table;margin:0 auto;width:700px;height:490px;background:#fff;overflow:hidden;}
        .img-window-m{ position:absolute;top:15px;right:30px;width:240px;height:240px;overflow:hidden;display: none;}
        .img-window>img,.img-window-m>img{ position:absolute;top:0px;left:0px;height: 100%}
        .img-window-m>img{ width: 1400px;height: auto;}
        .padding15{ padding: 15px;}
        .mouseDiv{ position: absolute;top: 0px;left: 0px;height: 100%;z-index: 99;cursor: -webkit-grab}
        .mouseDiv.active{ cursor: -webkit-grabbing}
        .mouseDivOpen{ position: absolute;top: 0px;left: 0px;height: 100%;width:100%;z-index: 999;cursor: none}
        .mouseDivOpen>div{ position: absolute;left: 0px;top:0px;width: 120px;height: 120px;background: rgba(255,255,255,.4);}
        .btn-left,.btn-right{ background: rgba(255,255,255,0.4); padding: 12px; border-radius: 6px;cursor: pointer;}
        .btn-left{position: absolute; left: 0; top: 50%;z-index: 100;}
        .btn-right{position: absolute; right: 0; top:50%;z-index: 100;}
        .mouseImg{width: 100%; height: 100%; margin:0 auto; position: absolute;}
        .imgStretch{z-index: 100;}
        body{background: #000; -moz-user-select: none; }

            /* 插件jquery.iviewer.css css */
        .viewer{-ms-touch-action: none;}
        .iviewer_common{position:absolute; bottom:10px; height: 28px; z-index: 5000;}
        .iviewer_cursor{cursor: url(img/hand.cur) 6 8, pointer;}
        .iviewer_drag_cursor{cursor: url(img/grab.cur) 6 8, pointer;}
        .iviewer_button{width: 28px; cursor: pointer; background-position: center center; background-repeat: no-repeat;}
        .iviewer_zoom_in{ background: url(/images/iviewer.zoom_in.png); position:absolute; top: 63%; left: 94%;}
        .iviewer_zoom_out{background: url(/images/iviewer.zoom_out.png); position: absolute; left: 94%; top: 71%;}
        .iviewer_zoom_zero{background: url(/images/iviewer.zoom_zero.png); position: absolute; left: 94%; top: 79%;}
        .iviewer_zoom_fit{background: url(/images/iviewer.zoom_fit.png); position: absolute; left: 94%; top: 87%;}
        .iviewer_zoom_status{left: 160px; font: 1.5em/28px Sans; color: #00aded; text-align: center; width: 60px; position: absolute; left: 92.5%; top: 94%;}
        .iviewer_rotate_left{left: 227px; background: #fff url(img/iviewer.rotate_left.png) center center no-repeat;}
        .iviewer_rotate_right{left: 262px; background: #fff url(img/iviewer.rotate_right.png) center center no-repeat;} /* jquery.iviewer.css */
        .viewer{width: 64%; height: 500px; border: 1px solid black; position: relative; margin:0 auto; margin-top: 3%;}
        .wrapper{overflow: hidden;}
            /* 插件jquery.iviewer.css  css */
            /* 提示语的样式 */
        .noleft{position: absolute; left: 0; top: 44%;}
        .noright{position: absolute; right: 0; top: 44%;}
        .nomore{padding: 2px 8px; text-align: center; background-color: #969494; color: #fff; border-radius: 6px; border: 2px solid #4a4949;  font-size: 12px; display: none;}
            /*三个按钮样式开始*/
        .set-center{
            margin: 0 auto;
            width: 290px;
            margin-top: 20px;
        }
        .ml-10{
            border:0 none;
        }
        .active{
            color: #fff!important;
            background-color: #03a9f4!important;
        }


        /*配准加载中弹窗开始*/
        .mask{
            width: 28%;
            background: #fff;
            position:absolute;
            left:50%;
            top:50%;
            transform:translate(-50%, -50%);
            padding-bottom: 40px;
        }
        .load-mascot{
            display: block;
            margin:0 auto;
        }
        .load-font{
            margin-top:-50px;
        }
        .fail{
            width: 28%;
            background: #fff;
            position: absolute;
            left: 50%;
            top: 50%;
            transform: translate(-50%, -50%);
            text-align: center;
            height: 60px;
            line-height: 60px;
        }
        .loading-villain{
            position: fixed;
            left: 0;
            top: 0;
            width: 100%;
            height: 100%;
            z-index: 10000;
            background-color: rgba(0,0,0,0.5);
            display: none;
        }
        /*配准加载中弹窗结束*/

    </style>
</head>

<body onselectstart="return false">

<!--查看原图/视盘提取/血管提取 三个按钮开始-->
<div class="set-center">

    <a class="btn btn-default btn-raised ml-10 active  top-btn"  data="0" id="">查看原图</a>
    <a class="btn btn-default btn-raised ml-10 common-blue top-btn" data="1" id="discExtraction">图像增强</a>
    <!--<a class="btn btn-default btn-raised ml-10 common-blue top-btn" data="2" id="vesselExtraction">血管提取</a>-->
</div>
<!--查看原图/视盘提取/血管提取 三个按钮结束-->


<div class="wrapper">
    <div id="newdiv" data=""></div>
    <div id="remindLeft" class="nomore noleft">没有更多了</div>
    <img src="/images/btn-left.png" class="btn-left btnImgUp"/>
    <div id="viewer" class="viewer"></div>
    <div id="remindRight" class="nomore noright">没有更多了</div>
    <img src="/images/btn-right.png"  class="btn-right btnImgDown"/>
</div>




<!--配准奔跑小人加载弹窗开始-->
<div class="loading-villain">
    <div class="mask">
        <img src="/images/load_mascot.gif" class="load-mascot"/>
        <div class="text-center load-font">正在努力加载中,请耐心等待.....</div>
    </div>
</div>
<!--配准奔跑小人加载弹窗结束-->


<!--提取失败，请重新操作 开始-->
<div class="loading-villain">
    <div class="fail">提取失败,请重新操作</div>
</div>
<!--提取失败，请重新操作 结束-->

<script>
    if (!Date.now) {
        Date.now = function now() {
            return new Date().getTime();
        };
    }
    // 设定起始时间
    window.__t = Date.now();
</script>
{%include file="../../Core_Tj/views/statistics.tpl"%}
<script >
    //百度统计开始
    $(function() {
        _hmt.push(['_trackEvent', 'TMS', 'load', 'dom', Date.now() - window.__t]);
    });
    $(window).on('load', function(){
        _hmt.push(['_trackEvent', 'TMS', 'load', 'window', Date.now() - window.__t]);
    });
    //百度统计结束
    $(document).ready(function(){
        var errTime = null;
//        var a_single_figurel = new Date().getTime()-t1;
//        _hmt.push(['_setCustomVar',1,'a_single_figurel', a_single_figurel]);
        var  num, seperateArr = new Array(), imagesList = new Array(), imageNum , count=0, currentImage=null;
        var imgList = new Array();
        var iviewer = {};
        var single = getSessionInfo("data");
        var singleIds = getSessionInfo('imageIdArray');
        if (single == null){
            single = $("#newdiv").attr("data");
        }else {
            init(single);
        }
        if (single == ""){
            readData();
        }else {
            init(single);
        }
        function readData() {
            var singleData = getLocalStorageItem("imageData");
            singleIds = getLocalStorageItem('imageIdArray');
            if (singleData == ""){
                if (count++ < 10){
                    setTimeout(readData, 100);
                }
                return "";
            }else {
                setSessionInfo('imageIdArray', singleIds);
                cleanLocalStorageItem('imageIdArray');
                setSessionInfo("data", singleData);
                cleanLocalStorageItem("imageData");
                init(singleData);
            }
        }

        function init(singleData) {
            singleData = decodeURI(singleData);
            singleData = singleData.replace(/\%2F/g, "/");
            singleData = singleData.replace(/\%3A/g, ":");

            seperateArr = singleData.split("&");
            imgList.splice(0, imgList.length);
            for (var i = 0; i < seperateArr.length; i++){
                var small = seperateArr[i].split("=");
                if (small[0] == "images[]" && small.length == 2){
                    imgList.push(small[1]);
                }else if(small[0] == "imgnum" && small.length == 2){
                    num = small[1];
                }else if(small[0] == "images[]" && small.length == 3){
                    imgList.push(small[1]+'='+small[2]);
                }
            }
            imagesList = imgList;
            imageNum = num;
            $("#viewer").empty().css("opacity", "0.05").iviewer({
                src: imagesList[imageNum],
                initCallback: function() {
                    iviewer = this;
                }
            });
            setTimeout(showImageView , 200);
        }

        var stretch = true;
        var showBool = false;


        /*上一页*/
        $(".btnImgUp").on("click",function(a) {
            if(imageNum == 0){
                showAlert(0);
                return false;
            }
            imageNum--;
            var imgSrc=imagesList[imageNum];
            changeImage(imgSrc)
            currentImage = null;
        });
        /*下一页*/
        $(".btnImgDown").on("click",function(a) {
            if(imageNum == imagesList.length-1){
                showAlert(1);
                return false;
            }
            imageNum++;

            var imgSrc=imagesList[imageNum];
            currentImage = null;
            changeImage(imgSrc);
        });

        function showImageView() {
            $("#viewer").css("opacity", 1);
        }



        function changeImage(imgSrc){
            $("#viewer").empty().css("opacity", "0.05").iviewer(
                {
                    src: imgSrc,
                    initCallback: function()
                    {
                        iviewer = this;
                    }
                });
            setTimeout(showImageView , 200);
        }
        //提示语
        function showAlert(isLeft) {
            if (showBool){
                return;
            }
            switch (isLeft){
                case 0:{
                    $(".noleft").show();
                }
                    break;
                case 1:{
                    $(".noright").show();
                }
                    break;
                default:
                    break;
            }
            showBool = true;
            setTimeout(hidden, 1000);

        }
        function hidden() {
            $(".noleft").hide();
            $(".noright").hide();
            showBool = false;
        }





        //视盘提取开始
        $('.top-btn').click(function (e) {

            var $that = $(this),
                imgType = $that.attr('data');
            if ($that.hasClass('active')){
                return false;
            }

            if (imgType == 0){
                changeImage(imagesList[imageNum]);
                $that.addClass('active').siblings().removeClass('active');
                return false;
            }


            var imgIds = JSON.parse(singleIds);
            if (!(imgIds && imgIds.length > imageNum)){
                alert('图片id错误,请重试');
                return false;
            }
//            if (currentImage){
//                changeImage(currentImage.imageUrl);
//                return false;
//            }
            var data = {
                imageUrl:imagesList[imageNum],
                imageType:imgType,
                imageId : imgIds[imageNum]
            };
            $that.addClass('active').siblings().removeClass('active');

            switch (imgType){
                case '1':{
                    $('.loading-villain:first').show();
                    getDiscExtraction(data);
                }
                    break;
                case '2':{
                    $('.loading-villain:first').show();
                    getVesselExtraction(data);
                }
                    break;
                default:
                    break;
            }

        });
        function showErrView(errInfo) {
            if (errTime){
                errTime = null;
            }
            errInfo = ((errInfo == '')?errInfo: '提取失败，请重新操作');
            var $errView = $('.loading-villain:last');
            $errView.find('fail').html(errInfo);
            $errView.show();
            errTime = setTimeout(function () {
                $errView.hide();
                errTime = null;
            }, 2000);
        }

        function getDiscExtraction(data) {

            $.ajax({
                url:'/Registration/Algorithm/doOpticDisc',
                type:'POST',
                dataType: 'json',
                data:data,
                success:function (response) {
                    $('.loading-villain:first').hide();
                    if (response.status == 0){
                        console.log('getDiscExtraction', response);
                        changeImage(response.data.imageUrl);
                        currentImage = response.data;
                    }else if (response.status == 800){
                        location.href = '/login/index/index'
                    }else{
                        showErrView(response.statusInfo)
                    }
                },

                error:function () {

                }
            })
        }
        //视盘提取结束


        //血管提取开始
        function getVesselExtraction(data) {
            $.ajax({
                url:'/Registration/Algorithm/doBloodVessel',
                type:'POST',
                dataType: 'json',
                data:data,
                success:function (response) {
                    $('.loading-villain:first').hide();
                    if (response.status == 0){

                        changeImage(response.data.imageUrl);
                        currentImage = response.data;
                        console.log('getVesselExtraction', response);
                    }else if (response.status == 800){
                        location.href = '/login/index/index'
                    }else{
                        showErrView(response.statusInfo)
                    }
                },

                error:function () {

                }
            })
        }
        //血管提取结束


    });



</script>

</body>
</html>

