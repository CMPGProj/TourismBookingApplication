// Free rule-based Help Chatbot for the Tourism Management and Booking System.
// Pure client-side keyword matching - no external API, no cost, fully
// integrated (loaded on every page via Site.Master / Controls/Chatbot.ascx).

var chatbotRules = [
    { keywords: ["book", "make a booking", "reserve", "explore"], answer: "To make a booking: go to 'Explore attractions', choose one, pick a date, time and number of participants, then click Confirm booking." },
    { keywords: ["cancel"], answer: "To cancel a booking: go to 'My bookings', select it from the list, and click Cancel booking." },
    { keywords: ["change", "reschedule", "edit booking"], answer: "To change a booking: go to 'My bookings', select it, update the date, time or participants, and click Save changes." },
    { keywords: ["review"], answer: "Go to 'My reviews', pick a booked attraction from the list, choose a rating, and click Submit review." },
    { keywords: ["register", "sign up", "create account"], answer: "Click 'Sign Up' on the Login page and fill in your name, email and password." },
    { keywords: ["password", "forgot"], answer: "Contact the system Administrator to reset your password - self-service reset is not yet available." },
    { keywords: ["contact", "attraction contact"], answer: "Each attraction's contact person is shown under Attraction Contacts (staff view)." },
    { keywords: ["administrator", "assistant", "login"], answer: "Administrators have full access; Assistants have limited access. Use the Login page and choose 'staff member'." },
    { keywords: ["which attractions", "attractions can i book", "knysna", "town"], answer: "Use the Town filter on 'Explore attractions' to see everything bookable in that area." },
    { keywords: ["add a tourist"], answer: "Administrators: go to Tourists, fill in the form on the left, and click Save." },
    { keywords: ["run a report"], answer: "Go to Reports to see the revenue summary or search a tourist's bookings by date range." },
    { keywords: ["hi", "hello", "hey"], answer: "Hi! I am the help assistant. Ask me how to do something, or ask about attractions and bookings." }
];

var chatbotChipSets = {
    guest: ["How do I sign up?", "How do I log in?"],
    Tourist: ["Which attractions can I book in Knysna?", "How do I cancel a booking?", "How do I add a review?"],
    Administrator: ["How do I add a tourist?", "Run a report", "How do I add an attraction?"],
    Assistant: ["How do I add a tourist?", "Run a report"]
};

var defaultAnswer = "Sorry, I don't have an answer for that yet. Try asking about booking, cancelling, changing a booking, or reviews.";

function toggleChatbot() {
    var box = document.getElementById("chatbotBox");
    var opening = (box.style.display === "none" || box.style.display === "");
    box.style.display = opening ? "flex" : "none";
    box.style.flexDirection = "column";
    if (opening && document.getElementById("chatbotMessages").children.length === 0) {
        addChatbotMessage("Hi, I am the help assistant. Ask me how to do something, or ask about attractions and\nbookings.", "bot");
        renderChatbotChips();
    }
}

function addChatbotMessage(text, sender) {
    var messages = document.getElementById("chatbotMessages");
    var wrap = document.createElement("div");
    wrap.className = sender === "user" ? "chatbotMsgUser" : "chatbotMsgBot";
    var bubble = document.createElement("span");
    bubble.innerText = text;
    wrap.appendChild(bubble);
    messages.appendChild(wrap);
    messages.scrollTop = messages.scrollHeight;
}

function matchChatbotAnswer(input) {
    var lower = input.toLowerCase();
    for (var i = 0; i < chatbotRules.length; i++) {
        var rule = chatbotRules[i];
        for (var k = 0; k < rule.keywords.length; k++) {
            if (lower.indexOf(rule.keywords[k]) !== -1) {
                return rule.answer;
            }
        }
    }
    return defaultAnswer;
}

function renderChatbotChips() {
    var role = window.chatbotUserRole || "guest";
    var chips = chatbotChipSets[role] || chatbotChipSets.guest;
    var holder = document.getElementById("chatbotChips");
    holder.innerHTML = "";
    chips.forEach(function (chip) {
        var el = document.createElement("span");
        el.className = "chatChip";
        el.innerText = chip;
        el.onclick = function () {
            document.getElementById("chatbotInput").value = chip;
            sendChatbotMessage();
        };
        holder.appendChild(el);
    });
}

function sendChatbotMessage() {
    var input = document.getElementById("chatbotInput");
    var text = input.value.trim();
    if (text === "") return;

    addChatbotMessage(text, "user");
    var answer = matchChatbotAnswer(text);
    setTimeout(function () { addChatbotMessage(answer, "bot"); }, 250);

    input.value = "";
}
