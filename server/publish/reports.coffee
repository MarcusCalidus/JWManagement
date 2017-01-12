Meteor.publish 'reports', (projectId, month) ->
	if typeof projectId == 'string' && projectId != '' && typeof month == 'string' && month != ''
		if Roles.userIsInRole @userId, Permissions.admin, projectId
			firstDay = parseInt moment(month, 'YYYY[M]MM').format('YYYYDDDD')
			lastDay = parseInt moment(month, 'YYYY[M]MM').endOf('month').format('YYYYDDDD')

			Shifts.find
				$and: [
					projectId: projectId
				,
					date: $gte: firstDay
				,
					date: $lte: lastDay
				]
			,
				fields:
					date: 1
					start: 1
					end: 1
					'teams.name': 1
					'teams.participants': 1
					'teams.report': 1
		else
			@ready()
	else
		@ready()
