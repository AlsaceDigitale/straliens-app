@App = angular.module 'straliens', ['ui.router', 'uiGmapgoogle-maps', 'ui.bootstrap', 'ngCookies', 'cgNotify']
serverUrl = 'http://' + if location.host == 'straliens.scalingo.io' or location.host == 'straliens.eu' then 'straliens-server.scalingo.io' else 'localhost:3000'
wsUrl = 'ws://' + if location.host == 'straliens.scalingo.io' or location.host == 'straliens.eu' then 'straliens-server.scalingo.io' else 'localhost:3000'


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


    .state 'nogame',
        url: '/nogame'
        controller: 'nogameCtrl'
        title: 'no game'
        templateUrl: '/partials/nogame.html'


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
    '$http'
    '$state'
    ($scope, $http, $state) ->
        $http
            url: serverUrl + "/api/points/#{$state.params.id}/check/"
            method: 'GET'
            withCredentials: true

        .success (data) ->
            $state.go 'play'
        .error (data) ->
            $state.go 'login'
]

# Notify controller
# -----------------



App.controller 'notifCtrl', [
    '$scope'
    'notify'

    ($scope, notify) ->
        notify.config {startTop : 0, maximumOpen: 3, templateUrl: "/resources/angular-notify-custom.html"}    
        $scope.shownotify = ->
            notify "Hello there" 
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
        $rootScope.points = {}

        if !$rootScope.validUser()
            $state.go 'login'

        $http.get serverUrl + '/api/games/current'
        .success (data) ->
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
            .error (data) ->
                $state.go 'nogame'

        if !$rootScope.validUser()
            $state.go 'login'

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
    ($rootScope, $scope, $state, $http) ->
        $scope.showTeamPwd = false

        if $rootScope.validUser()
            $state.go 'play'

        $scope.onSelect = ($item) ->
            $scope.team = $item
            $scope.showTeamPwd = true

        $scope.validate = (form) ->
            $http
                withCredentials: true
                url: serverUrl + "/api/services/login?sections=team",
                method: "POST"
                data:
                    nickname: form.nickname
                    password: form.password
            
            .success (data) ->
                $rootScope.user.id = data.id
                $rootScope.user.name = data.nickname
                $rootScope.user.teamId = data.teamId
                $rootScope.user.team = data.team

                localStorage.user = JSON.stringify $rootScope.user

                $rootScope.updateVitals()

                $rootScope.socket.disconnect()
                $rootScope.socket = io wsUrl

                $state.go 'play'
            .error (data) ->
                if data.type == 'AuthenticationError'
                    $scope.error = true
]


App.controller 'signupCtrl', [
    '$rootScope'
    '$scope'
    '$state'
    '$http'
    ($rootScope, $scope, $state, $http) ->
        if $rootScope.validUser()
            $state.go 'play'

        $scope.teams = []

        $scope.errors = {}

        $scope.resultTeam =
            name: ''
            pwd: ''
            slogan: ''

        $http.get serverUrl + "/api/teams"
        .success (data) ->
            $scope.teams = data

        $scope.team = ->
            return team for team in $scope.teams when team.name.toLowerCase() == ($scope.resultTeam.name || '').toLowerCase()

        $scope.create = (form) ->
            createUser = (user) ->
                $http
                    withCredentials: true
                    url: serverUrl + '/api/users?sections=team',
                    method: "POST"
                    data:
                        nickname: user.nickname
                        email: user.email
                        password: user.password
                        teamPassword: user.teamPassword
                        teamId: user.teamId
                .success (data) ->
                    $rootScope.user.id = data.id
                    $rootScope.user.name = data.nickname
                    $rootScope.user.teamId = data.teamId
                    $rootScope.user.team = data.team

                    localStorage.user = JSON.stringify $rootScope.user

                    $rootScope.updateVitals()

                    $rootScope.socket.disconnect()
                    $rootScope.socket = io wsUrl

                    $state.go 'play'
                .error (data) ->
                    data.fields.forEach (err) ->
                        $scope.errors[err.path] = err.message

            if !$scope.team()
                $http.post serverUrl + '/api/teams',
                    name: $scope.resultTeam.name
                    slogan: $scope.resultTeam.slogan
                    password: $scope.resultTeam.password
                .success (team) ->
                    $scope.team = ->
                        return team

                    user =
                        nickname: form.nickname.$viewValue
                        email: form.email.$viewValue
                        password: form.password.$viewValue
                        teamPassword: form.teamPassword.$viewValue
                        teamId: team.id
                    createUser(user)
                .error (data) ->
                    # TODO

            else
                user =
                    nickname: form.nickname.$viewValue
                    email: form.email.$viewValue
                    password: form.password.$viewValue
                    teamPassword: form.teamPassword.$viewValue
                    teamId: $scope.team().id
                createUser(user)
]

App.controller 'nogameCtrl', [
    '$rootScope'
    '$scope'
    '$state'
    '$http'
    ($rootScope, $scope, $state, $http) ->
        $http.get serverUrl + '/api/games'
        .success (games) ->
            $scope.games = games
            $scope.games.forEach (game) ->
                game.startDate = moment(new Date(game.startTime)).format "dddd Do MMMM à HH:mm"
                game.endDate = moment(new Date(game.endTime)).format "HH:mm"
        .error (data) ->
            console.log data
]

# RUN !!
# ------
App.run [
    '$rootScope'
    '$state'
    '$window'
    '$http'
    'notify'
    ($rootScope, $state, $window, $http, notify) ->
        $rootScope.$state = $state

        $rootScope.endTime = '00H00'

        $http
            withCredentials: true
            url: serverUrl + '/api/services/logged-in'
        .success (status) ->
            if status == true
                if localStorage.user
                    $rootScope.user = JSON.parse localStorage.user

        $rootScope.user =
            team: null
            teamId: -1
            score: 0
            energy: 0
            id: null

        $rootScope.socket = io wsUrl
        $rootScope.socket.on 'score:update', (userScore, teamScore) ->
            $rootScope.user.score = userScore

        $rootScope.socket.on 'notification:send', (data) ->
            notify "Hello there "+data

        $rootScope.socket.on 'user:update', (data) ->
            if data.energy then $rootScope.user.energy = data.energy

        $rootScope.validUser = () ->
            # TODO : check with token/whatever
            return localStorage.user
        
        $rootScope.updateVitals = ->
            $http
                withCredentials: true
                url: serverUrl + "/api/users/me",
                method: "GET"
            .success (data) ->
                if data.gameUser.energy then $rootScope.user.energy = data.gameUser.energy
                if data.gameUser.score then $rootScope.user.score = data.gameUser.score

        $rootScope.updateVitals()
]