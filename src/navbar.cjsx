React = require "react"
State = require "./state"
BsNavbar = require("react-bootstrap").Navbar
{Nav, NavItem} = require("react-bootstrap")

class Navbar extends React.Component

	handleSaveRequest: (e) ->
		e.preventDefault()
		State.trigger "save_resource"

	handleUiChange: (status, e) ->
		e.preventDefault()
		State.trigger "set_ui", status

	handleDrag: (e) ->
		e.preventDefault()
		return unless (files = e.dataTransfer?.files) and
			(file = files?[0])
		reader = new FileReader()
		reader.onload = (e) -> 
			try
				json = JSON.parse e.target.result
				State.trigger "load_json_resource", json
			catch e
				State.trigger "set_ui", "load_error"

		State.trigger "set_ui", "loading"
		reader.readAsText(file)
	
	render: ->
		navItems = [
			<NavItem key="open" onClick={@handleUiChange.bind(@, "open")}>Open Resource</NavItem>
		]

		if @props.hasResource
			navItems.push <NavItem key="resource_json" onClick={@handleUiChange.bind(@, "export")}>
				Export JSON
			</NavItem>

		if @props.isRemote
			navItems.push <NavItem key="remote_save" onClick={@handleSaveRequest.bind(@)}>Save and Close</NavItem>
			navItems.push <NavItem key="remote_cancel" onClick={@handleSaveRequest.bind(@)}>Cancel and Close</NavItem>

		<BsNavbar fixedTop={true} className="navbar-custom"
			onDragEnter={@handleDrag.bind(@)}
			onDragOver={@handleDrag.bind(@)}
			onDrop={@handleDrag.bind(@)}
			onDragLeave={@handleDrag.bind(@)}
		>
			<BsNavbar.Header>
				<div className="pull-left" style={margin: "10px"}>
					<img src="./img/smart-bug.png" />
				</div>
				<BsNavbar.Brand>
					FRED v0.02
				</BsNavbar.Brand>
				<BsNavbar.Toggle />
			</BsNavbar.Header>
			<BsNavbar.Collapse><Nav>
				{navItems}
			</Nav></BsNavbar.Collapse>
		</BsNavbar>

module.exports = Navbar