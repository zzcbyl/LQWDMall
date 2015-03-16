<%@ Page Title="" Language="C#" MasterPageFile="~/Master.master" AutoEventWireup="true" CodeFile="Default2.aspx.cs" Inherits="Default2" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MasterHead" Runat="Server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="MasterContent" Runat="Server">

 <div class="well">
        <h2>Quantity:</h2>
        <div class="input-append spinner" data-trigger="spinner">
          <input type="text" value="1" data-rule="quantity">
          <div class="add-on">
            <a href="javascript:;" class="spin-up" data-spin="up"><i class="icon-sort-up"></i></a>
            <a href="javascript:;" class="spin-down" data-spin="down"><i class="icon-sort-down"></i></a>
          </div>
        </div>
      </div>
</asp:Content>

