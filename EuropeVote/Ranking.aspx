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

    <div style="margin-top:10px; background:#fff; line-height:35px; padding:10px 20px 20px;">
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
                    <td><%=index %>、</td>
                    <td><%=row["image_username"].ToString()%></td>
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

