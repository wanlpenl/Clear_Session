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
        html,body{ float: left;width: 100%; height: 100%; overflow: auto;}
        .minHeight{ float:left;width: 50%;height: auto;overflow: auto;}
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
        body{background: #000;}
    </style>
</head>

<body style="height:100%; overflow:auto;">
<div style="height:100%; overflow:auto;">
    <div id="newdiv" data="" style="float:left;"></div>
<!--全部显示-->
<div class="minImg" style="margin-top: 30px; height: 100%; overflow:auto;">
    <!--{%foreach from=$images item = i%}-->
        <!--<div class="minHeight">-->
            <!--<img width="100%" src="{%$i%}">-->
        <!--</div>-->
    <!--{%/foreach%}-->
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
    <script language="JavaScript">
        $(function() {
            _hmt.push(['_trackEvent', 'TMS', 'load', 'dom', Date.now() - window.__t]);
        });
        $(window).on('load', function(){
            _hmt.push(['_trackEvent', 'TMS', 'load', 'window', Date.now() - window.__t]);
        });
        $(document).ready(function() {
//            var multiple = new Date().getTime()-t1;
//            _hmt.push(['_setCustomVar',1,'multiple', multiple]);
            var num, seperateArr = new Array, count = 0;
            var imgList = new Array;

            var more = getSessionInfo("data");
            if (more == null) {
                more = $("#newdiv").attr("data");
            } else {
                init(more);
            }
            if (more == "" || more == null || more == undefined) {
                readData();
            } else {
                init(more);
            }
            function readData() {
                var moreData = getLocalStorageItem("imageData");
                if (moreData == "") {
                    if (count++ < 10){
                        setTimeout(readData, 100);
                    }
                    return "";
                } else {
                    setSessionInfo("data", moreData);
                    cleanLocalStorageItem("imageData");
                    init(moreData);
                }
            }

            function init(moreData) {
                moreData = decodeURI(moreData);
                moreData = moreData.replace(/\%2F/g, "/");
                moreData = moreData.replace(/\%3A/g, ":");
                seperateArr = moreData.split("&");
                imgList.splice(0, imgList.length);
                for (var i = 0; i < seperateArr.length; i++) {
                    var small = seperateArr[i].split("=");
                    if (small[0] == "image[]" && small.length == 2) {
                        imgList.push(small[1]);
                    } else if (small[0] == "imgnum" && small.length == 2) {
                        num = small[1];
                    }else if(small[0] == "image[]" && small.length == 3){
                        imgList.push(small[1]+'='+small[2]);
                    }
                }
                var html = "";
                imgList.forEach(function (element, index) {
                    html += '<div class="minHeight"> <img width="100%" src="'+element+'"> </div>'
                });
                $(".minImg").html(html);
            }
        });
    </script>
</body>
</html>
