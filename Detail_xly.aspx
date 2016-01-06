<%@ Page Title="卢勤问答平台冬令营" Language="C#" MasterPageFile="~/Master.master" %>
<%@ Import Namespace="System.Web.Script.Serialization" %>

<script runat="server">

</script>

<asp:Content ID="Content1" ContentPlaceHolderID="MasterHead" Runat="Server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="MasterContent" Runat="Server">
<script runat="server">
    public string repeatCustomer = "0";
    public string StartDate = "";
    public string showDate = "";
    protected void Page_Load(object sender, EventArgs e)
    {
        if (this.Session["RepeatCustomer"] != null)
            repeatCustomer = this.Session["RepeatCustomer"].ToString();


        string result = HTTPHelper.Get_Http(System.Configuration.ConfigurationManager.AppSettings["apiDomain"].ToString() + "api/product_get_detail.aspx?productid=" + Request["productid"]);
        JavaScriptSerializer json = new JavaScriptSerializer();
        Dictionary<string, object> dic = json.Deserialize<Dictionary<string, object>>(result);
        if (dic.Keys.Contains("startTime"))
        {
            StartDate = dic["startTime"].ToString().Replace("/", "-").Split(' ')[0];
            showDate = Convert.ToDateTime(StartDate).ToString("MM月dd日");
            if (showDate.Substring(0, 1) == "0")
            {
                showDate = showDate.Substring(1);
            }
        }
    }
