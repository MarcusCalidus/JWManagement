import '/imports/api/projects/projects.coffee'

import '/imports/ui/pages/support/support.coffee'
import '/imports/ui/pages/vessels/vessels.js'

import { SimpleSchemaHelper } from '/imports/api/util/simpleSchema.coffee'

import './mainRoutes.coffee'
import './projectRoutes.coffee'
import './policyRoutes.coffee'

SimpleSchemaHelper.init()
