serverUrl = 'http://' + if location.host == 'straliens-app.scalingo.io' or location.host == 'straliens.eu' then 'straliens.scalingo.io' else 'localhost:3000'

@App = angular.module 'straliens', ['ui.router', 'uiGmapgoogle-maps', 'ui.bootstrap', 'ngCookies']
App.config (uiGmapGoogleMapApiProvider) ->
    uiGmapGoogleMapApiProvider.configure {
        v: '3.17'
        libraries: 'visualization'
    }

App.config [
    '$httpProvider'
    ($httpProvider) ->
        # Use x-www-form-urlencoded Content-Type
        $httpProvider.defaults.headers.post['Content-Type'] = 'application/x-www-form-urlencoded;charset=utf-8'

        ###*
        # The workhorse; converts an object to x-www-form-urlencoded serialization.
        # @param {Object} obj
        # @return {String}
        ###

        param = (obj) ->
            query = ''
            name = undefined
            value = undefined
            fullSubName = undefined
            subName = undefined
            subValue = undefined
            innerObj = undefined
            i = undefined
            for name of obj
                value = obj[name]
                if value instanceof Array
                    i = 0
                    while i < value.length
                        subValue = value[i]
                        fullSubName = name + '[' + i + ']'
                        innerObj = {}
                        innerObj[fullSubName] = subValue
                        query += param(innerObj) + '&'
                        ++i
                else if value instanceof Object
                    for subName of value
                        subValue = value[subName]
                        fullSubName = name + '[' + subName + ']'
                        innerObj = {}
                        innerObj[fullSubName] = subValue
                        query += param(innerObj) + '&'
                else if value != undefined and value != null
                    query += encodeURIComponent(name) + '=' + encodeURIComponent(value) + '&'
            if query.length then query.substr(0, query.length - 1) else query

        # Override $http service's default transformRequest
        $httpProvider.defaults.transformRequest = [ (data) ->
            if angular.isObject(data) and String(data) != '[object File]' then param(data) else data
        ]
]

App.config ($stateProvider, $urlRouterProvider) ->
    $urlRouterProvider.otherwise '/play'

    $stateProvider
    .state 'play',
        url: '/play'
        controller: 'playCtrl'
        title: 'Accueil'

    .state 'login',
        url: '/login'
        controller: 'loginCtrl'
        title: 'Login'
        templateUrl: '/partials/login.html'

    .state 'signup',
        url: '/signup'
        controller: 'signupCtrl'
        title: 'SignUp'
        templateUrl: '/partials/signup.html'

    .state 'check',
        url: '/check/:id'
        controller: 'checkCtrl'
        title: 'check'
        templateUrl: '/partials/check.html'


# Main controller
# ---------------
App.controller 'appCtrl', [
    '$scope'
    ($scope) ->
]

# Check controller
# ---------------
App.controller 'checkCtrl', [
    '$scope'
    '$state'
    ($scope, $state) ->
        $scope.test = $state.params.id
]

# Index page controller
# ---------------------
App.controller 'playCtrl', [
    '$rootScope'
    '$scope'
    '$http'
    '$state'
    'uiGmapGoogleMapApi'
    ($rootScope, $scope, $http, $state, uiGmapGoogleMapApi) ->

        if !$rootScope.validUser()
            $state.go 'login'

        $http.get serverUrl + "/api/points"
        .success (data) ->
            $scope.points = data
            $scope.points.forEach (point) ->
                $http.get serverUrl + "/api/points/"+ point.id
                .success (data) ->
                    point.coordinates = { latitude: point.lat, longitude: point.lng }
                    point.options = {
                        labelContent: Math.abs(data.energy) || '0'
                        labelAnchor: "0 0"
                        labelClass: 'map-label side-' + data.side
                    }
                    point.icon =
                        path: ''
                    point.data = data
                    console.log point, data

        $scope.map =
            zoom: 15
            center:
                #center on cathedrale
                latitude: 48.5819
                longitude: 7.75104
            options:
                minZoom: 15
                maxZoom: 20
                panControl: false
                zoomControl: true
                mapTypeControl: false
                scaleControl: false
                streetViewControl: false
                overviewMapControl: false
                mapTypeControl: false
            events:
                center_changed: (map) ->
                    allowedBounds =
                        sw: [48.572579, 7.732542]
                        ne: [48.589705, 7.775301]
                    C = map.getCenter()
                    if C.lng() > allowedBounds.ne[1] || C.lng() < allowedBounds.sw[1] || C.lat() > allowedBounds.ne[0] || C.lat() < allowedBounds.sw[0]
                        X = C.lng()
                        Y = C.lat()

                        AmaxX = allowedBounds.ne[1]
                        AmaxY = allowedBounds.ne[0]
                        AminX = allowedBounds.sw[1]
                        AminY = allowedBounds.sw[0]

                        if (X < AminX)
                            X = AminX
                        if (X > AmaxX)
                            X = AmaxX
                        if (Y < AminY)
                            Y = AminY
                        if (Y > AmaxY)
                            Y = AmaxY

                        map.panTo {lat: Y, lng: X}
]