</script>
<div class="mainpage">
    <div class="titleNav">
        <a onclick="location.href = 'Default_xly.aspx';" class="returnA"> </a>
        <span class="titleSpan">冬令营详情</span>
    </div>
    <div class="m-dcontent" style="margin-top:10px;">
        <div id="prodimg" style="border:1px solid #ccc;">
            
        </div>
        <div id="prodtitle" style="line-height:22px; font-size:16pt; padding:10px 0;">
        </div>
        <div class="article_time">
            <i></i><span><%=showDate %></span>
            <span style="float:right; margin-right:20px; font-size:12pt;" onclick='dateChange();'>日期选择 ></span>
            <br style="clear:both;" />
        </div>
        <%--<div class="m-dprice rel">
            <s class="gray" id="originalprice" style="margin-right:10px;"></s><span class="red" id="prodprice"></span>
            <a onclick="javascript:joinxly();" class="btn btn-danger" style="width:20%; position:absolute; right:0px; bottom:0px;">我要报名</a>
        </div>--%>
    </div>
    <%--<div id="proddescription" class="m-ddescription">
    </div>--%>

    <div style="margin:0; background:#fff; font-size:30px; padding-bottom:10px;">
        <!-- 日历部分 -->		
	    <div class="Calendar">
          <div id="idCalendarPre">&lt;&lt;</div>
          <div id="idCalendarNext">&gt;&gt;</div>
          <span id="idCalendarYear"></span>年 <span id="idCalendarMonth"></span>月
          <table cellspacing="0">
            <thead>
              <tr>
                <td>日</td>
                <td>一</td>
                <td>二</td>
                <td>三</td>
                <td>四</td>
                <td>五</td>
                <td>六</td>
              </tr>
            </thead>
            <tbody id="idCalendar">
            </tbody>
          </table>
        </div>
        <script language="JavaScript">
            var startDate = '<%=StartDate %>';
            var flag = [];

            flag.push(startDate + "-775-9800-1000-10");

            flag.sort();

            var calendarDay = startDate;
            var dtArr = calendarDay.split("-");
            var stateDate = new Date(dtArr[0] + "/" + dtArr[1] + "/" + dtArr[2]);

            var cale = new Calendar("idCalendar", {
                Year: stateDate.getFullYear(),
                Month: stateDate.getMonth() + 1,
                SelectDay: stateDate,
                //  onSelectDay: function(o){ o.className = "onSelect"; },
                // onToday: function(o){ o.className = "onToday"; },
                onFinish: function () {
                    element("idCalendarYear").innerHTML = this.Year; element("idCalendarMonth").innerHTML = this.Month;
                    
                    for (var i = 0, len = flag.length; i < len; i++) {
                        var y_select = parseInt(flag[i].split("-")[0]);
                        var m_select = parseInt(flag[i].split("-")[1]);
                        var d_select = parseInt(flag[i].split("-")[2]);
                        var id = parseInt(flag[i].split("-")[3]);
                        var price = parseFloat(flag[i].split("-")[4]);
                        var inventory = parseInt(flag[i].split("-")[5]);
                        
                        var arr1 = flag[i].split("-");
                        var dateNum = arr1[0] + arr1[1] + arr1[2];
                        
                        if (this.Year == y_select && this.Month == m_select) {
                            this.Days[d_select].innerHTML = "<a href='javascript:void(0);'  style='color:#FFFFFF' onclick=\"selectDay('" + this.Month + "月" + d_select + "日','" + id + "',this,'" + dateNum + "','" + inventory + "');return false;\"><ul style=\"line-height:1rem;\"><li>" + d_select + "</li><li>" + price + "</li></ul></a>";

                            //if (20160105 > dateNum || inventory <= 0) {
                            //    this.Days[d_select].bgColor = "#D6D6D6";
                            //} else {
                            //    this.Days[d_select].bgColor = "#0897F2";
                            //}

                            if (inventory > 0 && flag[i].indexOf(calendarDay) > -1) {
                                this.Days[d_select].bgColor = "#cc0000";
                            }

                            this.Days[d_select].width = " 14.4% ";
                        }


                    }
                }
            });

            element("idCalendarPre").onclick = function () { cale.PreMonth(); }
            element("idCalendarNext").onclick = function () { cale.NextMonth(); }

            function selectDay(day, id, obj, dateNum, inventory) {
                //if (20160105 > dateNum) {
                //    alert("选择的日期无效-_-");
                //} else if (inventory <= 0) {
                //    alert("亲,商品售罄了，请换一天试试!");
                //} else {
                //    $('#nowTime').html(day);
                //    $("#calendarId").val(id);
                //    $(".Calendar").hide();
                //    $("#idCalendar").find("[bgColor='#cc0000']")[0].bgColor = "#0897F2";
                //    obj.parentNode.bgColor = "#cc0000";
                //}
                joinxly();
            }

            function dateChange() {
                if ($(".Calendar").css('display') == 'none')
                    $(".Calendar").show();
                else
                    $(".Calendar").hide();
            }
        </script>
        <!-- 日历部分 -->	
    </div>
    </div>

    <div class="m-description">
        <ul class="description-menu">
            <li class="active-controller">亮点</li>
            <li>行程</li>
            <li style="width:34%;">费用</li>
        </ul>
        <ul class="description-item">
            <li class="active-controller"><p>&#12288;&#12288;让孩子敢说话，会说话，说自己的话，善于运用语言的力量！</p><p>&#12288;&#12288;想学说话，就要找会说话的人！</p><p>&#12288;&#12288;2016年 1月29日&mdash;&mdash;2月3日，《我要学演说》少年口才培训营特邀北京人民广播电台的金话筒节目主持人“小雨姐姐”和“知心姐姐”卢勤老师联合倾力策划，全程陪伴；邀请著名少儿节目主持人鞠萍姐姐、深圳卫视著名节目主持人强子哥哥倾情分享，名师带领，为8-18岁的青少年带来终身难忘的演说特训营！</p><p>&#12288;&#12288;给孩子一个舞台，点燃孩子的激情；名师专家口传心授，释放孩子的潜能；星光璀璨，展示孩子的才华。在这里，表达自己不再是埋藏在心里的一个冲动，话语权也不再是少数人的特权，舞台聚光灯将属于勇于挑战自我的你！</p><p><strong>一、心动理由：</strong></p><div style="padding-left:10px;"><p><strong>名师引路：</strong>教孩子说话，就要找最会说孩子话的名师，面对面聆听导师专家的成功经验。</p><p><span style="color:#7030A0;">“鞠萍姐姐”：</span>分享语言的魅力；</p><p><span style="color:#7030A0;">“小雨姐姐”：</span>“小雨姐姐”教你如何给你的声音化妆；</p><p><span style="color:#7030A0;">“卢勤老师”：</span>“做人与做事”系列课程，教会孩子学习说话先学习做人；</p><p><span style="color:#7030A0;">“强子哥哥”：</span>教你做个有活力的主持人……</p><div style="text-align: center; margin: 10px 0;"><img width="80%" src="http://mall.luqinwenda.com/upload/prodimg/yjy_pic1.jpg"></div><p><strong>知心辅导员专家团队专业辅导：</strong>知心姐姐教育服务中心，将派出一支包括教育、心理、活动、后勤的专业团队全程负责管理，让孩子们学习四大成长法宝：1.学习展示自己； 2.学习管理自己；3. 学习团队合作； 4.学习面对冲突。收获三个心灵朋友：1、一句心灵小语；2、一个心灵故事；3、一次心理访谈。</p><p><strong>孩子的变化摄影师全程记录：</strong>专业的摄制组，用镜头记录下孩子们从入营到闭营的闪亮瞬间。</p><p><strong>闭营仪式全体孩子精彩展示：</strong>每一个孩子都能登上舞台，发表自己的演说，展示自己的成长，体验少年演说家的成就感；邀请家长及亲朋好友参加。</p><p><strong>医生、教官悉心保护：</strong>著名医院的儿科专家成为随队医生，负责营员们的健康；多名安保人员保证孩子们外出及住宿的安全。</p><p><strong>微信短信定时互动：</strong>每天清晨、中午、晚上，定时推送孩子们的精彩图片，专业带队老师会与家长定时沟通，分享孩子的成长瞬间。</p><p><strong>后期跟踪：</strong>专业带队老师将针对孩子特点和家庭需求，对孩子们的家庭教育和教养方式提供建设性的意见。</p><div style="text-align: center; margin: 10px 0;"><img width="80%" src="http://mall.luqinwenda.com/upload/prodimg/yjy_pic3.jpg"></div></li>
            <li><p><strong>活动时间：</strong>2016年 1月29日&mdash;2月3日</p><p><strong>活动地点：</strong>深圳</p><p><strong>主办单位：</strong>中国少年儿童新闻出版总社知心姐姐教育服务中心<br />&#12288;&#12288;&#12288;&#12288;&#12288;&#12288;&#12288;卢勤问答互动平台</p><p><strong>集训重点：</strong></p><div style="text-align: center; margin: 10px 0;"><img width="80%" src="http://mall.luqinwenda.com/upload/prodimg/yjy_pic2.jpg"></div><div style="padding-left:10px;"><p>&#12288;&#12288;学习演说先学习做人, 做好人才能说好话,  才能做正能量的传播者；</p><p>&#12288;&#12288;学习正确的演说语态、咬字发音及公众演说技巧；</p><p>&#12288;&#12288;学习少年演说技巧，训练声音控制与表达各种情绪的能力，以及模仿能力，掌握语言表达技巧；</p><p>&#12288;&#12288;传授主持的基本技巧，通过角色表演、想象力训练等方法培养孩子的观察力、模仿力和舞台表现力；</p><p>&#12288;&#12288;进行专门的仪态训练，通过对孩子进行规范性的仪表、仪态的训练，纠正诸多孩子在语言表达时习惯性的小动作，最终提升孩子的气质；</p><p>&#12288;&#12288;采用分组学习、小组竞赛的方式，锻炼孩子的自信及应变能力，克服在公开场合语言表达的心理障碍，为日后参与校内外朗读、演讲或入学面试，奠定良好的基础。</p></div><p><strong>活动安排：</strong></p><div style="text-align: center; margin: 10px 0;"><img width="80%" src="http://mall.luqinwenda.com/upload/prodimg/yjy_xingcheng.jpg"></div><p><strong>营员要求：</strong>8-16岁，身心健康，有一定的自理能力，能遵守营期的纪律和文明礼仪的在校少年儿童 。</p></li>
            <li><p><strong>费用说明：</strong>9800元/人。</p><%--<p><strong>优惠政策：</strong>12月1日前报名优惠300元，老营员优惠300元，老营员可以同时享受双重优惠。</p>--%><p><strong>报名方式：</strong></p><div style="padding-left:10px;"><p>卢勤问答互动平台电话报名：<br />&#12288;&#12288;18601016361（新老师）<br />&#12288;&#12288;18511998488（旭老师）</p></li>
        </ul>
        <div style="text-align:center;">
            <img src="images/dingyuehao.gif" width="80%" /></div>
    </div>
    <%--<div style="background:#fff; padding:10px; text-align:center;">
        <a onclick="javascript:joinxly();" class="btn btn-danger" style="width:25%;" >我要报名</a>
    </div>--%>
    <div class="clear" style="height:60px;"></div>
    <div class="m-bottom">
        <ul id="footermenu" style="padding:0; background:#BF1924; font-size:12pt;">
            <%--<li id="ftm-type">
                <div>商品分类</div>
            </li>--%>
            <li id="ftm-user" style="width:20%;">
                <%--<div><a href="userIndex.aspx">个人中心</a></div>--%>
                <div><a style="color:#fff;" href="tel:18601016361">电话</a></div>
            </li>
            <li id="ftm-cart" style="width:80%;">
                <div>
                    <a style="color:#fff;" id="my-cart" href="javascript:void(0);"  onclick="javascript:joinxly();">出发日期及价格
                    <em id="my_cart_em" class="abs" style="display: none; right:35%;"></em>
                </a></div>
            </li>
        </ul>
        <div class="clear"></div>
    </div>
</div>

<script type="text/javascript">
    var repeat = <%=repeatCustomer %>;
    var prodid = QueryString('productid');
    $(document).ready(function () {
        if (prodid == null) {
            alert('商品参数有误');
            return;
        }
        filldetail(prodid);

        $('.description-menu li').click(function () {
            var i = $('.description-menu li').index(this);
            $('.description-menu li').each(function () {
                $(this).removeAttr("class");
            });
            $('.description-menu li').eq(i).attr("class", "active-controller");
            
            $('.description-item li').each(function () {
                $(this).removeAttr("class");
            });
            $('.description-item li').eq(i).attr("class", "active-controller");
        });

    });

    function joinxly() {
        location.href = 'Join_xly.aspx?productid=' + prodid;
    }
</script>
</asp:Content>

