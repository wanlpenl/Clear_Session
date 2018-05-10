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
    <script src="/js/util.js"></script>
    <script src="/js/Storage.js"></script>
    <style>
        html,body{ float: left;width: 100%;height: 100%;}
        .minHeight{ float:left;width: 50%;height: 100%;overflow: auto;}
        .minImg>img{ float:left;height: 400px;}
        .minWidth>img{ display: none;margin: 10px auto;max-width: 100%;}
        .minWidth>img:first-child{ display:block;}
        table{ margin-top: 15px;}
        table td{ vertical-align: top;text-align: center;width: 130px;}
        table td>input{ vertical-align: top;}
        div.imageOpenInput{ position: relative;display: inline-block;width: 100px;height: 100px;overflow: hidden; line-height: 100px;text-align: center;cursor: pointer}
        .btn-div{ position: absolute;top:0px;right: 15px;width: 75px;z-index: 2}
        .mouseImg,.mouseDiv{ position: absolute;top: 0px;left: 0px;width: 100%;}
        .mouseDiv{ height: 100%;z-index: 1;cursor: -webkit-grab}
        .mouseDiv.active{ cursor: -webkit-grabbing}
        .dis-border-left{ border-left: 7px solid #f3f3f3;}
        .dis-border-right{ border-right: 7px solid #f3f3f3;}
        .mt-30{ margin-top: 30px;}
        .pt-10{ padding-top: 10px;}

        .pair{float: right; margin-top: 10px;}
        .ln_clear{clear:both;}
        .btn-left,.btn-right{ background: rgba(255,255,255,0.4); padding: 12px; border-radius: 6px;cursor: pointer;}
        .btn-left{position: absolute; left: 0; top: 50%;}
        .btn-right{position: absolute; right: 0; top: 50%;}
        body{background: #000;}

        .noleft{position: absolute; left: 0; top: 44%;}
        .noright{position: absolute; right: 0; top: 44%;}
        .nomore{padding: 2px 8px; text-align: center; background-color: #969494; color: #fff; border-radius: 6px; border: 2px solid #4a4949;  font-size: 12px; display: none;}
    </style>
</head>

<body>
<div>


    <!--闪烁显示-->

    <div id="newdiv" data=""></div>
    <div id="remindLeft" class="nomore noleft">没有更多了</div>
    <img src="/images/btn-left.png" id="preBtn" class="btn-left" />
    <div class="text-center minWidth" id="minWidth">
        <!--{%foreach from=$images item = i%}-->
        <!--<img src="{%$i%}">-->
        <!--{%/foreach%}-->
    </div>
    <div id="remindRight" class="nomore noright">没有更多了</div>
    <img src="/images/btn-right.png" id="nextBtn" class="btn-right"/>
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
    <script>
        var flashing = performance.timing.domComplete -performance.timing.navigationStart;
        (function() {
            //百度统计开始

            $(function() {
                _hmt.push(['_trackEvent', 'TMS', 'load', 'dom', Date.now() - window.__t]);
            });
            $(window).on('load', function(){
                _hmt.push(['_trackEvent', 'TMS', 'load', 'window', Date.now() - window.__t]);
            });
            //百度统计结束
        })();
    </script>
    <script>
        //  获取当前窗口尺寸
        function getWindowSize(){
            var winWidth = 0;
            var winHeight = 0;
            // 获取窗口宽度
            if (window.innerWidth) {
                winWidth = window.innerWidth;
            }else if ((document.body) && (document.body.clientWidth)) {
                winWidth = document.body.clientWidth;
            }
            // 获取窗口高度
            if (window.innerHeight) {
                winHeight = window.innerHeight;
            }else if ((document.body) && (document.body.clientHeight)) {
                winHeight = document.body.clientHeight;
            }
            // 通过深入 Document 内部对 body 进行检测，获取窗口大小
            if (document.documentElement && document.documentElement.clientHeight && document.documentElement.clientWidth){
                winHeight = document.documentElement.clientHeight;
                winWidth = document.documentElement.clientWidth;
            }
            return {winWidth:winWidth,winHeight:winHeight};
        }
        $(document).ready(function(){
//            var flashing = new Date().getTime()-t1;
//            _hmt.push(['_setCustomVar',1,'flashing', flashing]);
            var t = null;

            var num = 0;
            var index = 0;
            var count = $("#minWidth>img").size();
            var showBool = false;
            var maxIndex = (count % 2 ==0?count - 2:count - 3);
            var seperateArr = new  Array, imgList = new Array;

            var flash = getSessionInfo("data"),
                dataNew = getLocalStorageItem('imageDataNew');
            if (dataNew != '1'){
                if (flash == null){
                    flash = $("#newdiv").attr("data");
                }else {
                    init(flash);
                }
                if (flash == ""){
                    readData();
                }else {
                    init(flash);
                }
            }else {
                readData();
                cleanLocalStorageItem('imageDataNew');
            }


            function readData() {
                var flashData = getLocalStorageItem("imageData");
                if (flashData == ""){
                    setTimeout(readData, 100);
                    return "";
                }else {
                    setSessionInfo("data", flashData);
                    cleanLocalStorageItem("imageData");
                    init(flashData);
                }
            }

            function init(flashData) {

                flashData = decodeURI(flashData);
                flashData = flashData.replace(/\%2F/g, "/");
                flashData = flashData.replace(/\%3A/g, ":");
                seperateArr = flashData.split("&");
                imgList.splice(0, imgList.length);
                for (var i = 0; i < seperateArr.length; i++) {
                    var small = seperateArr[i].split("=");
                    if (small[0] == "image[]" && small.length == 2) {
                        imgList.push(small[1]);
                    } else if (small[0] == "imgnum" && small.length == 2) {
                    }else if(small[0] == "image[]" && small.length == 3){
                        imgList.push(small[1]+'='+small[2]);
                    }
                }
                count = imgList.length;
                maxIndex = (count % 2 ==0?count - 2:count - 3);
                imgList.forEach(function(element, index){
                    $("#minWidth").append("<img src='"+element+"'>");
                });
                changeImgs();
            }


            $("#preBtn").click(function (a) {
                clearTime();
                if (count <= 3) {
                    showAlert(0);
                    changeImgs();
                    return false;
                }
                index -= 2;
                if (index < 0) {
                    index = 0;
                    showAlert(0);
                }
                num = index;
                changeImgs();

            });



            $("#nextBtn").click(function (a) {
                clearTime();
                if (count <= 3) {
//            alert("当前只有一对图片");
                    showAlert(1);
                    changeImgs();
                    return false;
                }
                index += 2;
                if (index > maxIndex) {
                    index = maxIndex;
                    showAlert(1);
                }
                num = index;
                changeImgs();

            });
            function clearTime() {
                window.clearTimeout(t);
                t = null;

            }
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
            function changeImgs() {

                var img = new Image()
                img.src = $("#minWidth>img").attr("src");
                var imgW = img.width;
                var imgH = img.height;
                var winSize = getWindowSize();
                $("#minWidth>img").css({width:"auto", height:winSize.winHeight});

                $("#minWidth>img").eq(num).show().siblings("img").hide();
                num++;
                if (num > index + 1){
                    num = index;
                }
                clearTime();
                t = setTimeout(changeImgs, 2000);
            }

        });
    </script>
</body>
</html>
