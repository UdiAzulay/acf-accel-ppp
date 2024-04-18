<% local view, viewlibrary = ... 
htmlviewfunctions = require("htmlviewfunctions") 
%>
<% viewlibrary.dispatch_component("status") %>
<% htmlviewfunctions.displayitem(view) %>

