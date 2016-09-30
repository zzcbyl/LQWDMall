<%@ Page Title="悦长大平台夏令营" Language="C#" MasterPageFile="~/Master.master" %>
<%@ Import Namespace="System.Web.Script.Serialization" %>

<script runat="server">

</script>

<asp:Content ID="Content1" ContentPlaceHolderID="MasterHead" Runat="Server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="MasterContent" Runat="Server">
<script runat="server">
    public string repeatCustomer = "0";
    public string StartDate = "";
    public string EndDate = "";
    public string showDate = "";
    public string price = "";
    protected void Page_Load(object sender, EventArgs e)
    {
        if (this.Session["RepeatCustomer"] != null)
            repeatCustomer = this.Session["RepeatCustomer"].ToString();


        string result = HTTPHelper.Get_Http(System.Configuration.ConfigurationManager.AppSettings["apiDomain"].ToString() + "api/product_get_detail.aspx?productid=" + Request["productid"]);
        JavaScriptSerializer json = new JavaScriptSerializer();
        Dictionary<string, object> dic = json.Deserialize<Dictionary<string, object>>(result);
        if (dic.Keys.Contains("startTime"))
        {
            StartDate = dic["startTime"].ToString(); //dic["startTime"].ToString().Replace("/", "-").Split(' ')[0];
            showDate = Convert.ToDateTime(StartDate).Month.ToString() + "月" + Convert.ToDateTime(StartDate).Day.ToString() + "日";
            EndDate = dic["endTime"].ToString();
            if (!EndDate.Equals(""))
                showDate += "－" + Convert.ToDateTime(EndDate).Month.ToString() + "月" + Convert.ToDateTime(EndDate).Day.ToString() + "日";
            //if (showDate.Substring(0, 1) == "0")
            //{
            //    showDate = showDate.Substring(1);
            //}
            //price = (Convert.ToInt32(dic["price"].ToString()) / 100).ToString();
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
            
            <br style="clear:both;" />
        </div>
       
    </div>
   
    </div>

    <div class="m-description">
        <ul class="description-menu">
            <li class="active-controller">亮点</li>
            <li>行程</li>
            <li style="width:34%;">费用</li>
        </ul>
        <ul class="description-item">
            <li id="point_li" class="active-controller">
                <p>&#12288;&#12288;让孩子敢说话，会说话，说自己的话，善于运用语言的力量！</p>
                <p>&#12288;&#12288;想学说话，就要找会说话的人！</p>
                <p>&#12288;&#12288;2017年 1月18日&mdash;&mdash;1月24日，由中国少年儿童新闻出版总社知心姐姐教育服务中心、北京阳光天女教育咨询有限公司、悦长大家庭教育专家问答平台共同主办——“少年演说家”潜能开发营，邀请中国最会说话的人，组建一支包含播音主持、教育心理、少儿活动、媒体新闻等最专业的教学与管理团队，呈现符合儿童心理发展规律的演说课堂&教育活动，为每一个“少年演说家”带来一场终身难忘的演说培训体验冬令营活动。</p>
                <p><strong>一、名家讲堂-跟中国最会说话的人学说话：</strong></p>
                <div style="padding-left:10px;">
                    <div style="text-align: center; margin: 10px 0;">
                        <img width="80%" src="http://mall.luqinwenda.com/upload/prodimg/speech_winter_2017_pic1.jpg">
                    </div>
                    <p><strong>特邀专家：</strong></p>
                    <p><span style="color:#7030A0;">杨澜：</span>著名媒体人；</p>
                    <p><span style="color:#7030A0;">敬一丹：</span>《焦点访谈》节目主持人；</p>
                    <p><span style="color:#7030A0;">卢勤：</span>中国少年儿童新闻出版总社首席教育专家、著名的“知心姐姐；</p>
                    <p><span style="color:#7030A0;">于丹：</span>著名文化学者；</p>
                    <p><span style="color:#7030A0;">小雨姐姐：</span>北京人民广播电台播音“金话筒”主持人；</p>
                    <p><span style="color:#7030A0;">鞠萍姐姐：</span>中央电视台著名主持人、制片人、编导；</p>
                    <p><strong>知心辅导员专家团队专业辅导：</strong>知心姐姐教育服务中心，将派出一支包括教育、心理、活动、后勤的专业团队全程负责管理，让孩子们学习四大成长法宝：1.学习展示自己； 2.学习管理自己；3. 学习团队合作； 4.学习面对冲突。收获三个心灵朋友：1、一句心灵小语；2、一个心灵故事；3、一次心理访谈。</p><p><strong>孩子的变化摄影师全程记录：</strong>专业的摄制组，用镜头记录下孩子们从入营到闭营的闪亮瞬间。</p><p><strong>闭营仪式全体孩子精彩展示：</strong>每一个孩子都能登上舞台，发表自己的演说，展示自己的成长，体验少年演说家的成就感；邀请家长及亲朋好友参加。</p><p><strong>医生、教官悉心保护：</strong>著名医院的儿科专家成为随队医生，负责营员们的健康；多名安保人员保证孩子们外出及住宿的安全。</p><p><strong>微信短信定时互动：</strong>每天清晨、中午、晚上，定时推送孩子们的精彩图片，专业带队老师会与家长定时沟通，分享孩子的成长瞬间。</p><p><strong>后期跟踪：</strong>专业带队老师将针对孩子特点和家庭需求，对孩子们的家庭教育和教养方式提供建设性的意见。</p><div style="text-align: center; margin: 10px 0;"><img width="80%" src="http://mall.luqinwenda.com/upload/prodimg/yjy_pic3.jpg"></div></li>
            <li id="trip_li"><p><strong>活动时间：</strong>2016年 7月15日&mdash;7月21日</p><p><strong>活动地点：</strong>深圳</p><p><strong>主办单位：</strong>中国少年儿童新闻出版总社知心姐姐教育服务中心<br />&#12288;&#12288;&#12288;&#12288;&#12288;&#12288;&#12288;悦长大互动平台</p><p><strong>集训重点：</strong></p><div style="text-align: center; margin: 10px 0;"><img width="80%" src="http://mall.luqinwenda.com/upload/prodimg/yjy_pic2.jpg"></div><div style="padding-left:10px;"><p>&#12288;&#12288;学习演说先学习做人, 做好人才能说好话,  才能做正能量的传播者；</p><p>&#12288;&#12288;学习正确的演说语态、咬字发音及公众演说技巧；</p><p>&#12288;&#12288;学习少年演说技巧，训练声音控制与表达各种情绪的能力，以及模仿能力，掌握语言表达技巧；</p><p>&#12288;&#12288;传授主持的基本技巧，通过角色表演、想象力训练等方法培养孩子的观察力、模仿力和舞台表现力；</p><p>&#12288;&#12288;进行专门的仪态训练，通过对孩子进行规范性的仪表、仪态的训练，纠正诸多孩子在语言表达时习惯性的小动作，最终提升孩子的气质；</p><p>&#12288;&#12288;采用分组学习、小组竞赛的方式，锻炼孩子的自信及应变能力，克服在公开场合语言表达的心理障碍，为日后参与校内外朗读、演讲或入学面试，奠定良好的基础。</p></div><p><strong>活动安排：</strong></p><div style="text-align: center; margin: 10px 0;"><img width="80%" src="http://mall.luqinwenda.com/upload/prodimg/yjy_xingcheng.jpg"></div><p><strong>营员要求：</strong>8-16岁，身心健康，有一定的自理能力，能遵守营期的纪律和文明礼仪的在校少年儿童 。</p></li>
            <li id="cost_li"><p><strong>费用说明：</strong>9800元/人。</p><%--<p><strong>优惠政策：</strong>12月1日前报名优惠300元，老营员优惠300元，老营员可以同时享受双重优惠。</p>--%><p><strong>报名方式：</strong></p><div style="padding-left:10px;"><p>悦长大互动平台电话报名：<br />&#12288;&#12288;18601016361（新老师）<br />&#12288;&#12288;18511998488（旭老师）</p></li>
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
                    <a style="color:#fff;" id="my-cart" href="javascript:void(0);"  onclick="javascript:joinxly();">报名
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

        lineLink = "http://mall.luqinwenda.com/Detail_xly.aspx?productid=" + prodid;
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
        location.href = 'Join_xly.aspx?productid=' + prodid + '&#ATable';
    }
</script>
</asp:Content>

