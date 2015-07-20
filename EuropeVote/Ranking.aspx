<%@ Page Title="" Language="C#" MasterPageFile="~/EuropeVote/EuropeMaster.master" %>
<%@ Import Namespace="System.Data" %>
<script runat="server">
    public DataTable rankingDt = new DataTable();
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            rankingDt = EuropeVote.getEuropeVotes();
        }
    }
</script>

<asp:Content ID="Content1" ContentPlaceHolderID="head" Runat="Server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" Runat="Server">
    <div style="margin-top:5px; background:#fff; line-height:35px; padding:10px 20px 20px;">
        <h4 style="border-bottom: 1px solid #6699CC; padding:10px 0 5px; margin-bottom:10px;">排行榜</h4>
        <table class="rankingTable">
            <thead>
                <tr>
                    <td style="width:30%;">序号</td>
                    <td style="width:30%;">姓名</td>
                    <td style="width:40%;">得票</td>
                </tr>
            </thead>
            <tbody>
            <%  int index = 1;
               foreach (DataRow row in rankingDt.Rows)
               { %>
                <tr>
                    <td><%=index %></td>
                    <td><%=row["image_username"].ToString().Substring(0, 1) + "*" + (row["image_username"].ToString().Length > 2 ? row["image_username"].ToString().Substring(2, 1) : "")%></td>
                    <td><%=row["cc"].ToString() %>票</td>
                </tr>
            <% if (index == 10)
                   break;
                index++;
               } %>
            </tbody>
        </table>
    </div>
</asp:Content>

