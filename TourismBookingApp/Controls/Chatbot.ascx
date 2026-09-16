<%@ Control Language="C#" AutoEventWireup="true" CodeBehind="Chatbot.ascx.cs" Inherits="TourismBookingApp.Controls.Chatbot" %>

<div id="chatbotToggle" onclick="toggleChatbot()"> Need help?</div>

<div id="chatbotBox" style="display:none;">
    <div class="chatbotHeader">
        <span onclick="toggleChatbot()" class="chatbotClose">&times;</span>
        <div class="chatbotHeaderTitle">Help assistant</div>
        <div class="chatbotHeaderSubtitle">Answers questions about using the system</div>
    </div>
    <div id="chatbotMessages"></div>
    <div id="chatbotChips" class="chatChips"></div>
    <div class="chatbotInputRow">
        <input type="text" id="chatbotInput" placeholder="Type your question..." onkeypress="if(event.key==='Enter'){sendChatbotMessage();}" />
        <button type="button" onclick="sendChatbotMessage()">&#10148;</button>
    </div>
</div>

<script src="Scripts/chatbot.js"></script>
