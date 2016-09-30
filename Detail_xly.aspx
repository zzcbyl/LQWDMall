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
            <li id="point_li" class="active-controller"></li>
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