App.controller 'loginCtrl', [
    '$rootScope'
    '$scope'
    '$state'
    '$http'
    '$cookies'
    ($rootScope, $scope, $state, $http, $cookies) ->
        $scope.showTeamPwd = false

        $scope.onSelect = ($item) ->
            $scope.team = $item
            $scope.showTeamPwd = true

        $scope.validate = (form) ->
            $http.post serverUrl + "/api/services/login?sections=team",
                nickname: form.nickname
                password: form.password
            .success (data) ->
                $rootScope.user.id = data.id
                $rootScope.user.name = data.nickname
                $rootScope.user.teamId = data.teamId
                $rootScope.user.team = data.team

                $cookies.putObject("user", $rootScope.user)

                $state.go 'play'
            .error (data) ->
                # TODO: make something with the error
                console.log data
]


App.controller 'signupCtrl', [
    '$rootScope'
    '$scope'
    '$state'
    '$http'
    '$cookies'
    ($rootScope, $scope, $state, $http, $cookies) ->
        $scope.showTeamPwd = false

        $scope.teams = []

        $scope.resultTeam =
            name: ''
            pwd: ''
            slogan: ''

        $http.get serverUrl + "/api/teams"
        .success (data) ->
            $scope.teams = data

        $scope.team = ->
            return team for team in $scope.teams when team.name.toLowerCase() == $scope.resultTeam.name.toLowerCase()

        $scope.create = (form) ->
            createUser = (user) ->
                $http.post serverUrl + '/api/users?sections=team',
                    nickname: user.nickname
                    email: user.email
                    password: user.password
                    teamId: user.teamId
                .success (data) ->
                    $rootScope.user.id = data.id
                    $rootScope.user.name = data.nickname
                    $rootScope.user.teamId = data.teamId
                    $rootScope.user.team = data.team

                    $cookies.putObject("user", $rootScope.user)

                    $state.go 'play'
                .error (data) ->
                    # TODO: make something with the error
                    console.log data

            if !$scope.team()
                $http.post serverUrl + '/api/teams',
                    name: $scope.resultTeam.name
                    slogan: $scope.resultTeam.slogan
                    password: $scope.resultTeam.pwd
                .success (team) ->
                    console.log team
                    user =
                        nickname: form.nickname
                        email: form.email
                        password: form.password
                        teamId: team.id
                    createUser(user)
                .error (data) ->
                    console.log data
]

# RUN !!
# ------
App.run [
    '$rootScope'
    '$state'
    '$window'
    '$cookies'
    ($rootScope, $state, $window, $cookies) ->
        $rootScope.$state = $state
        $rootScope.$cookies = $cookies

        # TODO: récupérer le temps restant
        $rootScope.endTime = '00H00'

        $rootScope.user = if $cookies.getObject('user') then $cookies.getObject('user') else
            team: null
            teamId: -1
            score: 0
            energy: 0

        $rootScope.validUser = () ->
            # TODO : check with token/whatever
            return !!$rootScope.user.name

        # $rootScope.ws = $websocket "ws://127.0.0.1:8000/ws"
        # $rootScope.ws.send JSON.stringify(action: "test")
]