import './allProjects.tpl.jade'

searchString = new ReactiveVar
projectCount = new ReactiveVar

Template.allProjects.helpers

	projectCount: -> projectCount.get()

Template.allProjects.onRendered -> Tracker.afterFlush => @autorun =>

	Meteor.call 'getProjectCount', (e, r) -> projectCount.set(r)

	projects = Projects.find {},
		fields: name: 1
	,
		sort: name: 1

	initDone = false

	drawProjectList = -> if initDone
		Tracker.afterFlush ->

			rows = []
			columns = [
				{ name: 'id', title: '#', breakpoints: '', filterable: false }
				{ name: '_id', title: 'ID', breakpoints: '' }
				{ name: 'name', title: 'Name' , breakpoints: '' }
				{ name: 'showAdmins', title: 'Action' , breakpoints: '' }
			]

			for project, index in projects.fetch()
				rows.push
					id: index + 1
					_id: project._id
					name: project.name
					showAdmins: '<a class="showAdmins" data-id="' + project._id + '" href>Admins...</a> | <a class="showShifts" href="/_/' + project._id + '/shifts" target="blank">Shifts...</a> | <a class="showSettings" href="/_/' + project._id + '/settings" target="blank">Settings...</a>'

			$('#projectTable').html('').footable
				columns: columns
				rows: rows
				sorting: enabled: true
				filtering: enabled: false
				paging:
					enabled: true
					size: 20

	@autorun ->
		FlowRouter.getParam('language') # redraw with new language

		handle = Meteor.subscribe 'support.projects', searchString.get()
		if handle.ready()
			Projects.find().observe
				added: drawProjectList
				changed: drawProjectList
				removed: drawProjectList

			initDone = true

			drawProjectList()

Template.allProjects.events

	'keyup #projectString': (e) ->
		searchString.set(e.target.value)

	'click .showAdmins': (e) ->
		projectId = $(e.target).attr('data-id')

		$('#userString').val projectId + '=admin'
		$('#userString').keyup()
