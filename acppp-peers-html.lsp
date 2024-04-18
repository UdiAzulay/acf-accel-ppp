<% local form, viewlibrary, page_info, session = ...
htmlviewfunctions = require("htmlviewfunctions")
html = require("acf.html")
%> 
<% local name = cfe({ type="hidden", value="" }) %>
<% local redir = cfe({ type="hidden", value=page_info.orig_action }) %>
<table id="list" class="tablesorter">
	<% for i, v in pairs(form.value) do %>
		<% if i == 1 then %>
			<tr>
				<th>#</th>
				<% for c, cv in pairs(v) do
					if c > 1 then %>
						<th><%= html.html_escape(cv)%></th>
					<% end %>
				<% end %>
				<th>Actions</th>
			</tr>
			<tbody>
		<% else %>
			<tr>
				<td><%= i - 1 %></td>
				<% for c, cv in pairs(v) do 
					if c > 1 then %>
						<td><%= html.html_escape(cv)%></td>
					<% end %>
				<% end %>
				<td>
					<%
					name.value = v[1]
					htmlviewfunctions.displayitem(cfe({type="form", value={sid=name}, label="", option="Disconnect", action="disconnect"}), page_info, -1)
					%>
				</td>
			</tr>
		<% end %>
	<% end %>
	</tbody>
</table>
