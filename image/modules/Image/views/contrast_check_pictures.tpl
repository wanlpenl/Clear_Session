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
           .viewer{width: 100%; height: 500px; border: 1px solid black; position: relative; margin:0 auto; background: #000;} 
           .wrapper{overflow: hidden;}
        /* 插件jquery.iviewer.css  css */
        .left-max-width table tr{float: left; width: 120%; overflow-y: hidden;}
        .wrap{margin-left: 5px;}
    </style>
</head>

<body>
<div>

<!--对比-->
  <div class="col-lg-12 bg-f3">
  <!-- 左侧 -->
      <div class="col-lg-6 dis-border-right bg-ff pt-10">
          <div class="wrap">
              <div>
                <span>视力 : </span><span>{%$info.one.sRSight%}/{%$info.one.sLSight%}</span>
              </div>
              <div>
                <span>眼压 : </span><span>{%$info.one.sREyePress%}/{%$info.one.sLeyePress%}</span>
              </div>
              <div>
                <span>阅片诊断 : </span><span>{%$info.one.sReport%}</span>
              </div>
          </div>
          <div class="left-max-width" style="overflow-x: auto;overflow-y: hidden;">
              <table border="0px" cellpadding="0px" cellspacing="0px">
                  <tr>
                      {%foreach from=$arrOne item = i key = k%}
                      <td>
                          <div  class="imageOpenInput">
                            <span class="vertical-img-center bg-f3">
                                <img src='{%$i.originalImg%}'>
                            </span>
                          </div>
                          <input type="checkbox" {%if $k == 0%}checked {%/if%}class="imageOpenInput" value="{%$i.originalImg%}">
                      </td>
                      {%/foreach%}
                  </tr>
              </table>
          </div>
          <div id="viewer1" class="viewer">
                
            </div>
          <div class="hiddenImg" style="display: none;">
              <div data="{%$arrOne[0]['originalImg']%}"></div>
              
          </div>
      </div>
      <!-- 右侧 -->
      <div class="col-lg-6 dis-border-left bg-ff pt-10">
          <div class="wrap">
              <div>
                  <span>视力 : </span><span>{%$info.two.sRSight%}/{%$info.two.sLSight%}</span>
              </div>
              <div>
                  <span>眼压 : </span><span>{%$info.two.sREyePress%}/{%$info.two.sLeyePress%}</span>
              </div>
              <div>
                  <span>阅片诊断 : </span><span>{%$info.two.sReport%}</span>
              </div>
          </div>
          <div class="left-max-width" style="overflow-x: auto;overflow-y: hidden;">
              <table border="0px" cellpadding="0px" cellspacing="0px">
                  <tr>
                      {%foreach from=$arrTwo item = i key = k%}
                      <td>
                          <div  class="imageOpenInput">
                            <span class="vertical-img-center bg-f3">
                                <img src='{%$i.originalImg%}'>
                            </span>
                          </div>
                          <input type="checkbox" {%if $k == 0%}checked {%/if%}class="imageOpenInput" value="{%$i.originalImg%}">
                      </td>
                      {%/foreach%}
                  </tr>
              </table>
          </div>
          <div id="viewer2" class="viewer">
                
            </div>
          <div class="hiddenImg"  style="display: none;">
              <div data="{%$arrTwo[0]['originalImg']%}"></div>

          </div>
      </div>
  </div>
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

    //百度统计开始

    $(function() {
        _hmt.push(['_trackEvent', 'TMS', 'load', 'dom', Date.now() - window.__t]);
    });
    $(window).on('load', function(){
        _hmt.push(['_trackEvent', 'TMS', 'load', 'window', Date.now() - window.__t]);
    });
    //百度统计结束

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

//        var contrast_check_pictures = new Date().getTime()-t1;
//        _hmt.push(['_setCustomVar',1,'contrast_check_pictures', contrast_check_pictures]);
      var src1 = $(".hiddenImg:first>div").attr("data");
      var src2 = $(".hiddenImg:last>div").attr("data");

      var iviewer = {};
      $("#viewer1").iviewer(
      {
        src: src1,
        initCallback: function()
        {
          iviewer = this;
        }
      });
      $("#viewer2").iviewer(
      {
        src: src2,
        initCallback: function()
        {
          iviewer = this;
        }
      });

        $(".imageOpenInput").on("click",function(){
            var imgSrc=$(this).closest("td").find("input:first").val();
            $(this).closest("table").find("input").prop("checked",false);
            $(this).closest("td").find("input:first").prop("checked",true);
            $(this).closest(".col-lg-6").find(".viewer>img").attr("src",imgSrc);
        });



        /*取消文本选择功能*/
        $(document).bind("selectstart",function(){ return false;});
    });
</script>
</body>
</html>
