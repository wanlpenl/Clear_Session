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
    <script src="/js/jquery.mousewheel.min.js"></script>
    <script src="/js/jquery.iviewer.js"></script>
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
        body{background:#000;}

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
           .iviewer_zoom_status{left: 160px; font: 1.5em/28px Sans; color: #fff; text-align: center; width: 60px; position: absolute; left: 91.5%; top: 94%;} 
           .iviewer_rotate_left{left: 227px; background: #fff url(img/iviewer.rotate_left.png) center center no-repeat;} 
           .iviewer_rotate_right{left: 262px; background: #fff url(img/iviewer.rotate_right.png) center center no-repeat;} /* jquery.iviewer.css */ 
           .viewer{width: 100%; height: 500px; border: 1px solid black; position: relative; margin:0 auto;} 
           .wrapper{overflow: hidden;}
        /* 插件jquery.iviewer.css  css */
    </style>
</head>
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
<body>
<div>
{%if $pageType == "闪烁显示"%}

<!--闪烁显示-->

  <!--上一对 下一对的按钮-->
  <div class="pair">
    <button type="button" id="preBtn">上一对</button>
    <button type="button" id="nextBtn">下一对</button>
  </div>
  <div class="ln_clear"></div>
  <!--上一对 下一对的按钮-->
  <div class="text-center minWidth" id="minWidth">
      {%foreach from=$images item = i%}
      <img src="{%$i%}">
      {%/foreach%}
  </div>
<script>
    //百度统计开始

    $(function() {
        _hmt.push(['_trackEvent', 'TMS', 'load', 'dom', Date.now() - window.__t]);
    });
    $(window).on('load', function(){
        _hmt.push(['_trackEvent', 'TMS', 'load', 'window', Date.now() - window.__t]);
    });
    //百度统计结束
    $(document).ready(function(){

//        var contrast_images = new Date().getTime()-t1;
//        _hmt.push(['_setCustomVar',1,'contrast_images', contrast_images]);
        var num = 0;
         var index = 0;
        var count = $("#minWidth>img").size();
        var t="";
        var maxIndex = (count % 2 ==0?count - 2:count - 3);
        $("#preBtn").click(function (a) {
          clearTime();
          if (count <= 3) {
            alert("当前只有一对图片");
            changeImgs();
            return false;
          }
          index -= 2;
          if (index < 0) {
            index = maxIndex;
          }
          
          num = index;
          changeImgs();
        })
        $("#nextBtn").click(function (a) {
          clearTime();
          if (count <= 3) {
            alert("当前只有一对图片");
            changeImgs();
            return false;
          }
          index += 2;
          if (index > maxIndex) {
            index = 0;
          }
          num = index;
          changeImgs();
        })
        function clearTime() {
          window.clearTimeout(t);
        }
        function changeImgs() {
            $("#minWidth>img").eq(num).show().siblings("img").hide();
            num++;
            //if(num >= $("#minWidth>img").size()){
            if (num > index + 1){
                num = index;
            }
            t = setTimeout(changeImgs, 1000);
        }
        changeImgs();

        /*setInterval(function() {
            $("#minWidth>img").eq(num).show().siblings("img").hide();
            num++;
            //if(num >= $("#minWidth>img").size()){
            if (num > index + 1){
                num = index;
            }
        },1000);*/
    });


    /*放大缩小比例尺*/
    /*比例尺开始*/
/*图片缩放进度开始*/
        $(".imgStretch>.fa").on("click",function(){
            var $jindu = $(this).closest(".imgStretch").find(".stretchIcon");
            var top = $jindu.position().top;
            var maxTop = $jindu.parent().height();
            if($(this).hasClass("fa-plus")){
                top -= 5;
            }else{
                top += 5;
            }
            top = top<0?0:top;
            top = top>maxTop?maxTop:top;
            $jindu.css({ top:top});
            stretchIcon($(this));
        });
        $(".imgStretch").mousemove(function(e){
            if(!stretch){
                return false;
            }
            var $stretchObj=$(this).find(".stretchIcon:first");
            var maxHeight=$stretchObj.parent("div").height();
            var top = e.pageY-stretchY;
            top = top<0?0:top;
            top = top>maxHeight?maxHeight:top;
            $stretchObj.css({ top:top+"px"});
            stretchIcon($(this));
        });
        $(".stretchIcon").mousedown(function(e) {
            var pageY= e.pageY - $(this).position().top;
            stretchY=pageY;
            stretch = true;
        });
        $(".imgStretch").mouseout(function(e){
            //stretch = false;
        });
        /*图片缩放进度结束*/
        $(".mouseDiv").mousemove(function(e){
            if(!mouseBool){
                return false;
            }
            var $imageObj=$(this).prev("img");
            var maxWidth = $(this).width() -$imageObj.outerWidth();
            var maxHeight = $(this).height() -$imageObj.outerHeight();
            var left = e.pageX-pageList[0];
            if(maxWidth<0){
                left = left<maxWidth?maxWidth:left;
                left = left>0?0:left;
            }else{
                left = left<0?0:left;
                left = left>maxWidth?maxWidth:left;
            }
            var top = e.pageY-pageList[1];
            if(maxHeight<0){
                top = top<maxHeight?maxHeight:top;
                top = top>0?0:top;
            }else{
                top = top <0?0:top;
                top = top>maxHeight?maxHeight:top;
            }
            $imageObj.css({
                left:left+"px",
                top:top+"px"
            });
        });
        $(".mouseDiv").mousedown(function(e) {
            $(this).addClass("active");
            var $imageObj=$(this).prev("img");
            var pageX= e.pageX - $imageObj.position().left;
            var pageY= e.pageY - $imageObj.position().top;
            pageList=[pageX,pageY];
            mouseBool = true;
        });

        $(document).mouseup(function(e){
            $(".mouseDiv").removeClass("active");
            mouseBool = false;
            stretch = false;
        });
        $(".mouseDiv").mouseout(function(e){
            $(".mouseDiv").removeClass("active");
            mouseBool = false;
        });
        /*图片放大*/
        $(".imageBig").on("click",function(){
            var imageObj=$(this).closest(".col-lg-6").find(".mouseImg:first");
            var width=imageObj.width()+10+"px";
            var height=imageObj.height()+10+"px";
            var left=imageObj.position().left-5+"px";
            var top=imageObj.position().top-5+"px";
            imageObj.css({
                width:width,
                left:left,
                top:top,
                height:height
            });
        });
        /*图片缩小*/
        $(".imageSmall").on("click",function(){
            var imageObj=$(this).closest(".col-lg-6").find(".mouseImg:first");
            var width=imageObj.width()-10;
            var height=imageObj.height()-10+"px";
            var left=imageObj.position().left+5+"px";
            var top=imageObj.position().top+5+"px";
            if(width < 100){
                return false;
            }
            imageObj.css({
                width:width+"px",
                left:left,
                top:top,
                height:height
            });
        });
/*比例尺结束*/
    /*放大缩小比例尺*/
</script>
{%/if%}
<!--双窗口显示-->


    <div id="newdiv" data=""></div>
<div class="col-lg-12">
    <div class="col-lg-6 bg-ff pt-10" style="background: #000; width:50%; float:left;">
        <div class="wrapper">
            
            <div id="viewer1" class="viewer">
                
            </div>
            
        </div>
    </div>
    <div class="col-lg-6 bg-ff pt-10" style="background: #000; width:50%; float:left;">
        <div class="wrapper">
            
            <div id="viewer2" class="viewer">
                
            </div>
            
        </div>
    </div>

</div> 

<!--{%foreach from=$images item = i%}-->
<!--<div class="hiddenImg" style="display: none;">-->
    <!--<div data ="{%$i%}" ></div>-->
<!--</div>-->
<!--{%/foreach%}-->

<script type="text/javascript">



    $(function () {
        var imgList = new Array, count = 0;
        var seperateArr = new Array;
        var iviewer = {};

        var pair = getSessionInfo("data");
        if (pair == null){
            pair = $("#newdiv").attr("data");
        }else {
            init(pair);
        }
        if (pair == ""){
            readData();
        }else {
            init(pair);
        }

        function readData() {

            var pairData = getLocalStorageItem("imageData");
            if (pairData == ""){
                if (count ++ <10){
                    setTimeout(readData, 100);
                }
                return "";
            }else {
                setSessionInfo("data", pairData);
                cleanLocalStorageItem("imageData");
                init(pairData);
            }
        }

        function init(pairData) {
            pairData = decodeURI(pairData);
            pairData = pairData.replace(/\%2F/g, "/");
            pairData = pairData.replace(/\%3A/g, ":");
            seperateArr = pairData.split("&");
            imgList.splice(0, imgList.length);
            for (var i = 0; i < seperateArr.length; i++){
                var small = seperateArr[i].split("=");
                if (small[0] == "image[]" && small.length == 2){
                    imgList.push(small[1]);
                }else if(small[0] == "imgnum" && small.length == 2){
                }else if(small[0] == "image[]" && small.length == 3){
                    imgList.push(small[1]+'='+small[2]);
                }
            }



            if (!imgList.length)return;
            $("#viewer1").empty().iviewer({
                src: imgList[0],
                initCallback: function() {
                    iviewer = this;
                }
            });
            if (imgList.length == 2){
                $("#viewer2").empty().iviewer({
                    src: imgList[1],
                    initCallback: function()
                    {
                        iviewer = this;
                    }
                });
            }

        }


//        $("#viewer1").iviewer(
//        {
//          src: src1,
//          initCallback: function()
//          {
//            iviewer = this;
//          }
//        });
//
//        if (count == 2){
//            $("#viewer2").iviewer({
//                        src: src2,
//                        initCallback: function()
//                        {
//                            iviewer = this;
//                        }
//                    });
//        }
    });

  function stretchIcon($obj){
        var $topParent = $obj.closest(".w-h-4-3");
        var $imgObj = $topParent.find(".mouseImg:first");    //图片
        var $stretchIcon = $topParent.find(".stretchIcon:first");//进度
        var topbili = $stretchIcon.position().top / $stretchIcon.parent().height();
        var bili = 0,width,height,left,top,maxWidth,maxHeight;
        if(topbili<0.5){
            bili = 500-(400*2*topbili);
        }else{
            bili = 100-(80*2*(topbili-0.5));
        }
        bili = bili/100;
        width = $topParent.width()*bili;
        height = $topParent.outerHeight()*bili;
        left =$imgObj.position().left -(width - $imgObj.width())/2;
        maxWidth = $topParent.width() -width;
        if(maxWidth<0){
            left = left<maxWidth?maxWidth:left;
            left = left>0?0:left;
        }else{
            left = left<0?0:left;
            left = left>maxWidth?maxWidth:left;
        }
        top =$imgObj.position().top -(height - $imgObj.height())/2;
        maxHeight = $topParent.outerHeight() -height;
        if(maxHeight<0){
            top = top<maxHeight?maxHeight:top;
            top = top>0?0:top;
        }else{
            top = top <0?0:top;
            top = top>maxHeight?maxHeight:top;
        }
        $imgObj.css({
            width:width,
            height:height,
            left:left,
            top:top
        })
    }
    $(document).ready(function(){
        $(".imageOpenInput").on("click",function(){
            var imgSrc=$(this).closest("td").find("input:first").val();
            $(this).closest("table").find("input").prop("checked",false);
            $(this).closest("td").find("input:first").prop("checked",true);
            $(this).closest(".col-lg-6").find(".mouseImg:first").attr("src",imgSrc).css({ left:"0px",top:"0px",width:"100%",height:"auto"});
        });

        var mouseBool = false;
        var stretch = false;
        var stretchY = 0;
        var pageList = [];

        /*图片缩放进度开始*/
        $(".imgStretch>.fa").on("click",function(){
            var $jindu = $(this).closest(".imgStretch").find(".stretchIcon");
            var top = $jindu.position().top;
            var maxTop = $jindu.parent().height();
            if($(this).hasClass("fa-plus")){
                top -= 5;
            }else{
                top += 5;
            }
            top = top<0?0:top;
            top = top>maxTop?maxTop:top;
            $jindu.css({ top:top});
            stretchIcon($(this));
        });
        $(".imgStretch").mousemove(function(e){
            if(!stretch){
                return false;
            }
            var $stretchObj=$(this).find(".stretchIcon:first");
            var maxHeight=$stretchObj.parent("div").height();
            var top = e.pageY-stretchY;
            top = top<0?0:top;
            top = top>maxHeight?maxHeight:top;
            $stretchObj.css({ top:top+"px"});
            stretchIcon($(this));
        });
        $(".stretchIcon").mousedown(function(e) {
            var pageY= e.pageY - $(this).position().top;
            stretchY=pageY;
            stretch = true;
        });
        $(".imgStretch").mouseout(function(e){
            //stretch = false;
        });
        /*图片缩放进度结束*/
        $(".mouseDiv").mousemove(function(e){
            if(!mouseBool){
                return false;
            }
            var $imageObj=$(this).prev("img");
            var maxWidth = $(this).width() -$imageObj.outerWidth();
            var maxHeight = $(this).height() -$imageObj.outerHeight();
            var left = e.pageX-pageList[0];
            if(maxWidth<0){
                left = left<maxWidth?maxWidth:left;
                left = left>0?0:left;
            }else{
                left = left<0?0:left;
                left = left>maxWidth?maxWidth:left;
            }
            var top = e.pageY-pageList[1];
            if(maxHeight<0){
                top = top<maxHeight?maxHeight:top;
                top = top>0?0:top;
            }else{
                top = top <0?0:top;
                top = top>maxHeight?maxHeight:top;
            }
            $imageObj.css({
                left:left+"px",
                top:top+"px"
            });
        });
        $(".mouseDiv").mousedown(function(e) {
            $(this).addClass("active");
            var $imageObj=$(this).prev("img");
            var pageX= e.pageX - $imageObj.position().left;
            var pageY= e.pageY - $imageObj.position().top;
            pageList=[pageX,pageY];
            mouseBool = true;
        });

        $(document).mouseup(function(e){
            $(".mouseDiv").removeClass("active");
            mouseBool = false;
            stretch = false;
        });
        $(".mouseDiv").mouseout(function(e){
            $(".mouseDiv").removeClass("active");
            mouseBool = false;
        });
        /*图片放大*/
        $(".imageBig").on("click",function(){
            var imageObj=$(this).closest(".col-lg-6").find(".mouseImg:first");
            var width=imageObj.width()+10+"px";
            var height=imageObj.height()+10+"px";
            var left=imageObj.position().left-5+"px";
            var top=imageObj.position().top-5+"px";
            imageObj.css({
                width:width,
                left:left,
                top:top,
                height:height
            });
        });
        /*图片缩小*/
        $(".imageSmall").on("click",function(){
            var imageObj=$(this).closest(".col-lg-6").find(".mouseImg:first");
            var width=imageObj.width()-10;
            var height=imageObj.height()-10+"px";
            var left=imageObj.position().left+5+"px";
            var top=imageObj.position().top+5+"px";
            if(width < 100){
                return false;
            }
            imageObj.css({
                width:width+"px",
                left:left,
                top:top,
                height:height
            });
        });

        /*取消文本选择功能*/
        $(document).bind("selectstart",function(){ return false;});
    });
</script>
</body>
</html>
