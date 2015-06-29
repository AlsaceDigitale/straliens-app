@App = angular.module 'straliens', ['ui.router', 'uiGmapgoogle-maps', 'ngWebSocket', 'ui.bootstrap', 'ngCookies']
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
        templateUrl: 'partials/login.html'

    .state 'signup',
        url: '/signup'
        controller: 'signupCtrl'
        title: 'SignUp'
        templateUrl: 'partials/signup.html'

    .state 'check',
        url: '/check/:id'
        controller: 'checkCtrl'
        title: 'check'
        templateUrl: 'partials/check.html'


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

        $http.get "http://localhost:3000/api/points"
        .success (data) ->
            data.forEach (obj, key) ->
                $http.get "http://localhost:3000/api/points/"+ obj.id
                .success (data) ->
                    obj.coordinates = { latitude: obj.lat, longitude: obj.lng }
                    obj.options = {
                        labelContent: Math.abs(data.energy)
                        labelAnchor: "0 0"
                        labelClass: 'map-label side-' + data.side
                    }
                $scope.points = data

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
            $http.post "http://localhost:3000/api/services/login?sections=team",
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

        $http.get "http://localhost:3000/api/teams"
        .success (data) ->
            if !data or data.length == 0
                data = [
                    "straliens"
                    "terrien"
                ]
            $scope.teams = data

        $scope.create = (form) ->
            $http.post 'http://localhost:3000/api/users?sections=team',
                nickname: form.nickname
                email: form.email
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

# RUN !!
# ------
App.run [
    '$rootScope'
    '$state'
    '$window'
    '$websocket'
    '$cookies'
    ($rootScope, $state, $window, $websocket, $cookies) ->
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

        $rootScope.ws = $websocket "ws://127.0.0.1:8000/ws"
        # $rootScope.ws.send JSON.stringify(action: "test")
]